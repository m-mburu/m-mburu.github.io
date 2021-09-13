#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(shinydashboard)
library(tidyverse)
starwars_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_6225/datasets/starwars.csv"

server <- function(input, output, session) {
    reactive_starwars_data <- reactiveFileReader(
        intervalMillis = 1000,
        session = session,
        filePath = starwars_url,
        readFunc = function(filePath) { 
            read.csv(url(filePath))
        }
    )
    
    output$table <- renderTable({
        reactive_starwars_data() %>% head()
        
    })
}

body <- dashboardBody(
    tableOutput("table")
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)