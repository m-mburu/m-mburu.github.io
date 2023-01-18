library(tidyverse)
library(data.table)
library(shiny)
library(shinydashboard)

load("data/finaccess_2021.rda")

df <- finaccess_2021[, .(freq = .N), by = .(County, A24)][
    ,sample_size := sum(freq), by = County][
        , perc := round(freq/sample_size * 100, 1)][A24 == "Yes"]

library(ggiraph)

kenya_counties_m <- left_join(kenya, kenya_counties, 
                              by = "county")

df[, County := as.character(County)]
kenya_counties_m[, County := as.character(County)]
df <- left_join(df, kenya_counties_m, by = "County")

df <- st_set_geometry(df, value = "geometry")
p = ggplot(df)+
    geom_sf_interactive(aes(fill = perc, tooltip = paste0(County, ":" ,perc, "%")))+
    theme_void()

ggiraph(ggobj = p)

finacces_labels <- sapply(finaccess_2021, attr, "label")
finacces_nms <- names(finaccess_2021)

fin_col_labels <- data.table(finacces_nms = finacces_nms,
                             finacces_labels = finacces_labels)

fin_col_labels[, gen_name := str_extract_all(finacces_nms, "^.{3}")]
fin_col_labels[, gen_name := str_trim(gen_name)]

fin_col_labels[, finacces_labels := str_replace_all(finacces_labels, finacces_nms, "")]

fin_col_labels[, finacces_labels := str_replace_all(finacces_labels, "^\\.", "")]

fin_col_labels[, finacces_labels := str_trim(finacces_labels)]
