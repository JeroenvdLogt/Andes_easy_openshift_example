# Round  up all results
round_up_results <- function(years) {
  res <- list()
  for(year in years){
    res[[year]] <- readRDS(file = paste0('/data-data/easy_calc_', year, '.rds'))
  }
  round_up <- sum(unlist(res))
  print(round_up)
  saveRDS(object = round_up, '/data-data/round_up.rds')
}
