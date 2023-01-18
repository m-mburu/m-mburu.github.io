
library(haven)
library(tidyverse)
library(data.table)
library(sf)
library(here)
library(table1)
library(tictoc)

finaccess_2021 <- read_sav(here("finaccess/Anonymized Weighted FinAccess 2021.sav"))

tic()
finaccess_2021 <- spss_label_function(finaccess_2021)
toc()

save(finaccess_2021, file = here("kenya_pop/data/finaccess_2021.rda"))
aspirations <- finaccess_2021[,.(freq = .N), by = .(County, B3B)] %>%
    .[, perc := round(freq/sum(freq) * 100, 2), by = County] 

#aspirations <- commi
xcol <- table1(~B1A|County, data = finaccess_2021) %>% as.data.frame()
#install.packages("rKenyaCensus")
# install.packages("devtools")
#remotes::install_github("Shelmith-Kariuki/rKenyaCensus")

library(rKenyaCensus)

data(DataCatalogue)

#View(KenyaCounties_SHP)

kenya_counties <- st_as_sf(KenyaCounties_SHP)

kenya_counties <- nms_clean(kenya_counties)

save(kenya_counties, file = here("kenya_pop/data/kenya_counties.rda"))

nms_prop <- c("county", "population", "area",
              "pd", "pdr", "factor", "cri")


kenya_counties_r <-kenya_counties[, .(county_key=county, county )] 


kenya_counties_fin <-finaccess_2021[, .(county_key =toupper(County), County )
                                    ]%>%unique(by = "county_key")


kenya_counties_r[county_key == "ELGEYO/MARAKWET", county_key := "ELGEYO-MARAKWET"]
kenya_counties_r[county_key == "TAITA/TAVETA", county_key := "TAITA-TAVETA"]
kenya_counties_r[county_key == "HOMA BAY", county_key := "HOMABAY"]


kenya <- merge(kenya_counties_r,kenya_counties_fin, by = "county_key", all = T )

save(kenya, file = here("kenya_pop/data/kenya.rda"))


kenya_counties_key <- merge(kenya, kenya_counties, by = "county")
putting_food <- aspirations[ by =B3B]

putting_food <- aspirations[aspirations[, .I[perc == max(perc)], by=County]$V1]


putting_food_merge <- merge(putting_food, kenya_counties_key, by = "County")

putting_food_merge <- st_set_geometry(putting_food_merge, "geometry")

library(tmap)
tmap_options(check.and.fix = TRUE)
map2 <- tm_shape(putting_food_merge)+
    tm_borders(col = "gold")+
    tm_fill(col = "B3B")+
    #tm_bubbles(size = "perc", col = "gold")+
    tm_layout(main.title = "Popular crop grown per county Kenya",
              title.position = c(0.2, "top"))


map2 <- tmap_leaflet(map2)
map2
kenyan_pop <- V3_T2.4a %>% nms_clean()


