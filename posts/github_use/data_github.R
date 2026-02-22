
library(tidyverse)
library(data.table)
library(janitor)
library(tmap)

developers <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/developers.csv")
git_pushes <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/git_pushes.csv")
git_repos <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/repositories.csv")
programming_languages <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/languages.csv")

github_data_name <- c("developers", "git_pushes", "git_repos", "programming_languages")

iso3 <- fread("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv") 



fwrite(iso3, "data/iso3.csv")

iso3 <- iso3[, .(iso2_code = `alpha-2`, iso_a3 = `alpha-3`)]

data("World")


africa <- World %>% 
  left_join(iso3,by = "iso_a3") %>%
  filter(continent == "Africa")

latest_year <- max(developers$year, na.rm = TRUE)
latest_quarter <- max(developers[year == latest_year]$quarter, na.rm = TRUE)

# Then, filter the data table for the latest year and quarter
latest_developers <- developers[year == latest_year & quarter == latest_quarter]

# Finally, join the data table with the africa map

latest_developers <- latest_developers %>%
  right_join(africa, by = "iso2_code")

latest_developers[, devs_per_100k := round(developers/pop_est * 100000)]
library(sf)

latest_developers_sf <- st_set_geometry(latest_developers,value = "geometry")

library(ggiraph)
map4 <- ggplot(latest_developers_sf, aes(fill = devs_per_100k, tooltip = paste0(name, ":", devs_per_100k))) +
    geom_sf_interactive() +
    scale_fill_viridis_c() +
    #facet_wrap(~col_labels) +
    theme_void() +
    theme(legend.position = "left",
          legend.key.width = unit(0.1, 'cm')) + 
    labs(title = "Developers per 100,000 people", fill = "", caption = "Source: GitHub 2021") 
girafe(ggobj = map4)


# latest_developers_sf_sub <-  latest_developers_sf %>%
#     select(name, iso2_code, value = devs_per_100k, geometry) %>%
#     mutate(group = "Developers per 100,000 people")
# 
# git_repos_sub <- git_repos_sf %>%
#     select(name, iso2_code, value = repositories, geometry) %>%
#     mutate(group = "GitHub repositories")
# git_pushes_sub <- git_pushes_sf %>%
#     select(name, iso2_code, value = git_pushes, geometry) %>%
#     mutate(group = "GitHub pushes")
# all_data <- bind_rows(latest_developers_sf_sub, git_repos_sub, git_pushes_sub)
# 
# devs_rep_pushes_map <- create_interactive_map(data_sf = all_data, 
#                                               fill_var = value,
#                                               tooltip_var = name,
#                                               facet_var = "group")
# 
# devs_rep_pushes_map