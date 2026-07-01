# Agent Instructions

## R Style

When writing R for analysis scripts or R Markdown files, match the style used in
the project analysis files.

- Prefer readable, explicit code over dense one-liners.
- Use two-space indentation.
- Use snake_case for objects, functions, and column names.
- Put constants and reusable vectors near the top of the file or chunk.
- Keep helper functions small and place them before the analysis chunks that use
  them.
- Use spaces around assignment, arithmetic, and comparison operators.
- Use `<-` for assignment outside `data.table` update expressions.
- Break long function calls over multiple lines, with each argument on its own
  line when that improves scanning.
- Use trailing commas in multi-line function calls only when already required by
  the surrounding syntax.
- Prefer `TRUE` and `FALSE` over `T` and `F`.
- Avoid unnecessary comments. Use prose in R Markdown for analysis context, and
  use comments only when code intent would otherwise be hard to infer.

## R Markdown

- Use a setup chunk with `include=FALSE` for package loading, global chunk
  options, paths, constants, and helper functions.
- Set chunk options explicitly for output behavior, for example `echo`,
  `message`, `warning`, `include`, `fig.height`, `fig.width`, and `results`.
- Use descriptive chunk labels in kebab-case, such as
  `prepare-spirometry` or `spirometry-standard-summary`.
- Separate preparation, summary table, and model or plotting output into
  separate chunks.
- Use Markdown headings and short prose to explain the analysis decision, data
  exclusions, and derived variables.

## data.table

Prefer `data.table` for data manipulation once data is loaded.

- Convert imported data with `setDT(df)` after cleaning names.
- Rename columns with `setnames()` instead of rebuilding the data.
- Use `DT[i, j, by]` syntax for filtering, mutation, aggregation, and ordering.
- Write multi-step mutations as separate `DT[, column := value]` blocks when that
  makes the analysis easier to audit.
- Use `:=` for in-place updates.
- Use `fifelse()` for vectorized conditional assignment inside `data.table`.
- Use `.SD` and `.SDcols` for column subsets, especially when selecting analysis
  variables or applying the same function to multiple columns.
- Use `lapply(.SD, as.numeric)` for grouped type conversion across named columns.
- Use `uniqueN()` for counting unique values within grouped summaries.
- Use `rowSums(.SD, na.rm = TRUE)` for row-wise sums across selected columns.
- Chain short `data.table` calls when the result remains readable, for example
  filtering after `merge()` and then ordering.
- Prefer explicit intermediate objects for major analysis stages, such as raw
  import, cleaned data, analysis subset, melted data, and summary output.

Example shape:

```r
outcome_cols <- c(
  "chronic_cough",
  "breathlessness",
  "sputum"
)

analysis_dt <- source_dt[
  ,
  .SD,
  .SDcols = c("study_no", "author_year", "total_n", "tb_group", outcome_cols)
]

analysis_dt[
  ,
  total_n := as.numeric(total_n)
]

summary_dt <- analysis_dt[
  ,
  .(
    Studies = uniqueN(author_year),
    Events = sum(value, na.rm = TRUE),
    `Total sample` = sum(total_n, na.rm = TRUE)
  ),
  by = .(variable, tb_group)
][order(variable, tb_group)]
```

## Imports And Paths

- Load packages in the setup chunk or at the top of the script.
- Use `here()` for project-relative paths.
- Store important directories in named objects such as `data_folder`, `scripts`,
  or date-specific data folders.
- Source shared project helpers with `source(here(...))`.
- Use `readxl::read_excel()` or an imported `read_excel()` with explicit
  `sheet` and `col_types` when reading workbook data.
- Clean imported workbook names before converting to `data.table`.

## Analysis Conventions

- Define exclusion IDs and analysis group constants once, then reuse them.
- Normalize identifiers such as author-year labels with a helper function rather
  than repeating string operations.
- Keep outcome machine names and display labels in parallel vectors, then create
  a lookup `data.table` with `variable` and `title`.
- Preserve clear intermediate names that describe the analysis stage, for example
  `spirometry_component_analysis`, `spirometry_component_m_cb`, and
  `spirometry_component_outcomes`.
- When deriving values from partially missing components, make missing-data rules
  explicit in code and explain the rule in nearby R Markdown prose.
- Filter invalid records explicitly, such as missing IDs, total rows, mixed
  groups, or event counts greater than denominators.

## Output

- Use `knitr::kable()` for compact summary tables in R Markdown.
- Keep model, plot, and summary function calls formatted with one argument per
  line when they have several inputs.
- Pass named arguments explicitly for analysis helpers.
- Keep figure dimensions close to the chunk where the figure is produced.
