
library(shapper)


library("randomForest")
library("DALEX")
Y_train <- HR$status
x_train <- HR[ , -6]
set.seed(123)
model_rf <- randomForest(x = x_train, y = Y_train)
plot(model_rf)
library(rpart)
model_tree <- rpart(status~. , data = HR)

library(shapper)

p_function <- function(model, data) predict(model, newdata = data, type = "prob")

ive_rf <- individual_variable_effect(model_rf, data = x_train, predict_function = p_function,
                                     new_observation = x_train[1:20,], nsamples = 50)


ive_tree <- individual_variable_effect(model_tree, data = x_train, predict_function = p_function,
                                       new_observation = x_train[1:2,], nsamples = 50)



plot(ive_rf)
