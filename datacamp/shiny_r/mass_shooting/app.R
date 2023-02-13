
library(tidyverse)
library(shiny)
library(leaflet)
mass_shootings <- read_csv("mass-shootings.csv")

mass_shootings <- mass_shootings %>%
    mutate(date =as.Date(date, format = "%m/%d/%y"))
text_about <- "This data was compiled by Mother Jones, nonprofit founded in 1976.
Originally covering cases from 1982-2012, this database
has since been expanded numerous times to remain current."

ui <- bootstrapPage(
    theme = shinythemes::shinytheme('simplex'),
    leaflet::leafletOutput('map', width = '100%', height = '100%'),
    absolutePanel(top = 10, right = 10, id = 'controls',
                  sliderInput('nb_fatalities', 'Minimum Fatalities', 1, 40, 10),
                  dateRangeInput(
                      'date_range', 'Select Date', "2010-01-01", "2019-12-01"
                  ),
                  # CODE BELOW: Add an action button named show_about
                  actionButton("show_about", "About")
                  
    ),
    tags$style(type = "text/css", "
    html, body {width:100%;height:100%}     
    #controls{background-color:white;padding:20px;}
  ")
)
server <- function(input, output, session) {
    # CODE BELOW: Use observeEvent to display a modal dialog
    # with the help text stored in text_about.
    
    observeEvent(input$show_about,{ showModal(modalDialog(text_about, title = 'About'))})
    
    
    output$map <- leaflet::renderLeaflet({
        mass_shootings %>% 
            filter(
                date >= input$date_range[1],
                date <= input$date_range[2],
                fatalities >= input$nb_fatalities
            ) %>% 
            leaflet() %>% 
            setView( -98.58, 39.82, zoom = 5) %>% 
            addTiles() %>% 
            addCircleMarkers(
                popup = ~ summary, radius = ~ sqrt(fatalities)*3,
                fillColor = 'red', color = 'red', weight = 1
            )
    })
}

shinyApp(ui, server)