# Round  up all results
round_up_results <- function(years) {
  for(year in years){
    res <- readRDS(file = paste0('easy_calc_', year, '.rds'))
  }
}