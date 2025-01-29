
library(tidyverse)
library(data.table)


dividends <- fread("data/dividends.csv")

dividends <- janitor::clean_names(dividends)

# grepl names ending with _date
date_cols <- colnames(dividends)[grepl("_date", colnames(dividends))]

# convert to date format is in 18-Mar-2024

dividends[, (date_cols) := lapply(.SD, function(x) as.Date(x, format = "%d-%b-%Y")), .SDcols = date_cols]
