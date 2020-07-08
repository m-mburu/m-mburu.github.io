library(sf)
library(raster)
library(tidyverse)
library(data.table)
library(readxl)
library(geosphere)
library(tmap)




#read wasting prevalance and stunting
world_stunting <- raster("stunt_post_means.TIF")

plot(world_stunting)


clean_read <- function(data_folder, raster_file, name){
    
    df <- st_read(data_folder)
    df_sp <- as(df, "Spatial")
    setDT(df)
    df[, (name):=  raster::extract(raster_file, df_sp,
                                   weights=FALSE, fun=mean,
                                   na.rm = T)]
    
    df = st_set_geometry(df, "geometry")
    return(df)
}



file_nms <- c("kenya", "tz_shape", "rwanda", "uganda")

i = 0

data_sets <- lapply(file_nms, function(x)
    
    #i <<- i + 1,
   
    df = clean_read(data_folder = x, raster_file = world_stunting, name = "stunt_prev")
    
    
    
)

rwanda <- st_read("kenya")

names(data_sets) <- file_nms

list2env(data_sets, .GlobalEnv)

names(kenya)
kenya_sub <- kenya %>% select(ADM2_EN, geometry, stunt_prev)
tz_shape_sub <- tz_shape %>% select(ADM2_EN, geometry, stunt_prev) %>%
    mutate(ADM2_EN = paste0(ADM2_EN, stunt_prev))
ttm()
tm_shape(tz_shape_sub)+
    tm_borders(col = "gold")+
    tm_fill(col = "stunt_prev")
