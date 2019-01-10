
# build:
# docker build -f boc-base.dockerfile -t boc-base:v1.0 .
#
# run:
# docker run -it --name boc-base -p 10200:10200 -p 10201:10201 -p 10202:10202   boc-base:v1.0 /bin/bash

FROM azul/zulu-openjdk:8u192

RUN apt-get update && apt-get -y upgrade && apt-get -y install bash curl unzip

# Create corda user
RUN addgroup corda && useradd corda -g corda -m -d /opt/corda
WORKDIR /opt/corda

# Create dirs
RUN mkdir -p /opt/corda/cordapps
RUN mkdir -p /opt/corda/certificates
RUN mkdir -p /opt/corda/drivers
RUN mkdir -p /opt/corda/logs
RUN mkdir -p /opt/corda/additional-node-infos

ENV MY_P2P_PORT=10200
ENV MY_RPC_PORT=10201
ENV MY_RPC_ADMIN_PORT=10202

RUN chown -R corda:corda /opt/corda

##CORDAPPS FOLDER
VOLUME ["/opt/corda/cordapps"]
##PERSISTENCE FOLDER
VOLUME ["/opt/corda/persistence"]
##CERTS FOLDER
VOLUME ["/opt/corda/certificates"]
##OPTIONAL JDBC DRIVERS FOLDER
VOLUME ["/opt/corda/drivers"]
##LOG FOLDER
VOLUME ["/opt/corda/logs"]
##ADDITIONAL NODE INFOS FOLDER
VOLUME ["/opt/corda/additional-node-infos"]

##CORDA JAR
ADD --chown=corda:corda resources/corda-node-3.3-corda.jar /opt/corda/corda.jar
ADD --chown=corda:corda resources/entrypoint.sh  /opt/corda/entrypoint.sh
RUN chmod +x /opt/corda/entrypoint.sh
ENV PATH=$PATH:/opt/corda

EXPOSE $MY_P2P_PORT
EXPOSE $MY_RPC_PORT

#USER "corda"
CMD ["entrypoint.sh"]
