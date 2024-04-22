#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Paramètres manquants."
    echo "Utilisation : ./docker_install.sh IP_SERVEUR_POSTGRES"
    exit
fi

echo user | sudo -S apt update
sudo apt install docker docker-compose curl -y

ssh-keygen -f ~/.ssh/id_rsa -N ""

ssh-copy-id -i ~/.ssh/id_rsa user@$1

mkdir /home/user/odoo

cd config/traefik

sudo docker network create web

sudo docker-compose up -d
