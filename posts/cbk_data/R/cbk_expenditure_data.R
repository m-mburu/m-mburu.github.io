
library(tidyverse)
library(data.table)
library(gtsummary)
library(lubridate)
library(mTools)
library(here)
"Analysis of tax revenues"
source(here("R/used_functions.R"))
gok_earnings_exp <- fread(here("data", "192479059_Revenue and Expenditure.csv"))

domestic_debt <- fread(here("data", "790192073_Public Debt.csv"), skip = 3) %>% 
    janitor::clean_names()



setnames(domestic_debt, "year", "fiscal_year")

col_index <- 3:8
list_col_nms <- list()

for (i in seq_along(col_index)) {
    
    list_col_nms[[i]] <- gok_earnings_exp[col_index[i], ] %>% as.character()
}

nms_list <- paste("nms", seq_along(col_index),   sep = "_")

names(list_col_nms) <- nms_list

dt_list_col <-as.data.table(list_col_nms)
dt_list_col[dt_list_col == ""] <- NA
nms_to_format <- c("nms_1", "nms_3")
dt_list_col[, (nms_to_format) := lapply(.SD, zoo::na.locf, na.rm = F), .SDcols = nms_to_format]

nms_paste <- c("nms_4", "nms_5", "nms_6")

dt_list_col[!is.na(nms_2), col_nms := paste0(nms_2,"_", nms_3)]

# replace NA with empty string for nms_paste cols
dt_list_col[, (nms_paste) := lapply(.SD, function(x) ifelse(is.na(x), "", x)), .SDcols = nms_paste]
dt_list_col[is.na(nms_2),  col_nms:= paste0(.SD, collapse = "_"), .SDcols = nms_paste, by = seq_len(nrow(dt_list_col)-2)]
dt_list_col[grepl("TOTAL|NON-TAX", nms_3)|grepl("^EXPENDITURE|Grants|^Other", nms_4), col_nms := paste0(nms_3,"_", col_nms)]

dt_list_col[, col_nms := janitor::make_clean_names(col_nms)]

col_nms_rev_exp <- dt_list_col$col_nms
names(gok_earnings_exp) <- col_nms_rev_exp

gok_earnings_exp <- gok_earnings_exp[-(1:8)]


gok_earnings_exp[, (col_nms_rev_exp) := lapply(.SD,convert_to_num), .SDcols = col_nms_rev_exp]


#gok_earnings_exp[, (rev_exp_vars) := lapply(.SD, function(x) x/1000), .SDcols = rev_exp_vars]

old_dates_nms <- c("fiscal_year", "month_year")
new_dates_nms <- c("year", "month")
setnames(gok_earnings_exp, old_dates_nms, new_dates_nms)
                   
gok_earnings_exp[, date := as.Date(paste(year, month, "01", sep = "-"))]
gok_earnings_exp[, quarter_m := quarter(date)]
gok_earnings_exp[, number := 1:.N]


save(gok_earnings_exp, file = here("data", "gok_earnings_exp.rda"))



# exp_rev_per_year = exp_plot_list$data
# exp_rev_per_year_wide <- dcast(year~variable,
#                                value.var = "sum_val", 
#                                data = exp_rev_per_year)
# 
# exp_rev_per_year_wide[,  perc_diff :=( total_expenditure - total_revenue)/total_revenue * 100]



library(ggplot2)
library(zoo)

library(readxl)

#Key CBK Indicative Exchange Rates (1).xlsx
usd_rates <- read_xlsx(here("data", "Key CBK Indicative Exchange Rates (1).xlsx"), sheet = 1)
# Assuming usd_rates is a dataframe that contains the columns 'Date' and 'Mean'
usd_rates$Date <- as.Date(usd_rates$Date, format="%d/%m/%Y")
usd_rates <- usd_rates %>%
    arrange(Date)
usd_rates$Moving_Average <- rollmean(usd_rates$Mean, 30, fill = NA, align='right')

# Plotting with ggplot2
ggplot(data = usd_rates, aes(x = Date)) + 
    geom_line(aes(y = Mean, colour = "Original Exchange Rate"), size = 1, alpha = 0.5) +
    geom_line(aes(y = Moving_Average, colour = "30-day Moving Average"), size = 1) +
    labs(title = "Kenyan Shillings to USD Exchange Rate with Moving Average",
         x = "Date", y = "Exchange Rate (KSh per USD)") +
    scale_colour_manual("",
                        breaks = c("Original Exchange Rate", "30-day Moving Average"),
                        values = c("blue", "red")) +
    theme_minimal() +
    theme(legend.position = "bottom")
