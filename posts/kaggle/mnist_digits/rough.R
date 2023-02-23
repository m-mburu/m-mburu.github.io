
# GLRM

## H2o init

```{r}
library(h2o)
h2o.init()


# Store the data into h2o cluster
train_x_h20 <- as.h2o(train_data2[, -1]/255)
```

## Fit glrm

```{r}
glrm_mnist <- h2o.glrm(training_frame = train_x_h20,
                       k = 10,
                       seed = 100,
                       max_iterations = 3000)
```

## Fit glrm

```{r}

glrm_x <- as.data.table(h2o.getFrame(glrm_mnist@model$representation_name))

train_glrm <- data.table(label = train_data2$label, glrm_x)
```

## Plot Objective Function
```{r}
plot(glrm_mnist)
```


```{r}
ggplot(train_glrm, aes(x= Arch1, y = Arch2, color =factor(label))) + 
    ggtitle("Digit Mnist GLRM Archetypes") + 
    geom_text(aes(label = label)) + 
    theme(legend.position="none")
```


```{r}
train_glrm[, label := factor(label, 
                             levels = lvl, 
                             labels = lbls)]
```


## Train models

```{r}
set.seed(100)


tic()

model_list_glrm <- caretList(
    label~.,
    data= train_glrm,
    trControl=train_ctrl,
    tuneList = list(caretModelSpec(method="xgbTree", tuneGrid= xgb_grid),
                    caretModelSpec(method="ranger", tuneGrid= ranger_grid)
                    
    )
)

toc()
```


```{r}
model_list_glrm
```

