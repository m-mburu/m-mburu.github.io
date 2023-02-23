
## Load packages


library(tidyverse)
library(data.table)
library(caret)
library(ggthemes)
library(lubridate)
library(DT)
library(tictoc)


## Reading data


shap_values <- fread("shap_values.csv")
trainperf <- fread("trainperf.csv")
shap_values_wide <- shap_values %>%
    dcast(customerid + class~ feature,
          value.var = "phi",
          fun.aggregate = sum)



