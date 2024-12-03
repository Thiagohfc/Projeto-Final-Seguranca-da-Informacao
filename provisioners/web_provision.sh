#!/bin/bash

# Baixa a imagem oficial do Apache
docker pull httpd

# Inicia o container com o Apache, montando o diretório de conteúdo e configuração
sudo docker build -t meu-apache /vagrantWeb/
sudo docker run -d --net=host --name apache-container meu-apache

# Logs de auditoria
sudo apt install -y auditd
sudo systemctl enable auditd
sudo auditctl -w /vagrantWeb/html -p rwxa
echo "0 2 * * * rsync -av /var/log/audit/ /backup/logs/" | sudo tee -a /etc/crontab

