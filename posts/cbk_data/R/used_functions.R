
library(tidyverse)
library(data.table)
library(ggiraph)
library(scales)


brks_fun<- function(x){
    mxx = max(x, na.rm = T) %>% round(-1)
    seq(0, mxx, length.out = 5)
}


convert_to_num <- function(x){
    
    gsub(",", "", x) |>
        as.numeric()
}

plot_compare <- function(df, 
                         id_vars,
                         compare_vars,
                         x_val, 
                         y_val, 
                         col_val,
                         xlab,
                         ylab,
                         title_lab,
                         nrow_legend =1){
    
    cols_to_select = c(id_vars, compare_vars)
    gok_sum =  melt(df[,..cols_to_select], id.vars = id_vars)
    gok_sum[, variable := str_to_sentence( str_replace_all(variable, "_",  " "))]
    gok_sum = gok_sum[, .(sum_val = round(sum(value, na.rm = T))), by = c(id_vars, "variable")]
    col_val2 = enquo(col_val) %>% 
        rlang::as_name()
    len_var = gok_sum[, unique(.SD), .SDcols = col_val2] %>% nrow()
    #print(len_var)
    brks = gok_sum[, brks_fun(sum_val)]
    plot = gok_sum %>%
        ggplot( aes(x =  {{x_val}} ,
                    y = {{y_val}}, 
                    color = {{col_val}},
                    group = {{col_val}}))+
        geom_line_interactive()+
        geom_point_interactive(aes(tooltip = paste0({{col_val}}," in " ,{{x_val}}," : " ,{{y_val}})), size = 0.7)+
        labs(x = xlab, y = ylab, title = title_lab)+
        scale_y_continuous(labels=comma, breaks = brks) +
        scale_color_manual(name = "", values = scales::brewer_pal(palette = "Accent", type = "qual")(len_var))+
        guides(color = guide_legend(nrow = nrow_legend))+
        #theme_minimal()
        ggthemes::theme_hc()
    #girafe(ggobj =  plot)
    list(plot = plot, data =gok_sum )
}
