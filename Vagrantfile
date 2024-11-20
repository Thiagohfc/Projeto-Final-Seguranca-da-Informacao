# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Configuração Geral de Provedor
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--audio", "none"]
  end

  # Máquina Principal: web_server
  config.vm.define "web_server" do |web|
    web.vm.box = "ubuntu/focal64"
    web.vm.network "private_network", ip: "192.168.56.2"
    web.vm.network "forwarded_port", guest: 80, host: 8080
    web.vm.synced_folder "./shared_folder/www", "/www"
    web.vm.synced_folder "./DockerDHCP", "/vagrantDHCP"
    web.vm.synced_folder "./DockerWeb", "/vagrantWeb"
    
    # Provisionamento com scripts externos e comandos inline
    web.vm.provision "shell", path: "provisioners/dhcp_provision.sh"
    web.vm.provision "shell", path: "provisioners/web_provision.sh"
    
    web.vm.provision "shell", inline: <<-SHELL
      # Atualizações
      sudo apt update && sudo apt upgrade -y
      sudo apt autoremove -y

      # Configuração SSH
      echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
      sudo systemctl restart sshd

      # Firewall
      sudo ufw default deny incoming
      sudo ufw default allow outgoing
      sudo ufw allow 22
      sudo ufw allow 80
      sudo ufw allow 443
      sudo ufw --force enable

      # Hardening: FailBan para proteção contra ataques de força bruta
      sudo apt install fail2ban -y
      sudo systemctl enable fail2ban
      sudo systemctl start fail2ban

      # Docker
      sudo apt install -y docker.io
      sudo systemctl enable docker
      sudo systemctl start docker

      # Instalação do Docker Compose
      sudo curl -L "https://github.com/docker/compose/releases/download/2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose

      # Verificação do Docker
      docker --version
      systemctl status docker
    SHELL
  end

  # Máquina de Teste: vmTeste
  config.vm.define "vmTeste" do |virtual|
    virtual.vm.box = "ubuntu/focal64"
    virtual.vm.network "private_network", type: "dhcp"
    virtual.vm.hostname = "MaquinaTeste"

    # Provisionamento da máquina de teste
    virtual.vm.provision "shell", inline: <<-SHELL
      # Instalar Ferramentas de Teste
      sudo apt update && sudo apt install -y curl wget

      # Firewall para o hardening de servidores
      sudo apt install ufw -y
      sudo ufw default deny incoming
      sudo ufw default allow outgoing
      sudo ufw allow ssh
      sudo ufw allow 80
      sudo ufw enable
    SHELL
  end
end
