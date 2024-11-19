# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

# VM 1
  config.vm.box = "ubuntu/focal64"
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  config.vm.define "vm1" do |virtual|
    
    virtual.vm.network "private_network", ip: "192.168.56.2"
    virtual.vm.network "forwarded_port", guest: 80, host: 8081, host_ip: "192.168.56.2"
    
    
    #configuração nfs
    #virtual.vm.synced_folder ".", "/trabalho-final-adm-redes", type: "nfs", mount_options: ['nolock','udp']
    virtual.vm.synced_folder "shared_folder/www", "/www" 
    
    #virtual.vm.synced_folder "./shared_folder/", "/shared_folder"

    virtual.vm.provision "shell", path: "./config_archives/dhcpd_conf.sh"
    virtual.vm.provision "shell", path: "./config_archives/ftp_conf.sh"
    virtual.vm.provision "shell", path: "./config_archives/nfs_conf.sh"
    virtual.vm.provision "shell", path: "./config_archives/dns_resolver.sh"
    virtual.vm.provision "shell", path: "./config_archives/apache.sh"

    virtual.vm.hostname = "VirtualMachine"
  end
  #VM Teste
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end
  config.vm.define "vmTeste" do |virtual|
    virtual.vm.network "private_network", type: "dhcp"
    virtual.vm.hostname = "MaquinaTeste"
  end
end