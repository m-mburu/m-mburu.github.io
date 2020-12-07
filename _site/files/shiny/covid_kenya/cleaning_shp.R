
library(tidyverse)
library(data.table)
library(sf)

counties <- st_read("data/County/County.shp") %>% setDT()
counties[, COUNTY := gsub("-", " ", COUNTY)]
counties[COUNTY == "Keiyo Marakwet" , COUNTY := "Elgeyo Marakwet"]

head(counties) %>% View

counties_nms_c <- october_m[, unique(county)] %>% tolower()

counties_nms_shape <- counties[, unique(COUNTY)] %>% tolower()

counties_nms_shape[!counties_nms_shape %in% counties_nms_c ]

names(counties) <- names(counties) %>% tolower()

counties[, county_id := tolower(county)]

counties <- st_set_geometry(counties, "geometry")

st_write(counties, "data/kenya_county/kenya_county.shp")
