#!/usr/bin/env script

args = commandArgs(trailingOnly = TRUE)
environment <- ''
if (length(args) > 0) {
    environment = c(args[1])
}

rlib <- paste0('/usr/app/Rlibs')

# main call
.libPaths(rlib)
source(easy_calc.R)
source(round_up_results.R)
for(year in 2020:2059){easy_calc(year)}
round_up_results(2020:2059)
print(readRDS(round_up.rds)