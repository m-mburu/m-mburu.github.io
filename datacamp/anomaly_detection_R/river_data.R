
library(tidyverse)
library(data.table)
nitrate <- c(1.581, 1.323, 1.14, 1.245, 1.072, 1.483, 1.162, 1.304, 1.14, 
             1.118, 1.342, 1.245, 1.204, 1.14, 1.204, 1.118, 1.025, 1.118, 
             1.285, 1.14, 0.949, 0.922, 0.949, 1.118, 1.265, 1.095, 1.183, 
             1.162, 1.118, 1.285, 1.049, 0.922, 0.775, 0.866, 0.922, 1.643, 
             1.323, 1.285, 1.095, 1.049, 1.095, 0.922, 0.866, 1.049, 0.922, 
             1.095, 1.183, 1.304, 1.162, 1.225, 1.285, 1.072, 1.533, 1.095, 
             1.396, 1.025, 0.922, 0.949, 1.118, 1.342, 1.36, 1.36, 1.204, 
             1.265, 1, 1.183, 1.025, 0.866, 1.072, 1.049, 1.049, 1.049, 1.095, 
             1.183, 1.095, 0.975, 1.118, 0.975, 1.049, 0.837, 0.922, 1.118, 
             1.072, 1.204, 0.975, 1.095, 1.049, 0.866, 0.922, 1.049, 1.127, 
             1.072, 0.975, 1.049, 1.183, 1.245, 1.225, 1.225, 1.265, 1.118, 
             1.14, 1.072, 1.095, 0.671, 1.183, 0.949, 1.162, 1.095, 1.323, 
             1.342, 1.277, 1.015, 1, 0.922, 0.894, 1, 1.049, 0.922, 1.517, 
             1.265, 1.414, 1.304, 1.14, 1.14, 1.049, 1.068, 0.906, 1.095, 
             0.883, 1.14, 1.025, 1.36, 1.183, 1.265, 1.304, 0.964, 0.975, 
             0.99, 0.877, 1.049, 0.975, 1, 1.183, 1.225, 1.265, 1.183, 1.049, 
             0.97, 0.894, 0.98, 0.964, 0.894, 0.922, 1.14, 1.183, 1.897, 1.095, 
             1.14, 1.414, 1.14, 1, 1.049, 0.889, 0.872, 1, 1.095, 0.671, 1.095, 
             1.14, 1.304, 1.025, 0.975, 1, 0.877, 0.949, 0.866, 1.058, 1.086, 
             1.118, 1.162, 1.221, 1.265, 1.122, 1.015, 1.162, 0.825, 0.906, 
             0.849, 0.985, 1.118, 1.077, 1.237, 1.237, 1.063, 1.01, 0.933, 
             0.922, 0.806, 0.748, 0.592, 0.911, 0.806, 0.98, 1.077, 1.212, 
             1.277, 0.954, 0.837, 0.917, 0.9, 1.068, 0.872, 0.99, 1.131, 1.068, 
             1.208, 1.319, 1.281, 0.905, 0.819, 0.826, 0.974, 0.888, 0.804, 
             0.996, 1.127, 1.17, 1.166, 1.261, 1.275, 1.179, 1.079, 0.951, 
             0.852, 0.872, 0.834, 0.859, 1.077, 1.095, 1.285, 1.323, 1.16, 
             1.125, 0.957, 0.948, 0.907, 0.89, 0.999, 0.999, 0.953, 0.9, 0.986, 
             1.187, 1.054, 1.079, 0.997, 0.851, 0.803, 0.971, 1.025, 1.086, 
             1.114, 1.068, 1.091, 1.034, 0.871, 0.781, 0.865, 0.7, 0.673, 
             0.881, 0.782, 0.97, 1.044, 1.17, 1.196, 1.091, 1.068, 0.967, 
             0.823, 0.73, 0.693, 0.788, 1.095, 1.183, 0.996, 1.105, 0.939, 
             0.914, 0.813, 0.775)

months <- c("January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December", "January", 
            "February", "March", "April", "May", "June", "July", "August", 
            "September", "October", "November", "December", "January", "February", 
            "March", "April", "May", "June", "July", "August", "September", 
            "October", "November", "December", "January", "February", "March", 
            "April", "May", "June", "July", "August", "September", "October", 
            "November", "December", "January", "February", "March", "April", 
            "May", "June", "July", "August", "September", "October", "November", 
            "December", "January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December", 
            "January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December", "January", 
            "February", "March", "April", "May", "June", "July", "August", 
            "September", "October", "November", "December", "January", "February", 
            "March", "April", "May", "June", "July", "August", "September", 
            "October", "November", "December", "January", "February", "March", 
            "April", "May", "June", "July", "August", "September", "October", 
            "November", "December", "January", "February", "March", "April", 
            "May", "June", "July", "August", "September", "October", "November", 
            "December", "January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December", 
            "January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December", "January", 
            "February", "March", "April", "May", "June", "July", "August", 
            "September", "October", "November", "December", "January", "February", 
            "March", "April", "May", "June", "July", "August", "September", 
            "October", "November", "December", "January", "February", "March", 
            "April", "May", "June", "July", "August", "September", "October", 
            "November", "December", "January", "February", "March", "April", 
            "May", "June", "July", "August", "September", "October", "November", 
            "December", "January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December", 
            "January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December", "January", 
            "February", "March", "April", "May", "June", "July", "August", 
            "September", "October", "November", "December", "January", "February", 
            "March", "April", "May", "June", "July", "August", "September", 
            "October", "November", "December", "January", "February", "March", 
            "April", "May", "June", "July", "August", "September", "October", 
            "November", "December", "January", "February", "March", "April", 
            "May", "June", "July", "August", "September", "October", "November", 
            "December", "January", "February", "March", "April", "May", "June", 
            "July", "August", "September", "October", "November", "December", 
            "January", "February", "March")

river <- data.table(nitrate, months)
river[, index := 1:.N]


data_table <- function(df){
    library(DT)
    datatable(df,
              rownames = FALSE,
              style = "bootstrap4", class = 'cell-border stripe',
              options = list(scrollX = TRUE,
                  columnDefs = list(list(className = 'dt-center', targets = 1:ncol(df)))
              )
    )
}
save(data_table, file = "data_table.rda")
