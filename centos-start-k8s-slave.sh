# enable network for CentOS in Virtual Machine
sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-enp0s3 && /etc/init.d/network restart

# network setting
yum update -y && yum install -y net-tools git vim openssh-server

# install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io

# stop firewalld
service firewalld stop

# install kubernetes
touch /etc/yum.repos.d/kubernetes.repo
vi /etc/yum.repos.d/kubernetes.repo # paste from file
yum install -y kubelet kubeadm kubectl

# kubelet will be dead if not doing this
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab
systemctl daemon-reload
systemctl restart docker

# No need to start kubelet before kubeadm
#systemctl restart kubelet
# need to wait for about 10 mins, you will see kubelet start, before that you always see kubelet not starting by command 'service kubelet status'
# new update: it auto-restart: running -> dead() -> running
# service run command: /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml 
# before kubeadm, no files found

# remove containerd toml file
rm -f /etc/containerd/config.toml
service containerd restart

# join master after master-kubeadm done
# example
kubeadm join 172.20.10.11:6443 --token jnp4by.b67x5n2i3lyb8b3e \
    --discovery-token-ca-cert-hash sha256:e071cb26d25d8d30eb0c967ef89bdc57fbc138e02051f57837428eb187d64355