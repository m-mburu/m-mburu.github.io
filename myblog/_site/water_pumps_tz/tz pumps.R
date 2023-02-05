


library(tidyverse)
library(data.table)
library(knitr)
library(broom)
library(caret)
library(kableExtra)
library(ggthemes)


train_y <- fread("0bf8bc6e-30d0-4c50-956a-603fc693d966.csv")
train_x <-  fread("4910797b-ee55-40a7-8668-10efd5c1b960.csv")

test <- fread("702ddfc5-68cd-4d1d-a0de-f5f566f76d91.csv")

train_data <- merge(train_y, train_x, by = "id")
train_data[, set := "train"]

test[, set := "test"]

pump_data <- rbindlist(list(train_data, test), fill = T)


train_data[, .N, by = status_group]


