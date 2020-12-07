
setwd("E:/R/shape files/kenyan-counties")

pacman::p_load(maptools)

pacman::p_load(rgdal)
counties <- rgdal::readOGR("County.shp")
#install.packages("gpclib", type="source")
library(ggplot2)
x <- counties@data
county_name <- x$COUNTY
library(gpclib)
kenya_df <- broom::tidy(counties)
head(kenya_df)
map <- ggplot() +
        geom_polygon(data = kenya_df, aes(x = long, y = lat, group = id, fill= id),  colour = "black")

m <- map + theme_void()
plotly::ggplotly(m)
library(data.table)
library(readxl)
acc <- setDT(read_excel("E:/R/accident database/accidents-database-.xlsx"))

library(ggmap)

api_key_google = "AIzaSyBdcFLR53zlEQuT249Tx6WJ6eVKgq2qp38"

register_google(key = api_key_google)

place <- gsub("na|near|kercho ", "", tolower(paste(acc$COUNTY,acc$PLACE)))
df_codes <- geocode(place)

library(dplyr)
get_map(location = "Isiolo", zoom = 6, maptype = "roadmap") %>% ggmap()+
    geom_point(data = df_codes, aes(lon, lat), size = 2)+
    stat_density2d(
        aes(x = lon, y = lat, fill = ..level..
        ),alpha = 0.7,
        size = 2, bins = 7, data = df_codes,
        geom = "polygon")


max(df_codes$lon, na.rm = T)
max(df_codes$lat, na.rm = T)

setDT(df_codes)

summary(df_codes)
#df_codes[, lat := ifelse(lat > 6|lat<-2, NA, lat)]

df_codes[, lon := ifelse(lon < 21, NA, lon)]

df_codes[, lat := ifelse(lat > 6, NA, lat)]

map <- ggplot() +
    geom_polygon(data = kenya_df, aes(x = long, y = lat, group = id),  colour = "black", fill = NA)+
    stat_density2d(
        aes(x = lon, y = lat, fill = ..level..
           ),alpha = 0.7,
        size = 2, bins = 20, data = df_codes,
        geom = "polygon")

map + theme_void()




library(ggplot2)
library (rgdal)
library (rgeos)
library(maptools)

county_shp <-  rgdal::readOGR("County.shx" )

county_shp@data$id <- rownames(county_shp@data)



county_points <- fortify(county_shp)
county_df <- merge(county_points, county_shp@data, by="id")

map <- ggplot() +
    geom_polygon(data =county_df, aes(x = long, y = lat, group = id, fill = COUNTY))+
    theme_void() +
    ggtitle("Kenya Counties") +
    theme(legend.position = "none")

map


