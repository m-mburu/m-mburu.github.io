
library(tidyverse)
library(data.table)
library(gtsummary)
library(lubridate)
library(mTools)
"Analysis of tax revenues"
source(here("R/used_functions.R"))
gok_earnings_exp <- fread("https://www.centralbank.go.ke/uploads/government_finance_statistics/2061750468_Revenue%20and%20Expenditure.csv")

domestic_debt <- fread("https://www.centralbank.go.ke/uploads/government_finance_statistics/602640278_Domestic%20Debt%20by%20Instrument.csv", skip =2)

domestic_debt <- domestic_debt %>% 
    janitor::clean_names()


dm_explanation <- domestic_debt[grep("\\*", fiscal_year)[1] : .N]
domestic_debt <- domestic_debt[-(grep("\\*", fiscal_year)[1] : .N)]

domestic_debt <- domestic_debt[fiscal_year != ""]
firs_cols1 <- gok_earnings_exp[5, ] %>% as.character()

firs_cols <- gok_earnings_exp[6, ] %>% as.character()

sec_cols <- gok_earnings_exp[7, ] %>% as.character()

col_nms_rev_exp <- paste0(firs_cols1, firs_cols, sec_cols) %>% 
    janitor::make_clean_names()

col_nms_rev_exp[col_nms_rev_exp == "x"] = "month"

names(gok_earnings_exp) = col_nms_rev_exp

gok_earnings_exp <- gok_earnings_exp[-(1:8)]


gok_earnings_exp[, (col_nms_rev_exp) := lapply(.SD,convert_to_num), .SDcols = col_nms_rev_exp]

rev_exp_vars <- c( "tax_revenue_import_duty", "excise_duty", 
                   "income_tax", "vat", "othertax_income", "totaltaxrevenue", "non_taxrevenue", 
                   "totalrevenue", "programme_grants", "project_grants", "total_grants", 
                   "recurrent_expenditure_domestic_interest", "foreign_interest", 
                   "wages_salaries", "pensions", "other", "totalrecurrent", "county_transfer", 
                   "developmentexpenditure", "totalexpenditure")

rev_exp_vars_new <- c( "import_duty", "excise_duty", 
                   "income_tax", "vat", "othertax_income", "total_tax_revenue", "non_taxrevenue", 
                   "total_revenue", "programme_grants", "project_grants", "total_grants", 
                   "domestic_interest", "foreign_interest", 
                   "wages_salaries", "pensions", "other", "total_recurrent", "county_transfer", 
                   "development_expenditure", "total_expenditure")

#gok_earnings_exp[, (rev_exp_vars) := lapply(.SD, function(x) x/1000), .SDcols = rev_exp_vars]

gok_earnings_exp[, date := as.Date(paste(year, month, "01", sep = "-"))]
gok_earnings_exp[, quarter_m := quarter(date)]
gok_earnings_exp[, number := 1:.N]

gok_sum <- gok_earnings_exp[, .(totalexpenditure = sum(totalexpenditure), totalrevenue = sum(totalrevenue)), by = year]

setnames(gok_earnings_exp,
         rev_exp_vars, 
         rev_exp_vars_new)

save(gok_earnings_exp, file = here("data", "gok_earnings_exp.rda"))

setDT(domestic_debt)

domestic_debt_vec <- c("treasury_bills", "treasury_bonds", 
                       "government_stocks", "overdraft_at_central_bank",
                       "advances_from_commercial_banks", 
                       "other_domestic_debt", "total_domestic_debt")

domestic_debt[, (domestic_debt_vec) := lapply(.SD,convert_to_num),
              .SDcols = domestic_debt_vec]
domestic_debt[, fiscal_year := paste(fiscal_year, "-01")]

domestic_debt <- cbind(domestic_debt, gok_earnings_exp[, .(date, quarter_m, year)])
save(domestic_debt, file = here("data", "domestic_debt.rda"))


# exp_rev_per_year = exp_plot_list$data
# exp_rev_per_year_wide <- dcast(year~variable,
#                                value.var = "sum_val", 
#                                data = exp_rev_per_year)
# 
# exp_rev_per_year_wide[,  perc_diff :=( total_expenditure - total_revenue)/total_revenue * 100]

