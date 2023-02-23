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


ui <- dashboardPage(skin = "black",
                    
                    ## ++ Shiny dashboard HEADER-------------------------------------------------------------------------------------
                    dashboardHeader(title = "Malnutrition Prevalence in Africa 0 - 5 years",
                                    dropdownMenu(type = "messages",
                                                 messageItem(
                                                     from = "",
                                                     message = ""
                                                 )), titleWidth = 400),
                    
                    
                    ## ++ Shiny dashboard SIDEBAR -----------------------------------------------------------------------------------
                    dashboardSidebar(
                        sidebarMenu(
                            
                            menuItem(h5("UNICEF Africa Stunting levels"), 
                                     tabName = 'afri_man'),
                            
                            
                            menuItem(h5("IHME malnutrition prevalence"), 
                                     tabName = 'afri_ihm'
                                     # menuSubItem("Samples Shipped to Kilifi",
                                     #             tabName = "shipped_to_kilifi"),
                                     # 
                                     # menuSubItem("External Labs",
                                     #             tabName = "shipp_external")
                                     
                                     
                            )#,
                            # menuItem(h5("Poverty levels"),
                            #          tabName = 'note_to_file'
                            #          
                            #          
                            # )
                            
                        )
                    ),
                    
                    ## ++ Shiny dashboard BODY -------------------------------------------------------------------------------------
                    dashboardBody(
                        ## all the body items go into the tabitems
                        tabItems(
                            tabItem(tabName = "afri_man",
                                    fluidRow(
                                        tabsetPanel(
                                            tabPanel("Africa Stunting Prevalence Ages 0 - 5 Years",
                                                     column(width = 8,
                                                            box(width = NULL,  solidHeader = F, status = "primary", title = "Stunting Prevalence",
                                                                tmapOutput("afri_prev", width = "100%", height = 700))), 
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
                                                            box(width = NULL, solidHeader = F, status = "primary", 
                                                                title = "Stunting prevalence over time",
                                                                plotlyOutput("countries_line"))),
                                                     column(width = 2,
                                                            box(width = NULL, solidHeader = F, status = "primary",
                                                                selectInput("select_countries", "Select Countries",
                                                                            choices = countries_names,
                                                                            selected = c("kenya", "nigeria"), multiple = TRUE),
                                                                selectInput("select_type", "Select type eg sex, area:",
                                                                            choices = c("Rural/Urban", "Sex"),
                                                                            selected = "Rural/Urban"),
                                                                selectInput("select_year_tab2", "Select year",
                                                                            choices = year_unicef,
                                                                            selected = 2019))),
                                                     
                                                     column(width = 10,
                                                            box(width = NULL, solidHeader = F, status = "primary", title = "Stunting national prevalence compared with rural/urban or sex",
                                                                plotlyOutput("compare_bar_tab2")))
                                            )
                                        )
                                    )),
                            
                            tabItem(tabName = "afri_ihm",
                                    fluidRow(
                                        tabsetPanel(
                                            tabPanel("Africa Stunting/Wasting/Underweight Prevalence Ages 0 - 5 Years",
                                                     column(width = 10,
                                                            box(width = NULL,  solidHeader = F, status = "primary", title = "Wasting/Underweight/Stunting Prevalence",
                                                                tmapOutput("afri_prev_ihm", width = "100%", height = 800))), 
                                                     column(width = 2,
                                                            box(width = NULL, solidHeader = F, status = "primary",
                                                                selectInput("select_maln_ihm", "Select underweight, Wasting or Stunting levels",
                                                                            choices = maln_level,
                                                                            selected = "stunting_prev"))
                                            )),
                                            tabPanel("Compare Malnutrition levels",
                                                     column(width = 10,
                                                            box(width = NULL,  solidHeader = F, status = "primary", title = "Average Stunting/Wasting/ Underweight Prevalence",
                                                                plotlyOutput("afri_compare_ihm"))), 
                                                     column(width = 2,
                                                            box(width = NULL, solidHeader = F, status = "primary",
                                                                selectInput("select_maln_ihm_co", "Select Countries",
                                                                            choices = countries_names,
                                                                            selected = c("kenya", "uganda"), multiple = TRUE))
                                                     ))
                                        )
                                    ))
                        )
                    ))