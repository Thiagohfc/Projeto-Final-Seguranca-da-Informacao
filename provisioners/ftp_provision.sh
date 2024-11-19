#!/bin/bash

set -e

apt update
apt install -y docker.io
docker pull bogem/ftp

sudo docker run -d -v /vagrantFTP:/home/vsftpd \
	-p 20:20 -p 21:21 -p 47400-47470:47400-47470 \
	-e FTP_USER=teste \
	-e FTP_PASS=teste123 \
	-e PASV_ADDRESS=172.17.0.1 \
	--name ftp \
	--restart=always bogem/ftp