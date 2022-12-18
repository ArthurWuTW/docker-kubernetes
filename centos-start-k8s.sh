swapoff -a
systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet
# need to wait for about 10 mins, you will see kubelet start, before that you always see kubelet not starting by command 'service kubelet status'

# stop firewalld
service firewalld stop

# init kubeadm
kubeadm init --apiserver-advertise-address=172.20.10.6 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.25.0 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16
