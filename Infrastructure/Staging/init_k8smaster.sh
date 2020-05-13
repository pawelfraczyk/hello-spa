#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.20.1.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Copy Kube admin config
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo "[TASK 3] Deploy Calico network"
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh

# Install Helm
echo "[TASK 5] Install Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh

# Install Gitlab runner
echo "[TASK 6] Install Gitlab runner"
# Get your URL and Registration Token from GitLab Settings > CI / CD > Runners
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm install --namespace kube-system gitlab gitlab/gitlab-runner --set gitlabUrl=<gitlabURL>,runnerRegistrationToken=<gitlab-token>,rbac.create=true,rbac.clusterWideAccess=true,runners.namespace=spa