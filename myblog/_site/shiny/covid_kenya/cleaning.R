library(tidyverse)
library(data.table)
library(zoo)
october <- fread("data/october.csv")
kenya_counties <- st_read("data/kenya_county/kenya_county.shp")

october_m <- melt(october, 
                  id.vars = c("county", "cumulative_cases"),
                  variable.factor = F,
                  variable.name = "day",
                  value.name = "cases",
                  value.factor = F)

october_m <- october_m[county != "Kenya"]

october_m[, day := paste0(day, "-", 2020)]

october_m[, day := as.Date(day, "%d-%b-%Y")]

october_m[, county := gsub("/", " ", county)]
october_m[, county := str_trim(gsub("-nithi", " ", tolower(county)))]
october_m[, county := str_trim(gsub("city", "", tolower(county)))]

october_m[, county_id := tolower(county)]

october_m[is.na(cases), cases := 0]

october_m[, week_no := week(day)]

week_tally <- october_m[, .(week_ave = mean(cases, na.rm = T)), by = .(county, week_no)]
