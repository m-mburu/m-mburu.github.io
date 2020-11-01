
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

africa_unicef <- fread("data/africa_unicef.csv")


world <- st_read("data/africa_shp/world.shp")

countries <-  world %>% 
    filter(continent == "Africa") %>% setDT()

countries[, name_long := as.character(name_long)]
# 
# countries <- rnaturalearth::ne_countries(scale = 50,
#                                          type = 'sovereignty',
#                                          returnclass = "sf",
#                                          continent = "Africa") %>% 
#     setDT()


countries[,  name_long := ifelse(grepl( "swaziland", tolower( name_long) ), "eswatini" ,  name_long)]
countries[,  name_long := ifelse(grepl( "guinea bissau", tolower( name_long) ), "guinea-bissau" ,  name_long)]
countries[,  name_long := ifelse(grepl( "the gambia", tolower( name_long) ), "gambia" ,  name_long)]
countries[, name_long := ifelse(grepl( "côte d'ivoire",
                                       tolower(name_long), fixed = TRUE),
                                "Ivory Coast", name_long)]

africa_count <- countries#[tolower(name_long) %in%
#tolower(africa_unicef$countryname)]

y <- unique(africa_count$name_long) %>% tolower()

#x[!x %in% y ]

setnames(africa_count, "name_long", "countryname")




africa_count <- africa_count[, .(countryname, geometry)]

africa_count[, countryname := tolower(as.character(countryname))]
africa_unicef[, countryname := tolower(as.character(countryname))]


type_sex_area <- africa_unicef[, unique(type)] %>% as.character()
year_unicef <- africa_unicef[, unique(cmrs_year)] %>% sort()
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
df <- africa_unicef[type == "national" & cmrs_year == 2015]

df <- merge(df, africa_count,
            by = "countryname", all.y = T)

df <- st_set_geometry(df, "geometry")

my_map <- tm_shape(df) +
    tm_fill(col = "value")
tmap_leaflet(my_map, in.shiny = TRUE)
