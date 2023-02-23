
library(shiny)
library(tidyverse)
library(babynames)
data("babynames", package = "babynames")
namesm = unique(babynames$name)[1:20]
ui <- fluidPage(
    titlePanel("Baby Name Explorer"),
    sidebarLayout(
        sidebarPanel(selectInput('name', 'Enter Name', choices = namesm)),
        mainPanel(plotOutput('trend'))
    )
)
server <- function(input, output, session) {
    output$trend <- renderPlot({
        # CODE BELOW: Update to display a line plot of the input name
        ggplot(subset(babynames, name == input$name)) +
            geom_line(aes(x = year, y = prop, color = sex))
        
    })
}
shinyApp(ui = ui, server = server)