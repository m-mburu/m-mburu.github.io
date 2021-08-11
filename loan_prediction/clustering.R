
library(tidyverse)
library(data.table)
library(caret)
library(ggthemes)
library(lubridate)
library(DT)
library(tictoc)
shap_values <- fread("shap_values.csv")
trainperf <- fread("trainperf.csv")
shap_values_wide <- shap_values %>%
    dcast(customerid + class~ feature,
          value.var = "phi",
          fun.aggregate = sum)




library(kernlab)

shap_matrix <- shap_values_wide[, .SD, .SDcols = !c("class", "customerid")] %>% 
    as.matrix()


spec_models <- list()
tot_withinss <- c()

tic()

for(i in 1:10){
    
    spec_fit <- specc(shap_matrix, centers=i+1)
    tot_withinss[i] <-withinss(spec_fit) %>% mean()
    spec_models[[i]] <- spec_fit
}

toc()

plot( tot_withinss)




specc_clusters <- factor(spec_models[[2]]@.Data)

library(Rtsne)

tsne_output <- Rtsne(shap_matrix, 
                     check_duplicates = FALSE)
    

# Generate a data frame to plot the result
tsne_loan <- data.table(
    customerid = shap_values_wide$customerid,
    tsne_x = tsne_output$Y[,1],
    tsne_y = tsne_output$Y[,2],
    clusters = specc_clusters
    )

tsne_loan <- merge(trainperf[, .(customerid, label = good_bad_flag)],
      tsne_loan, by = "customerid")


ggplot(tsne_loan,
       aes(x = tsne_x, y = tsne_y, color = factor(clusters))) + 
    ggtitle("t-SNE of loan data") + 
    geom_point()+
    #geom_text(aes(label = label)) +
    theme(legend.position = "none")
