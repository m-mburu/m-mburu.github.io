
library(tidyverse)
library(data.table)
load("~/r_projects/m-mburu.github.io/kenya_population/kenya_pop/data/finaccess_2021.rda")

col_labels <- lapply(finaccess_2021, attr, "label") %>%
    unlist()

col_nms <- names(col_labels)

col_labels_df <- data.table(col_nms, col_labels)
