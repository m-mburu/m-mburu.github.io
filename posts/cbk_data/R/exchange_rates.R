library(tidyverse)
library(data.table)
library(ggiraph)
library(scales)
library(here)

kes_dollar <- fread(here("data", "Key CBK Indicative Exchange Rates_dollar.csv")) 

kes_pound <- fread(here("data", "Key CBK Indicative Exchange Rates_Pound.csv"))

kes_p_d <- rbind(kes_dollar, kes_pound) 

kes_p_d[, Date := as.Date(Date, format = "%d/%m/%Y")]

kes_p_d[, data_id := ifelse(Currency == "US DOLLAR",1, 2)]
kes_p_d <- kes_p_d[Date >= "2005-01-01"]
setorder(kes_p_d, Currency, Date)
kes_p_d_plot <- ggplot(kes_p_d, aes(x = Date, y = Mean,group = Currency, color =Currency ,  data_id = data_id)) +
  geom_line_interactive() +
  geom_point_interactive() +
  scale_y_continuous(labels = scales::comma) +
    scale_color_manual_interactive(name = "", values = brewer_pal(type = "qual", palette = "Dark2" )(2))+
  scale_x_date(date_labels = "%Y", date_breaks = "2 year") +
  labs(title = "Kenyan Shilling to US Dollar & British Pound Exchange Rates",
       x = "Year",
       y = "Exchange Rate",
       caption = "Source: Central Bank of Kenya") +
  ggthemes::theme_hc() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0.5))

girafe(ggobj = kes_p_d_plot,
       options = list(
           opts_hover(css = ''), ## CSS code of line we're hovering over
           opts_hover_inv(css = "opacity:0.1;"), ## CSS code of all other lines
           opts_sizing(rescale = T) ## Fixes sizes to dimensions below
       ))
