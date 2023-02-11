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

header <- dashboardHeader(
    dropdownMenu(
        type = "notifications",
        notificationItem(
            text = "The International Space Station is overhead!",
            icon = icon("rocket")
        )
    )
)
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)

server <- function(input, output, session) {
    
}
shinyApp(ui, server)

