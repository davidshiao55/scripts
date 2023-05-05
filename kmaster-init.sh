#Script should be run as root 
#Disable Firewall
ufw disable
#Disable swap
swapoff -a; sed -i '/swap/d' /etc/fstab
#Update sysctl settings for Kubernetes networking
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
#Install docker engine
{
  apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt update
  apt install -y docker-ce=5:19.03.10~3-0~ubuntu-focal containerd.io
}
#Add Apt repository
{
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
}
#Install Kubernetes components
apt update && apt install -y kubeadm=1.18.5-00 kubelet=1.18.5-00 kubectl=1.18.5-00
#Initialize Kubernetes Cluster
#Update the below command with the ip address of kmaster
kubeadm init --apiserver-advertise-address=$1 --pod-network-cidr=192.168.0.0/16  --ignore-preflight-errors=all
#Deploy Calico network
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
#Cluster join command
kubeadm token create --print-join-command
#run kubectl as normal user
mkdir -p /home/$2/.kube
cp -i /etc/kubernetes/admin.conf /home/$2/.kube/config
chown $(id $2 -u):$(id $2 -g) /home/$2/.kube/config
