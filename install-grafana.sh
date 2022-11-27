#!/bin/bash
function Install_Grafana {

read -p "Enter Master Username: " master_username
read -p "Enter Master Hostname: " master_hostname
read -sp "Enter Master Password: " master_password
clear
create_namespace=$(kubectl create ns grafana)
check_namespace=$(kubectl )
ssh -T "${master_username}"@"${master_hostname}" '( [[ $(kubectl get ns grafana) == $? ]] || { kubectl create ns grafana
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/grafana-loki 
} )'
# ssh -T "${master_username}"@"${master_hostname}" "echo ${master_password} | ${add_helm_repo}"
# ssh -T "${master_username}"@"${master_hostname}" "echo ${master_password} | ${helm_deploy}"
}
Install_Grafana