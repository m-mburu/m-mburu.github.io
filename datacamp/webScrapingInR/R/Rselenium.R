library(rvest)
library(xml2)

url <-  'https://www.nse.co.ke/corporate-actions'

webpage <- read_html(url)

## extract h3 tags

h3_tags <- webpage %>%
  html_element("h3") %>%
  html_text()

xml_str <- html_structure(webpage)

webpage$doc %>% print()


# Load necessary libraries
library(RSelenium)
library(rvest)
library(wdman)
selServ <- selenium()
# Start RSelenium client and server
rD <- rsDriver()
remDr <- rD$client

# Go to the webpage
remDr$navigate(url )

# Get page source
page_source <- remDr$getPageSource()[[1]]
