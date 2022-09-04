#!/bin/bash
export TERM=xterm

JOIN_COMMAND=$(kubeadm token create --print-join-command)

RESET_WORKER="bash <(curl -s https://install-k8s-worker.sh)"

read -p "ENTER SSH USERNAME 1: " USERNAME_ONE
read -p "ENTER WORKER HOSTNAME/IP 1: " HOSTNAME_ONE
read -sp "ENTER REMOTE PASSWORD: " PASSWORD_ONE
clear

ssh ${USERNAME_ONE}@${HOSTNAME_ONE} "echo ${PASSWORD_ONE} | ${RESET_WORKER} && \
sudo -S ${JOIN_COMMAND} | grep -w 'This node has joined the cluster'"
sleep 2
clear

read -p "ENTER SSH USERNAME 2: " USERNAME_TWO
read -p "ENTER WORKER HOSTNAME/IP 2: " HOSTNAME_TWO
read -sp "ENTER REMOTE PASSWORD: " PASSWORD_TWO
clear
ssh ${USERNAME_TWO}@${HOSTNAME_TWO} "echo ${PASSWORD_TWO} | ${RESET_WORKER} && \
sudo -S ${JOIN_COMMAND} | grep -w 'This node has joined the cluster'"
sleep 2
clear
