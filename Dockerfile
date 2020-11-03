FROM rocker/r-ver:3.6.0

RUN apt-get update

# This is a mandatory minimal list of libs for all R projects
RUN apt-get -y install libcurl4-openssl*
RUN apt-get -y install libssl-*
RUN apt-get -y install libxml2-*
RUN apt-get -y install locate

# This is the extensive libs list for being able to build all kinds of R projects that have need of dependencies on other libs
RUN apt-get -y install gdal-bin proj-bin libgdal-dev libproj-dev
RUN apt-get -y install default-jdk
RUN apt-get -y install libbz2-dev libpcre3-dev

# This is to be able to test connections
RUN apt-get -y install telnet strace ltrace tar rsync

COPY ./main.R /usr/app/main.R
COPY ./easy_calc.R /usr/app/easy_calc.R
COPY ./round_up_results.R /usr/app/round_up_results.R

WORKDIR /usr/app

RUN mkdir -p /usr/app/Rlibs

# start script
ENTRYPOINT ["Rscript"]
CMD ["/usr/app/main.R"]