#!/bin/bash

sed -i -e "s/MACHINE/$HOSTNAME/g" ~/sae-b/scripts/odoo/config/odoo/docker-compose.yml

scp -r ~/sae-b/[!.]* dattier.iutinfo.fr:~/sae-b &> /dev/null

sed -i -e "s/$HOSTNAME/MACHINE/g" ~/sae-b/scripts/odoo/config/odoo/docker-compose.yml

echo "Tous les fichiers ont été transférés."