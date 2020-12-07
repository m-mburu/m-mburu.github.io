library(DAAG)
library(tidyverse)
library(keras)
head(ais)
# standardise
minmax <- function(x) (x - min(x))/(max(x) - min(x))
x_train <- apply(ais[,1:11], 2, minmax)

# PCA
pca <- prcomp(x_train)

# plot cumulative plot
qplot(x = 1:11, y = cumsum(pca$sdev)/sum(pca$sdev), geom = "line")
