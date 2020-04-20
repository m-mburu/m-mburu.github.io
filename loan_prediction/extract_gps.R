
library(sf)
library(raster)
library(tidyverse)
library(data.table)
library(readxl)
library(geosphere)
library(tmap)

#population density file
world <- raster("ppp_2019_1km_Aggregated.tif")


#get projection for map
proj4string = CRS(as.character(projection(world)))
gps_data <- fread("gps_data.csv")
gps_data <- gps_data[!is.na(Latitude)]
setorder(gps_data, record_id)
chain_shape <- SpatialPointsDataFrame(gps_data[,.(Longitude,Latitude)], 
                                                gps_data ,    #the R object to convert
                                                proj4string = proj4string)   # assign a CRS 




#outfile <- 'shape_files/chain.shp'
#shapefile(chain_shape, outfile, overwrite=TRUE)
# 



gps_data[, pop_density := raster::extract(world, chain_shape, weights=FALSE, fun=mean)]


#read wasting prevalance and stunting
world_wasting <- raster("wasting_post_means.TIF")

world_underwight <- raster("underweight_post_means.TIF")

world_stunting <- raster("stunt_post_means.TIF")

#extracting values
gps_data[, wasting_prev := raster::extract(world_wasting, chain_shape, weights=FALSE, fun=mean)]

gps_data[, underweight_prev := raster::extract(world_underwight, chain_shape, weights=FALSE, fun=mean)]


gps_data[, stunting_prev := raster::extract(world_stunting, chain_shape, weights=FALSE, fun=mean)]

##Africa health facilities from who
who_gps <- read_excel("who-cds-gmp-2019-01-eng.xlsx") %>% setDT()

#african countries where chain is
countries <- c("Burkina Faso", "Kenya", "Uganda", "Malawi" )

africa_chain_health_fac <- who_gps[Country %in% countries]

africa_sites <- gps_data[site %in% c("Kilifi", "Migori", "Nairobi", 
                                     "Blantyre", "Banfora", "Kampala")] 

#subset africa sites in chain data
africa_sites[, Country := ifelse(site %in%  c("Kilifi", "Migori", "Nairobi"), "Kenya",
                                 ifelse(site %in% "Kampala", "Uganda", 
                                        ifelse(site == "Blantyre", "Malawi",
                                               "Burkina Faso"))) ]


#rename
setnames(africa_chain_health_fac, "Facility type",  "hospital_type")

#split into lists

africa_chain_health_fac_list <- split(africa_chain_health_fac, 
                                      africa_chain_health_fac$Country)

library(geosphere)
library(foreach)
#function to calculate distances
source("cross_dist.R")

#get nearest dist for african sites
list_countries_africa <- foreach(i = 1:length(africa_chain_health_fac_list),
                                 .packages = c("data.table", "geosphere")) %do%{
                                     this = africa_chain_health_fac_list[[i]]
                                     country = unique(this$Country)
                                     cat("\n", country, "..", "\n", "")
                                     that = africa_sites[Country == country]
                                     chain_site = that[, unique(as.character(site))]
                                    dfg= calculate_dist(chain_gps_data = that, 
                                                    country_hospitals = this,
                                                    chain_site = chain_site )
                                    dfg
                                 } 




#combine the lists
africa_sites_nearest <- rbindlist(list_countries_africa)

africa_sites_nearest[, Country := NULL]
#pakistan healthfacilities
pakistan <- fread("pakistan.csv")

setnames(pakistan, c("X", "Y", "amenity"), c("Long", "Lat", "hospital_type"), )

#Pakistan Extraction
pakistan <- pakistan[!is.na(Long)]
pakistan <- pakistan[hospital_type != "pharmacy"]

karachi_dist <- calculate_dist(chain_gps_data = gps_data,
                              country_hospitals = pakistan, 
                              chain_site = "Karachi")


#read bangladesh health facilities data
bang_health <- sf::st_read("bandgladesh_health")

bang_health <- st_transform(bang_health, crs = "+proj=longlat")

bang_coordinates <- data.table(hospital_type =bang_health$FType, st_coordinates(bang_health))

setnames(bang_coordinates, c("X", "Y"), c("Long", "Lat") )

bang_coordinates[, hospital_type := as.character(hospital_type)]

bang_dist <- calculate_dist(chain_gps_data = gps_data,
                            country_hospitals = bang_coordinates, 
                            chain_site = c("Dhaka", "Matlab"))


#bind row nearest 
gps_data <- rbindlist(list(africa_sites_nearest , 
                      karachi_dist, bang_dist))

study_hospitals <- read_excel("GPS_coordinatesSITES_updated.xlsx") %>% setDT()


gps_data <- merge(gps_data, study_hospitals, by  = "site")

list_sites <- split(gps_data, gps_data$site)

list_sites_output <- list()

for (i in 1:length(list_sites)) {
    this = list_sites[[i]]
    list_in = list()
    
    for (k in 1:nrow(this)) {
        part_coords = c(this$Longitude[k], this$Latitude[k])
        hospital_coords = c(this$lon[k], this$lat[k])
        
        dist_to_hosp <- distHaversine(part_coords,
                                      hospital_coords)/1000
        
        list_in[[k]] <- data.table(this[k,], study_hosp_dist = dist_to_hosp)
    }
    list_sites_output[[i]] <- rbindlist(list_in)
    cat(i, "..")
}

id <- fread("master_recordIDs_list_v8.csv")
id[, site := as.integer(as.numeric(record_id)/1000)]
lvl_site <- c( 10001, 10002, 10003, 20001,
               30001, 40001, 50001, 50002, 60001)

lbl_site <- c("Kilifi","Nairobi","Migori","Kampala",
              "Blantyre","Karachi","Dhaka","Matlab","Banfora")
id[, site :=  factor(site, levels = lvl_site, labels = lbl_site)]
id[,  adm_parttype := ifelse(str_sub(record_id, 6, 6) %in% c(7, 8,9), 2, 1)]

nms_del <- c("site", "adm_parttype", "Country")

gps_data_final <- rbindlist(list_sites_output)
gps_data_final[, (nms_del) := NULL]

chain_gps_dist <- merge(id, gps_data_final, by = "record_id", all.x = T)

write.csv(chain_gps_dist, file = "chain_gps_data.csv", row.names = F, na = ".")

if (!require("installr")){ 
    install.packages("installr")
    library(installr)
    install.imagemagick("https://www.imagemagick.org/script/download.php")
} else {
library(installr)
install.imagemagick("https://www.imagemagick.org/script/download.php")
}
