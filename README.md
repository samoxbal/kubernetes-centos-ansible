# kubernetes-centos-ansible

Role for deploy Kubernetes cluster in Vagrant.

Use `vagrant up` to deploy 1 master node and 2 worker nodes.

Then generate join token on kube-master:

`kubeadm token create --print-join-command`

Finally, on each worker node execute join command from master.

By default use Calico CNI.
