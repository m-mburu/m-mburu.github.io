library(shiny)
library(shinydashboard)
#library(bs4Dash)
library(tablerDash)
header <-  dashboardHeader(title = "Basic dashboard")

sidebar <-  dashboardSidebar(
  sidebarMenu(
    br(),
    menuItem("Histogram", tabName = "hist"),
    br(),
    menuItem("Scatter Plot", tabName = "scatterplot")
  )

 
)

body <- dashboardBody(
    # Boxes need to be put in a row (or column)
  tabItems(
    tabItem(tabName = "hist",
      
      fluidRow(
        box(width = 10,plotOutput("plot1", height = 250)),
        
        box(width = 2,
          title = "Controls",
          sliderInput("slider", "Number of observations:", 1, 100, 50)
        )
      )
    )
  )
 
  )

ui <- dashboardPage(header, sidebar, body)


