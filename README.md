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

# Configuração de Hardware do Ambiente Virtual

## Especificações Gerais

- **Sistema Operacional Base**: Ubuntu 20.04 (focal64)
- **Provedor de Virtualização**: VirtualBox
- **Gerenciador de Ambientes**: Vagrant

---

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

## Provisionamento

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
