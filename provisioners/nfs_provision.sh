#!/bin/bash

apt update
apt install -y nfs-kernel-server
sudo apt install -y docker.io
docker pull thiagofelix/nfs_ubuntu

sudo docker run -d --restart always -e SYNC=true --name nfs -p 8049:2049 --privileged -v /var/www/html:/ -e SHARED_DIRECTORY=/ thiagofelix/nfs_ubuntu


