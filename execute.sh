export password=ds20010114
export ip=192.168.1.117
echo $password | sudo -S apt update
echo $password | sudo -S apt install curl -y
#kmaster
curl -LJO https://raw.githubusercontent.com/davidshiao55/scripts/main/kmaster-init.sh
echo $password | sudo -S bash -x ./kmaster-init.sh $ip

#kworker
curl -LJO https://raw.githubusercontent.com/davidshiao55/scripts/main/kworker-init.sh
echo $password | sudo -S bash -x ./kworker-init.sh
#join command
echo $password | sudo -S kubeadm join 192.168.56.2:6443 --token jekt3q.8o9x967snmsfcsig     --discovery-token-ca-cert-hash sha256:8361c41e3dd2bff72117746189f66b7f9fa95e84e6d4e5cd093cef2d75f54f9c