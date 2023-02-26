
data_table <- function(df){
    library(DT)
    n_col = ncol(df)-1
    datatable(df,
              rownames = FALSE,
              style = "bootstrap4", class = 'cell-border stripe',
              options = list(scrollX = TRUE,
                             columnDefs = list(list(className = 'dt-center', targets = 0:n_col))
              )
    )
}


