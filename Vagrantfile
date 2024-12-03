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
    web.vm.network "forwarded_port", guest: 80, host: 8080
    #web.vm.network "forwarded_port", guest: 2222, host: 2222, id: "ssh"
    #web.ssh.port = 2222
    web.vm.synced_folder "./DockerDHCP", "/vagrantDHCP"
    web.vm.synced_folder "./DockerWeb", "/vagrantWeb"
    #config.ssh.username = "dockeruser"

    # Provisionamento: Instalação e Configuração
    web.vm.provision "shell", inline: <<-SHELL
      # Atualizações do Sistema
      sudo apt update && sudo apt upgrade -y
      sudo apt autoremove -y
    
      # Configurando o fuso horário
      sudo timedatectl set-timezone America/Sao_Paulo
      sudo timedatectl set-ntp true

      # Ferramentas para configurações e testes
      apt install -y net-tools

      # Criando o usuário e configurando permissões
      sudo useradd -m -s /bin/bash dockeruser
      echo "dockeruser ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/dockeruser

      # Configurando sem senha para o usuário
      sudo passwd -d dockeruser

      # Adicionando o usuário ao grupo docker
      sudo usermod -aG docker dockeruser

      # Configurando permissões na pasta de trabalho
      # Garantindo que os diretórios existam antes de alterar permissões
      if [ -d "/vagrantWeb" ]; then
        sudo chown -R dockeruser:dockeruser /vagrantWeb
      fi

      if [ -d "/vagrantDHCP" ]; then
        sudo chown -R dockeruser:dockeruser /vagrantDHCP
      fi

      sudo su dockeruser

    SHELL

    # Provisionamento com scripts externos
    web.vm.provision "shell", path: "provisioners/firewall_provision.sh"
    web.vm.provision "shell", path: "provisioners/docker_provision.sh"
    web.vm.provision "shell", path: "provisioners/ssh_provision.sh"
    web.vm.provision "shell", path: "provisioners/hardening_provision.sh"
    web.vm.provision "shell", path: "provisioners/dhcp_provision.sh"
    web.vm.provision "shell", path: "provisioners/web_provision.sh"
    web.vm.provision "shell", path: "provisioners/services_provision.sh"
  end

  # Máquina de Teste: Ferramenta de Verificação
  config.vm.define "vmTeste" do |virtual|
    virtual.vm.box = "ubuntu/focal64"
    virtual.vm.hostname = "MaquinaTeste"
    virtual.vm.network "private_network", type: "dhcp"

    virtual.vm.provision "shell", inline: <<-SHELL
      # Instalar Ferramentas de Teste
      sudo apt update && sudo apt upgrade -y
      sudo apt autoremove -y
      sudo apt install net-tools -y

      # Testes de Conectividade e Segurança
      curl -I http://192.168.56.2:80
    SHELL
  end
end
