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
    tmap_options(check.and.fix = TRUE) 
    test1 <- reactive({
        if(input$segment == 'National') {
            
            x = input$area_national
            
        } else if(input$segment =='Rural/Urban'){
            x = input$area_rural
            
        } else if(input$segment =='Sex'){
            x = input$sex
            
        }else x = input$age
    })
    
    output$afri_prev <- renderLeaflet({
        
        df <- africa_unicef[type == test1() & cmrs_year == input$year_select_maln]
        
        df <- merge(df, africa_count,
                    by = "countryname", all.y = T) 
        
        df <- st_set_geometry(df, "geometry")
        
        my_map <- tm_shape(df) +
            tm_fill(col = "value", id = "country")+
            tm_borders(col = "gold")
        tmap_leaflet(my_map, in.shiny = TRUE)
   
        })
    
    

    
    output$countries_line <- renderPlotly({
        
        df <- africa_unicef[type == "national" & countryname %in% input$select_countries]
        
        ggplot(df, aes(cmrs_year, value, group = countryname, color = countryname))+
            geom_line() +
            theme_fivethirtyeight()
        
    })
    
    # 
    output$compare_bar_tab2 <- renderPlotly({

        df <- africa_unicef[type2 %in% c("National",input$select_type) & countryname %in% input$select_countries & cmrs_year == input$select_year_tab2]
        if(input$select_type == "Age"){
            lvl = c(child_age, "national")
            df[, type := factor(type, levels = lvl)]
        }

        ggplot(df, aes(countryname, value, fill = type))+
            geom_bar(stat = "identity", position = "dodge") +
            theme_fivethirtyeight()

    })
    
    
    output$afri_prev_ihm <- renderLeaflet({
        
        df <- africa_prev_melt[maln_level == input$select_maln_ihm]
        
        df <- merge(df, africa_count,
                    by = "countryname", all.y = T) 
        
        df <- st_set_geometry(df, "geometry")
        
        my_map <- tm_shape(df) +
            tm_fill(col = "ihm_maln_estimate", id = "country_name")+
            tm_borders(col = "gold")
        tmap_leaflet(my_map, in.shiny = TRUE)
        
    })
    
    output$afri_compare_ihm <- renderPlotly({
        
        df <- africa_prev_melt[countryname %in% input$select_maln_ihm_co]
        
        ggplot(df, aes(countryname, ihm_maln_estimate, fill = maln_level))+
            geom_bar(stat = "identity", position = "dodge") +
            theme_fivethirtyeight()
        
    })
    

    
}