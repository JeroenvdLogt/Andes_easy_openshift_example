#!/usr/bin/env script

args = commandArgs(trailingOnly = TRUE)
environment <- ''
if (length(args) > 0) {
    environment = c(args[1])
}

rlib <- paste0('/usr/app/Rlibs')

# main call
.libPaths(rlib)
install.packages('doParallel')
library('doParallel')
source('/usr/app/easy_calc.R')
source('/usr/app/round_up_results.R')
doParallel::registerDoParallel(cores = 10)
foreach(year = 2020:2059) %dopar% {easy_calc(year)}
print('Succeeded easy_calc')
round_up_results(2020:2059)
eval(parse(text="system('ls -lR /data-data')"))
