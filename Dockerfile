FROM brainlife/mcr:neurodebian1604-r2017a
MAINTAINER Lindsey Kitchell <kitchell@indiana.edu>

ADD /msa /msa

#we want all output to go here (config.json should also go here)
#RUN mkdir /output
WORKDIR /output

ENTRYPOINT ["/msa/main"]
