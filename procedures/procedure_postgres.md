---
title: Procédure de déploiement PostgreSQL
author: Théo LENGLART et Ulysse COULIOU
date: 2023-2024
---
<!-- # SAE-B Déployer et sécuriser des services dans un réseau

## Première procédure: Installation et configuration de PostgreSQL

### Groupe 
### - Ulysse Couliou BUT2-J
### - Théo Lenglart BUT2-J -->

# 1. Création de la machine Postgresql

Avant d'exécuter le script d'installation de la machine Postgres, vérifiez que vous vous trouvez bien sur la machine dattier ( accessible via *dattier.iutinfo.fr*) et que les machines **Odoo** et **Sauvegarde** soient déjà créées.

## Exécution du script d'installation

Pour créer la machine Postgres il suffit d'exécuter la commande suivante :
```bash
./postgres_vm.sh <IP_SERVEUR_POSTGRES> <IP_SERVEUR_ODOO> <IP_SERVEUR_SAUVEGARDE>
```

Ce script va créer une machine virtuelle et la démarrer. Ensuite, il va chercher l'adresse IP de la machine toutes les 2 secondes jusqu'à ce qu'il la trouve. Après ça, il va envoyer tous les scripts utiles à la configuration du réseau et de Postgresql.
Lors de cette phase, il vous sera demandé d'accepter la machine Postgres ( écrire *yes* lors de la connexion ssh pour pouvoir envoyer les scripts vers l'autre machine ) puis d'entrer le mot de passe pour se connecter à la machine en tant qu'utilisateur **user** ( il ne vous sera demander qu'une seule fois lors de l'exécution de ce script ).

# 2. Configuration de la machine Postgres

## Configuration réseau et Postgresql

Lors de l'exécution du script, le serveur se verra attribuer l'adresse IP que vous aviez fourni en paramètre puis va redémarrer. Ensuite, il va installer Postgresql avec un utilisateur nommé **admin** ( mot de passe : admin ).

> Il se peut que lors du redémarrage de la machine la connexion soit interrompue. Si cela vous arrive, il vous suffit de vous connecter avec l'utilisateur **user** en ssh à la machine Postgresql, l'adresse IP étant celle que vous avez choisi lors de l'exécution du script. 
> Ensuite, il suffit d'exécuter la commande suivante :
> ```bash
> sudo ./postgresInstall.sh <IP_SERVEUR_ODOO> <IP_SERVEUR_SAUVEGARDE>
> ```

## Configuration de la sauvegarde journalière

Pour finir, le script va déplacer un script nommé *backup.sh* dans le dossier /root pour empêcher l'accès aux autres utilisateur qui n'ont pas les droits admin, puis va ajouter un cron qui va s'exécuter tous les jours à 01:30 ( heure à laquelle il ne devrait y avoir personne de connecté à la base de données ).

> Toutefois, si une erreur se produit et le cron n'est pas créer, veuillez exécuter la commande suivante :
> ```bash
> source config_backup.sh <IP_SERVEUR_SAUVEGARDE>
> ```