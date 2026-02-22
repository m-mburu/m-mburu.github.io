
library(tidyverse)
library(data.table)
library(janitor)
library(tmap)
library(patchwork)
library(sf)
library(ggiraph)
library(viridis) # For scale_fill_viridis_c

developers <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/developers.csv")
git_pushes <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/git_pushes.csv")
git_repos <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/repositories.csv")

developers <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/developers.csv")

programming_languages <- fread("https://raw.githubusercontent.com/github/innovationgraph/main/data/languages.csv")

library(data.table)

# Function to convert year and quarter vectors to last date of the quarter
year_quarter_to_date <- function(year, quarter) {
    # Ensure the vectors are the same length
    if (length(year) != length(quarter)) {
        stop("The length of year and quarter vectors must be the same.")
    }
    
    # Create a data.table with the provided year and quarter
    dt <- data.table(year = year, quarter = quarter)
    
    # Create a data.table with quarter-end dates
    quarter_end_dates <- data.table(
        quarter = 1:4,
        end_date = c("03-31", "06-30", "09-30", "12-31")
    )
    
    # Merge the data.tables to get the end dates
    merged_dt <- merge(dt, quarter_end_dates, by = "quarter", sort = FALSE)
    
    # Create the full date string
    merged_dt[, full_date := as.Date(paste(year, end_date, sep = "-"))]
    
    # Return the full date as a vector
    return(merged_dt[, full_date])
}

# Examples
years <- c(2020, 2020, 2024)
quarters <- c(1, 2, 1)
print(year_quarter_to_date(years, quarters))  # "2020-03-31" "2020-06-30" "2024-03-31"

# Using more examples
years_example <- c(2020, 2021, 2022, 2023)
quarters_example <- c(1, 4, 3, 2)
print(year_quarter_to_date(years_example, quarters_example))  # "2020-03-31" "2021-12-31" "2022-09-30" "2023-06-30"



python_developers <- programming_languages[language == "Python", ]

# :q what is is02 code for nigeria
# :a NG
# :q what is is02 code for UK
# :a UK
developers_ke <- python_developers[iso2_code %in% c("KE", "EG", "ZA", "RW","NG"), ]

developers_ke[, year_quarter := paste0(year, "-", quarter)]


developers_ke[, date := year_quarter_to_date(year, quarter)]

p <- ggplot(developers_ke, aes(x = date, y = num_pushers, colour = iso2_code)) +
    geom_line() +
    labs(title = "Developers in Kenya Over Time", x = "Date", y = "Number of Developers") +
    theme_minimal()

plotly::ggplotly(p)
