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
    rval_bmi <- reactive({
        input$weight/(input$height^2)
    })
    # CODE BELOW: Add a reactive expression rval_bmi_status to 
    # return health status as underweight etc. based on inputs
    rval_bmi_status <- reactive({
        cut(rval_bmi(), 
            breaks = c(0, 18.5, 24.9, 29.9, 40),
            labels = c('underweight', 'healthy', 'overweight', 'obese')
        )
        
        
    })
    
    
    
    output$bmi <- renderText({
        bmi <- rval_bmi()
        paste("Your BMI is", round(bmi, 1))
    })
    output$bmi_status <- renderText({
        # MODIFY CODE BELOW: Replace right-hand-side with 
        # reactive expression rval_bmi_status
        bmi_status  <- rval_bmi_status()
        paste("You are", bmi_status)
    })
}
ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
        sidebarPanel(
            numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
            numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
        ),
        mainPanel(
            textOutput("bmi"),
            textOutput("bmi_status")
        )
    )
)

shinyApp(ui = ui, server = server)