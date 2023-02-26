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

sidebar <- dashboardSidebar(
    actionButton("click", "Update click box")
) 

server <- function(input, output) {
    output$click_box <- renderValueBox({
        valueBox(
            value = input$click,
            subtitle = "Click Box"
        )
    })
}

body <- dashboardBody(
    valueBoxOutput("click_box")
)


ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)
shinyApp(ui, server)