options(scipen = 999)
gok_earnings_exp[, quarter_yr := quarter(date)]

p = plot_compare(df = gok_earnings_exp, 
                 id_vars = c("year"),
                 compare_vars = c("totalexpenditure", "totalrevenue"),
                 x_val = year,
                 col_val = variable,
                 y_val = sum_val)   


p

p = plot_compare(df = gok_earnings_exp, 
                 id_vars = c("year"),
                 compare_vars = c("totalexpenditure", "totalrevenue"),
                 x_val = year,
                 col_val = variable,
                 y_val = sum_val)   


p


exp_types_total <- c("totalrecurrent", 
                     "county_transfer", 
                     "developmentexpenditure")


p = plot_compare(df = gok_earnings_exp, 
                 id_vars = c("year"),
                 compare_vars = exp_types_total,
                 x_val = year,
                 col_val = variable,
                 y_val = sum_val)   


p

types_of_recurrent_exp <- c("recurrent_expenditure_domestic_interest", 
                            "foreign_interest", "wages_salaries",
                            "pensions", "other")



p = plot_compare(df = gok_earnings_exp, 
                 id_vars = c("year"),
                 compare_vars = types_of_recurrent_exp,
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
