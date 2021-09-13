#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

server <- function(input, output, session) {
    # MODIFY CODE BELOW: Delay the height calculation until
    # the show button is pressed
    rval_height_cm <- eventReactive(input$show_height_cm, {
        input$height * 2.54
    })
    
    output$height_cm <- renderText({
        height_cm <- rval_height_cm()
        paste("Your height in centimeters is", height_cm, "cm")
    })
}

ui <- fluidPage(
    titlePanel("Inches to Centimeters Conversion"),
    sidebarLayout(
        sidebarPanel(
            numericInput("height", "Height (in)", 60),
            actionButton("show_height_cm", "Show height in cm")
        ),
        mainPanel(
            textOutput("height_cm")
        )
    )
)

shinyApp(ui = ui, server = server)