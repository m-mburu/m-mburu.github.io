library(tidyverse)
library(data.table)
library(sf)
library(tmap)
energy_types <- fread('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-04/energy_types.csv', header = TRUE)
country_totals <- fread('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-04/country_totals.csv', header =  TRUE)

worldmap <- rnaturalearth::ne_download(scale = 110,
                                       type = "countries",
                                       category = "cultural",
                                       destdir = tempdir(),
                                       load = TRUE,
                                       returnclass = "sf")
country_totals[country == "UK", country_name := "United Kingdom"]

energy_types[country == "UK", country_name :="United Kingdom"]


setDT(worldmap)
worldmap[grepl("macedonia", tolower(ADMIN)), ADMIN]
worldmap[ADMIN == "Republic of Serbia", ADMIN := "Serbia" ]
worldmap[ADMIN == "Bosnia and Herzegovina", ADMIN := "Bosnia & Herzegovina" ]
worldmap[ADMIN == "Bosnia and Herzegovina", ADMIN := "Bosnia & Herzegovina" ]
worldmap[ADMIN == "Macedonia", ADMIN := "North Macedonia" ]

countries <- energy_types[, unique(country_name)] %>% sort()


europe <- worldmap[worldmap$ADMIN %in% countries,]

europe <- st_set_geometry(europe, "geometry")

table(europe$SOVEREIGNT)
class(europe)

ggplot(europe)+
    geom_sf()

ttm()
tm_shape(europe)+
    tm_polygons(id = "ADMIN")
