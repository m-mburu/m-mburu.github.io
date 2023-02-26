
library(tidyverse)
library(data.table)
mtcars <- mtcars %>% rownames_to_column(var = "car") %>% setDT()
server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}
