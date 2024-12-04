#!/bin/bash

# Verificar se as configurações já existem antes de adicionar duplicatas
sudo sed -i '/^Port /d' /etc/ssh/sshd_config
echo "Port 2222" | sudo tee -a /etc/ssh/sshd_config

sudo sed -i '/^PermitRootLogin /d' /etc/ssh/sshd_config
echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config

sudo sed -i '/^DenyUsers /d' /etc/ssh/sshd_config
echo "DenyUsers Web" | sudo tee -a /etc/ssh/sshd_config

#sudo sed -i '/^PubkeyAuthentication /d' /etc/ssh/sshd_config
#echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config

# Reiniciar o serviço SSH para aplicar as mudanças
echo "Reiniciando o serviço SSH..."
sudo systemctl restart sshd

# Confirmar se o serviço foi reiniciado corretamente
if systemctl is-active --quiet sshd; then
    echo "Configurações aplicadas e serviço SSH reiniciado com sucesso."
else
    echo "Erro: O serviço SSH não foi reiniciado corretamente. Verifique o arquivo de configuração."
fi
