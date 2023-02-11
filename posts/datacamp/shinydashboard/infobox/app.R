#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library("shiny")
library("shiny")
library(shinydashboard)
body <- dashboardBody(
    fluidRow(
        # Column 1
        column(width = 6,
               infoBox(
                   width = NULL,
                   title = "Regular Box, Column 1",
                   subtitle = "Gimme those Star Wars"
               )
        ),
        # Column 2
        column(width = 6,
               infoBox(
                   width = NULL,
                   title = "Regular Box, Column 2",
                   subtitle = "Don't let them end"
               )
        ),
    )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)


server <- function(input, output, session) {
    
}
shinyApp(ui, server)