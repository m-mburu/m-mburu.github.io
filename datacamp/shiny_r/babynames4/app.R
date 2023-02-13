
library(shiny)
library(tidyverse)
library(babynames)
data("babynames", package = "babynames")


get_top_names <- function(.year, .sex) {
    babynames %>% 
        filter(year == .year) %>% 
        filter(sex == .sex) %>% 
        top_n(10) %>% 
        mutate(name = forcats::fct_inorder(name))
}


# MODIFY this app (built in the previous exercise)
ui <- fluidPage(
    titlePanel("Most Popular Names"),
    sidebarLayout(
        sidebarPanel(
            selectInput('sex', 'Select Sex', c("M", "F")),
            sliderInput('year', 'Select Year', min = 1880, max = 2017, value = 1900)
        ),
        mainPanel(
            tabsetPanel(
                tabPanel("Plot",  plotOutput('plot')),
                tabPanel("Table", tableOutput("mytable"))
            )
            
        )
    )
)

server <- function(input, output, session) {
    output$plot <- renderPlot({
        top_names_by_sex_year <- get_top_names(input$year, input$sex) 
        ggplot(top_names_by_sex_year, aes(x = name, y = prop)) +
            geom_col()
    })
    output$mytable <- renderTable({
        get_top_names(input$year, input$sex) 
    })
}

shinyApp(ui = ui, server = server)