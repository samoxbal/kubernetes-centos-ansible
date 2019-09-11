# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box="centos/7"

    config.hostmanager.enabled = true
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    config.vm.define "kube-master" do |master|
        master.vm.network "private_network", ip: "192.168.50.10"
        master.vm.hostname = "kube-master"
    end

    (1..2).each do |i|
        config.vm.define "kube-node-#{i}" do |node|
            node.vm.network "private_network", ip: "192.168.50.#{i + 10}"
            node.vm.hostname = "kube-node-#{i}"
        end
    end

    def config_provision_playbook(config, component_name, extra_vars = {})
        ansible_groups = {
            "kube-master" => ["kube-master"],
            "kube-nodes" => ["kube-node-1", "kube-node-2"]
        }
        config.vm.provision component_name, type: 'ansible' do |ansible|
            ansible.host_key_checking = false
            ansible.playbook = "play-#{component_name}.yml"
            ansible.groups = ansible_groups
            ansible.extra_vars = extra_vars
        end
    end

    config_provision_playbook(config, "k8s", extra_vars = {
        vagrant: true,
        kubeadm_user: "vagrant",
        calico_ipv4_pool_cidr: "192.168.0.0/16",
        pod_network_cidr: "192.168.0.0/19",
        apiserver_address: "192.168.50.10",
        calico_cni_image: "calico/cni:v3.8.0",
        calico_pod2deamon_image: "calico/pod2daemon-flexvol:v3.8.0",
        calico_node_image: "calico/node:v3.8.0",
        calico_controller_image: "calico/kube-controllers:v3.8.0"
    })

    config_provision_playbook(config, "k8s-nodes")
    config_provision_playbook(config, "helm")

    config_provision_playbook(config, "istio", {
        kubeadm_user: "vagrant",
        istio_release_path: "https://github.com/istio/istio/releases/download/1.2.2/istio-1.2.2-linux.tar.gz"
    })

    config_provision_playbook(config, "k8s-dashboard", {
        kube_dashboard_image: "k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1"
    })
end