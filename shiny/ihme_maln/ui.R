## Load required packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(sf)
library(tmap)
library(leaflet)
library(DT)
library(plotly)
library(ggthemes)
library(data.table)
library(gapminder)

countries <- c("Kenya", "Uganda")
ui <- dashboardPage(skin = "blue",
                    
                    ## ++ Shiny dashboard HEADER-------------------------------------------------------------------------------------
                    dashboardHeader(title = "Malnutrition",
                                    dropdownMenu(type = "messages",
                                                 messageItem(
                                                     from = "",
                                                     message = ""
                                                 )), titleWidth = 400),
                    
                    
                    ## ++ Shiny dashboard SIDEBAR -----------------------------------------------------------------------------------
                    dashboardSidebar(
                        sidebarMenu(
                            
                            menuItem(h5("Africa Malnutrion Maps"), 
                                     tabName = 'afri_man'),
                            
                            
                            menuItem(h5("Gapminder Data"), 
                                     tabName = 'afri_gap'
                                     # menuSubItem("Samples Shipped to Kilifi",
                                     #             tabName = "shipped_to_kilifi"),
                                     # 
                                     # menuSubItem("External Labs",
                                     #             tabName = "shipp_external")
                                     
                                     
                            ),
                            menuItem(h5("Poverty levels"),
                                     tabName = 'note_to_file'
                                     

                                     )
                            
                        )
                    ),
                    
                    ## ++ Shiny dashboard BODY -------------------------------------------------------------------------------------
                    dashboardBody(
                        ## all the body items go into the tabitems
                        tabItems(
                            tabItem(tabName = "afri_man",
                                    fluidRow(
                                        tabsetPanel(
                                            tabPanel("Africa Malnutrition Prevalence",
                                                     column(width = 10,
                                                            box(width = NULL,height = "100%", solidHeader = T, status = "primary", title = "Malnutrition Prevalence",
                                                                leafletOutput("afri_prev")), 
                                                            column(width = 2,
                                                                   box(width = NULL, solidHeader = T, status = "primary",
                                                                       selectInput("gender_select_maln", "Select, National estimate or sex",
                                                                                   choices = c("National", "Male", "Female"),
                                                                                   selected = "National"))),
                                                     )),
                                            tabPanel("Compare Countries, Line and bars",
                                                     column(width = 10,
                                                            box(width = NULL, solidHeader = T, status = "primary", 
                                                                title = "Compare countries",
                                                                plotlyOutput("countries_line"))),
                                                     column(width = 2,
                                                            box(width = NULL, solidHeader = T, status = "primary",
                                                                selectInput("Select Countries", "",
                                                                            choices = countries,
                                                                            selected = c("Kenya", "Uganda"), multiple = TRUE),
                                                                selectInput("Select Sex", "Select Sex:",
                                                                            choices = c("National", "Male", "Female"),
                                                                            selected = "National"))),
                                                     column(width = 10,
                                                            box(width = NULL, solidHeader = T, status = "primary", title = "Stored Samples per site",
                                                                plotlyOutput("bar_output")))
                                            )
                                        )
                                    ))
                        )
                    ))




