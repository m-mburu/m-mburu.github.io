
(0*2) + 3*1

3*2 + (0*1)

breed
labrador    24.025641
pitbull     22.432122
poodle      22.783084
pug         22.529472

library(tidyverse)
N <- c("242", "279", "243", "236") %>% as.numeric()

breed = c("labrador", "pitbull", "poodle", "pug")

weight <- c(rnorm(242, 24.02, 10.99), 
            rnorm(279, 22.43, 11.86),
            rnorm(243, 22.78, 11.15),
            rnorm(236, 22.53,10.19))


my_list <- list()
breed <- for (i in 1:length(breed)) {
    
    my_list[[i]] = rep(breed[i], N[i])
    
}

my_breed <- unlist(my_list)


filename = "C:/Users/mmburu/Desktop/data_camp/data_camp/python_notebooks/python_programming_track/Introduction to Data Science in Python"

data.frame(breed = my_breed, weight = weight) %>%
    write.csv(file = file, row.names = F)
gravel.radius.mean()
Out[2]: 4.251234275649894
gravel.radius.std()
Out[3]: 1.0821193343621338

file2 = paste0(filename, "/", "gravel.csv")
data.frame(radius= rnorm(1000, 4.2512, 1.08)) %>%
    write.csv(file = file2, row.names = F)
