#!/bin/bash

# Configuração Básica de Hardening
sudo systemctl enable apparmor
sudo systemctl start apparmor
sudo chmod 644 /etc/hosts
sudo chmod 644 /etc/hosts.deny

# Fail2Ban para proteção
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
echo -e "[sshd]\nenabled = true\nmaxretry = 3\nbantime = 3600" | sudo tee -a /etc/fail2ban/jail.local
sudo systemctl restart fail2ban