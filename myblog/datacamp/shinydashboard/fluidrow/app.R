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
    fluidRow(
        # Row 1
        box(
            width = 12,
            title = "Regular Box, Row 1",
            "Star Wars"
        )
    ),
    # Row 2
    fluidRow(
        box(
            width = 12,
            title = "Regular Box, Row 2",
            "Nothing but Star Wars"
        )
    )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)

server <- function(input, output) {
    
}

shinyApp(ui, server)