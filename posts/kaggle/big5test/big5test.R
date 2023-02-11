

library(tidyverse)
library(data.table)

big5test <- fread("data/data-final.csv", na.strings = c("NULL", "NA"))

table(big5test$country)
head(big5test) %>% view

big5test <- big5test[!is.na(EXT1)]
set.seed(100)
sub_sample <- sample(nrow(big5test), 10000)
big5test_sub <- big5test[sub_sample]

nms_qtns <- c("EXT1", "EXT2", "EXT3", "EXT4", "EXT5", "EXT6",
  "EXT7", "EXT8", "EXT9", "EXT10", "EST1", "EST2", 
  "EST3", "EST4", "EST5", "EST6", "EST7", "EST8", 
  "EST9", "EST10", "AGR1", "AGR2", "AGR3", "AGR4",
  "AGR5", "AGR6", "AGR7", "AGR8", "AGR9", "AGR10",
  "CSN1", "CSN2", "CSN3", "CSN4", "CSN5", "CSN6",
  "CSN7", "CSN8", "CSN9", "CSN10", "OPN1", "OPN2", 
  "OPN3", "OPN4", "OPN5", "OPN6", "OPN7", "OPN8", "OPN9", "OPN10")


#big5test_sub[, (nms_qtns) := lapply(.SD, as.numeric ), .SDcols = nms_qtns]

colSums(is.na(big5test))

zeroone <- function(x){
    
    (x - min(x))/(max(x) - min(x))
}

zeroone(big5test$EXT1)

#big5test_sub[, (nms_qtns) := lapply(.SD,  function(x)zeroone(x)), .SDcol = nms_qtns]

big5test_sub_cols <- big5test_sub[, ..nms_qtns]

big5test_sub_cols[x] %>% View

colSums(is.na(big5test_sub_cols))

x <- which(is.na(big5test_sub_cols$EXT1))

# Set the seed
#set.seed(1234)

# Generate the t-SNE embedding 

library(h2o)
# Start a connection with the h2o cluster
h2o.init()
big5test_sub_cols <-  big5test_sub_cols[,1:8]

person_dat <- as.h2o(big5test_sub_cols, "person_dat")

person_glrm <- h2o.glrm(training_frame = person_dat,
                       k = 2,
                       seed = 123,
                       max_iterations = 2100)


X_matrix <- as.data.table(h2o.getFrame(person_glrm@model$representation_name))
# Dimension of X_matrix
dim(X_matrix)

head(X_matrix)

ggplot(X_matrix, aes(Arch1, Arch2)) +
    geom_point()

h2o.shutdown()

kmeans_model <- kmeans(big5test_sub_cols, centers = 2)

X_matrix[, centers := kmeans_model$cluster]

ggplot(X_matrix, aes(Arch1, Arch2, col = factor(centers))) +
    geom_point()
