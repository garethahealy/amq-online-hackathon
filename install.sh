#!/usr/bin/env bash

echo "Its expected you are logged in as an admin!!!"

oc whoami

oc new-project enmasse-infra

oc apply -f install/bundles/enmasse
oc apply -f install/bundles/monitoring


oc apply -f install/components/scenario1