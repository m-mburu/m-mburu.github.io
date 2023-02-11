
library(tidyverse)
library(data.table)
library(readxl)
africa <- read_excel("data/africa.xlsx")
nms <- names(africa)[1] %>% str_split(pattern = "\\s") %>%
    unlist()
nms <- nms[nms != ""]
names(africa)[1] <- "all_dat"

setDT(africa)

africa[, all_dat := gsub("Burkina Faso", "Burkina_Faso", all_dat)]
nms <- c("row_name", nms)
africa[, (nms) := tstrsplit(all_dat, "\\s")]
write_csv(africa, file = "data/africa_csv.csv")
africa_csv <- fread("data/africa_csv.csv", header = F, fill = T)

names(africa_csv) <- nms
africa_csv[, row_name:= NULL]
write_csv(africa_csv, file = "data/africa_clean.csv")
