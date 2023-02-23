#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
# Define UI for application that draws a histogram
header <- dashboardHeader(
    dropdownMenu(
        type = "messages",
        messageItem(
            from = "Lucy",
            message = "You can view the International Space Station!",
            href = "https://spotthestation.nasa.gov/sightings/"
        ),
        # Add a second messageItem() 
        messageItem(
            from = "Lucy",
            message = "Learn more about the International Space Station",
            href = "https://spotthestation.nasa.gov/faq.cfm"
        )
    )
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        # Create two `menuItem()`s, "Dashboard" and "Inputs"
        menuItem("Dashboard",
                 tabName = "dashboard"),
        menuItem("Inputs",
                 tabName = "inputs")
    )
)

body <- dashboardBody(
    # Create a tabBox
    tabItems(
        tabItem(
            tabName = "dashboard",
            tabBox(
                title = "International Space Station Fun Facts",
                tabPanel("Fun Fact 1"),
                tabPanel("Fun Fact 2")
            )
        ),
        tabItem(tabName = "inputs")
    )
)

# Create the UI using the header, sidebar, and body
ui <- dashboardPage(header, sidebar, body)
