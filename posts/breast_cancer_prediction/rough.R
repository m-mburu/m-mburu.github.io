data()
remotes::install_github("ModelOriented/shapper")
shapper::install_shap()
remotes::install_github("ModelOriented/DALEX2")
library("DALEX2")
Y_train <- HR$status
x_train <- HR[ , -6]

# Let's build models
library("randomForest")
set.seed(123)
model_rf <- randomForest(x = x_train, y = Y_train)

# here shapper starts
# load shapper
library(shapper)
p_function <- function(model, data) predict(model, newdata = data, type = "prob")

ive_rf <- individual_variable_effect(model_rf, data = x_train, predict_function = p_function,
                                     new_observation = x_train[1:2,], nsamples = 150)

# plot
plot(ive_rf)


# Calculate shap values for random forest

## start by defining a model

- IML uses R6 system in R who

```{r}

library(iml)
X_pred <- train_data[, .SD, .SDcols = !c("diagnosis")] %>%
    as.data.frame() # this because i use data.table

pred <- function(rf, test_data)  {
    results <- predict(rf, newdata =X_pred, type = "prob")
    return(results[[1L]])
}

predictor <- Predictor$new(model = rf,
                           data =X_pred,
                           predict.function = pred,
                           y = train_data$diagnosis)
```

## Calculate shap values

```{r shap_values}

tic()

shap_list <- foreach(i = 1:nrow(X_pred)) %do%{
    shap <- Shapley$new(predictor,  x.interest = X_pred[i, ], sample.size = 150)
    shap_import <-shap$results %>% data.table()
    shap_import <- shap_import[class == "M"]
    shap_import[,id := pat_id[i]]
    
}
toc()

shap_values <- rbindlist(shap_list)
write_csv(shap_values, path = "shap_values.csv")
```

## Head shap

```{r}
head(shap_values, 10) %>% datatable(options = list(scrollX = TRUE))
```
