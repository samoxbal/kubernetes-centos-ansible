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

    config.vm.provision :ansible do |ansible|
        ansible.host_key_checking = false
        ansible.playbook = "play-k8s.yml"
        ansible.inventory_path = "./vagrant"
        ansible.extra_vars = {
            vagrant: true
        }
    end
end