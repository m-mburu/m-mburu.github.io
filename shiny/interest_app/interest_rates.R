
library(tidyverse)
library(data.table)
years = 1 *12 %>% as.integer()
mon = 000

vars <- rnorm(100000, mean = .08, sd = .001)

hist(vars)
sum_vars =12000
hist_vals <- c()
interest <- c()
deposits <- c()
lump =0000
lump_months = c(3, 5, 8)
daily_interest <- list()


rates <- function(sum_vars, mon, lump = 0, lump_months = c(3, 5, 8), time_in_years = 1,
                  interest_rate = 0.067, compoud_period = c("daily", "monthy", "quartely", "yearly") ){
    if(is.null(compoud_period)) compoud_period = "daily"
    vars <- rnorm(100000, mean = interest_rate, sd = .001)
    
    hist_vals <- c()
    interest <- c()
    deposits <- c()
    daily_interest <- list()
    
    years = time_in_years *12 %>% as.integer()
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
    
    return(list(interest = interest, sum_vars = sum_vars,hist_vals =  hist_vals, deposits = deposits ))
}


df <- rates(sum_vars=150000, mon = 20000, lump = 0, 
            lump_months = c(3, 5, 8), interest_rate = 0.08, 
            time_in_years = 3)

plot(df$interest, type = "l")
df
hist_vals
interest

