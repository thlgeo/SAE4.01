#!/bin/bash

if [[ $# -ne 3 ]]
then
    echo "Paramètre manquant"
    echo "Utilisation : ./new_user_odoo.sh NOM_CLIENT MOT_DE_PASSE IP_SERVEUR_POSTGRES"
    exit
fi

if ! ping -c 1 $3 &> /dev/null
then
    echo "Adresse IP invalide ou inutilisée : $3"
    echo "Exemple d'adresse IP valide : 10.42.191.1"
    exit 2
fi

NAME=$1
PASSWORD=$2
IPPOSTGRES=$3
HOME="/home/user"

#echo "Choisisez un port pour le docker du nouveau client : "
#read PORT 

#if [[ -n PORT || PORT -ge 0 && PORT -le 1024 ]]
#then
#    if [ nc -z localhost $PORT ]
#    then
#        echo "Port déjà utilisé"
#    fi
#    ./$0
#fi

sshpass -p user ssh -o StrictHostKeyChecking=no user@$IPPOSTGRES "echo user | sudo -S ./create_user_db.sh $1"

mkdir $HOME/odoo/$NAME-compose
mkdir $HOME/odoo/$NAME-compose/config

cp $HOME/config/odoo/docker-compose.yml $HOME/odoo/$NAME-compose/
cp $HOME/config/odoo/odoo.conf $HOME/odoo/$NAME-compose/config/

sed -i -e "s/NAME/$NAME/g" $HOME/odoo/$NAME-compose/docker-compose.yml
sed -i -e "s/PORT/$PORT/g" $HOME/odoo/$NAME-compose/docker-compose.yml
sed -i -e "s/IPPOSTGRES/$IPPOSTGRES/g" $HOME/odoo/$NAME-compose/config/odoo.conf

sed -i -e "s/NAME/$NAME/g" $HOME/odoo/$NAME-compose/config/odoo.conf
sed -i -e "s/PASSWORD/$PASSWORD/g" $HOME/odoo/$NAME-compose/config/odoo.conf

cd ~/odoo/$NAME-compose

echo user | sudo -S docker-compose up -d

cd ~/config/traefik

echo root | su root -c "docker-compose up -d"
