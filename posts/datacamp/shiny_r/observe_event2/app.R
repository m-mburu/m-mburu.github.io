#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

bmi_help_text <- "Body Mass Index is a simple calculation using a person's height and weight. The formula is BMI = kg/m2 where kg is a person's weight in kilograms and m2 is their height in metres squared. A BMI of 25.0 or more is overweight, while the healthy range is 18.5 to 24.9."

server <- function(input, output, session) {
    # MODIFY CODE BELOW: Wrap in observeEvent() so the help text 
    # is displayed when a user clicks on the Help button.
    
    # Display a modal dialog with bmi_help_text
    # MODIFY CODE BELOW: Uncomment code
    observeEvent(input$show_help,{ showModal(modalDialog(bmi_help_text))})
    
    rv_bmi <- eventReactive(input$show_bmi, {
        input$weight/(input$height^2)
    })
    output$bmi <- renderText({
        bmi <- rv_bmi()
        paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
    })
}

ui <- fluidPage(
    titlePanel('BMI Calculator'),
    sidebarLayout(
        sidebarPanel(
            textInput('name', 'Enter your name'),
            numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
            numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120),
            actionButton("show_bmi", "Show BMI"),
            # CODE BELOW: Add an action button named "show_help"
            actionButton("show_help", "Help")
            
        ),
        mainPanel(
            textOutput("bmi")
        )
    )
)

shinyApp(ui = ui, server = server)