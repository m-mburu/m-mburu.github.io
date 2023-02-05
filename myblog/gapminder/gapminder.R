library(gapminder)
library(tidyverse)
library(data.table)
library(gganimate)
data("gapminder",package= "gapminder")

setDT(gapminder)
ggplot(gapminder, 
       aes(gdpPercap, lifeExp, color = country, size = pop))+
    geom_point(show.legend = FALSE)+
    labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
    transition_time(year) 


east_africa <- gapminder[country %in% c("Kenya", "Uganda", "Tanzania", "Rwanda")]  

ggplot(east_africa, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
    geom_point(alpha = 0.7, show.legend = TRUE) +
    #scale_colour_manual(values = country_colors) +
    scale_size(range = c(2, 12)) +
    scale_x_log10() +
    #facet_wrap(~continent) +
    # Here comes the gganimate specific bits
    labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
    transition_time(year) +
    ease_aes('linear')
