#!/usr/bin/env script

args = commandArgs(trailingOnly = TRUE)
environment <- ''
if (length(args) > 0) {
    environment = c(args[1])
}

rlib <- paste0('/usr/app/Rlibs')

# main call
.libPaths(rlib)
source('/usr/app/easy_calc.R')
source('/usr/app/round_up_results.R')
for(year in 2020:2059){easy_calc(year)}
print('Succeeded easy_calc')
round_up_results(2020:2059)
eval(parse(text="system('ls -lR /data-data')"))
