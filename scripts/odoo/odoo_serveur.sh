#!/bin/bash

set -e

read -p "Entrez l'adresse IP du serveur Odoo : " ip

if [[ $# -ne 1 ]]
then
    echo "Paramètre manquant"
    echo "Utilisation : ./odoo_serveur.sh IP_SERVEUR_ODOO"
    exit
fi

if ping -c 1 $1 &> /dev/null || [ $? -ne 1 ]
then
    echo "Adresse IP invalide ou déjà utilisé : $1"
    echo "Exemple d'adresse IP valide : 10.42.191.1"
    exit 2
fi

vmiut make odoo
vmiut start odoo

ip=

echo "machine démarré"

while [[ -z "$ip" ]]
do
    echo "cherche ip"
    ip=$(vmiut info odoo | grep ip-possible | cut -d '=' -f 2)
    sleep 3
done

echo "ip attribué"

if [[ -z "$(ls ~/.ssh | grep id_rsa)" ]]
then 
    ssh-keygen -f ~/.ssh/id_rsa -N ""
fi

ssh-copy-id -i ~/.ssh/id_rsa user@$ip

scp ../config_reseau.sh user@$ip:~/
scp * user@$ip:~
ssh user@$ip "mkdir config"
scp -r ../../config/odoo user@$ip:~/config/
scp -r ../../config/traefik user@$ip:~/config/

echo "Connexion root"
ssh user@$ip "echo root | su root -c './config_reseau.sh $1'"
echo "Réseau configuré"

echo -e "\nRedémarrage..."

sleep 10

ssh user@$1 " source docker_install.sh"

