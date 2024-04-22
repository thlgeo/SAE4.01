---
title: Procédure de déploiement de la machine de sauvegarde
author: Théo LENGLART et Ulysse COULIOU
date: 2023-2024
---

# 1. Création de la machine Sauvegarde

Avant d'exécuter le script d'installation de la machine Sauvegarde, vérifiez que vous vous trouvez bien sur la machine dattier ( accessible via *dattier.iutinfo.fr*).

## Exécution du script d'installation

Pour créer la machine Sauvegarde il suffit d'exécuter la commande suivante :
```bash
./backup_serveur.sh <IP_SERVEUR_SAUVEGARDE >
```

1. Le script vérifiera si l'adresse IP est valide et utilisée. Si l'adresse IP est invalide ou inutilisée, le script affichera un message d'erreur et se terminera.

2. Une fois l'adresse IP attribuée au serveur de sauvegarde, le script générera une paire de clés SSH si elle n'existe pas déjà.

3. Le script copiera la clé publique SSH vers le serveur de sauvegarde en utilisant la commande `ssh-copy-id`.

4. Ensuite, le script copiera le fichier `config_reseau.sh` vers le serveur de sauvegarde.

5. Enfin, le script exécutera la commande `apt update && apt install rsync && ./config_reseau.sh` sur le serveur de sauvegarde pour installer la commande rsync et configurer le réseau.

6. Une fois toutes les étapes terminées, le script affichera le message "Réseau configuré".