
library(sf)
library(tidyverse)
library(data.table)
library(spData)
library(raster)

unicef_stunting <- fread("data/unicef_stunting.csv")

nms <- unicef_stunting[3, ] %>% as.character()

idx <- grep("female_month_24_59_ul", nms)

unicef_stunting <- unicef_stunting[, 1:idx]

nms <- nms[1:idx]

nms <- gsub("\\s", "_", nms) %>% str_to_lower()

names(unicef_stunting) <- nms

unicef_stunting <- unicef_stunting[-(1:3)]

footnotes <- nms[grepl("footnote", nms)]

unicef_stunting[, (footnotes) := NULL]

nms <- names(unicef_stunting)

idx2 <- grep("national_r", nms) - 1

id_vars <- nms[1:idx2]

unicef_stunting_m <- melt(unicef_stunting, 
                          id.vars = id_vars)

unicef_stunting_m[, value := str_trim(value)]

unicef_stunting_m[, value := as.numeric(value)]

unicef_stunting_m <- unicef_stunting_m[!grepl("_weighted", variable)]

unicef_stunting_m[, type := str_extract(variable, "national|male|female|urban|rural|^month")]

unicef_stunting_m[, table(type, useNA = "always")]

unicef_stunting_m[is.na(type)] %>% View

unicef_stunting_m <- unicef_stunting_m[!is.na(type)]

unicef_stunting_m[, age := str_extract(variable, "_month.*")]
unicef_stunting_m[, age := gsub("_month_|_[a-z]{1,2}$", "", age)]
unicef_stunting_m[, ci := str_extract(variable, "[a-z]{1,2}$")]

unicef_stunting_m[!is.na(age)] %>% View

unicef_stunting_m[, table(ci)]

unicef_stunting_m[is.na(ci)] %>% View

unicef_stunting_m <- unicef_stunting_m[!grepl("q\\d|^bottom|^top", variable)]

unicef_stunting_m <- unicef_stunting_m %>% 
    distinct(countryname, cmrs_year, variable, .keep_all = T)

unicef_stunting_m[, country := as.character(countryname)]

unicef_stunting_m[, countryname := ifelse(grepl( "^congo$",
                                                 str_to_lower(countryname) ),
                                          "Republic of the Congo", countryname)]

# unicef_stunting_m[, countryname := ifelse(grepl( "cabo verde",
#                                                  str_to_lower(countryname) ), 
#                                           "Cape Verde", countryname)]
# 
unicef_stunting_m[, countryname := ifelse(grepl( "côte d'ivoire",
                                                 str_to_lower(countryname), fixed = TRUE ),
                                          "Ivory Coast", countryname)]


unicef_stunting_m[, countryname := ifelse(grepl( "tanzania",
                                                 str_to_lower(countryname) ),
                                          "tanzania", countryname)]


africa_unicef <- unicef_stunting_m[unregion == "Africa"]


x  <- unique(africa_unicef$countryname) %>% str_to_lower

countries <-  world %>% 
    filter(continent == "Africa") %>% setDT()

# 


countries[,  name_long := ifelse(grepl( "eSwatini", name_long), "eswatini" ,  name_long)]
countries[,  name_long := ifelse(grepl( "tanzania", str_to_lower( name_long) ), "tanzania" ,  name_long)]
countries[,  name_long := ifelse(grepl( "guinea bissau", str_to_lower( name_long) ), "guinea-bissau" ,  name_long)]
countries[,  name_long := ifelse(grepl( "the gambia", str_to_lower( name_long) ), "gambia" ,  name_long)]

countries[, name_long := ifelse(grepl( "côte d'ivoire",
                                                 str_to_lower(name_long), fixed = TRUE),
                                          "Ivory Coast", name_long)]

africa_count <- countries[str_to_lower(name_long) %in%
                                      str_to_lower(africa_unicef$countryname)]

y <- unique(africa_count$name_long) %>% str_to_lower()

x[!x %in% y ]

setnames(africa_count, "name_long", "countryname")

# write_csv(africa_unicef, path = "data/africa_unicef.csv")
st_write(world, "data/africa_shp/world.shp")




year_unicef <- africa_unicef[, unique(cmrs_year)] %>% sort()

x  <- africa_count[, unique(countryname)]

year_long <- rep(year_unicef, length(x))

x_long <- rep(x, each = length(year_unicef))

df_comp <- data.table(countryname =  x_long, cmrs_year = year_long)

interest_var <- c("national_r", "male_r",
                  "female_r" ,  "urban_r", "rural_r" )

africa_unicef[, unique(variable)]
africa_unicef <- africa_unicef[variable %in% interest_var | type %in% "month"]
africa_unicef <- africa_unicef[ci == "r"]
africa_unicef[, countryname := str_to_lower(countryname)]
africa_split <- split(africa_unicef,
                      by = c("countryname", "variable"), drop = TRUE)


comb_list <- list()
df_comp[, countryname := str_to_lower(countryname) ]

for (i in 1:length(africa_split)) {
    
    df = africa_split[[i]]
    #df[, countryname := str_to_lower(countryname) ]
    country = df[, unique(countryname)]
    df_comp1 <- df_comp[countryname ==  country]
    
    df <- merge(df, df_comp1,
                by = c("countryname", "cmrs_year"), all.y = T)
    
    df[, value := nafill(value, type = "locf")]
    df[, value := nafill(value, type = "nocb")]
    var  = df[!is.na(variable), unique(variable)] %>% as.character()
    df[, variable := var]
    var1  = df[!is.na(type), unique(type)] %>% as.character()
    df[, type := var1]
    # var1  = df[!is.na(ci), unique(ci)] %>% as.character()
    # df[, ci := var1]
    var1  = df[!is.na(country), unique(country)] %>% as.character()
    df[, country := var1]
    comb_list[[i]] = df
    cat(i, "...")
}



africa_unicef <- rbindlist(comb_list)
africa_unicef[type == "month", age := str_extract(variable, "_.*_")]
africa_unicef[, age := str_trim(gsub("^_|_$", "", age))]
#africa_unicef[, ci := str_extract(variable, "[a-z]{1,2}$")]

africa_unicef[, countryname := as.character(countryname)]
africa_count[, countryname := as.character(countryname)]

africa_unicef[, countryname := str_to_lower(countryname)]
africa_count[, countryname := str_to_lower(countryname)]

africa_unicef <- merge(africa_unicef, 
                       africa_count[, .(countryname, gdpPercap, lifeExp)], by = "countryname",
                       all.y = TRUE)

africa_unicef[, country := paste0(country," ", value, " %")]
#africa_unicef[, formal_en := paste0(formal_en, " ", value, "%")]
save(africa_unicef,  "data/africa_unicef.rda")



##

#read wasting prevalance and stunting
world_wasting <- raster("data/wasting_post_means.TIF")

world_underwight <- raster("data/underweight_post_means.TIF")

world_stunting <- raster("data/stunt_post_means.TIF")

plot(world_stunting)

africa_count_sf <- st_set_geometry(africa_count, "geom")

africa_count_sp <- as_Spatial(africa_count_sf)

africa_count[, wasting_prev := raster::extract(world_wasting, africa_count_sp,
                                           weights=FALSE, fun=mean,
                                           na.rm = T)]

africa_count[, underweight_prev := raster::extract(world_underwight, africa_count_sp,
                                               weights=FALSE, fun=mean,
                                               na.rm= T)]


africa_count[, stunting_prev := raster::extract(world_stunting, africa_count_sp,
                                            weights=FALSE, fun=mean,
                                            na.rm = T)]


save(africa_count[, .(countryname, wasting_prev, underweight_prev, stunting_prev)],
          file = "data/africa_malnutrition_prev.rda")


## test
africa_count <- st_set_geometry(africa_count, "geom")
ggplot(africa_count) +
    geom_sf()


