
library(tidyverse)
library(data.table)

unicef_stunting <- fread("data/unicef_stunting.csv")

nms <- unicef_stunting[3, ] %>% as.character()

idx <- grep("female_month_24_59_ul", nms)

unicef_stunting <- unicef_stunting[, 1:idx]

nms <- nms[1:idx]

nms <- gsub("\\s", "_", nms) %>% tolower()

names(unicef_stunting) <- nms

unicef_stunting <- unicef_stunting[-(1:3)]

footnotes <- nms[grepl("footnote", nms)]

unicef_stunting[, (footnotes) := NULL]

nms <- names(unicef_stunting)

idx2 <- grep("national_r", nms) - 1

id_vars <- nms[1:idx2]

unicef_stunting_m <- melt(unicef_stunting, 
                          id.vars = id_vars)

unicef_stunting_m[, value := str_trim(value)]

unicef_stunting_m[, value := as.numeric(value)]

unicef_stunting_m <- unicef_stunting_m[!grepl("_weighted", variable)]
unicef_stunting_m[, type := str_extract(variable, "national|male|female|urban|rural|^month")]

unicef_stunting_m[, table(type, useNA = "always")]

unicef_stunting_m[is.na(type)] %>% View

unicef_stunting_m <- unicef_stunting_m[!is.na(type)]
