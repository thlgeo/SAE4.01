#!/bin/bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Paramètres manquants."
    echo "Utilisation : ./init_vm.sh IP_SERVEUR_POSTGRES IP_SERVEUR_ODOO IP_SERVEUR_SAUVEGARDE"
    exit 1
fi

start_vm() {
    vm_type=$1
    ip=
    echo "Démarrage de la machine virtuelle $vm_type..."
    vmiut make $vm_type
    vmiut start $vm_type
    echo "Machine $vm_type démarrée."

    while [[ -z "$ip" ]]; do
        echo -ne "Recherche de l'adresse IP pour $vm_type...\033[0K\r"
        ip=$(vmiut info $vm_type | grep ip-possible | cut -d '=' -f 2)
        sleep 1.5
    done

    echo "Adresse IP attribuée pour $vm_type : $ip"

    if [[ ! -f ~/.ssh/id_rsa ]]; then
        echo "Génération de la clé SSH..."
        ssh-keygen -f ~/.ssh/id_rsa -N ""
    fi

    echo "Copie de la clé SSH vers la machine virtuelle $vm_type..."
    ssh-copy-id -i ~/.ssh/id_rsa user@$ip

    echo "Copie des fichiers vers la machine virtuelle $vm_type..."
    scp config_reseau.sh user@$ip:~/
    scp -r $vm_type/* user@$ip:~/

    echo "Configuration du réseau sur la machine virtuelle $vm_type..."
    echo "Connexion en tant que root..."
    configure_network $ip $2
    echo "Redémarrage..."
    sleep 15
}

configure_network() {
    echo "Configuration du réseau sur la machine virtuelle $vm_type..."
    echo "Connexion en tant que root..."
    #while ! ssh -F /dev/null -l user -o BatchMode=yes -o ConnectTimeout=10 $1 true &>/dev/null
    #do
#	echo "Tentive de connexion..."
    #done
    ssh -o ConnectTimeout=15 user@$1 "echo root | su root -c \"./config_reseau.sh $2\""
    echo "Réseau configuré pour $vm_type."
}

if ! vmiut info odoo &> /dev/null
then
    
    if ping -c 1 $2 &> /dev/null || [ $? -ne 1 ]
    then
        echo "Adresse IP invalide ou déjà utilisée : $2"
        echo "Exemple d'adresse IP valide : 10.42.191.1"
        exit 2
    fi

	start_vm "odoo" $2

	echo "Installation d'Odoo sur $2..."
	echo "Connexion en tant que user..."
	ssh -o ConnectTimeout=15 user@$2 "source docker_install.sh $1"
else
    echo -e "Machine odoo déjà créée\n"
fi

if ! vmiut info sauvegarde &> /dev/null
then

    if ping -c 1 $3 &> /dev/null || [ $? -ne 1 ]
    then
        echo "Adresse IP invalide ou déjà utilisée : $3"
        echo "Exemple d'adresse IP valide : 10.42.191.1"
        exit 2
    fi

	start_vm "sauvegarde" $3

	echo "Installation des outils de sauvegarde sur $3..."
	ssh -o ConnectTimeout=15 user@$3 "echo user | sudo -S apt update && echo user | sudo -S apt install rsync"
	echo "Machine sauvegarde configurée."
else
    echo -e "Machine sauvegarde déjà créée\n"
fi

if ! vmiut info postgres &> /dev/null
then

    if ping -c 1 $1 &> /dev/null || [ $? -ne 1 ]
    then
        echo "Adresse IP invalide ou déjà utilisée : $1"
        echo "Exemple d'adresse IP valide : 10.42.191.1"
        exit 2
    fi

    start_vm "postgres" $1

    echo "Installation de PostgreSQL sur $1..."
    echo "Connexion en tant que user..."
    ssh -o ConnectTimeout=15 user@$1 "echo user | sudo -S ./postgresInstall.sh $2 $3"
else
    echo -e "Machine postgres déjà créée\n"
fi

echo "Toutes les machines virtuelles sont configurées et prêtes."

if ! ping -c 1 "$2" &> /dev/null; then
        echo "**ERREUR : La VM Odoo n'est pas accessible. Veuillez vérifier la connectivité réseau.**"
        exit 1
fi
