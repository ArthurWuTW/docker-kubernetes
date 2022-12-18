swapoff -a
systemctl daemon-reload
systemctl restart docker
systemctl restart kubelet
# need to wait for about 10 mins, you will see kubelet start, before that you always see kubelet not starting by command 'service kubelet status'


