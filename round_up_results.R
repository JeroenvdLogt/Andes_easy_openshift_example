# Round  up all results
round_up_results <- function(years) {
  res <- list()
  for(year in years){
    res[[year]] <- readRDS(file = paste0('easy_calc_', year, '.rds'))
  }
  round_up <- sum(unlist(res))
  saveRDS(object = round_up, 'round_up.rds')
}