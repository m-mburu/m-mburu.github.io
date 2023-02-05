#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
    textInput('name', 'Enter your name')
)

server <- function(input, output, session) {
    # CODE BELOW: Add an observer to display a notification
    # 'You have entered the name xxxx' where xxxx is the name
    observe(
        showNotification(
            paste("You have entered the name xxxx ", input$name)
        )
    )
    
    
    
    
    
}

shinyApp(ui = ui, server = server)