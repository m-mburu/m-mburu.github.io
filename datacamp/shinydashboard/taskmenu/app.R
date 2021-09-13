#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

text <- c("find 20 hidden mickeys on the Tower of Terror", 
  "Find a paint brush on Tom Sawyer Island", "Meet Chewbacca")

value <- c(60L, 0L, 100L)

task_data <- data.frame(text, value)

library(shinydashboard)
library(tidyverse)
server <- function(input, output) {
    output$task_menu <- renderMenu({
        tasks <- apply(task_data, 1, function(row) { 
            taskItem(text = row[["text"]],
                     value = row[["value"]])
        })
        dropdownMenu(type = "tasks", .list = tasks)
    })
}

header <- dashboardHeader(dropdownMenuOutput(outputId = "task_menu"))

ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)