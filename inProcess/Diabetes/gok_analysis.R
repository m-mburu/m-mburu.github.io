
library(tidyverse)
library(tidymodels)
library(data.table)
library(gtsummary)
library(mTools)
"Analysis of tax revenues"

gok_earnings_exp <- fread("https://www.centralbank.go.ke/uploads/government_finance_statistics/2061750468_Revenue%20and%20Expenditure.csv")

domestic_debt <- fread("https://www.centralbank.go.ke/uploads/government_finance_statistics/602640278_Domestic%20Debt%20by%20Instrument.csv")

firs_cols1 <- gok_earnings_exp[5, ] %>% as.character()

firs_cols <- gok_earnings_exp[6, ] %>% as.character()

sec_cols <- gok_earnings_exp[7, ] %>% as.character()

col_nms_rev_exp <- paste0(firs_cols1, firs_cols, sec_cols) %>% 
    janitor::make_clean_names()

col_nms_rev_exp[col_nms_rev_exp == "x"] = "month"

names(gok_earnings_exp) = col_nms_rev_exp

gok_earnings_exp <- gok_earnings_exp[-(1:8)]

convert_to_num <- function(x){
    
    gsub(",", "", x) |>
        as.numeric()
}

gok_earnings_exp[, (col_nms_rev_exp) := lapply(.SD,convert_to_num), .SDcols = col_nms_rev_exp]

rev_exp_vars <- c( "tax_revenue_import_duty", "excise_duty", 
                   "income_tax", "vat", "othertax_income", "totaltaxrevenue", "non_taxrevenue", 
                   "totalrevenue", "programme_grants", "project_grants", "total_grants", 
                   "recurrent_expenditure_domestic_interest", "foreign_interest", 
                   "wages_salaries", "pensions", "other", "totalrecurrent", "county_transfer", 
                   "developmentexpenditure", "totalexpenditure")


gok_earnings_exp[, (rev_exp_vars) := lapply(.SD, function(x) x/1000), .SDcols = rev_exp_vars]

gok_earnings_exp[, date := as.Date(paste(year, month, "01", sep = "-"))]
gok_earnings_exp[, number := 1:.N]

gok_sum <- gok_earnings_exp[, .(totalexpenditure = sum(totalexpenditure), totalrevenue = sum(totalrevenue)), by = year]

gok_earnings_exp <- gok_earnings_exp[year != 2023]
library(ggiraph)
plot_compare <- function(df, id_vars, compare_vars, x_val, y_val, col_val){
    cols_to_select = c(id_vars, compare_vars)
    gok_sum =  melt(df[,..cols_to_select], id.vars = id_vars)
    
    gok_sum = gok_sum[, .(sum_val = sum(value, na.rm = T)), by = c(id_vars, "variable")]
    col_val2 = enquo(col_val) %>% 
        rlang::as_name()
    len_var = gok_sum[, unique(.SD), .SDcols = col_val2] %>% nrow()
    print(len_var)

    plot = gok_sum %>%
        ggplot( aes(x =  {{x_val}} , y = {{y_val}}, color = {{col_val}}, group = {{col_val}}))+
        geom_line_interactive(aes(tooltip = paste0({{col_val}}," : " ,{{y_val}})))+
        scale_color_manual(values = brewer_pal(palette = "Accent", type = "qual")(len_var))+
        ggthemes::theme_fivethirtyeight()
    girafe(ggobj =  plot)
}


options(scipen = 999)
gok_earnings_exp[, quarter_yr := quarter(date)]

p = plot_compare(df = gok_earnings_exp, 
                 id_vars = c("year"),
                 compare_vars = c("totalexpenditure", "totalrevenue"),
                 x_val = year,
                 col_val = variable,
                 y_val = sum_val)   


p
tax_revs <- c("tax_revenue_import_duty", 
              "excise_duty", "income_tax",
              "vat", "othertax_income")

tax_revs_perc <- paste0(tax_revs, "_","perc")

gok_earnings_exp[, (tax_revs_perc) := lapply(.SD, function(x) x/totaltaxrevenue * 100), .SDcols = tax_revs]

plot_compare(df = gok_earnings_exp, 
             id_vars = "year",
             compare_vars = c("vat", "income_tax", "excise_duty"),
             x_val = year,
             col_val = variable,
             y_val = sum_val)    

ggplot(gok_sum, aes(year, totalexpenditure))+
    geom_line()+
    geom_line(aes(y = totalrevenue), size =1)
