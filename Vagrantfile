Vagrant.configure("2") do |config|
  # Configuração do provedor VirtualBox
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4098
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--audio", "none"]
  end

  # Máquina principal: Servidor Web com Docker
  config.vm.define "web_server" do |web|
    web.vm.box = "ubuntu/focal64"
    web.vm.hostname = "web-server"
    web.vm.network "private_network", ip: "192.168.56.2"
    web.vm.network "forwarded_port", guest: 80, host: 8080 # Para web
    #web.vm.network "forwarded_port", guest: 2222, host: 2223
    #web.vm.network "forwarded_port", guest: 2222, host: 2222, id: "ssh"
    #web.ssh.port = 2222
    web.vm.synced_folder "./DockerWeb", "/vagrantWeb"

    # Provisionamento: Instalação e Configuração
    web.vm.provision "shell", inline: <<-SHELL
      # Atualizações do Sistema
      sudo apt update # Busca Atualizações
      sudo apt autoremove -y
    
      # Configurando o fuso horário
      sudo timedatectl set-timezone America/Sao_Paulo
      sudo timedatectl set-ntp true

      # Ferramentas para configurações e testes
      apt install -y net-tools

      # Criando o usuário e configurando permissões
      sudo useradd -m -s /bin/bash Web
      echo "Web ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/Web

      # Configurando permissões na pasta de trabalho
      # Garantindo que os diretórios existam antes de alterar permissões
      if [ -d "/vagrantWeb" ]; then
        sudo chown -R Web:Web /vagrantWeb
      fi

      sudo su Web

    SHELL

    # Provisionamento com scripts externos
    web.vm.provision "shell", path: "provisioners/firewall_provision.sh"
    web.vm.provision "shell", path: "provisioners/docker_provision.sh"
    web.vm.provision "shell", path: "provisioners/ssh_provision.sh"
    web.vm.provision "shell", path: "provisioners/hardening_provision.sh"
    web.vm.provision "shell", path: "provisioners/web_provision.sh"
    web.vm.provision "shell", path: "provisioners/services_provision.sh"

    # Configurar o Vagrant para usar a porta correta após o provisionamento
    #config.ssh.forward_agent = true
    #config.ssh.port = 2223
  end
end
