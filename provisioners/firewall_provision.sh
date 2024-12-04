#!/bin/bash

# Configuração do Firewall
sudo iptables -F
sudo iptables -X

# Definir políticas padrão
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT

# Permissões de tráfego
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # HTTP
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT # HTTPS
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT # SSH
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT # Ping
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT   # DNS entrada
sudo iptables -A INPUT -i lo -j ACCEPT              # Loopback
