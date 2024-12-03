# Projeto-Final-Seguranca-da-Informacao

Este projeto configura um servidor WEB "seguro" que tem como base os principais pilares da segurança da informação, aderindo de práticas de hardening para amenizar os riscos que podem vir a acontecer durante o seu uso.

# Estrutura do Projeto

- DockerDHCP
- DockerWeb
- provisioners/
	- dhcp_provision.sh
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

1. Clone o repositório do Github.
2. Acesse o diretório pelo terminal e execute o comando "vagrant up" para iniciar o provisionamento do servidor.
3. Verifique os status do servidor com o comando "vagrant status" e observe se está em execução ou não.
4. Após verificar os status do servidor, digite "vagrant ssh" junto com o nome da VM (web_server) para iniciar o shell ou também poderá acessar a VM pelo Virtualbox.
5. Por fim, desligue o servidor digitando "vagrant halt", e caso queira apaga-la, digite "vagrant destroy".

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

1.Servidor Web
- Criação de usuário e atribuição de permissãoes.
- Configurações de firewall.
- Configurações de SSH.
- Configurações de Hardening.
- Instalaçoes de serviços.
- Construção e execução do servidor de apache via docker.

##Considerações Finais

 - O ambiente foi configurado para simular um servidor de web real.
 - Todos os serviços foram provisionados automaticamente via scripts, mas podem ser ajustados conforme as necessidades.
 - Certifique-se de que as portas necessárias estejam liberadas no firewall do host.
