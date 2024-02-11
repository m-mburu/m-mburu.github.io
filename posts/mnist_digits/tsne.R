# Compare between tsne amd glmr

## TSNE

```{r, fig.width = 6, fig.height = 4}
library(Rtsne)

tsne_output <- Rtsne(train_x, check_duplicates = FALSE, PCA = FALSE)

# Generate a data frame to plot the result
tsne_train <- data.table(tsne_x = tsne_output$Y[,1],
                         tsne_y = tsne_output$Y[,2],
                         label =  train_data2$label)

# Plot the embedding usign ggplot and the label
ggplot(tsne_train,
       aes(x = tsne_x, y = tsne_y, color = factor(label))) + 
    ggtitle("t-SNE of MNIST data set") + 
    geom_text(aes(label = label)) +
    theme(legend.position = "none")


```

## Plot tsne group means

```{r}
tsne_mean <- tsne_train[, 
                        .(mean_x = mean(tsne_x), mean_y = mean(tsne_y)),
                        by = label]


ggplot(tsne_mean,
       aes(x = mean_x, y = mean_y, color = factor(label))) + 
    ggtitle("t-SNE of MNIST data set group means") + 
    geom_text(aes(label = label)) +
    theme(legend.position = "none")


```

## Kmeans to see if tsne and kmeans agree

```{r}
set.seed(123)
k_means_mnist <- kmeans(train_x, 10)

tsne_train[, cluster := k_means_mnist$cluster]
ggplot(tsne_train,
       aes(x = tsne_x, y = tsne_y, color = factor(cluster))) + 
    geom_point()+
    ggtitle("t-SNE of MNIST data set") + 
    theme(legend.position = "none")

tsne_train[, cluster := NULL]
```

## Model hyper parameters


```{r}
tsne_train[, label:=  factor(label)]

set.seed(100)

cv_fold <- createFolds(tsne_train$label, k = 5)


library(caretEnsemble)

train_ctrl <- trainControl(method = "cv",
                           number = 3,
                           summaryFunction = multiClassSummary,
                           classProbs = TRUE,
                           allowParallel=T,
                           index = cv_fold,
                           verboseIter = TRUE,
                           returnResamp = "all", 
                           savePredictions = "final", 
                           search = "grid")



xgb_grid <-  expand.grid(nrounds = c(100, 150),
                         eta = 0.06,
                         max_depth =c(2, 5, 20),
                         gamma = c(6,0),
                         colsample_bytree = 0.8,
                         min_child_weight =0.8,
                         subsample =  .8)



ranger_grid <- expand.grid(splitrule = "extratrees",
                           mtry =2,
                           min.node.size = c(1, 5))


svm_grid <- expand.grid(C = c(.5, 1, 5, 20),
                        sigma= seq(0.001, 1, length.out = 4))
```

## Train TSNE model

- Caret complains when factor levels are numeric

```{r}
lbls <- c("zero", "one", "two", "three", 
          "four", "five", "six", "seven",
          "eight", "nine")

lvl <- 0:9

tsne_train[, label := factor(label, 
                             levels = lvl, 
                             labels = lbls)]
```

## Train models

```{r, message=TRUE}
set.seed(100)

# 

tic()

model_list <- caretList(
    label~.,
    data= tsne_train,
    trControl=train_ctrl,
    tuneList = list(caretModelSpec(method="xgbTree", tuneGrid= xgb_grid),
                    caretModelSpec(method="ranger", tuneGrid= ranger_grid )
                    
    )
)

toc()
```

### Model output

```{r}
model_list
```


### Resamples


```{r}
resamples_models <- resamples(model_list)

dotplot(resamples_models, metric = "Accuracy")
```
