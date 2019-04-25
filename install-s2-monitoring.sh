#!/usr/bin/env bash

oc project enmasse-infra
oc label namespace enmasse-infra monitoring-key=middleware
oc apply -f https://raw.githubusercontent.com/integr8ly/grafana-operator/master/deploy/crds/Grafana.yaml
oc apply -f https://raw.githubusercontent.com/integr8ly/grafana-operator/master/deploy/crds/GrafanaDashboard.yaml

#git clone https://github.com/integr8ly/application-monitoring-operator
cd /Users/mtoth/work/repos/application-monitoring-operator/
oc apply -f ./deploy/roles
oc apply -f ./deploy/operator_roles/
oc apply -f ./deploy/crds/ApplicationMonitoring.yaml
oc apply -f ./deploy/operator.yaml
oc apply -f ./deploy/examples/ApplicationMonitoring.yaml



cd /Users/mtoth/work/enmasse-0.28.0-rc6/

# PATCH
sed -i 's/\${OAUTH_PROXY_IMAGE}/openshift\/oauth-proxy:latest/g' install/bundles/monitoring/060-Prometheus-prometheus.yaml
sed -i 's/\${OAUTH_PROXY_IMAGE}/openshift\/oauth-proxy:latest/g'  install/components/prometheus/060-Prometheus-prometheus.yaml

oc apply -f install/bundles/monitoring

#Example testins monitoring application
#oc new-project example-prometheus-nodejs
#oc label namespace example-prometheus-nodejs monitoring-key=middleware
#oc process -f https://raw.githubusercontent.com/david-martin/example-prometheus-nodejs/master/template.yaml | oc create -f -

# Install Grafana Operator
#git clone https://github.com/integr8ly/grafana-operator src/github.com/integr8ly/grafana-operator
#cd /Users/mtoth/work/repos/src/github.com/integr8ly/grafana-operator

#sed -i 's/application-monitoring/enmasse-infra/g' deploy/roles/cluster_role_binding.yaml
#sed -i 's/application-monitoring/enmasse-infra/g' deploy/examples/Grafana.yaml

# Install go
#export GOBIN=/usr/local/bin/

#make setup/dep
#make code/run

cd -

git clone https://github.com/OpenShiftDemos/grafana-openshift
cd grafana-openshift/
chmod +x root/usr/bin/fix-permissions
chmod +x run.sh
oc new-build --binary --name=grafana
oc start-build grafana --from-dir=. --follow
oc new-app grafana

cd -

