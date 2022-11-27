#!/bin/bash

set -euo pipefail
export TERM=xterm

sudo -S kubeadm reset -f &&
sudo -S rm -rf /etc/cni/net.d/ &&
sudo -S rm -f $HOME/.kube/config &&
sudo -S rm -rf /etc/kubernetes/ &&
sudo -S iptables --flush &&
sudo -S cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo -S swapoff -a && sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab &&
sudo -S modprobe overlay && sudo modprobe br_netfilter &&
sudo -S sleep 2 &&
sudo -s cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo -S sysctl --system &&
sudo -S apt-get update && sudo -S apt-get install -y apt-transport-https ca-certificates curl software-properties-common containerd
sleep 2 && echo "Executing a step..."
sudo -S mkdir -p /etc/apt/keyrings &&
sudo -S curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
sudo -S echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&

sudo -S apt-get update && sudo apt-get install -y containerd.io &&
sudo -S mkdir -p /etc/containerd &&
sudo -S containerd config default | sudo tee /etc/containerd/config.toml &&
sudo -S systemctl restart containerd &&
sudo -S sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list" &&
sudo -S sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -" &&
sudo -S apt-get update -y &&
sudo -S apt-get install -y kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00 --allow-downgrades &&
sudo -S apt-mark hold kubelet kubeadm kubectl &&
source <(kubectl completion bash) &&
sudo -S echo "source <(kubectl completion bash)" >> $HOME/.bashrc &&
sudo -S kubeadm init --kubernetes-version 1.22.1 --cri-socket=/var/run/containerd/containerd.sock --pod-network-cidr 192.168.0.0/16 --control-plane-endpoint 192.168.249.133| tee $HOME/cp.out &&
sudo -S mkdir -p $HOME/.kube &&
sudo -S cp -i /etc/kubernetes/admin.conf $HOME/.kube/config &&
sudo -S chown $(id -u):$(id -g) $HOME/.kube/config &&
sudo -S sleep 15 &&
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml &&
kubectl get pod --all-namespaces &&
kubectl taint node --all node-role.kubernetes.io/master- &&
sleep 2 && echo "Enter password to create the join-command local file..."