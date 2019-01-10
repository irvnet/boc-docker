
# build:
# docker build -f boc-bank.dockerfile -t boc-bank:v1.0 .
#
# run:
# docker run -it --name boc-bank -p 10200:10200 -p 10201:10201 -p 10202:10202   boc-bank:v1.0 /bin/bash

FROM boc-base:v1.0

# Create corda user
WORKDIR /opt/corda

ENV MY_P2P_PORT=10200
ENV MY_RPC_PORT=10201
ENV MY_RPC_ADMIN_PORT=10202


##CORDAPPS FOLDER
ADD --chown=corda:corda boot-bank/cordapps/* /opt/corda/

##PERSISTENCE FOLDER
ADD --chown=corda:corda boot-bank/persistence.mv.db /opt/corda/persistence.mv.db
ADD --chown=corda:corda boot-bank/persistence.trace.db /opt/corda/persistence.trace.db

##CERTS FOLDER
VOLUME ["/opt/corda/certificates"]
ADD --chown=corda:corda boot-bank/certificates/*.jks /opt/corda/certificates/

##OPTIONAL JDBC DRIVERS FOLDER
VOLUME ["/opt/corda/drivers"]
ADD --chown=corda:corda boot-bank/drivers/jolokia-jvm-1.6.0-agent.jar /opt/corda/drivers/jolokia-jvm-1.6.0-agent.jar

##LOG FOLDER
VOLUME ["/opt/corda/logs"]
ADD --chown=corda:corda boot-bank/logs/*.log /opt/corda/logs/

##ADDITIONAL NODE INFOS FOLDER
VOLUME ["/opt/corda/additional-node-infos"]
ADD --chown=corda:corda boot-bank/additional-node-infos/* /opt/corda/additional-node-infos/

##CONFIG LOCATION
VOLUME ["/etc/corda"]

ENV PATH=$PATH:/opt/corda

EXPOSE $MY_P2P_PORT
EXPOSE $MY_RPC_PORT

USER "corda"
CMD ["entrypoint.sh"]
