#!/bin/bash

set -e

#read -p "Nom d'utilisateur pour la base de données : " username
#read -p "Nom de la base de données : " dbname

if [[ $# -ne 2 ]]
then
    echo "Paramètre manquant"
    echo "Utilisation : ./postgresInstall.sh IP_SERVEUR_ODOO IP_SERVEUR_SAUVEGARDE"
    exit
fi

for ip in $*
do
    if ! ping -c 1 $ip &> /dev/null
    then
        echo "Adresse IP invalide ou inutilisée : $ip"
        echo "Exemple d'adresse IP valide : 10.42.191.1"
        exit 2
    fi
done

sudo apt update

sudo apt install postgresql postgresql-contrib rsync -y

systemctl enable postgresql
systemctl start postgresql

echo "Création d'un utilisateur admin..."
sudo -i -u postgres psql -c "create user admin with password 'admin' superuser"
sudo -i -u postgres createdb --encoding=UTF8 --locale=C --template=template0 --owner=admin admin

echo "Installation de postgresql terminée"
echo "configuration de postgresql..."

sudo sed -i -e "/host    all             all             127.0.0.1\/32            scram-sha-256/a host\tall\t\tall\t\t$1\/32\t\ttrust" /etc/postgresql/15/main/pg_hba.conf

# Remplace la ligne #listen_addresses = 'localhost' par listen_addresses = '*' dans le fichier de configuration postgresql.conf de PostgreSQL. Permet à PostgreSQL d'accepter des connexions à distance depuis n'importe quelle adresse IP (*).
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/15/main/postgresql.conf

sudo -i -u postgres psql -c "alter user admin with createdb createrole;"

sudo systemctl restart postgresql

echo "Configuration de Postgresql terminée"

source config_backup.sh $2

#echo "Veuillez procéder à la configuration des backups"
