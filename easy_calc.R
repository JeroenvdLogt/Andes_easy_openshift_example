# Function with easy calculation
easy_calc <- function(year) {
  result <- 100 + year
  saveRDS(object = result, file = easypaste0('easy_calc_', year, '.rds'))
}
