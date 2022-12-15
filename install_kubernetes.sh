sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    net-tools
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list

sudo mv ~/kubernetes.list /etc/apt/sources.list.d

sudo apt update

sudo apt install -y kubelet

sudo apt install -y kubeadm

sudo apt install -y kubectl

sudo apt-get install -y kubernetes-cni

# user: username
sudo usermod -a -G docker user
