#!/bin/bash
set -euo pipefail
export TERM=xterm

RESET_MASTER="bash <(curl -s https://raw.githubusercontent.com/joshkor1982/cka-study-tool/main/install-k8s-master.sh)"

read -p "Enter Master Username: " master_username
read -p "Enter Master Hostname: " master_hostname
read -sp "Enter Master Password: " master_password
clear

ssh ${master_username}@${master_hostname} "echo ${master_password} | ${RESET_MASTER}"
sleep 2
clear