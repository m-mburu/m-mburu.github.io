# theme(axis.line = element_blank(),
#               axis.text = element_blank(),
#               axis.ticks = element_blank(),
#               axis.title = element_blank(),
#               panel.background = element_blank(),
#               panel.border = element_blank(),
#               panel.grid.major = element_blank(),
#               panel.grid.minor = element_blank(),
#               plot.background = element_blank())
# 

library(tidyverse)

break_func <- function(s){
    
    s = tolower(s)
    if(nchar(s) <= 1) return(s)
    veci = c()
    for (i in 1:nchar(s)) {
        veci[i] = str_sub(s, i, i)
    }
    return(veci)
}


s = break_func("Anna")

is_pal <- function(s) {
    print(s)
    if(length(s)<= 1) {
        
        return(TRUE)
        
    }else{
      
        return(s[1] == s[length(s)] & is_pal(s[2:(length(s)-1)]))
    }
}

is_pal(break_func("Anna")) 
