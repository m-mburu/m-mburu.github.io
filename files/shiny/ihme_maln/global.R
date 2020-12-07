
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

africa_unicef <- africa_unicef[!is.na(type)]

africa_unicef[grepl("^month", variable), type := age]

# child_age <- c("0_5", "6_11", "12_23", "0_23",
#                "24_35", "36_47", 
#                "48_59", "24_59")

child_age <- c("0_5", "6_11", "12_23", "24_35", "36_47","48_59")

#child_ageb <- c("0_23", "24_59")

africa_unicef[, type2 := case_when(type %in% c("male", "female") ~ "Sex",
                                   type %in% c("rural", "urban") ~ "Rural/Urban",
                                   type %in% child_age ~ "Age",
                                   type %in%  "national" ~ "National",
                                   TRUE ~ "NA")]

africa_unicef[, type2 := ifelse(type2 == "NA", NA, type2)]
africa_unicef <- africa_unicef[!is.na(type2)]

#africa_unicef[, table(type, type2)]
#africa_unicef[type2 == "Age", unique(type)]




type_sex_area <- africa_unicef[, unique(type)] %>% as.character()
year_unicef <- africa_unicef[, unique(cmrs_year)] %>% sort()
countries_names <- africa_unicef[, unique(countryname)]

africa_prev <- fread("data/africa_malnutrition_prev.csv")

africa_prev_melt <- melt(africa_prev, id.vars = "countryname",
                    variable.factor = F,
                    variable.name = "maln_level",
                    value.name = "ihm_maln_estimate")


africa_country <- africa_unicef %>% distinct(countryname, country)
africa_country[, country := gsub("\\d.*$", "", country)]
africa_country <-africa_country %>% distinct(countryname, country)
maln_level <- africa_prev_melt[, unique(maln_level)]

africa_prev_melt <- merge(africa_prev_melt, africa_country, by = "countryname" )

africa_prev_melt[, ihm_maln_estimate := round(ihm_maln_estimate * 100, 2)]

africa_prev_melt[, country_name := paste0(country, " ", ihm_maln_estimate, " %" )]

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
