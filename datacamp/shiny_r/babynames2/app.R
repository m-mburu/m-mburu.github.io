
library(shiny)
library(tidyverse)
library(babynames)
data("babynames", package = "babynames")
library(shiny)
library(tidyverse)
library(babynames)
data("babynames", package = "babynames")
ui <- fluidPage(
    titlePanel("What's in a Name?"),
    # Add select input named "sex" to choose between "M" and "F"
    selectInput('sex', 'Select Sex', choices = c("F", "M")),
    # CODE BELOW: Add slider input named 'year' to select years  (1900 - 2010)
    sliderInput("year","Year" ,min = 1900, max = 2010, value = 1900),
    
    # Add plot output to display top 10 most popular names
    plotOutput('plot_top_10_names')
)

server <- function(input, output, session){
    # Render plot of top 10 most popular names
    output$plot_top_10_names <- renderPlot({
        # Get top 10 names by sex and year
        top_10_names <- babynames %>% 
            filter(sex == input$sex) %>% 
            # MODIFY CODE BELOW: Filter for the selected year
            filter(year == input$year) %>% 
            top_n(10, prop)
        # Plot top 10 names by sex and year
        ggplot(top_10_names, aes(x = name, y = prop)) +
            geom_col(fill = "#263e63")
    })
}

shinyApp(ui = ui, server = server)