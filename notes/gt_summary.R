
library(survival)

# install.packages("gtsummary")
library(gtsummary)
library(tidyverse)
trial2 <- trial %>% select(trt, age, grade)


tab <- trial2 %>%
    tbl_summary(by = trt) %>%
    add_p()


tab2 <- trial2 %>%
    tbl_summary(
        by = trt,
        type = all_continuous() ~ "continuous2",
        statistic = all_continuous() ~ c(
            "{N_nonmiss}",
            "{median} ({p25}, {p75})",
            "{mean} ({sd})",
            "{min}, {max}"
        ),
        missing = "ifany"
    ) %>%
    add_p(pvalue_fun = ~ style_pvalue(.x, digits = 2))

tab_df = as.data.frame(tab2)

mTools::data_table(tab_df)
