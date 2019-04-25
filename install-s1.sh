#!/usr/bin/env bash

#echo "Its expected you are logged in as an admin!!!"

#oc whoami

#oc new-project enmasse-infra

#oc apply -f install/bundles/enmasse
#oc apply -f install/bundles/monitoring

#oc apply -f install/bundles/example-roles
#oc adm policy add-role-to-user view user1 -n enmasse-infra
#oc adm policy add-role-to-user enmasse.io:tenant-admin user1 -n enmasse-infra

USERNAME_PASS=$(echo -n password | base64)

## RUN AS ADMIN
oc logout
oc login -u opentlc-mgr -p r3dh4t1! https://master.amqhackfest-emea01.openshift.opentlc.com

oc project enmasse-infra

oc apply -n enmasse-infra -f install/components/scenario1/AuthenticationService-standard.yaml

oc process -f install/components/scenario1/StandardInfraConfig-template.yaml | oc apply -n enmasse-infra  -f -

oc process -f install/components/scenario1/AddressPlan-anycastrouter-template.yaml -p PLAN_NAME=anycastrouterday -p ROUTER_SLICE=0.0000001 | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario1/AddressPlan-anycastrouter-template.yaml -p PLAN_NAME=anycastrouternight -p ROUTER_SLICE=0.1 | oc apply -n enmasse-infra  -f -

oc process -f install/components/scenario1/AddressPlan-queue-partitions-template.yaml -p PLAN_NAME=queuepartitionsday -p ROUTER_SLICE=0.1 -p BROKER_SLICE=0.1 | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario1/AddressPlan-queue-partitions-template.yaml -p PLAN_NAME=queuepartitionsnight -p ROUTER_SLICE=0.0000001 -p BROKER_SLICE=0.0000001 | oc apply -n enmasse-infra  -f -

oc process -f install/components/scenario1/AddressPlan-topic-template.yaml -p ROUTER_SLICE=0.1 -p BROKER_SLICE=0.1 | oc apply -n enmasse-infra  -f -

oc process -f install/components/scenario1/AddressSpacePlan-default-template.yaml | oc apply -n enmasse-infra  -f -

# RUN AS TENANT
oc logout
oc login -u user1 -p r3dh4t1! https://master.amqhackfest-emea01.openshift.opentlc.com

oc new-project enmasse-is-great

oc process -f install/components/scenario1/AddressSpace-default.yaml | oc apply -n enmasse-is-great -f -

oc process -f install/components/scenario1/Address-input_batch.yaml | oc apply -n enmasse-is-great -f -
oc process -f install/components/scenario1/Address-input_online.yaml | oc apply -n enmasse-is-great -f -
oc process -f install/components/scenario1/Address-results-template.yaml -p CUSTOMER_ID=1 | oc apply -n enmasse-is-great -f -
oc process -f install/components/scenario1/Address-alerts-template.yaml | oc apply -n enmasse-is-great -f -

oc process -f install/components/scenario1/MessagingUser-external-template.yaml -p ADDRESS_SPACE=default -p USERNAME=extamq1 -p CUSTOMER_ID=1 -p PASSWORD=$USERNAME_PASS | oc apply -n enmasse-is-great -f -
oc process -f install/components/scenario1/MessagingUser-internal-template.yaml -p ADDRESS_SPACE=default -p USERNAME=intamq1 -p CUSTOMER_ID=1 -p PASSWORD=$USERNAME_PASS | oc apply -n enmasse-is-great -f -