#!/bin/bash

# Habilitar IP Forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Configurar NAT para compartilhar conexão com a Internet
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

# Buscar atualizações no sistema
sudo apt-get update

# Instalar o net-tools
sudo apt-get install net-tools

# Criar um ip na interface de rede privada
sudo ifconfig enp0s8 192.168.56.9 netmask 255.255.255.0 up

# Definir o DNS nas linhas do arquivo /reolv.conf
sudo echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf

# Salvar as DNS no arquivo
sudo sysctl -p
