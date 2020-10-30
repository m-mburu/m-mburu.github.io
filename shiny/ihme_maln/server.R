library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(tmap)
library(leaflet)
library(DT)
library(plotly)
library(ggthemes)
library(data.table)
library(gapminder)
library(ggthemes)
server <- function(input, output) { 
    
    output$afri_prev <- renderLeaflet({
        
        df <- africa_unicef[type == input$gender_select_maln & cmrs_year == input$year_select_maln]
        
        df <- merge(df, africa_count,
                    by = "countryname", all.y = T) 
        
        df <- st_set_geometry(df, "geometry")
        
        my_map <- tm_shape(df) +
            tm_fill(col = "value", id = "formal_en")+
            tm_borders(col = "gold")
        tmap_leaflet(my_map, in.shiny = TRUE)
   
        })
    
    

    
    output$countries_line <- renderPlotly({
        
        df <- africa_unicef[type == input$select_type & countryname %in% input$select_countries]
        
        ggplot(df, aes(cmrs_year, value, group = countryname, color = countryname))+
            geom_line() +
            theme_fivethirtyeight()
        
    })
    
    # 
    output$compare_bar_tab2 <- renderPlotly({

        df <- africa_unicef[type == input$select_type & countryname %in% input$select_countries ]

        ggplot(df, aes(countryname, value, fill = countryname))+
            geom_bar(stat = "identity") +
            theme_fivethirtyeight()

    })

    
}