Master:

2 GB RAM
2 Cores of CPU
Slave/ Node:

1 GB RAM
1 Core of CPU

Pre-Installation Steps On Both Master & Slave (To Install Kubernetes)
$ sudo su
# apt-get update

Turn Off Swap Space
# swapoff -a
# nano /etc/fstab

Update The Hostnames
# nano /etc/hostname

Update The Hosts File With IPs Of Master & Node
# ifconfig
# nano /etc/hosts

Setting Static IP Addresses
Course Curriculum
# nano /etc/network/interfaces

Now enter the following lines in the file.

auto enp0s8
iface enp0s8 inet static
address <IP-Address-Of-VM>

Install OpenSSH-Server
Now we have to install openshh-server. Run the following command:

# sudo apt-get install openssh-server  
Install Docker
Now we have to install Docker because Docker images will be used for managing the containers in the cluster. Run the following commands:

# sudo su
# apt-get update 
# apt-get install -y docker.io
Next we have to install these 3 essential components for setting up Kubernetes environment: kubeadm, kubectl, and kubelet.

Run the following commands before installing the Kubernetes environment.

# apt-get update && apt-get install -y apt-transport-https curl
# curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
# apt-get update

Install kubeadm, Kubelet And Kubectl 
# apt-get install -y kubelet kubeadm kubectl 

Updating Kubernetes Configuration
# nano /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

Environment=”cgroup-driver=systemd/cgroup-driver=cgroupfs”

Steps Only For Kubernetes Master VM (kmaster)
Step 1 We will now start our Kubernetes cluster from the master’s machine. Run the following command:
# kubeadm init --apiserver-advertise-address=<ip-address-of-kmaster-vm> --pod-network-cidr=192.168.0.0/16

Step 2: As mentioned before, run the commands from the above output as a non-root user
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

$ kubectl get pods -o wide --all-namespaces 

Step 3  You will notice from the previous command, that all the pods are running except one: ‘kube-dns’. For resolving this we will install a pod network. To install the CALICO pod network, run the following command:
$ kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml 

Step 4: Next, we will install the dashboard. To install the Dashboard, run the following command:
$ kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

Step 5: Your dashboard is now ready with it’s the pod in the running state.
Step 6: By default dashboard will not be visible on the Master VM. Run the following command in the command line:

$ kubectl proxy

To view the dashboard in the browser, navigate to the following address in the browser of your Master VM: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

Step 7: In this step, we will create the service account for the dashboard and get it’s credentials.
Note: Run all these commands in a new terminal, or your kubectl proxy command will stop. 

Run the following commands:

1. This command will create a service account for dashboard in the default namespace

$ kubectl create serviceaccount dashboard -n default
2. This command will add the cluster binding rules to your dashboard account

$ kubectl create clusterrolebinding dashboard-admin -n default 
  --clusterrole=cluster-admin 
  --serviceaccount=default:dashboard
3. This command will give you the token required for your dashboard login
$ kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
