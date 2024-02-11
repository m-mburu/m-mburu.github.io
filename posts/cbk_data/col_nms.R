

library(dplyr)
library(data.table)
# I find it easier to use data.table
## put the dfs as a list


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


var <- c('City_Name',  'Temp',  'Pres' , 'Wind_Hor' , 'Wind_Ver' , 'Rainf' , 'S_Moist')

## comment 2 columns 
df1 = data.frame(City_Name = "NYC", 
                 Temp = 20,
                 Pres = 10,
                 #Wind_Hor = 5,
                 Wind_Ver = 5,
                # Rainf = 10,
                 S_Moist = 5)

## Comment 3
df2 = data.frame(#City_Name = "NYC", 
                 Temp = 15,
                 #Pres = 15,
                 Wind_Hor = 5,
                 Wind_Ver = 5,
                 Rainf = 15)
                 #S_Moist = 5)


dfs1 <- list(df1, df2)


## loop through 
processed_dfs <- lapply(seq_along(dfs1), function(x) {
    
    
    dfn = dfs1[[x]]
    dfn_nms = names(dfn)  
    
    var_missing = var[!var %in% dfn_nms]
   
    setDT(dfn)
    
    dfn[, (var_missing) := NA] # asign NA to all
    
    dfn[, ..var] ## data.table select sstatement 
})

## dplyr method
final_df <- bind_rows(processed_dfs)

## if you want final as data.table
final_df <- rbindlist(processed_dfs)

