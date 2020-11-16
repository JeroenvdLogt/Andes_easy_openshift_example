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

COPY ./main.R /usr/app/main.R
COPY ./easy_calc.R /usr/app/easy_calc.R
COPY ./round_up_results.R /usr/app/round_up_results.R

WORKDIR /usr/app

RUN mkdir -p /usr/app/Rlibs

# Install the R library basic dependencies
RUN Rscript /usr/ops/installVersionedDependencies.R NEXUSURL /usr/app/Rlibs && Rscript /usr/ops/installVersionedPackage.R NEXUSURL PROJECTNAME VERSION /usr/app/Rlibs FALSE && rm DESCRIPTION

RUN mkdir -p /usr/app/Rlibs
