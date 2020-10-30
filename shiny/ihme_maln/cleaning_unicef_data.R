
library(sf)
library(tidyverse)
library(data.table)

unicef_stunting <- fread("data/unicef_stunting.csv")

nms <- unicef_stunting[3, ] %>% as.character()

idx <- grep("female_month_24_59_ul", nms)

unicef_stunting <- unicef_stunting[, 1:idx]

nms <- nms[1:idx]

nms <- gsub("\\s", "_", nms) %>% tolower()

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

unicef_stunting_m[, countryname := ifelse(grepl( "congo",
                                                 tolower(countryname) ), 
                                          "Republic of Congo", countryname)]

unicef_stunting_m[, countryname := ifelse(grepl( "cabo verde",
                                                 tolower(countryname) ), 
                                          "Cape Verde", countryname)]

unicef_stunting_m[, countryname := ifelse(grepl( "côte d'ivoire",
                                                 tolower(countryname) ), 
                                          "Ivory Coast", countryname)]

africa_unicef <- unicef_stunting_m[unregion == "Africa"]

x  <- unique(africa_unicef$countryname) %>% tolower()


countries <- rnaturalearth::ne_countries(scale = 50,
                                         type = 'sovereignty',
                                         returnclass = "sf",
                                         continent = "Africa") %>% 
    setDT()

countries[,  sovereignt := ifelse(grepl( "swaziland", tolower( sovereignt) ), "eswatini" ,  sovereignt)]
countries[,  sovereignt := ifelse(grepl( "guinea bissau", tolower( sovereignt) ), "guinea-bissau" ,  sovereignt)]

africa_count <- countries#[tolower(sovereignt) %in%
                                      #tolower(africa_unicef$countryname)]

y <- unique(africa_count$sovereignt) %>% tolower()

x[!x %in% y ]

setnames(africa_count, "sovereignt", "countryname")

# write_csv(africa_unicef, path = "data/africa_unicef.csv")
#st_write(africa_count, "data/africa_count.shp")

# africa_unicef_merge <- merge(africa_unicef,
#                              africa_count[, .(countryname, geometry, formal_en, pop_est, gdp_md_est, income_grp)], 
#                              by = "countryname",
#                              all.x = T) 



#write_csv(africa_unicef_merge, path = "data/africa_unicef.csv")




year_unicef <- africa_unicef[, unique(cmrs_year)] %>% sort()

x  <- africa_count[, unique(countryname)]

year_long <- rep(year_unicef, length(x))

x_long <- rep(x, each = length(year_unicef))

df_comp <- data.table(countryname =  x_long, cmrs_year = year_long)

interest_var <- c("national_r", "male_r",
                  "female_r" ,  "urban_r", "rural_r" )

africa_unicef <- africa_unicef[variable %in% interest_var]

africa_split <- split(africa_unicef,
                      by = c("countryname", "variable"), drop = TRUE)


comb_list <- list()

for (i in 1:length(africa_split)) {
    
    df = africa_split[[i]]
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
    comb_list[[i]] = df
    cat(i, "...")
}



africa_unicef <- rbindlist(comb_list)
africa_unicef <- merge(africa_unicef, 
                       africa_count[, .(countryname, formal_en)], by = "countryname",
                       all.y = TRUE)


africa_unicef[, formal_en := paste0(formal_en, " ", value, "%")]
write_csv(africa_unicef, path = "data/africa_unicef.csv")


## test
africa_count <- st_set_geometry(africa_count, "geometry")
ggplot(africa_count) +
    geom_sf()
