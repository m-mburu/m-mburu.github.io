
library(tidyverse)
library(ggiraph)
interactive_points <- function(data,x, y,  fill_var, tooltip_var, facet_var = NULL) {
    # Create the ggplot
    p <- ggplot(data, aes(x = {{x}}, y = {{y}} , col = {{fill_var}}, tooltip = {{tooltip_var}})) +
        geom_point_interactive()
    
    girafe(ggobj = p, pointsize = 9)
}

data("iris")

interactive_points(iris, x = Sepal.Length, y = Sepal.Width, fill_var = Species, tooltip_var = paste0(Species, ":", Sepal.Length, ":", Sepal.Width))




top_6 <- programming_languages_dt%>%
    group_by(language) %>%
    summarise(num_pushers = sum(num_pushers)) %>%
    top_n(10, num_pushers)

library(plotly)

#plot pie chart for top_6
top_lan <- plot_ly(top_6, labels = ~language, values = ~num_pushers) %>%
    add_pie(hole = 0.6) %>%
    layout(title = "Top 6 programming languages",
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))




top_10_dt <- programming_languages_dt[,
                                      .(num_pushers = sum(num_pushers)),
                                      by = language][order(-num_pushers)][1:10]



number_pushers_lan <- programming_languages_dt[
    iso2_code %in% latest_developers_sf_top$iso2_code]

number_pushers_lan <- number_pushers_lan[devs_per_100k != 0,]
number_pushers_lan_split <- split.data.frame(number_pushers_lan, f =  number_pushers_lan$name)

number_pushers_lan_2 <- lapply(number_pushers_lan_split, function(x) {
    x <- x[devs_per_100k != 0] %>% 
        top_n(3, devs_per_100k)
    x
})  %>% rbindlist()  


## get top 3 languages with highest number of developers per 100k per country
top3_lan_per_country <- number_pushers_lan[order(-devs_per_100k), .SD[1:3],  by = name]


plot_interactive_bar(data = top3_lan_per_country,
                     x_var = name,
                     y_var = devs_per_100k,
                     fill_var = language,
                     title = "Top 3 languages with highest % of developers that pushed code to GitHub",)


merg_spatial_df <- function(df, spatial_df, by = "iso2_code") {
    # merge the dataframes
    dfs = split(df, f = list(df$year, df$quarter) )
    
    dfmerg <- lapply(dfs, function(x) {
        x <- merge(x,  spatial_df, by = by, all.y = T)
        x
    }) %>% rbindlist()
    
    return(dfmerg)
}


developers_merged <- merg_spatial_df(developers, africa)   

developers_merged[, devs_per_100k := developers / pop_est * 100000]


setDT(latest_developers_sf_top)
top_con_iso <- latest_developers_sf_top[order(-devs_per_100k), .SD[1:6, unique(iso2_code)]]


top_cont_df <- developers_merged[iso2_code %in% top_con_iso]
top_cont_df <- top_cont_df[order(year, quarter)] 

top_cont_df[, date := as.Date(paste0(year, "-", quarter, "-01"))]
top_cont_df[, date_labels := paste0(year, "-", quarter)]

## lagging the developers column to get the difference
# top_cont_df[, developers_lag := lag(developers, 1)]
# top_cont_df[, diff := developers - developers_lag]
# percentage change
#top_cont_df[, perc_change := diff / developers_lag * 100]


p = ggplot(top_cont_df, aes(x = date, y = devs_per_100k, color = name, tooltip =name )) +
    geom_line_interactive(size = 1) +
    labs(title = "Developers per 100k in top_cont_dfnya",
         x = "Date",
         y = "Developers per 100k") +
    
    #scale_x_date(labels = top_cont_df$date_labels, date_breaks = "3 months") +
    scale_color_brewer_interactive(palette = "Dark2", type = "qual") +
    theme_minimal() +
    theme(legend.position = "bottom")

ggiraph(code = print(p))




library(plotly)

# Define a more generic function for plotting

ke <- programming_languages[language ==  "Jupyter Notebook" & iso2_code == "KE"] 


