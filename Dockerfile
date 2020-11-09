FROM rocker/r-ver:3.6.0

RUN apt-get update

COPY ./main.R /usr/app/main.R
COPY ./easy_calc.R /usr/app/easy_calc.R
COPY ./round_up_results.R /usr/app/round_up_results.R

WORKDIR /usr/app

RUN mkdir -p /usr/app/Rlibs
