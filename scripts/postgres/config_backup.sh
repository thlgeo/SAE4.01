#!/bin/bash

if [[ $# -ne 1 ]]
then
    echo "Paramètre manquant"
    echo "Utilisation : ./config_backup.sh IP_SERVEUR_SAUVEGARDE"
    exit
fi

if ! ping -c 1 $1 &> /dev/null
then
    echo "Adresse IP invalide ou inutilisée : $1"
    echo "Exemple d'adresse IP valide : 10.42.191.1"
    exit 2
fi

echo "Configuration des backups..."

echo user | sudo ssh-keygen -f ~/.ssh/id_rsa -N ''
sudo echo "$(ssh-keyscan $1 | grep ssh-rsa)" >> /root/.ssh/known_hosts
sudo sshpass -p user ssh-copy-id -i ~/.ssh/id_rsa.pub user@$1

sudo chown root backup.sh

sudo mv backup.sh /root

echo root | su root -c "echo \"30 1 * * * root bash /root/backup.sh $1 2>> ~/erreur_backup.log\" >> /etc/crontab"

echo 'Configuration backup terminé'
