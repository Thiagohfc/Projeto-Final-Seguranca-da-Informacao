# Projeto-Final-Seguranca-da-Informacao

Este projeto configura um servidor WEB "seguro" que tem como base os principais pilares da segurança da informação, aderindo de práticas de hardening para amenizar os riscos que podem vir a acontecer durante o seu uso.

# Estrutura do Projeto

- DockerDHCP
- DockerWeb
- provisioners/
 	- docker_provision.sh
	- firewall_provision.sh
	- hardening_provision.sh
	- services_provision.sh
	- ssh_provision.sh
	- web_provision.sh
- README.md
- vagrantfile

## Pré-requisitos

- Vagrant
- VirtualBox

## Instruções de Uso

1. Clone o repositório do GitHub:
   ```bash
   git clone <url-do-repositorio>
   cd Projeto-Final-Seguranca-da-Informacao
   ```
2. Inicie o provisionamento do servidor:
   ```bash
   vagrant up
   ```
3. Verifique o status do servidor:
   ```bash
   vagrant status
   ```
4. Conecte-se ao servidor via SSH ou acesse pelo VirtualBox:
   ```bash
   vagrant ssh web_server
   ```
5. Para desligar o servidor, execute:
   ```bash
   vagrant halt
   ```
6. Caso precise apagar o ambiente virtual:
   ```bash
   vagrant destroy
   ```

# Planejamento de Hardware

## Especificações Gerais

- **Processador (CPU): Dual Intel Xeon Gold 6230R ou AMD EPYC 7282**
- **Memória RAM: 128 GB DDR4**
- **Armazenamento:**
	- SSD 2 TB NVMe
	- HDD 10 TB
	- Placa de Rede: Dual 10 Gigabit Ethernet
	- Fonte de Alimentação: 800W redundante, certificação 80 PLUS Platinum
- **Uso: Hospedagem de múltiplos serviços (site, sistemas acadêmicos, repositórios de arquivos, streaming de aulas), suportando até 2000 acessos simultâneos.**

---

## Instalação e Configuração do Sistema Operacional

### Etapa 1: Escolha do Sistema Operacional

- Ubuntu Server: Fácil de usar, bem documentado, ideal para servidores de pequeno e médio porte.

Certifique-se de ter backup de dados importantes antes de realizar a instalação.
Tenha uma lista de configurações planejadas para evitar retrabalhos.

### Etapa 2: Instalação do Sistema Operacional

- Baixe a ISO oficial do sistema operacional.
- Crie um pendrive bootável usando ferramentas como Rufus ou BalenaEtcher.
- Configuração de Boot
- Acesse a BIOS/UEFI e configure o boot para iniciar pelo pendrive.

**Procedimento de Instalação**

- Escolha "Instalar Ubuntu Server" ou equivalente.
- Configure o idioma e o teclado.
- Particionamento de Disco: Use LVM (Logical Volume Manager) para facilitar expansões futuras.
- Configure o usuário administrador e defina uma senha forte.
- Selecione pacotes básicos, como SSH e servidor web (opcional).

### Etapa 3: Configuração Básica Pós-Instalação

**Atualizações do Sistema**

```bash
sudo apt update && sudo apt upgrade -y  # Para distribuições baseadas em Debian/Ubuntu
```
**Configuração da Rede**

- Edite o arquivo de rede, por exemplo:
  
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
- Exemplo de configuração:
```bash
network:
  ethernets:
    eth0:
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
  version: 2
```
- Aplique as configurações:

```bash
sudo netplan apply
```
**Configuração de Nome de Host**

```bash
sudo hostnamectl set-hostname servidor-instituto
```

### Etapa 4: Configuração de Serviços

**Servidor Web**

- Linux (Apache):

```bash
sudo apt install apache2 -y  # Para Apache
```

- Configure o diretório de hospedagem e permissões:

```bash
sudo mkdir -p /var/www/instituto
sudo chown -R www-data:www-data /var/www/instituto
```
### Etapa 5: Configuração de Segurança

**Firewall**

```bash
sudo iptables -F
sudo iptables -X
```

```bash
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT
```
```bash
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED, -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
```

**Acesso SSH**

- Configure o acesso SSH para maior segurança:
```bash
sudo nano /etc/ssh/sshd_config
```
- Desative o login de root (PermitRootLogin no).
- Altere a porta padrão de 22 para algo como 2222.
- Reinicie o serviço:
```bash
sudo systemctl restart ssh
```

## Configuração do Hardware da Máquina Virtual

### 1. Servidor Web (`web_server`)
- **Box**: `ubuntu/focal64`
- **Hostname**: `web-server`
- **IP da Rede Privada**: `192.168.56.2`
- **Rede**:
  - **Adaptador 1**: NAT
  - **Adaptador 2**: Host-only
- **Encaminhamento de Portas**:
  - Porta 80 (guest) -> Porta 8080 (host) [HTTP]
  - Porta 22 (guest) -> Porta 2223 (host) [SSH Inicial]
  - Porta 2222 (guest) -> Porta 2222 (host) [SSH Final]
- **Hardware**:
  - **Memória**: 4096 MB
  - **CPUs**: 4
  - **Áudio**: Desativado
- **Pastas Sincronizadas**:
  - `./DockerDHCP` -> `/vagrantDHCP`
  - `./DockerWeb` -> `/vagrantWeb`

## Provisionamento Máquina Virtual

Os scripts de provisionamento do servidor está localizado no diretório "Providers". Cada script executa configurações específicas que garantem o funcionamento e a segurança do servidor.

1. Servidor Web
- Criação de usuário e atribuição de permissões.
- Configurações de firewall.
- Configurações de SSH.
- Configurações de Hardening.
- Instalação de serviços essenciais.
- Configuração e execução do servidor Apache via Docker

## Considerações Finais

 - O ambiente foi configurado para simular um servidor WEB real.
 - Todos os serviços foram provisionados automaticamente via scripts, mas podem ser ajustados conforme necessário.
 - Certifique-se de que as portas necessárias estejam liberadas no firewall do host para garantir o funcionamento correto.
