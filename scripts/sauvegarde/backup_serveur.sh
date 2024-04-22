#!/bin/bash

set -e

if [[ $# -ne 1 ]]
then
    echo "Paramètre manquant"
    echo "Utilisation : ./backup_serveur.sh IP_SERVEUR_SAUVEGARDE"
    exit
fi

if ping -c 1 $1 &> /dev/null || [ $? -ne 1 ]
then
    echo "Adresse IP invalide ou inutilisée : $ip"
    echo "Exemple d'adresse IP valide : 10.42.191.1"
    exit 2
fi

vmiut make sauvegarde
vmiut start sauvegarde

ip=

echo "machine démarré"

while [[ -z "$ip" ]]
do
    echo "cherche ip"
    ip=$(vmiut info sauvegarde | grep ip-possible | cut -d '=' -f 2)
    sleep 3
done

echo "ip attribué"

if [[ -z "$(ls ~/.ssh | grep id_rsa)" ]]
then 
    ssh-keygen -f ~/.ssh/id_rsa -N ""
fi

ssh-copy-id -i ~/.ssh/id_rsa user@$ip

scp ../config_reseau.sh user@$ip:~/

ssh user@$ip "echo root | su root -c \"apt update && apt install rsync && ./config_reseau.sh $1\""
echo "Réseau configuré"