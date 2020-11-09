# Function with easy calculation
easy_calc <- function(year) {
  result <- 100 + year
  eval(parse(text=paste0("system('echo ",year,"   ')")))
  saveRDS(object = result, file = paste0('data-data/easy_calc_', year, '.rds'))
  #eval(parse(text="system('ls -lR ./data-data/')"))
}
