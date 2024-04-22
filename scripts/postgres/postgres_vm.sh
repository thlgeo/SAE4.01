#!/bin/bash

set -e

if [[ $# -ne 3 ]]
then
    echo "Paramètres manquants."
    echo "Utilisation : ./postgres_vm.sh IP_SERVEUR_POSTGRES IP_SERVEUR_ODOO IP_SERVEUR_SAUVEGARDE"
    exit
fi

for ip in $*
do
    if [ $ip != $1 ] && ! ping -c 1 $ip &> /dev/null
    then
        echo "Adresse IP invalide ou inutilisée : $ip"
        echo "Exemple d'adresse IP valide : 10.42.191.1"
        exit 2
    elif ping -c 1 $1 &> /dev/null || [ $? -ne 1 ]
    then
        echo "Adresse IP invalide ou déjà utilisé : $ip"
        echo "Exemple d'adresse IP valide : 10.42.191.1"
        exit 2
    fi
done

echo "Démarrage de la machine virtuelle..."
vmiut make postgres
vmiut start postgres

ip=

echo "Machine démarrée."

while [[ -z "$ip" ]]
do
    echo -n "Recherche de l'adresse IP..."
    ip=$(vmiut info postgres | grep ip-possible | cut -d '=' -f 2)
    sleep 0.5
    echo -ne "\b."
    sleep 0.5
done

echo "Adresse IP attribuée : $ip"

if [[ -z "$(ls ~/.ssh | grep id_rsa)" ]]
then 
    echo "Génération de la clé SSH..."
    ssh-keygen -f ~/.ssh/id_rsa -N ""
fi

echo "Copie de la clé SSH vers la machine virtuelle..."
ssh-copy-id -i ~/.ssh/id_rsa user@$ip

echo "Copie des fichiers vers la machine virtuelle..."
scp ../config_reseau.sh user@$ip:~/
scp * user@$ip:~/

echo "Configuration du réseau sur la machine virtuelle..."
echo "Connexion en tant que root..."
ssh user@$ip "echo root | su root -c './config_reseau.sh $1'"
echo "Réseau configuré."

echo "Redémarrage de la machine virtuelle..."
sleep 10
echo "Installation de PostgreSQL..."

echo "Connexion en tant que user..."
ssh user@$1 "echo user | sudo -S ./postgresInstall.sh $2 $3"
