#!/bin/bash

sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo apt install python3-pip -y
sudo pip3 install docker-compose