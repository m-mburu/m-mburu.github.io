

library(pacman)
p_load(data.table, stringr, magrittr, foreach, ggplot2, zoo, knitr, plyr, 
       dplyr, ggthemes, readxl, stringi, Hmisc,
       doParallel, tidyr, DT)


setwd("E:/R/association analysis")

dat <- setDT(read.csv( "BreadBasket_DMS.csv" ))

head(dat[sample(1:nrow(dat), 10)])

dat2 <- dcast(Date+Time+Transaction~Item, data = dat, fun.aggregate = length)

number_items <- rowSums(dat2[, 4:98, with =F])

dat2[, number_items := number_items]

hist(number_items)

sumStats <- dat2 %>%
    summarise(Average = round(mean(number_items), 2), Stdev = round(sd(number_items), 2), Median = median(number_items),
              Minimum = min(number_items), Maximum = max(number_items),
              First_qurtile = quantile(number_items,0.25,  na.rm = T), Third_qurtile = quantile(number_items,0.75,  na.rm = T))

knitr::kable(sumStats)

dat_more_2 <- dat2[number_items >2]

#you want to see what they bought

items_bought <- paste(dat2[, 4:98, with =F], collapse = "", sep = "")

items_bought <- apply(dat_more_2[, 4:98, with =F], 1, paste, collapse = "", sep = "")
head(items_bought, 1)
index <- unlist(gregexpr("1", items_bought[2]))
item_names[index]
item_names <- names(dat_more_2)[4:98]
index %>% unlist()

list_items <- vector(mode = "list", length = length(items_bought))
for (i in 1:length(items_bought)) {
    index <- unlist(gregexpr("1", items_bought[i]))
    items_transaction_i <- item_names[index]
    items_transaction_i <- paste(items_transaction_i, sep = " ", collapse = " , ")
    list_items[[i]] <- items_transaction_i
}

head(unlist(list_items))

dat_more_2[, items_bought := unlist(list_items) ]

head(dat_more_2[sample(1:nrow(dat_more_2), 10), .(Transaction, number_items,items_bought)]) %>%View

#short cut for writing char vectors in R

my_item_set <- Hmisc::Cs(Coffee , Jam , Bread)

idx_sample <- grep( "Transactio|^Coffee$|^Jam$|^Bread$", names(dat_more_2))



item_set_dat <- dat2[, idx_sample, with = F] 

#some transaction bought more thanone of 
item_set_dat[, (my_item_set) := lapply(.SD, function(x) ifelse(x==0, 0, 1)), .SDcols = my_item_set]

item_set_dat[, total_items := rowSums(item_set_dat[, 2:4, with = F]) ]

support_coffee_pastry_jam <- table(item_set_dat$total_items)["3"]/9531 

item_set_dat[, coffee_pastry := rowSums(item_set_dat[, c(2,4), with = F]) ]

support_coffee_pastry <- table(item_set_dat$coffee_pastry)["2"]

confidence <- support_coffee_pastry_jam/support_coffee_pastry 

confidence * 100

pacman::p_load(arules, arulesViz, exploratory)

?apriori
data("Adult")
## Mine association rules.

dat[, Transaction := as.factor(Transaction)]

trans <- as(split(dat$Item, dat$Transaction), "transactions")

rules <- apriori(trans,
                 parameter = list(supp = 0.02, conf = 0.04, target = "rules"))
summary(rules)
rules <- sort(rules, by='confidence', decreasing = TRUE)
summary(rules)

inspect(rules[1:30])


