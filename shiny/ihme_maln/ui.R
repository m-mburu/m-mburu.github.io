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
                                                            box(width = NULL,  solidHeader = T, status = "primary", title = "Malnutrition Prevalence",
                                                                tmapOutput("afri_prev", width = "100%", height = 800))), 
                                                     column(width = 2,
                                                            box(width = NULL, solidHeader = T, status = "primary",
                                                                selectInput("gender_select_maln", "Select, National estimate or sex",
                                                                            choices = type_sex_area,
                                                                            selected = "national"),
                                                                selectInput("year_select_maln", "Select, Year",
                                                                            choices = year_unicef ,
                                                                            selected = 2019)))
                                                     ),
                                            tabPanel("Compare Countries, Line and bars",
                                                     column(width = 10,
                                                            box(width = NULL, solidHeader = T, status = "primary", 
                                                                title = "Compare countries",
                                                                plotlyOutput("countries_line"))),
                                                     column(width = 2,
                                                            box(width = NULL, solidHeader = T, status = "primary",
                                                                selectInput("select_countries", "Select Countries",
                                                                            choices = countries_names,
                                                                            selected = c("kenya", "nigeria"), multiple = TRUE),
                                                                selectInput("select_type", "Select type eg sex, area:",
                                                                            choices = type_sex_area,
                                                                            selected = "national"),
                                                                selectInput("select_year_tab2", "Select year",
                                                                            choices = year_unicef,
                                                                            selected = 2019))),
                                                     
                                                     column(width = 10,
                                                            box(width = NULL, solidHeader = T, status = "primary", title = "Malnutrition",
                                                                plotlyOutput("compare_bar_tab2")))
                                            )
                                        )
                                    ))
                        )
                    ))