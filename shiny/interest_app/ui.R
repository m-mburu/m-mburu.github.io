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
                        
                    )
                    

)
