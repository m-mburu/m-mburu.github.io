## Load required packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)
library(ggthemes)
library(data.table)

ui <- dashboardPage(skin = "blue",
                    
                    ## ++ Shiny dashboard HEADER-------------------------------------------------------------------------------------
                    dashboardHeader(title = "Interest rate Calculator",
                                    dropdownMenu(type = "messages",
                                                 messageItem(
                                                     from = "",
                                                     message = ""
                                                 )), titleWidth = 300),
                    
                    
                    ## ++ Shiny dashboard SIDEBAR -----------------------------------------------------------------------------------
                    dashboardSidebar(
                        sidebarMenu(
                            menuItem(h5("Home"), tabName = "home"))),
                    ## ++ Shiny dashboard BODY -------------------------------------------------------------------------------------
                   
                     dashboardBody(
                         
                         tabItems(
                             tabItem(tabName = "home",
                                     fluidRow(
                                         box(tags$h3("Interest App to estimate mutual fund returns in Kenya"), 
                                             width = 7, status = "primary", solidHeader = F))
                                 
                                 
                             )
                         )
                        
                    )
                    

)
