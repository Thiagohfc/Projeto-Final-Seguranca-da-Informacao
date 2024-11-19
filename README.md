# Projeto-Final-Seguran-a-da-Informacao

Este projeto configura um ambiente de laboratório de administração de redes com 3 máquinas virtuais usando Vagrant.


# Estrutura do Projeto
- shared_folder
- vagrantfile
- provisioners/
	- vm1_provision.sh
	- vm2_provision.sh
- README.md

## Pré-requisitos

- Vagrant
- VirtualBox

## Instruções de Uso

1. Clone o repositório do Github.
2. Acesse-o pelo terminal e execute o comando "vagrant up" para iniciar a criação das VMs.
3. Verifique os status de cada VM com o comando "vagrant status" e veja se estão criadas ou não.
4. Após verificar os status de cada VM, digite "vagrant ssh" junto com o nome da VM (VM1, VM2 OU VM3) para iniciar o shell de cada uma.
5. Por fim, desligue as VMs digitando "vagrant halt", e caso queira apaga-las, digite "vagrant destroy".

## Configuração de Rede

1. VM1
	- IP Privado Estático (192.168.56.10)
	- DNS
		- 8.8.8.8
		- 8.8.4.4
	-  Atribuição do IP privado estático (192.168.56.9) como Gateway padrão da rede.
2. VM3
	- IP Privado Estático (192.168.56.9)
	- IP Público DHCP - bridge com a interface de rede externa.
	- IP privado estático adicionado a mesma interface de rede do IP público DHCP.
	-  DNS
		- 8.8.8.8
		- 8.8.4.4
	- Liberação de portas para tráfego de pacotes entre as redes.
	- NAT da interface de rede externa mascarado na interface de rede interna.
	- Atribuição do IP privado estático (192.168.56.9) como Gateway padrão da rede.

## Provisionamento

Os scripts de provisionamento de cada VM está localizado no diretório "Providers". Cada script executa as configurações e a instalação dos serviços necessários para cada VM funcionar conforme sua função.
1. VM1 - Servidor Web
	- Instalação do apache.
2. VM2 - Gateway
	- Configura-o como Gateway padrão da rede.

## Acesso à Internet

Por meio da conexão à internet recebida por bridge ao DHCP da VM3, a interface de rede interna da VM3 recebe essa conexão e atribui ela ao seu IP privado estático, que por sua vez está na mesma faixa dos IPs das VMs 1 e 2, cada uma dessas VMs estão configuradas com IP da VM3 atuando como Gateway padrão da rede, assim as VMs 1 e 2 dependem da VM3 para terem acesso à internet.

```mermaid
sequenceDiagram
Interface Externa ->> VM3 (DHCP): Envia conexão
VM3 (DHCP) ->> VM3 (IP Privado): Estabelece conexão
VM3 (IP Privado) ->> VM1 (IP Privado): Envia acesso à internet
VM3 (IP Privado)->> VM2 (IP Privado): Envia acesso à internet
VM1 (IP Privado)-->> VM2 (IP Privado): Se comunica por IP
VM1 (IP Privado)-->> VM3 (IP Privado): Se comunica por IP
VM2 (IP Privado)-->> VM1 (IP Privado): Se comunica por IP
VM2 (IP Privado)-->> VM3 (IP Privado): Se comunica por IP
VM3 (IP Privado)-->> VM1 (IP Privado): Se comunica por IP
VM3 (IP Privado)-->> VM2 (IP Privado): Se comunica por IP
