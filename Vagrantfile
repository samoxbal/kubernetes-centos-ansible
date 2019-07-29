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

    def config_provision_playbook(config, playbook_name, extra_vars)
        ansible_groups = {
            "kube-master" => ["kube-master"],
            "kube-nodes" => ["kube-node-1", "kube-node-2"]
        }
        config.vm.provision playbook_name, type: 'ansible' do |ansible|
            ansible.host_key_checking = false
            ansible.playbook = "#{playbook_name}.yml"
            ansible.groups = ansible_groups
            ansible.extra_vars = extra_vars
        end
    end

    config_provision_playbook(config, "play-k8s", extra_vars = {
        vagrant: true,
        calico_ipv4_pool_cidr: "192.168.0.0/16",
        pod_network_cidr: "192.168.0.0/19",
        apiserver_address: "192.168.50.10"
    })

    config_provision_playbook(config, "play-k8s-nodes", {})

    config_provision_playbook(config, "play-ingress-nginx", {
        vagrant: true,
        nginx_ingress_image: "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.25.0"
    })

    config_provision_playbook(config, "play-k8s-dashboard", {
        vagrant: true,
        kube_dashboard_image: "k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1"
    })
end