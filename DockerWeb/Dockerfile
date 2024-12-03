# Usar a imagem base oficial do Apache
FROM httpd:2.4

# Atualizar pacotes essenciais (sem upgrade para manter a imagem leve)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configuração customizada do Apache
COPY ./conf/my-httpd.conf /usr/local/apache2/conf/httpd.conf

# Adicionar um index.html para teste inicial
COPY ./html/index.html /usr/local/apache2/htdocs/
RUN chmod 644 /usr/local/apache2/htdocs/index.html

# Configurar permissões e criar diretórios necessários
RUN mkdir -p /usr/local/apache2/logs && \
    chown -R www-data:www-data /usr/local/apache2/logs

# Configurar o diretório de trabalho
WORKDIR /usr/local/apache2

# Expor a porta 80
EXPOSE 80

# Comando padrão para iniciar o Apache
CMD ["httpd-foreground"]
