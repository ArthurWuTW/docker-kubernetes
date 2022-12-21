# enable network for CentOS in Virtual Machine
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3 # onboot=yes
/etc/init.d/network restart
yum update

# network setting
yum install net-tools git vim
yum install openssh-server

# install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io


swapoff -a
systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet
# need to wait for about 10 mins, you will see kubelet start, before that you always see kubelet not starting by command 'service kubelet status'

# install kubernetes
touch /etc/yum.repos.d/kubernetes.repo
vi /etc/yum.repos.d/kubernetes.repo # paste from file
yum install -y kubelet kubeadm kubectl

# stop firewalld
service firewalld stop

# remove containerd toml file
rm -f /etc/containerd/config.toml
service containerd restart

# pull kubeadm images
kubeadm config images pull


# init kubeadm
kubeadm init --apiserver-advertise-address=172.20.10.6 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.26.0 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16


# export KUBECONFIG
export KUBECONFIG=/etc/kubernetes/admin.conf

# Check kube command, localhost connection refuesed error disappear
kubectl get pods

# check all kube-systems
kubectl get pods -n kube-system
