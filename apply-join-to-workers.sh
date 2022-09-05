#!/bin/bash
export TERM=xterm

JOIN_COMMAND=$(kubeadm token create --print-join-command)

RESET_WORKER="bash <(curl -s https://raw.githubusercontent.com/joshkor1982/cka-study-tool/main/install-k8s-master.sh)"
RESET_MASTER="bash <(curl -s https://raw.githubusercontent.com/joshkor1982/cka-study-tool/main/install-k8s-worker.sh)"

read -p "Enter Master Username: " master_username
read -p "Enter Master Hostname: " master_hostname
read -sp "Enter Master Password: " master_password
clear

ssh ${master_username}@${master_hostname} "echo ${master_password} | ${RESET_MASTER}"
sleep 2
clear

read -p "Enter Worker One Username: " worker_one_username
read -p "Enter Worker One Hostname: " worker_one_hostname
read -sp "Enter Worker One Password: " worker_one_password
clear

ssh ${worker_one_username}@${worker_one_hostname} "echo ${worker_one_password} | ${RESET_WORKER} && \
sudo -S ${JOIN_COMMAND} | grep -w 'This node has joined the cluster'"
sleep 2
clear

read -p "Enter Worker Two Username: " worker_two_username
read -p "Enter Worker Two Hostname: " worker_two_hostname
read -sp "Enter Worker Two Password: " worker_two_password
clear
ssh ${worker_two_username}@${worker_two_hostname} "echo ${worker_two_password} | ${RESET_WORKER} && \
sudo -S ${JOIN_COMMAND} | grep -w 'This node has joined the cluster'"
sleep 2
clear
