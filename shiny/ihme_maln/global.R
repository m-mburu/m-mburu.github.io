
library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(tmap)
library(leaflet)
library(DT)
library(plotly)
library(ggthemes)
library(data.table)
library(gapminder)
library(zoo)

africa_unicef <- fread("data/africa_unicef.csv")

countries <- rnaturalearth::ne_countries(scale = 50,
                                         type = 'sovereignty',
                                         returnclass = "sf", continent = "Africa") %>% 
    setDT()

countries[,  sovereignt := ifelse(grepl( "swaziland", tolower( sovereignt) ), "eswatini" ,  sovereignt)]
countries[,  sovereignt := ifelse(grepl( "guinea bissau", tolower( sovereignt) ), "guinea-bissau" ,  sovereignt)]

africa_count <- countries#[tolower(sovereignt) %in%
                           #   tolower(africa_unicef$countryname)]

y <- unique(africa_count$sovereignt) %>% tolower()



setnames(africa_count, "sovereignt", "countryname")

africa_count <- africa_count[, .(countryname, geometry,
                 pop_est, gdp_md_est, income_grp)]

africa_count[, countryname := tolower(countryname)]
africa_unicef[, countryname := tolower(countryname)]


type_sex_area <- africa_unicef[, unique(type)] %>% as.character()
countries_names <- africa_unicef[, unique(countryname)]
# africa_unicef_merge <- merge(africa_unicef,
#                              africa_count, 
#                              by = "countryname",
#                              all = T) 
# 
# 
# africa_unicef_merge <- africa_unicef_merge[cmrs_year>1998]
# 
# setorder(africa_unicef_merge, cmrs_year, countryname )
# 
# africa_unicef_merge[, value := na.fill(value, type = "locf", fill = NA)]
# 
# #names(africa_unicef_merge)

# 
# df <- africa_unicef[type == "national" & cmrs_year == 2015]
# 
# df <- merge(df, africa_count,
#             by = "countryname", all.y = T) 
# 
# df <- st_set_geometry(df, "geometry")
# 
# my_map <- tm_shape(df) +
#     tm_fill(col = "value")
# tmap_leaflet(my_map, in.shiny = TRUE)
