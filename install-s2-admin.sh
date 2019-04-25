#!/usr/bin/env bash

## RUN AS ADMIN
oc logout
oc login -u opentlc-mgr -p r3dh4t1! https://master.amqhackfest-emea04.openshift.opentlc.com

oc project enmasse-infra

oc process -f install/components/scenario2-admin/PriorityClass-template.yaml | oc apply -n enmasse-infra  -f -

oc apply -n enmasse-infra -f install/components/scenario2-admin/AuthenticationService-standard.yaml

oc process -f install/components/scenario2-admin/BrokeredInfraConfig-engineering-template.yaml | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario2-admin/BrokeredInfraConfig-production-template.yaml | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario2-admin/BrokeredInfraConfig-qe-template.yaml | oc apply -n enmasse-infra  -f -

oc process -f install/components/scenario2-admin/AddressPlan-topic-template.yaml | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario2-admin/AddressPlan-queue-template.yaml | oc apply -n enmasse-infra  -f -

oc process -f install/components/scenario2-admin/AddressSpacePlan-engineering-template.yaml | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario2-admin/AddressSpacePlan-production-template.yaml | oc apply -n enmasse-infra  -f -
oc process -f install/components/scenario2-admin/AddressSpacePlan-qe-template.yaml | oc apply -n enmasse-infra  -f -