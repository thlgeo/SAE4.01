---
title: Procédure de déploiement Odoo
author: Théo LENGLART et Ulysse COULIOU
date: 2023-2024
---

# 1. Création de la machine Odoo

Avant d'exécuter le script d'installation de la machine Odoo, vérifiez que vous vous trouvez bien sur la machine dattier ( accessible via *dattier.iutinfo.fr*).

## Exécution du script d'installation

Pour créer la machine Odoo il suffit d'exécuter la commande suivante :
```bash
./odoo_serveur.sh <IP_SERVEUR_ODOO>
```

Ce script va créer une machine virtuelle et la démarrer. Ensuite, il va chercher l'adresse IP de la machine toutes les 2 secondes jusqu'à ce qu'il la trouve. Après ça, il va envoyer tous les scripts utiles à la configuration du réseau, de Odoo et de Traefik.
Lors de cette phase, il vous sera demandé d'accepter la machine Odoo ( écrire *yes* lors de la connexion ssh pour pouvoir envoyer les scripts vers l'autre machine ) puis d'entrer le mot de passe pour se connecter à la machine en tant qu'utilisateur **user**, mot de passe : **user** ( il ne vous sera demander qu'une seule fois lors de l'exécution de ce script ).

# 2. Configuration de la machine Odoo

## Configuration réseau, Odoo et Traefik

Lors de l'exécution du script, le serveur se verra attribuer l'adresse IP que vous aviez fourni en paramètre puis va redémarrer. Ensuite, il va installer Docker.

> Il se peut que lors du redémarrage de la machine la connexion soit interrompue. Si cela vous arrive, il vous suffit de vous connecter avec l'utilisateur **user** en ssh à la machine Odoo, l'adresse IP étant celle que vous avez choisi lors de l'exécution du script. 
> Ensuite, il suffit d'exécuter la commande suivante :
> ```bash
> source docker_install.sh
> ```

## Création d'une nouvelle instance Odoo

Pour créer une nouvelle instance d'odoo, il faut premièrement vous connecter à la machine virtuelle __*odoo*__, puis il suffit d'exécuter la commande suivante :
```bash
./new_user_odoo.sh <NOM_CLIENT> <MOT_DE_PASSE> <IP_SERVEUR_POSTGRES>
```
Cela va créer une nouvelle base de données liée à cette instance avec un nouvel utilisateur qui a comme nom le nom du client odoo que vous voulez installer. 
Après cela, vous pourrez accéder à votre nouvelle instance d'odoo via le lien suivant : _**<nom_client_odoo>.<machine_physique>.iutinfo.fr**_

Pour accèder à l'instance d'odoo via votre machine physique, veuillez vous référer à la [procédure de configuration ssh](configuration_ssh.md)