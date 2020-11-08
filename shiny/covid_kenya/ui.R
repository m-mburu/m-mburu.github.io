library(shiny)
library(shinythemes)

ui <-  navbarPage(theme = shinytheme("spacelab"),"Kenya Covid-19 Viz",

                  
                  tabsetPanel(type = "tabs",
                              tabPanel("REDCAP and KIDMS BACKLOGS ",
                                       sidebarLayout(
                                           sidebarPanel(
                                               selectInput("site",h3("Select  site:"), choices = c("Kilifi","Nairobi","Migori","Kampala","Blantyre","Karachi","Dhaka","Matlab","Banfora")
                                               ),
                                               
                                               dateRangeInput(
                                                   inputId = "date_range",
                                                   label = h3("Date Range"),
                                                   start = "2016-11-01" ,
                                                   end = Sys.Date(),
                                                   max = Sys.Date()),
                                               downloadButton(
                                                   "pend",label = ("Redcap BackLogs")),br(),br(),br(),
                                               
                                               downloadButton(
                                                   "pend1",label = ("KIDMS BackLogs"))
                                           ),
                                           mainPanel(
                                               textOutput("text"),tags$head(tags$style("#text{color: blue;
                                                                                         font-size: 30px;
                                                                                         font-style: bold;
                                                                                         }")), br(),br(),
                                               DT::dataTableOutput("backlog"),br(),
                                               textOutput("text1"),tags$head(tags$style("#text1{color: blue;
                                                                         font-size: 30px;
                                                                         font-style: bold;
                                                                         }")),br(),
                                               DT::dataTableOutput("backlog1")
                                           )
                                           
                                           
                                           
                                       )
                                       
                                       
                                       
                              ))
                  
                  
                  
                  
                  
                  
                  
                  
                  
)

