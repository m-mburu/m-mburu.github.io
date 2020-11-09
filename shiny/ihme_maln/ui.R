

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
library(shinythemes)

ui <-  navbarPage(theme = shinytheme("flatly"),"Malnutrition Prevalence in Africa 0 - 5 years",
                  
                  ###define user interface section of Participants to be replaced tabs
                  tabPanel("UNICEF Estimate Africa Stunting Prevalence Ages 0 - 5 Years",
                           tabsetPanel(type = "pills",
                                       #define table for Participant Replacement   
                                       tabPanel("Africa Stunting Prevalence Ages 0 - 5 Years",
                                                sidebarLayout(
                                                    sidebarPanel(
                                                        selectInput("gender_select_maln", "Select, National estimate or sex",
                                                                    choices = type_sex_area,
                                                                    selected = "national"),
                                                        selectInput("year_select_maln", "Select, Year",
                                                                    choices = year_unicef ,
                                                                    selected = 2019)),
                                                        # downloadButton(
                                                        #     "replace_dwn",label = ("cp missing sample")),
                                                        # br(),br(),br(),
                                                        
                                                    mainPanel(
                                                        
                    
                                                        
                                                        tmapOutput("afri_prev", width = "100%", height = 800), br()
                                                        
                                                        
                                                    )
                                                )
                                       ),
                                       #define interface for other time point participants missing samples
                                       tabPanel("Compare Countries, Line and bars",
                                                sidebarLayout(
                                                    sidebarPanel(
                                                        selectInput("select_countries", "Select Countries",
                                                                    choices = countries_names,
                                                                    selected = c("kenya", "nigeria"), multiple = TRUE),
                                                        selectInput("select_type", "Select type eg sex, area:",
                                                                    choices = c("Rural/Urban", "Sex"),
                                                                    selected = "Rural/Urban"),
                                                        selectInput("select_year_tab2", "Select year",
                                                                    choices = year_unicef,
                                                                    selected = 2019)
                                                    ),
                                                    mainPanel(
                                                        plotlyOutput("countries_line"), br(), br(),
                                                
                                                        
                                                        plotlyOutput("compare_bar_tab2"), br()
                                                        
                                                    )
                                                    
                                                )
                                       )
                           )
                  ),
                  
                  
                  ###define user interface section of Participants to be replaced tabs
                  tabPanel("IHME malnutrition prevalence",
                           tabsetPanel(type = "tabs",
                                       #define table for Participant Replacement   
                                       tabPanel("Africa Stunting/Wasting/Underweight Prevalence Ages 0 - 5 Years",
                                                sidebarLayout(
                                                    sidebarPanel(
                                                        selectInput("select_maln_ihm", "Select underweight, Wasting or Stunting levels",
                                                                    choices = maln_level,
                                                                    selected = "stunting_prev")),
                                                    # downloadButton(
                                                    #     "replace_dwn",label = ("cp missing sample")),
                                                    # br(),br(),br(),
                                                    
                                                    mainPanel(
                                                        
                                                        
                                                        
                                                        tmapOutput("afri_prev_ihm", width = "100%", height = 800), br()
                                                        
                                                        
                                                    )
                                                )
                                       ),
                                       #define interface for other time point participants missing samples
                                       tabPanel("Compare Malnutrition levels",
                                                sidebarLayout(
                                                    sidebarPanel(
                                                        selectInput("select_maln_ihm_co", "Select Countries",
                                                                    choices = countries_names,
                                                                    selected = c("kenya", "uganda"), multiple = TRUE)
                                                    ),
                                                    mainPanel(
                                                        
                                                        plotlyOutput("afri_compare_ihm"), br()
                                                        
                                                    )
                                                    
                                                )
                                       )
                           )
                  )
                  
)

