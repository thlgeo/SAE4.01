#!/bin/bash

set -e

ip=$1

if ping -c 1 $ip &> /dev/null
then
    echo "Adresse IP $ip valide"
else
        echo -e "Erreur : Paramètre manquant"
        echo "Utilisation : ./backup.sh IP_SERVEUR_SAUVEGARDE"
        exit 1
fi

d=$(date +%F)
for base in $(sudo -i -u postgres psql -c "\l" | grep -E -e "odoo_.*" | cut -d ' ' -f 2)
do
        sudo -i -u postgres pg_dump -U postgres -d $base -f /tmp/backup_$base -Fc
done
rsync -avz --delete-after /tmp/backup_* user@$ip:/home/user/$d/