#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

"Stop reactions with isolate()
Ordinarily, the simple act of reading a reactive value is sufficient to set up a relationship, where a change to the reactive value will cause the calling expression to re-execute. The isolate() function allows an expression to read a reactive value without triggering re-execution when its value changes.

In this exercise, you will use the isolate() function to stop reactive flow."
library(shiny)

server <- function(input, output, session) {
    rval_bmi <- reactive({
        input$weight/(input$height^2)
    })
    output$bmi <- renderText({
        bmi <- rval_bmi()
        # MODIFY CODE BELOW: 
        # Use isolate to stop output from updating when name changes.
        paste("Hi", isolate(input$name), ". Your BMI is", round(bmi, 1))
    })
}
ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
        sidebarPanel(
            textInput('name', 'Enter your name'),
            numericInput('height', 'Enter your height (in m)', 1.5, 1, 2, step = 0.1),
            numericInput('weight', 'Enter your weight (in Kg)', 60, 45, 120)
        ),
        mainPanel(
            textOutput("bmi")
        )
    )
)

shinyApp(ui = ui, server = server)