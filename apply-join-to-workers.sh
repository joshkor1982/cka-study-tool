#!/bin/bash
set -euo pipefail
export TERM=xterm

bash <(curl -s https://raw.githubusercontent.com/joshkor1982/cka-study-tool/main/install-k8s-master.sh)

JOIN_COMMAND='$('( kubeadm token create --print-join-command )' > /tmp/join_command)'
RESET_WORKER="bash <(curl -s https://raw.githubusercontent.com/joshkor1982/cka-study-tool/main/install-k8s-worker.sh)"

read -p "Enter Worker One Username: " worker_one_username
read -p "Enter Worker One Hostname: " worker_one_hostname
read -sp "Enter Worker One Password: " worker_one_password
clear

ssh ${worker_one_username}@${worker_one_hostname} "echo ${worker_one_password} | ${RESET_WORKER}"
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
pass='ZAQ!zaq1XSW@xsw2'
ssh j2186579@192.168.249.128 << 'EOF'
export JOIN_COMMAND="$(kubeadm token create --print-join-command)"
echo $JOIN_COMMAND='$JOIN_COMMAND'
EOF

'( cat /etc/passwd )' > /tmp/passwd