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

# Instalação e Configuração do Sistema Operacional

### Etapa 1: Escolha do Sistema Operacional

- Ubuntu 20.04.6 LTS (Focal Fossa): Fácil de usar, bem documentado, ideal para servidores de pequeno e médio porte.

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
sudo apt update && sudo apt upgrade -y
```
**Configuração da Rede**

- Edite o arquivo de rede, por exemplo:
  
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
- Exemplo de configuração:
```sh
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
```sh
# Criando o usuário e configurando permissões
sudo useradd -m -s /bin/bash Web # Cria um novo usuário com nome Web que terá um diretório home "-m" e terá um shell padrão /bin/bash "-s".
echo "Web ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/Web # Altera nas configurações de sudo para permitir a entrada sem senha.

# Garantindo que os diretórios existam antes de alterar permissões
if [ -d "/vagrantWeb" ]; then
	sudo chown -R Web:Web /vagrantWeb # Altera o dono do diretório.
fi

sudo su Web # acesso o usuário novo.
```
- Configurações de firewall.
```sh
# Configuração do Firewall
sudo iptables -F # Remove todas as regras atualmente configuradas em todas as cadeias do iptables (INPUT, OUTPUT, FORWARD).
sudo iptables -X # Remove todas as cadeias definidas pelo usuário, garantindo que o firewall esteja limpo antes de configurar novas regras.

# Definir políticas padrão
sudo iptables -P INPUT DROP # Define a política padrão para a cadeia INPUT como DROP, bloqueando qualquer tráfego de entrada que não seja explicitamente permitido.
sudo iptables -P OUTPUT ACCEPT # Define a política padrão para a cadeia OUTPUT como ACCEPT, permitindo todo o tráfego de saída.

# Permissões de tráfego
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # Permite conexões de entrada no protocolo TCP para a porta 80 (usada pelo HTTP).
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT # Permite conexões de entrada no protocolo TCP para a porta 443 (usada pelo HTTPS).
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT # Permite conexões de entrada no protocolo TCP para a porta 22 (usada pelo SSH).
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT # Permite pacotes ICMP do tipo echo-request (ping), necessários para verificar a conectividade com o sistema.
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT # Permite pacotes de entrada que fazem parte de conexões existentes (ESTABLISHED) ou conexões relacionadas (RELATED) a uma já estabelecida.
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT   # Permite pacotes de entrada no protocolo UDP vindos da porta 53, usados para respostas DNS.
sudo iptables -A INPUT -i lo -j ACCEPT # Permite tráfego de entrada na interface lo (loopback), essencial para o funcionamento interno do sistema.
```
- Configurações de SSH.
```sh
# Verificar se as configurações já existem antes de adicionar duplicatas
sudo sed -i '/^Port /d' /etc/ssh/sshd_config # Remove qualquer linha existente no arquivo /etc/ssh/sshd_config que comece com Port para evitar duplicatas ao adicionar a nova configuração.
echo "Port 2222" | sudo tee -a /etc/ssh/sshd_config # Adiciona ou anexa a configuração Port 2222 ao arquivo, alterando a porta padrão do SSH (22) para 2222, como uma prática de segurança para evitar ataques automatizados.

sudo sed -i '/^PermitRootLogin /d' /etc/ssh/sshd_config # Remove qualquer linha existente no arquivo que comece com PermitRootLogin para evitar duplicatas.
echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config # Adiciona ou anexa PermitRootLogin no ao arquivo, desativando logins diretos como root por SSH, melhorando a segurança.

sudo sed -i '/^DenyUsers /d' /etc/ssh/sshd_config # Remove qualquer linha existente que comece com DenyUsers para evitar duplicatas.
echo "DenyUsers Web" | sudo tee -a /etc/ssh/sshd_config # Adiciona ou anexa DenyUsers Web, proibindo o usuário Web de fazer login via SSH.

#sudo sed -i '/^PubkeyAuthentication /d' /etc/ssh/sshd_config # Quando essas linhas estão ativadas, removem duplicatas da configuração PubkeyAuthentication e configurariam o SSH para aceitar apenas autenticação baseada em chave pública, fortalecendo a segurança.
#echo "PubkeyAuthentication yes" | sudo tee -a /etc/ssh/sshd_config 

# Reiniciar o serviço SSH para aplicar as mudanças
sudo systemctl restart sshd # Reinicia o serviço SSH (sshd) para garantir que as novas configurações sejam aplicadas.

# Confirmar se o serviço foi reiniciado corretamente
if systemctl is-active --quiet sshd; then
    echo "Configurações aplicadas e serviço SSH reiniciado com sucesso."
else
    echo "Erro: O serviço SSH não foi reiniciado corretamente. Verifique o arquivo de configuração."
fi
# verifica silenciosamente se o serviço SSH está ativo.
# Se estiver ativo, exibe uma mensagem de sucesso.
# Se não estiver ativo, exibe uma mensagem de erro, alertando o usuário para verificar o arquivo de configuração, possivelmente devido a erros de sintaxe ou conflitos.
```
- Configurações de Hardening.
```sh
# Ativando Apparmor que aplica políticas restritivas para programas em execução, limitando o acesso a recursos do sistema
sudo systemctl enable apparmor # Configura o serviço AppArmor para iniciar automaticamente durante a inicialização do sistema.
sudo systemctl start apparmor # Inicia o serviço AppArmor imediatamente, aplicando as políticas configuradas no sistema.

# Instalando Fail2Ban para monitorar logs do sistema para detectar tentativas de acesso malicioso (como ataques de força bruta) e bloqueia os IPs ofensores.
sudo apt install fail2ban -y # Instala o software Fail2Ban e confirma "yes" para tudo.
sudo systemctl enable fail2ban # Configura o Fail2Ban para ser ativado automaticamente durante a inicialização do sistema.
echo -e "[sshd]\nenabled = true\nmaxretry = 3\nbantime = 3600" | sudo tee -a /etc/fail2ban/jail.local # Cria ou adiciona configurações no arquivo /etc/fail2ban/jail.local, usado para configurar as regras do Fail2Ban.
sudo systemctl restart fail2ban # Reinicia o serviço Fail2Ban para aplicar as novas configurações definidas no arquivo /etc/fail2ban/jail.local.
```
```sh
echo -e "[sshd]\nenabled = true\nmaxretry = 3\nbantime = 3600" | sudo tee -a /etc/fail2ban/jail.local

[sshd]: Define uma seção para proteger o serviço SSH.
enabled = true: Ativa a proteção para o SSH.
maxretry = 3: Permite no máximo 3 tentativas de login falhas antes de aplicar um bloqueio.
bantime = 3600: Define o tempo de bloqueio para IPs infratores como 3600 segundos (1 hora).
```
- Instalação de serviços essenciais.
```sh
# Ferramentas para configurações e testes
apt install -y net-tools # Pacote com ferramentas de rede.
sudo apt install -y docker.io # Docker.io é o pacote usado para instalar o Docker Engine, que é a principal ferramenta do Docker. Ele permite criar, gerenciar e executar contêineres.
sudo systemctl enable docker
sudo systemctl start docker
sudo apt install python3-pip -y
sudo pip3 install docker-compose # Docker-Compose é uma ferramenta complementar ao Docker, usada para orquestrar e gerenciar múltiplos contêineres.
```
- Configuração e execução do servidor Apache via Docker
```sh
# Inicia o container com o Apache, montando o diretório de conteúdo e configuração
sudo docker build -t meu-apache /vagrantWeb/  # Cria uma imagem Docker chamada "meu-apache" usando o Dockerfile no diretório /vagrantWeb/
sudo docker run -d --net=host --name apache-container meu-apache  # Inicia um contêiner chamado "apache-container" baseado na imagem "meu-apache", utilizando a rede do host

# Logs de auditoria
sudo apt install -y auditd  # Instala o pacote auditd para configurar auditorias de arquivos e eventos no sistema
sudo systemctl enable auditd  # Garante que o auditd será iniciado automaticamente no boot do sistema
sudo auditctl -w /vagrantWeb/html -p rwxa  # Configura o auditd para monitorar operações de leitura, escrita, execução e alteração no diretório /vagrantWeb/html
echo "0 2 * * * rsync -av /var/log/audit/ /backup/logs/" | sudo tee -a /etc/crontab  # Configura o cron para copiar os logs de auditoria do diretório /var/log/audit/ para /backup/logs/ diariamente às 2h
```

## Considerações Finais

 - O ambiente foi configurado para simular um servidor WEB real.
 - Todos os serviços foram provisionados automaticamente via scripts, mas podem ser ajustados conforme necessário.
 - Certifique-se de que as portas necessárias estejam liberadas no firewall do host para garantir o funcionamento correto.
