# Helper functions for posts/finaccess/mapping-financial-lives.qmd

as_label <- function(x) {
  if (inherits(x, "haven_labelled")) {
    as_factor(x, levels = "labels")
  } else {
    x
  }
}

num_value <- function(x) {
  suppressWarnings(as.numeric(zap_labels(x)))
}

text_value <- function(x) {
  tolower(trimws(as.character(as_label(x))))
}

yes_no <- function(x) {
  z <- num_value(x)
  fifelse(is.na(z), NA_integer_, fifelse(z == 1, 1L, fifelse(z == 2, 0L, NA_integer_)))
}

selected_binary <- function(x) {
  z <- num_value(x)
  fifelse(is.na(z), NA_integer_, fifelse(z == 1, 1L, 0L))
}

current_use <- function(x) {
  z <- num_value(x)
  txt <- text_value(x)
  fifelse(is.na(z) & is.na(txt), NA_integer_, fifelse(z == 1 | grepl("currently use", txt), 1L, 0L))
}

agree_binary <- function(x) {
  z <- num_value(x)
  txt <- text_value(x)
  fifelse(
    is.na(z) & is.na(txt),
    NA_integer_,
    fifelse(z == 1 | txt == "agree", 1L, fifelse(z == 2 | txt == "disagree", 0L, NA_integer_))
  )
}

worried_binary <- function(x) {
  z <- num_value(x)
  fifelse(is.na(z), NA_integer_, fifelse(z %in% c(1, 2), 1L, fifelse(z %in% c(3, 4), 0L, NA_integer_)))
}

difficulty_binary <- function(x) {
  z <- num_value(x)
  fifelse(is.na(z), NA_integer_, fifelse(z %in% c(1, 2), 1L, fifelse(z == 3, 0L, NA_integer_)))
}

count_value <- function(x) {
  z <- num_value(x)
  fifelse(is.na(z) | z >= 98, NA_real_, z)
}

any_disability <- function(...) {
  mat <- cbind(...)
  apply(mat, 1, function(row) {
    if (all(is.na(row))) {
      return(NA_integer_)
    }
    as.integer(any(row %in% c(2, 3, 4), na.rm = TRUE))
  })
}

weighted_mean_safe <- function(x, w) {
  keep <- stats::complete.cases(x, w) & w > 0
  if (!any(keep)) {
    return(NA_real_)
  }
  stats::weighted.mean(x[keep], w[keep])
}

weighted_total <- function(x, w) {
  keep <- stats::complete.cases(x, w) & w > 0
  sum(x[keep] * w[keep])
}

score_band <- function(x) {
  cut(
    x,
    breaks = c(-Inf, 0, 1, 3, Inf),
    labels = c("none", "low", "medium", "high"),
    right = TRUE
  )
}

clean_label_text <- function(x) {
  x <- trimws(as.character(x))
  x <- gsub('^"+|"+$', "", x)
  x <- trimws(x)
  gsub("\\s+", " ", x)
}

make_indicator_names <- function(variable, levels) {
  make.unique(make.names(paste(variable, levels, sep = "_")), sep = "_")
}

build_indicator_tree_data <- function(source_dt, predictors, label_lookup) {
  id_cols <- intersect(
    c("row_id", "interview__key"),
    names(source_dt)
  )
  source_dt <- copy(source_dt[
    ,
    c(id_cols, "food_poor_1m", "weight", "cluster_id", predictors),
    with = FALSE
  ])
  source_dt <- na.omit(source_dt)
  source_dt[, food_poor_1m := as.numeric(food_poor_1m)]

  level_counts <- vapply(
    source_dt[, ..predictors],
    function(x) length(levels(as.factor(x))),
    integer(1L)
  )

  binary_predictors <- names(level_counts[level_counts <= 2L])
  multi_level_predictors <- names(level_counts[level_counts > 2L])

  model_predictor_dt <- copy(source_dt[, ..binary_predictors])

  indicator_map <- if (length(multi_level_predictors)) {
    rbindlist(lapply(multi_level_predictors, function(variable) {
      levels_i <- levels(as.factor(source_dt[[variable]]))
      data.table(
        raw_variable = variable,
        level = levels_i,
        variable = make_indicator_names(variable, levels_i),
        variable_label = paste0(label_lookup[[variable]], ": ", clean_label_text(levels_i))
      )
    }))
  } else {
    data.table(
      raw_variable = character(),
      level = character(),
      variable = character(),
      variable_label = character()
    )
  }

  for (i in seq_len(nrow(indicator_map))) {
    source_variable <- indicator_map$raw_variable[i]
    source_level <- indicator_map$level[i]
    target_variable <- indicator_map$variable[i]
    model_predictor_dt[, (target_variable) := factor(
      fifelse(as.character(source_dt[[source_variable]]) == source_level, "Yes", "No"),
      levels = c("No", "Yes")
    )]
  }

  model_dt <- data.table(
    source_dt[
      ,
      c(id_cols, "food_poor_1m", "weight", "cluster_id"),
      with = FALSE
    ],
    model_predictor_dt
  )

  model_predictors <- names(model_predictor_dt)
  var_labels <- setNames(model_predictors, model_predictors)
  var_labels[intersect(binary_predictors, names(label_lookup))] <-
    label_lookup[intersect(binary_predictors, names(label_lookup))]
  var_labels[indicator_map$variable] <- indicator_map$variable_label

  list(
    data = model_dt,
    predictors = model_predictors,
    indicator_map = indicator_map,
    binary_predictors = binary_predictors,
    multi_level_predictors = multi_level_predictors,
    var_labels = var_labels
  )
}

make_cluster_fold_id <- function(cluster, outcome, weights = NULL, v = 5L, seed = 20260629) {
  cluster <- as.integer(cluster)
  outcome <- as.integer(outcome)
  if (length(cluster) != length(outcome)) {
    stop("`cluster` and `outcome` must have the same length.", call. = FALSE)
  }
  if (anyNA(cluster)) {
    stop("`cluster` cannot contain missing values.", call. = FALSE)
  }
  if (is.null(weights)) {
    weights <- rep(1, length(cluster))
  }
  weights <- as.numeric(weights)

  cluster_frame <- data.table(
    cluster_id = cluster,
    outcome = outcome,
    weight = weights
  )[
    ,
    .(
      rows = .N,
      events = sum(outcome == 1L, na.rm = TRUE),
      weighted_events = sum(weight * outcome, na.rm = TRUE),
      weighted_rows = sum(weight, na.rm = TRUE)
    ),
    by = cluster_id
  ]

  v <- max(2L, as.integer(v[1L]))
  v <- min(v, nrow(cluster_frame))

  set.seed(seed)
  cluster_frame[, random_order := runif(.N)]
  setorder(cluster_frame, -events, -weighted_events, random_order)
  cluster_frame[, fold_id := NA_integer_]

  fold_load <- data.table(
    fold_id = seq_len(v),
    events = 0,
    weighted_events = 0,
    rows = 0,
    weighted_rows = 0
  )

  for (i in seq_len(nrow(cluster_frame))) {
    setorder(fold_load, events, weighted_events, rows, fold_id)
    chosen_fold <- fold_load$fold_id[1L]
    cluster_frame[i, fold_id := chosen_fold]
    fold_load[
      fold_id == chosen_fold,
      `:=`(
        events = events + cluster_frame$events[i],
        weighted_events = weighted_events + cluster_frame$weighted_events[i],
        rows = rows + cluster_frame$rows[i],
        weighted_rows = weighted_rows + cluster_frame$weighted_rows[i]
      )
    ]
  }

  row_frame <- data.table(row_id = seq_along(cluster), cluster_id = cluster)
  row_frame[cluster_frame[, .(cluster_id, fold_id)], on = "cluster_id", fold_id := i.fold_id]
  row_frame$fold_id
}

make_cluster_resamples <- function(dt, fold_id, label) {
  fold_values <- sort(unique(fold_id))
  splits <- lapply(fold_values, function(fold_value) {
    rsample::make_splits(
      list(
        analysis = which(fold_id != fold_value),
        assessment = which(fold_id == fold_value)
      ),
      data = dt
    )
  })

  rsample::manual_rset(
    splits = splits,
    ids = sprintf("%s_fold_%02d", label, fold_values)
  )
}

prepare_tune_data <- function(dt) {
  out <- copy(dt)
  out[, food_poor_1m := factor(
    fifelse(food_poor_1m == 1L, "food_poor", "not_food_poor"),
    levels = c("food_poor", "not_food_poor")
  )]

  median_weight <- stats::median(out$weight[out$weight > 0], na.rm = TRUE)
  if (!is.finite(median_weight) || median_weight <= 0) {
    median_weight <- 1
  }

  # Keep survey weights bounded for tree tuning while preserving relative size.
  out[, case_wt_int := pmax(1L, pmin(20L, as.integer(round(weight / median_weight))))]
  out[, case_wt := hardhat::frequency_weights(case_wt_int)]
  out
}

make_tree_workflow <- function(formula, spec) {
  workflow() |>
    add_formula(formula) |>
    add_model(spec) |>
    add_case_weights(case_wt)
}

tune_tree <- function(dt, formula, resamples, grid, spec, metrics) {
  tree_workflow <- make_tree_workflow(formula, spec)

  tune_result <- tune_grid(
    tree_workflow,
    resamples = resamples,
    grid = grid,
    metrics = metrics,
    control = control_grid(save_pred = TRUE, save_workflow = TRUE)
  )

  best <- select_best(tune_result, metric = "roc_auc")
  final_workflow <- finalize_workflow(tree_workflow, best)
  final_fit <- fit(final_workflow, data = as.data.frame(dt))

  list(
    result = tune_result,
    metrics = as.data.table(collect_metrics(tune_result)),
    predictions = as.data.table(collect_predictions(tune_result)),
    best = as.data.table(best),
    final_workflow = final_workflow,
    final_fit = final_fit,
    tree = extract_fit_engine(final_fit)
  )
}

cached_tune_tree <- function(
  cache_dir,
  cache_name,
  dt,
  formula,
  resamples,
  grid,
  spec,
  metrics,
  cache_extra = list()
) {
  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

  cache_key <- digest::digest(list(
    cache_version = 1L,
    cache_name = cache_name,
    formula = paste(deparse(formula), collapse = " "),
    row_id = if ("row_id" %in% names(dt)) dt$row_id else seq_len(nrow(dt)),
    outcome = as.character(dt$food_poor_1m),
    case_weight = if ("case_wt_int" %in% names(dt)) dt$case_wt_int else NULL,
    cluster_id = dt$cluster_id,
    columns = names(dt),
    grid = as.data.frame(grid),
    resample_ids = resamples$id,
    cache_extra = cache_extra
  ))

  cache_path <- file.path(
    cache_dir,
    paste0(cache_name, "_", cache_key, ".rds")
  )

  if (file.exists(cache_path)) {
    message("Using cached tree tuning: ", cache_path)
    return(readRDS(cache_path))
  }

  tuning <- tune_tree(
    dt = dt,
    formula = formula,
    resamples = resamples,
    grid = grid,
    spec = spec,
    metrics = metrics
  )
  saveRDS(tuning, cache_path)
  message("Saved tree tuning cache: ", cache_path)
  tuning
}

coerce_to_party_tree <- function(tree) {
  if (inherits(tree, "rpart")) {
    return(partykit::as.party(tree))
  }

  tree
}
tree_edge_panel_values_only <- function(
  obj,
  digits = 3,
  fill = "white",
  justmin = 4,
  just = c("alternate", "increasing", "decreasing", "equal"),
  max_items = 3L,
  max_chars = 24L,
  plural_label = "levels",
  gp = grid::gpar(),
  ...
) {
  meta <- obj$data

  compact_split_value <- function(label) {
    label <- gsub("\\s+", " ", trimws(label))
    if (!grepl(",", label, fixed = TRUE)) {
      return(stringr::str_wrap(label, width = max_chars))
    }

    parts <- trimws(strsplit(label, ",", fixed = TRUE)[[1L]])
    if (length(parts) <= max_items && nchar(label) <= max_chars) {
      return(stringr::str_wrap(label, width = max_chars))
    }

    shown <- paste(parts[seq_len(min(max_items, length(parts)))], collapse = ", ")
    paste0(length(parts), " ", plural_label, "\n", stringr::str_wrap(paste0(shown, ", ..."), width = max_chars))
  }

  justfun <- function(i, split_labels) {
    myjust <- if (mean(nchar(split_labels)) > justmin) {
      match.arg(just, c("alternate", "increasing", "decreasing", "equal"))
    } else {
      "equal"
    }

    k <- length(split_labels)
    rval <- switch(myjust,
      equal = rep.int(0, k),
      alternate = rep(c(0.5, -0.5), length.out = k),
      increasing = seq(from = -k / 2, to = k / 2, by = 1),
      decreasing = seq(from = k / 2, to = -k / 2, by = -1)
    )

    grid::unit(0.5, "npc") + grid::unit(rval[i], "lines")
  }

  function(node, i) {
    split_info <- partykit::character_split(partykit::split_node(node), meta, digits = digits)
    split_labels <- vapply(split_info$levels, compact_split_value, character(1L))

    y <- justfun(i, split_labels)
    label <- split_labels[[i]]
    label_lines <- strsplit(label, "\n", fixed = TRUE)[[1L]]
    widest_line <- label_lines[which.max(nchar(label_lines))]

    grid::grid.rect(
      y = y,
      gp = grid::gpar(fill = fill, col = NA),
      width = grid::unit(1.05, "strwidth", widest_line),
      height = grid::unit(max(1L, length(label_lines)), "lines")
    )
    grid::grid.text(label, y = y, just = "center", gp = gp)
  }
}
class(tree_edge_panel_values_only) <- "grapcon_generator"

tree_inner_panel_compact_labeled <- function(
  obj,
  var_labels = NULL,
  show_p = FALSE,
  gp = grid::gpar(),
  fill = "white",
  max_chars = 34L,
  min_chars = 8L,
  ...
) {
  meta <- obj$data

  pretty_var_name <- function(var_name) {
    if (!is.null(var_labels) && var_name %in% names(var_labels)) {
      return(unname(var_labels[[var_name]]))
    }
    gsub("_", " ", var_name)
  }

  function(node) {
    split_info <- partykit::character_split(partykit::split_node(node), meta)
    label_lines <- strsplit(stringr::str_wrap(pretty_var_name(split_info$name), width = max_chars), "\n", fixed = TRUE)[[1L]]
    widest_line <- label_lines[which.max(nchar(label_lines))]
    if (nchar(widest_line) < min_chars) {
      widest_line <- paste(rep("a", min_chars), collapse = "")
    }

    grid::pushViewport(grid::viewport(gp = gp))
    grid::pushViewport(grid::viewport(
      width = grid::unit(1.12, "strwidth", widest_line),
      height = grid::unit(length(label_lines) + 0.8, "lines")
    ))
    grid::grid.roundrect(r = grid::unit(0.12, "snpc"), gp = grid::gpar(fill = fill, col = "#cfd8dc", lwd = 0.8))
    grid::grid.text(paste(label_lines, collapse = "\n"))
    grid::upViewport(2)
  }
}
class(tree_inner_panel_compact_labeled) <- "grapcon_generator"

plot_finaccess_tree <- function(
  tree,
  data,
  outcome = "food_poor_1m",
  weight = "weight",
  var_labels = finaccess_var_labels,
  fontsize = 10,
  fontfamily = "Segoe UI",
  inner_max_chars = 34L,
  edge_max_chars = 22L,
  terminal_width_lines = 5.2,
  terminal_height_lines = 3.1,
  tnex = 1.02,
  note = "FP = food-poor share in terminal node; % = weighted population share; Lift = FP relative to the sample average."
) {
  tree <- coerce_to_party_tree(tree)

  plot_fun <- getFromNamespace("plot.ci_tree", "ineqTrees")

  plot_fun(
    tree,
    gp = grid::gpar(fontsize = fontsize, fontfamily = fontfamily, col = "#18212f"),
    data = as.data.frame(data),
    var_labels = var_labels,
    terminal_stats = list(
      food_poor = function(df) weighted_mean_safe(df[[outcome]], df[[weight]]),
      pop_share = function(df) sum(df[[weight]], na.rm = TRUE) / sum(data[[weight]], na.rm = TRUE),
      lift = function(df) {
        weighted_mean_safe(df[[outcome]], df[[weight]]) /
          weighted_mean_safe(data[[outcome]], data[[weight]])
      }
    ),
    stat_labels = list(
      food_poor = "FP",
      pop_share = "%",
      lift = "Lift"
    ),
    stat_formatters = list(
      food_poor = function(x) sprintf("%.1f%%", 100 * x),
      pop_share = function(x) sprintf("%.1f%%", 100 * x),
      lift = function(x) sprintf("%.2fx", x)
    ),
    edge_panel = tree_edge_panel_values_only,
    ep_args = list(
      max_chars = edge_max_chars,
      gp = grid::gpar(fontsize = fontsize, fontfamily = fontfamily, col = "#18212f")
    ),
    inner_panel = tree_inner_panel_compact_labeled,
    ip_args = list(
      var_labels = var_labels,
      gp = grid::gpar(fontsize = fontsize, fontfamily = fontfamily, col = "#18212f"),
      fill = "#ffffff",
      max_chars = inner_max_chars
    ),
    terminal_fill = "#d9d9d9",
    tp_args = list(
      width_lines = terminal_width_lines,
      height_lines = terminal_height_lines
    ),
    tnex = tnex
  )

  if (!is.null(note) && nzchar(note)) {
    grid::grid.text(
      note,
      x = grid::unit(0.02, "npc"),
      y = grid::unit(0.012, "npc"),
      just = c("left", "bottom"),
      gp = grid::gpar(fontsize = max(7, fontsize - 2), fontfamily = fontfamily, col = "#4b5563")
    )
  }
}

leaf_table <- function(fit, dt, outcome = "food_poor_1m") {
  fit <- coerce_to_party_tree(fit)
  out <- copy(dt)
  out[, node := as.integer(predict(fit, newdata = as.data.frame(out), type = "node"))]
  base_prev <- weighted_mean_safe(out[[outcome]], out$weight)

  leaves <- out[
    ,
    .(
      n = .N,
      weighted_population = sum(weight),
      food_vulnerability = weighted_mean_safe(get(outcome), weight),
      food_vulnerable_weighted = weighted_total(get(outcome), weight)
    ),
    by = node
  ]

  terminal_nodes <- data.table(node = partykit::nodeids(fit, terminal = TRUE))
  leaves <- terminal_nodes[leaves, on = "node"]

  leaves[, `:=`(
    population_share = weighted_population / sum(weighted_population),
    share_of_food_vulnerable = food_vulnerable_weighted / sum(food_vulnerable_weighted),
    lift = food_vulnerability / base_prev,
    prevalence_pct = 100 * food_vulnerability
  )]

  leaves[, `:=`(
    population_share_pct = 100 * population_share,
    food_vulnerable_share_pct = 100 * share_of_food_vulnerable
  )][order(-lift)]
}
