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
export PATH=$PATH:/usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh

# Install Gitlab runner
echo "[TASK 6] Install Gitlab runner"
# Get your URL and Registration Token from GitLab Settings > CI / CD > Runners and change <gitlabURL> & <gitlab-token>
su - vagrant -c "helm repo add gitlab https://charts.gitlab.io/"
su - vagrant -c "helm repo update"
su - vagrant -c "helm install --namespace kube-system gitlab -f /vagrant/values.yaml gitlab/gitlab-runner"

# Install aws-ecr-credential
echo "[TASK 7] Install aws-ecr-credential"
su - vagrant -c "helm repo add architectminds https://architectminds.github.io/helm-charts/"
# Replace your AWS data & credentials here
su - vagrant -c "helm install aws-ecr-credential architectminds/aws-ecr-credential  \
  --set-string aws.account=<account number>  \
  --set aws.region=<aws region>  \
  --set aws.accessKeyId=<base64>  \
  --set aws.secretAccessKey=<base64>  \
  --set targetNamespace=default"

# Add permissions to gitlab user to dpeloy
echo "[TASK 8] Create clusterrolebinding for gitlab-runner role"
su - vagrant -c "kubectl create clusterrolebinding default-admin-ecr   --clusterrole=cluster-admin   --serviceaccount=default:default   --namespace=aws-ecr-credential-ns"