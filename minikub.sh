How To Install Minikube on Ubuntu 20.04 / 18.04 & Debian
kubernetes
Install VirtualBox:
sudo apt-get install -y virtualbox

Install kubelet:
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/Frelease/v1.5.1/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.9.2/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

minikube start --vm-driver virtualbox

Show minikube cluster IP
minikube ip

kubectl get pods --all-namespaces
kubectl config view
minikube addons list


Stopping a Cluster Minikube
minikube stop
