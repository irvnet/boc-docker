
# build:
# docker build -f boc-corp.dockerfile -t boc-corp:v1.0 .
#
# run:
# docker run -it --name boc-corp -p 10200:10200 -p 10201:10201 -p 10202:10202   boc-corp:v1.0 /bin/bash

FROM boc-base:v1.0

ENV MY_P2P_PORT=10200
ENV MY_RPC_PORT=10201
ENV MY_RPC_ADMIN_PORT=10202

ADD --chown=corda:corda boot-corp/cordapps/* /opt/corda/cordapps/
ADD --chown=corda:corda boot-corp/persistence.mv.db /opt/corda/persistence.mv.db
ADD --chown=corda:corda boot-corp/persistence.trace.db /opt/corda/persistence.trace.db
ADD --chown=corda:corda boot-corp/certificates/*.jks /opt/corda/certificates/
ADD --chown=corda:corda boot-corp/drivers/jolokia-jvm-1.6.0-agent.jar /opt/corda/drivers/jolokia-jvm-1.6.0-agent.jar
ADD --chown=corda:corda boot-corp/logs/*.log /opt/corda/logs/
ADD --chown=corda:corda boot-corp/additional-node-infos/* /opt/corda/additional-node-infos/

ENV PATH=$PATH:/opt/corda

EXPOSE $MY_P2P_PORT
EXPOSE $MY_RPC_PORT

USER "corda"
CMD ["entrypoint.sh"]
