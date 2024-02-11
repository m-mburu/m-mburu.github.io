library(tidyverse)
library(data.table)
library(here)
# Read in data
list.files(here("data"))
# "finaccess_2021.rda" "kenya_counties.rda" "kenya.rda"   
load(here("data", "finaccess_2021.rda"))
load(here("data", "kenya.rda"))
load(here("data", "kenya_counties.rda"))
setDT(finaccess_2021)
nms_fin2021 <-  names(finaccess_2021)
kenya_counties_df <- merge(kenya_counties, kenya, by = "county")


col_labels <- sapply(as.data.frame(finaccess_2021), attr , "label")

col_types <- sapply(finaccess_2021, class)

col_types2 <- sapply(col_types, function(x){
    
    x[!grepl("labelled|haven|vctrs_vctr", x)]
})

col_names <- names(finaccess_2021)

dictionary <- data.table(col_names, col_labels, col_types = col_types2)

dictionary[, col_labels := str_trim(gsub("^.{2,7}\\. ", "", col_labels))]

dictionary[, as_type  := paste0("as.", col_types)]
dictionary[, is_type := paste0("is.", col_types)]

fwrite(dictionary, here("data", "dictionary.csv"))

dictionary_sub <- dictionary[, .(col_names, col_labels)]

is_labelled <- function(x) inherits(x, "labelled")

find_col_class <- function(df, function_used) {
    
    function_used <- match.fun(function_used)
    nms <- names(df)
    tru_false <- sapply(df, function(x) function_used(x))
    nms[tru_false]
    
}

col_types_df <- dictionary %>%
    distinct(col_types, as_type, is_type) 

col_types_df[as_type == "as.double", as_type := "as.numeric"]
convert_columns <- function(df, is_type_vec, as_type_vec) {
    if (length(is_type_vec) != length(as_type_vec)) {
        stop("is_type_vec and as_type_vec must have the same length")
    }
    
    for (i in seq_along(is_type_vec)) {
        is_type_fun <- is_type_vec[i]
        as_type_fun <- as_type_vec[i]
        
        # Find columns that match the type
        nms <- find_col_class(df, is_type_fun) 
        
        # Convert as_type_fun from character to function
        as_type_converter <- match.fun(as_type_fun)
        
        # Apply the conversion
        df[, (nms) := lapply(.SD, as_type_converter), .SDcols = nms]
    }
    #return(df)
}


#convert_columns(finaccess_2021, col_types_df$is_type, col_types_df$as_type)

id_vars <- c("County", "A10i", "A21", "A22", "B3B")
id_vars_regex <- paste0("^", id_vars, "$")

questions_savs_loans <- c("^C1_[0-8]$", "^C1_(9|1[0])$", "^C1_(1[1-9]|2[0-6])$")


questions_int_v <- c("Savings products", "Registered Transaction Devices", "Loan Products")

questions_savs_loans_id <- c(id_vars_regex, questions_savs_loans)

savings_loans <- finaccess_2021[, .SD, .SDcols = patterns(paste0(questions_savs_loans_id, collapse = "|"))]

# Melt savings loans
savings_loans_melt <- melt(savings_loans, 
                           id.vars = id_vars, 
                           variable.name = "question",
                           variable.factor = FALSE,
                           value.name = "response")


savings_loans_melt[, question_type := fcase(
    str_detect(question, "^C1_[0-8]$"), "Savings products",
    str_detect(question, "^C1_(9|1[0])$"), "Registered Transaction Devices",
    str_detect(question, "^C1_(1[1-9]|2[0-6])$"), "Loan Products"
)]

savings_loans_melt[, question := factor(question,
                                        levels = dictionary$col_names,
                                        labels = dictionary$col_labels)]

savings_loans_melt[, question := factor(question)]


# A function group by id vars and question type response
# and calculate the percentage of responses

library(dplyr)
library(tidyr)

summary_perc_fun <- function(data, id_var,question_type,question, response){
    
    df =  data[, .(n = .N), by = c(id_var, question_type, question, response)][
        
        , perc :=round( n/sum(n)*100, 2), by = c(id_var, question_type, question)]
    df
    
}

# Example usage
# summary_perc_fun(your_data, id_var_column_name, question_type_column_name, question_column_name, response_column_name)

# Apply function to data

savings_loans_sex <- summary_perc_fun(savings_loans_melt,
                                      id_var ="A10i" ,
                                      question_type =  "question_type",
                                      question = "question",
                                      response= "response")

library(ggiraph)
plot_function <- function(data, 
                          question_type_f,
                          title, 
                          cord_flip = TRUE, 
                          xlab, 
                          ylab,
                          plot_width = 8,
                          plot_height = 7.5,
                          str_widthm = 20){
    
    cord_flip =    if(cord_flip == TRUE){
        coord_flip()
    } else NULL
    
   myplot =  data %>%
        filter(question_type == question_type_f) %>% 
        mutate(label = paste0(str_wrap(question, 20), " : ", response," : ", perc, "%")) %>%
        ggplot(aes(x = reorder(question, -perc), y = perc,  fill = response,tooltip = label )) +
        geom_bar_interactive(stat = "identity") +
        facet_grid(~A10i) +
       # geom_text(aes(label = paste0(perc, "%")), vjust = -0.5) +
        # str_wrap x axis
        scale_x_discrete(labels = function(x) str_wrap(x, width = str_widthm)) +
        cord_flip+
        scale_fill_brewer(palette = "Set1") +
        labs(title = title,
             x = xlab,
             y = ylab) +
        theme_minimal() +
        theme(
              plot.title = element_text(hjust = 0.5),
              legend.position = "bottom")
   
    girafe(ggobj = myplot, 
           pointsize = 10,
           width_svg = plot_width,
           height_svg = plot_height)
    
}

p1 = plot_function(data = savings_loans_sex, 
              question_type_f = "Savings products",
              title = "Savings products",
              cord_flip = TRUE,
              xlab = "Savings products",
              ylab = "Percentage of responses",
              plot_width = 8,
              plot_height = 7.5)


p2 = plot_function(data = savings_loans_sex, 
              question_type_f = "Loan Products",
              title = "Loan products",
              cord_flip = TRUE,
              xlab = "Loan products",
              ylab = "Percentage of responses",
              plot_width = 8,
              plot_height = 10,
              str_widthm = 50)


# save data set

savings_loans_county_s <- summary_perc_fun(savings_loans_melt,
                                      id_var ="County" ,
                                      question_type =  "question_type",
                                      question = "question",
                                      response= "response")



# Define the function
merge_split_combine <- function(df1, split_dfs, merge_by_column, split_cols) {
  
    # Initialize an empty list to store the merge results
    merge_results <- list()
    
    # Iterate over the split data frames and merge each with df2
    for (i in seq_along(split_dfs)) {
        merged_df <- merge(df1, split_dfs[[i]], by = merge_by_column, all.x = TRUE)
        merged_df[, (split_cols) := lapply(.SD, as.character), .SDcols = split_cols]
        merged_df[, (split_cols) := lapply(.SD, zoo::na.locf, na.rm = F), .SDcols = split_cols]
        merged_df[, (split_cols) := lapply(.SD, zoo::na.locf, na.rm = F, fromLast = T), .SDcols = split_cols]
     
        merge_results[[i]] <- merged_df
    }
    
    # Combine all merged data frames using rbindlist and return as a data.table
    result_dt <- rbindlist(merge_results)
    
    return(result_dt)
}

#savings_loans_county_s <- savings_loans_county_s[!is.na(response)]

split_dfs <- split(savings_loans_county_s,f = list(savings_loans_county_s$question, savings_loans_county_s$response))


savings_loans_county <- merge_split_combine(kenya,
                                            split_dfs = split_dfs, 
                                            merge_by_column = "County",
                                            split_cols = c("question_type","question", "response"))



savings_county <- savings_loans_county[question_type == "Savings products" & response == "Currently use"] %>%
    merge(kenya_counties, by = "county", all.y = TRUE)

svs_questions <- c(
    "Microfinance institution", 
    "Savings through mobile banking (e.g. Mshwari , KCB MPesa, MCoop cash, Eazzy Loan, Timiza, HF Whizz)?", 
    "Savings/keeping through mobile money account (e.g. MPESA, Airtel Money, TCash, Tangaza, MobiKash, Equitel)", 
    "Savings at a Sacco / Savings and Credit Cooperative organisation", 
    "Savings at a group or chama", 
    "Savings with a group of friends", 
    "Savings given to a family or friend to keep", 
    "Savings you keep in a secret hiding place"
)

graph_titles <- c(
    "Microfinance Institutions", 
    "Mobile Banking Savings", 
    "Mobile Money Account Savings", 
    "Sacco Savings", 
    "Group or Chama Savings", 
    "Friend Group Savings", 
    "Family or Friend Custody Savings", 
    "Secret Hiding Place Savings"
)
savings_county[, titles := factor(question, levels = svs_questions, labels = graph_titles)]
savings_county[, titles := str_wrap(as.character(titles), width = 50)] 
savings_county[, unique(question)] %>% dput
savings_county[is.na(perc), perc := 0]


# Create the data frame
savings_tools_df <- data.frame(
    Classification = c(
        "Formal Savings Tools", "Formal Savings Tools", "Formal Savings Tools", "Formal Savings Tools",
        "Informal Savings Tools", "Informal Savings Tools", "Informal Savings Tools", "Informal Savings Tools"
    ),
    titles = c(
        "Microfinance Institutions", 
        "Mobile Banking Savings", 
        "Mobile Money Account Savings", 
        "Sacco Savings",
        "Group or Chama Savings", 
        "Friend Group Savings", 
        "Family or Friend Custody Savings", 
        "Secret Hiding Place Savings"
    )
)

savings_county <- merge(savings_county, savings_tools_df, by = "titles")

savings_county_formal <- savings_county[Classification == "Formal Savings Tools"]
savings_county_informal <- savings_county[Classification == "Informal Savings Tools"]


library(sf)
savings_county_sf <- st_set_geometry(savings_county_formal, value = "geometry")

# mobile banking has not been well marketted and their is room for growth
map1 <- ggplot(savings_county_sf, aes(fill = perc, tooltip = paste0(str_to_title(county), " : ",str_wrap(titles, 20), ":" ,perc, "%"))) +
    geom_sf_interactive() +
    scale_fill_viridis_c() +
    facet_wrap(~titles) +
    theme_void() +
    theme(legend.position = "bottom") +
    labs(title = "Percentage of those who currently use various  savings formal products",
         fill = "Percentage of responses")

# map1 <- girafe(ggobj = map1, 
#        pointsize = 10,
#        width_svg = 12,
#        height_svg = 8)

#mobile_money_active 


mobile_ownership_df <- finaccess_2021[, .(freq = .N ), by = .(County,A10i, mobile_own)][,
     perc := freq/sum(freq)*100, by = .(County, A10i)
][,
  perc_label := scales::percent(perc/100, accuracy = 0.1)
][mobile_own == "Yes"] %>%
    merge(kenya_counties_df, by = "County", all.y = TRUE)






mobile_ownership_df_sf <- st_set_geometry(mobile_ownership_df, value = "geometry")

map3 <- ggplot(mobile_ownership_df_sf, aes(fill = perc, tooltip = paste0(County, ":", perc_label))) +
    geom_sf_interactive() +
    scale_fill_viridis_c() +
    facet_wrap(~A10i) +
    theme_void() +
    theme(legend.position = "bottom") +
    labs(title = "Mobile Phone Ownership in Kenya 2021",
         fill = "%")


type_phone_vars <-  nms_fin2021[grepl("S2__[1-5]{1}", nms_fin2021)]
type_phone <- finaccess_2021[, .SD, .SDcols = c(id_vars, type_phone_vars)]

type_phone_melt <- melt(type_phone, 
                           id.vars = id_vars, 
                           variable.name = "col_names",
                           variable.factor = FALSE,
                           value.name = "response") %>%
    merge(dictionary_sub, by = "col_names") 


type_phone_county <- summary_perc_fun(type_phone_melt,
                                           id_var ="County" ,
                                           question_type = NULL,
                                           question = "col_labels",
                                           response= "response")

type_phone_county <- type_phone_county[response == 1]

type_phone_county_dfs <- split(type_phone_county,f = list(type_phone_county$col_labels))


type_phone_county <- merge_split_combine(kenya_counties_df,
                                            split_dfs = type_phone_county_dfs, 
                                            merge_by_column = "County",
                                            split_cols = c("col_labels"))


type_phone_county_sf <- st_set_geometry(type_phone_county, value = "geometry")

map4 <- ggplot(type_phone_county_sf, aes(fill = perc, tooltip = paste0(County, ":", perc))) +
    geom_sf_interactive() +
    scale_fill_viridis_c() +
    facet_wrap(~col_labels) +
    theme_void() +
    theme(legend.position = "bottom") +
    labs(title = "Mobile Phone Ownership in Kenya 2021",
         fill = "%")


# incomegpnew  fct_collapse KSh 0        KSh 1 - 1,000    KSh 1,001 - 3,000    KSh 3,001 - 5,000 ;

income_levels <- c("KSh 0", "KSh 1 - 1,000", "KSh 1,001 - 3,000", "KSh 3,001 - 5,000", 
  "KSh 5,001 - 10,000", "KSh 10,001-20,000", "KSh 20,001 - 50,000", 
  "KSh 50,001 - 100,000", ">KSh 100,000", "Don't Know", "Refused to Answer")

income_rm <- c( "Don't Know", "Refused to Answer", "No response")

incomegpnew_df <- finaccess_2021[, .(freq = .N ), by = .(County, incomegpnew)][,
     perc := freq/sum(freq)*100, by = .(County)
][,
  perc_label := scales::percent(perc/100, accuracy = 0.1)
][!incomegpnew %in% income_rm]

incomegpnew_split <- split(incomegpnew_df, f = list(incomegpnew_df$incomegpnew))

incomegpnew <- merge_split_combine(kenya_counties_df,
                                         split_dfs = incomegpnew_split, 
                                         merge_by_column = "County",
                                         split_cols = c("incomegpnew"))

incomegpnew[is.na(perc), perc := 0]
incomegpnew <- incomegpnew[!is.na(incomegpnew)]
incomegpnew[, incomegpnew := factor(incomegpnew, levels = income_levels)] 
fwrite(incomegpnew_df, "incomegpnew_df.csv", row.names = FALSE)
incomegpnew_sf <- st_set_geometry(incomegpnew, value = "geometry")

map5 <- ggplot(incomegpnew_sf, aes(fill = perc, tooltip = paste0(County, ":", perc_label))) +
    geom_sf_interactive() +
    scale_fill_viridis_c() +
    facet_wrap(~incomegpnew) +
    theme_void() +
    theme(legend.position = "bottom") +
    labs(title = "Income Group Distribution in Kenya 2021",
         fill = "%")
map5


income_source_df <- finaccess_2021[, .(freq = .N ), by = .(County, A10i, A21,B3B, incomegpnew)]

fwrite(income_source_df, "income_source_df.csv", row.names = FALSE)
