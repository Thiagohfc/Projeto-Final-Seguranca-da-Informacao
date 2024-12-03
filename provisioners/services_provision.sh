#!/bin/bash

echo "Desabilitando serviços desnecessários para um servidor web..."

# Função para desabilitar e parar um serviço com validação
disable_service() {
    local service=$1

    # Parar o serviço
    echo "Parando o serviço $service..."
    if sudo systemctl stop "$service"; then
        echo "$service parado com sucesso."
    else
        echo "Erro ao parar $service. Verifique o nome do serviço ou sua configuração."
    fi

    # Desabilitar o serviço
    echo "Desabilitando o serviço $service..."
    if sudo systemctl disable "$service"; then
        echo "$service desabilitado com sucesso."
    else
        echo "Erro ao desabilitar $service. Verifique o nome do serviço ou sua configuração."
    fi

    echo "------------------------------------"
}

# Lista de serviços a desabilitar
services=(
    "atd"
    "irqbalance"
    "ModemManager"
    "multipathd"
    "snapd"
    "serial-getty@ttyS0"
    "getty@tty1"
)

# Iterar sobre a lista e desabilitar os serviços
for service in "${services[@]}"; do
    disable_service "$service"
done

echo "Todos os serviços especificados foram processados."
