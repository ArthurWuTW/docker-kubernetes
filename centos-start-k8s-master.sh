# enable network for CentOS in Virtual Machine
sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-enp0s3 && /etc/init.d/network restart

# network setting
yum update -y && yum install -y net-tools git vim openssh-server

# set hostname
hostnamectl set-hostname k8smaster

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

# pull kubeadm images
kubeadm config images pull

# init kubeadm
kubeadm init --apiserver-advertise-address=172.20.10.6 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.26.0 --service-cidr=10.96.0.0/12 --pod-network-cidr=10.244.0.0/16

# start kubelet service after kubeadm
service kubelet start

# export KUBECONFIG
export KUBECONFIG=/etc/kubernetes/admin.conf

echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> ~/.bashrc 

# Check kube command, localhost connection refuesed error disappear
kubectl get pods

# check all kube-systems
kubectl get pods -n kube-system


# after slave joined 
# check kubectl get nodes -> NotReady
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# [root@localhost ~]# kubectl get pods -n kube-system
# NAME                                            READY   STATUS    RESTARTS      AGE
# coredns-5bbd96d687-nf4hd                        1/1     Running   0             58m
# coredns-5bbd96d687-zk85w                        1/1     Running   0             58m
# etcd-localhost.localdomain                      1/1     Running   0             58m
# kube-apiserver-localhost.localdomain            1/1     Running   0             58m
# kube-controller-manager-localhost.localdomain   1/1     Running   6 (12m ago)   58m
# kube-proxy-6njt9                                1/1     Running   0             11m
# kube-proxy-n5pkf                                1/1     Running   0             58m
# kube-scheduler-localhost.localdomain            1/1     Running   6 (12m ago)   58m
# [root@localhost ~]# kubectl get nodes
# NAME                    STATUS   ROLES           AGE   VERSION
# k8s-slave1              Ready    <none>          11m   v1.26.0
# localhost.localdomain   Ready    control-plane   58m   v1.26.0
