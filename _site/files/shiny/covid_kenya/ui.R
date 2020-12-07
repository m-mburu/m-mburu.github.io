

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
library(bslib)
my_theme <- bs_theme(
    bg = "#202123", fg = "#B8BCC2", primary = "#EA80FC", 
    base_font = font_google("Grandstander")
)

child_age <- c(0, 1)
year_unicef <- 0:5
countries_names <- LETTERS[1:5]
maln_level <- LETTERS[1:5]
ui <-  navbarPage(theme =my_theme ,"Malnutrition Prevalence in Africa 0 - 5 years",
                  
                  ###define user interface section of Participants to be replaced tabs
                  tabPanel("UNICEF Estimate Africa Stunting Prevalence Ages 0 - 5 Years",
                           tabsetPanel(type = "pills",
                                       #define table for Participant Replacement   
                                       tabPanel("Africa Stunting Prevalence Ages 0 - 5 Years",
                                                sidebarLayout(
                                                    sidebarPanel(
                                                        selectInput("segment",
                                                                    label = "Select Sex, Rural/Urban etc",
                                                                    choices = c("National", "Rural/Urban", "Sex", "Age")),
                                                        conditionalPanel(
                                                            
                                                            condition = "input.segment == 'National'",
                                                            selectInput("area_national", "National Stunting prevalence levels",
                                                                        c("national"), selected = "national")),
                                                        
                                                        conditionalPanel(
                                                            
                                                            condition = "input.segment == 'Rural/Urban'",
                                                            selectInput("area_rural", "Rural/Urban Stunting prevalence",
                                                                        c("rural", "urban"), selected = "rural")),
                                                        conditionalPanel(
                                                            
                                                            condition = "input.segment == 'Sex'",
                                                            selectInput("sex", "Male female stunting levels",
                                                                        c("female", "male"), selected = "female")),
                                                        conditionalPanel(
                                                            
                                                            condition = "input.segment == 'Age'",
                                                            selectInput("age", "Age in months stunting levels",
                                                                        child_age, selected = "0_5")),
                                                        
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
                                                                    choices = c("Rural/Urban", "Sex", "Age"),
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

