#!/bin/bash

set -euo pipefail
echo $JOIN_COMMAND
sleep 2 && echo "Executing a step..." &&
sudo -S kubeadm reset -f &&
sleep 2 && echo "Executing a step..." &&
sudo -S rm -rf /etc/cni/net.d/ &&
sleep 2 && echo "Executing a step..." &&
sudo -S rm -f $HOME/.kube/config &&
sleep 2 && echo "Executing a step..." &&
sudo -S rm -rf /etc/kubernetes/ &&
sleep 2 && echo "Executing a step..." &&
sudo -S iptables --flush &&
sleep 2 && echo "Executing a step..." &&
sudo -S cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sleep 2 && echo "Executing a step..." &&
sudo -S swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab &&
sleep 2 && echo "Executing a step..." &&
sudo -S modprobe overlay && sudo modprobe br_netfilter &&
sleep 2 && echo "Executing a step..." &&
sudo -S sleep 2 &&
sleep 2 && echo "Executing a step..." &&
sudo -s cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sleep 2 && echo "Executing a step..." &&
sudo -S sysctl --system &&
sleep 2 && echo "Executing a step..." &&
sudo -S apt-get update && sudo -S apt-get install -y apt-transport-https ca-certificates curl software-properties-common containerd
sleep 2 && echo "Executing a step..."
sudo -S curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -S apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
sleep 2 && echo "Executing a step..."
sudo -S add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sleep 2 && echo "Executing a step..." &&
sudo -S apt-get update && sudo apt-get install -y containerd.io &&
sleep 2 && echo "Executing a step..." &&
sudo -S mkdir -p /etc/containerd &&
sleep 2 && echo "Executing a step..." &&
sudo -S containerd config default | sudo tee /etc/containerd/config.toml &&
sleep 2 && echo "Executing a step..." &&
sudo -S systemctl restart containerd &&
sleep 2 && echo "Executing a step..." && 
sudo -S sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list" &&
sleep 2 && echo "Executing a step..." &&
sudo -S sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -" &&
sleep 2 && echo "Executing a step..." &&
sudo -S apt-get update -y &&
sleep 2 && echo "Executing a step..." &&
sudo -S apt-get install -y kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00 --allow-downgrades &&
sleep 2 && echo "Executing a step..." &&
sudo -S apt-mark hold kubelet kubeadm kubectl &&
sudo -S ${JOIN_COMMAND}
echo "WORKER IS NOW CONFIGURED..." && sleep 4