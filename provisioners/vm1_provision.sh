#!/bin/bash

# Definindo gateway padrão para o ip da VM3
sudo ip route del default
sudo ip route add default via 192.168.56.9 dev enp0s8

# Atualizando e instalando funcionalidade
apt-get update
apt-get install -y apache2
apt-get install net-tools

# Definindo IP privado para a interface enp0s8
sudo ifconfig enp0s8 192.168.56.10 netmask 255.255.255.0 up

# Atribuindo servidor DNS a rede
sudo echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf
