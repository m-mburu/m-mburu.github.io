
library(tictoc)

tic()
rmarkdown::render("heart_failure.Rmd", clean = F)

toc()