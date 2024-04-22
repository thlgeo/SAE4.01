---
title: Configuration de SSH
author: Théo LENGLART et Ulysse COULIOU
date: 2023-2024
---

# Configuration du fichier

Pour voir l'instance Odoo sur votre machine physique via internet, il vous suffit de modifier/ajouter le contenu suivant dans le fichier ~/.ssh/config :

```bash
Host virt
	HostName dattier.iutinfo.fr
	User <NOM_UTILISATEUR>
	Port 22
	IdentityFile <CHEMIN_CLE_PUBLIQUE>

Host odoo
	HostName <IP_SERVEUR_ODOO>
	User user
	ProxyJump virt
	ForwardAgent yes
	LocalForward 0.0.0.0:8080 localhost:80
```

# Accès à Odoo

Pour accéder à odoo, il suffit d'ouvir un navigateur internet puis d'entrer l'url permettant d'accéder à Odoo sans oublier le port. Exemple : _**odoo.tilleul01.iutinfo.fr:8080**_.
Bien sûr, le port doit être le même que celui spécifié dans le fichier de config de SSH. Celui qui se trouve après _0.0.0.0_, donc ici ce sera **8080**.