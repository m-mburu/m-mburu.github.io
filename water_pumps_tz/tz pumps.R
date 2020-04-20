
setwd("C:/Users/mmburu/Desktop/R/water pumps tz")

dir()

library(tidyverse)
library(data.table)
library(xgboost)
library(knitr)
library(broom)
library(caret)
library(e1071)
library(kableExtra)
library(ggthemes)

install.packages(c("e1071", "kableExtra", "ggthemes"))
dir()

train_y <- setDT(read_csv("0bf8bc6e-30d0-4c50-956a-603fc693d966.csv"))
train <- setDT(read_csv("4910797b-ee55-40a7-8668-10efd5c1b960.csv"))

test <- setDT(read_csv("702ddfc5-68cd-4d1d-a0de-f5f566f76d91.csv"))

train[, set := "train"]

test[, set := "test"]

df <- rbindlist(list(train, test))

col_types <- sapply(df, typeof) 
char_cols <- col_types[col_types == "character"] %>% names() 

char_cols <- char_cols[char_cols != "set"]
library(dummies)
df_dummy <- dummy.data.frame(train, names = char_cols) %>%
    setDT()

names(col_types)

save(df, file = "df.rda")
save(df_dummy, file = "df_dummy.rda")
write.csv(df, file = "df.csv", row.names = F)
load(df)
pca <- prcomp(pca <- prcomp(cancer[, predictors, with = F], scale. = F)[, predictors, with = F], scale. = F)


pcpca <- prcomp(cancer[, predictors, with = F], scale. = F)
