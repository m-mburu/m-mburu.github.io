
library(tidyverse)
library(data.table)
years = 5 *12 %>% as.integer()
mon = 12000

vars <- rnorm(100000, mean = .067, sd = .001)

hist(vars)
sum_vars = 12000
hist_vals <- c()
interest <- c()
deposits <- c()
lump =0000
lump_months = c(3, 5, 8)
daily_interest <- list()
for(i in 1:years){
    
    
    interest_sum = 0
    for (j in 1:30) {
        int = sample(vars, 1)
        interesti = sum_vars * (1+ int/365) - sum_vars
        sum_vars = sum_vars + interesti
        interest_sum = interest_sum + interesti
    }
    
    if(i %in% lump_months) {deposit = mon + lump}else {deposit = mon}
 
    interest[i] = interest_sum
    sum_vars = sum_vars + deposit
    hist_vals[i] = sum_vars
    deposits[i] = deposit
    
    
    
}

plot(hist_vals, type = "l")
hist_vals
interest

