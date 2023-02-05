#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
# nms <- 1:50 %>%
#     as.character()
#recipes <- readRDS("~/projects/m-mburu.github.io/datacamp/shiny_r/quisine/recipes.rds")
recipes <- readRDS("recipes.rds")
# recipes <- recipes %>%
#     separate(ingredients, into = nms)
# recipes <- reshape2::melt(recipes,
#                           id.vars = c("id", "cuisine"),
#                           value.name = "ingridient")
# recipes <- recipes %>%
#     filter(!is.na(ingridient), ingridient != "c", ingridient != "")
# recipes$variable <- NULL
# saveRDS(recipes, file = "quisine/recipes.rds")
ui <- fluidPage(
    titlePanel('Explore Cuisines'),
    sidebarLayout(
        sidebarPanel(
            # CODE BELOW: Add an input named "cuisine" to select a cuisine
            selectInput('cuisine', 'Select Cuisine', unique(recipes$cuisine)),
            # Code BELOW: Add an input named "nb_ingredients" to select #ingredients
            sliderInput('nb_ingredients', 'Select No. of Ingredients', 5, 100, 20),
        ),
        mainPanel(
            # CODE BELOW: Add a DT output named "dt_top_ingredients"
            DT::DTOutput('dt_top_ingredients')
        )
    )
)
ingredient
server <- function(input, output, session) {
    # CODE BELOW: Render the top ingredients in a chosen cuisine as 
    # an interactive data table and assign it to output object `dt_top_ingredients`
    output$dt_top_ingredients <- DT::renderDT({
        recipes %>% 
            filter(cuisine == input$cuisine) %>% 
            count(ingredient, name = 'nb_recipes') %>% 
            arrange(desc(nb_recipes)) %>% 
            head(input$nb_ingredients)
    })
}
shinyApp(ui, server)
