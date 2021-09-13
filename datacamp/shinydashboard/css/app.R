#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library("shiny")
library(shinydashboard)

body <- dashboardBody(
    # Update the CSS
    tags$head(
        tags$style(
            HTML('
            h3 {font-weight: bold;}
            ')
        )
    ),
    fluidRow(
        box(
            width = 12,
            title = "Regular Box, Row 1",
            "Star Wars, nothing but Star Wars"
        )
    ),
    fluidRow(
        column(width = 6,
               infoBox(
                   width = NULL,
                   title = "Regular Box, Row 2, Column 1",
                   subtitle = "Gimme those Star Wars"
               )
        ),
        column(width = 6,
               infoBox(
                   width = NULL,
                   title = "Regular Box, Row 2, Column 2",
                   subtitle = "Don't let them end"
               )
        )
    )
)

ui <- dashboardPage(
    skin = "purple",
    header = dashboardHeader(),
    sidebar = dashboardSidebar(),
    body = body)


server <- function(input, output, session) {
  
}
shinyApp(ui, server)