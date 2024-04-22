#!/bin/bash

if [[ $# != 2 ]]
then   
    echo -e "Erreur : Paramètre manquant"
    echo "Utilisation : ./restore_backup.sh IP_SERVEUR_SAUVEGARDE DATE_BACKUP"
    exit 1
fi

if ! ping -c 1 $1 &> /dev/null
then
    echo "Adresse IP invalide ou inutilisée : $1"
    echo "Exemple d'adresse IP valide : 10.42.191.1"
    exit 2
fi

echo user | sudo rsync -avz user@$1:/home/user/$2 /tmp

echo user | sudo -i -u postgres psql -c "\i /tmp/$2/backup"