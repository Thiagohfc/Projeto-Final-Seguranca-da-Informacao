#!/bin/bash

# Definindo gateway padrão para o ip da VM3
sudo ip route del default
sudo ip route add default via 192.168.56.9 dev enp0s8

# Atualizando e instalando funcionalidade
apt-get update
apt-get install -y mysql-server
apt-get install net-tools

# Definindo IP privado para a interface enp0s8
sudo ifconfig enp0s8 192.168.56.11 netmask 255.255.255.0 up

# Atribuindo servidor DNS a rede
sudo echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf

# Definindo bind-address como 0.0.0.0 para permitir acesso remoto
echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

# Acessando e criando um novo usuário no mysql
sudo mysql -e "CREATE USER 'vm'@'%' IDENTIFIED BY '1234';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'vms'@'%' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"
