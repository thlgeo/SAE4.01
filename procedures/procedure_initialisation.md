---
title: Procédure de déploiement de toutes les machines virtuelles
author: Théo LENGLART et Ulysse COULIOU
date: 2023-2024
---
<!-- *# SAE-B Déployer et sécuriser des services dans un réseau -->

# Première procédure: Initialisation du projet et configuration de l'environnement et des machines virtuelles.

Avant tout chose, notez qu'il est essentiel de respecter chaque commande précisément écrite dans cette procédure afin de garantir le bon fonctionnement et la bonne exécution de chacun des scripts pour éviter toute erreur.

Pour commencer, on va tout d'abord cloner le projet dans le répertoire personnel (~) de l'uutilisateur.

```$ git clone ``` + https://gitlab.univ-lille.fr/prenom.nom.etu/sae-b.git (En veillant à remplacer par votre propre nom et prénom et changer le "etu").

Ensuite on se déplace dans le répertoire où se trouve les fichiers ici présents.

```$ cd ~/sae-b/scripts```

Dans un terminal, on va exécuter la commande ```$ ./to_dattier.sh``` pour copier le dossier sae-b sur la machine de virtualisation Dattier.

Ensuite il est nécessaire de se connecter à la machine de virtualisation Dattier.

Pour cela, on va exécuter la commande suivante:

```$ ssh dattier.iutinfo.fr```

On doit ensuite entrer sa passphrase pour se connecter à la machine de virtualisation Dattier.

```$ Enter your passphrase: "passphrase"``` (En veillant à remplacer "passphrase" par votre propre passphrase).

Ensuite, on va exécuter ensuite le script permettant de mettre en place les trois machines virtuelles nécessaires pour ce projet (Postgres, Odoo et Sauvegarde). Il faut préciser dans la ligne de commande trois arguments: l'adresse IP de la machine virtuelle Postgres, l'adresse IP de la machine virtuelle Odoo et l'adresse IP de la machine virtuelle Sauvegarde. Pour cela, vous devez prendre les adresses IP dans la plage d'adressage qui vous a été indiqué.
```bash
./sae-b/scripts/init_vm.sh IP_SERVEUR_POSTGRES IP_SERVEUR_ODOO IP_SERVEUR_SAUVEGARDE
``` 

Comme ces machines sont nouvelles et donc inconnues à votre machine, dans l'exécution du script la phrase "Are you sure you want to continue connecting (yes/no/[fingerprint])?" va apparaître. Il faut alors répondre "yes" pour continuer.

Puis, il apparaîtra le message suivant: "user@IP password:". Il faudra alors répondre avec le mot de passe "user" de l'utilisateur de la machine virtuelle.

PS: Ces messages apparaîtront trois fois dans l'exécution de script (une fois par machine virtuelle).

## Ce que fais concrètement ce script:

1. **Vérification des paramètres :**  
   Vérifie si le nombre d'arguments passés au script est égal à 3. Si ce n'est pas le cas, affiche un message d'erreur avec l'utilisation correcte du script et quitte.

2. **Définition de la fonction `start_vm` :**  
   Cette fonction démarre une machine virtuelle en fonction du type spécifié. Elle attend ensuite que l'adresse IP soit attribuée à cette machine virtuelle. Une fois l'adresse IP obtenue, elle génère une clé SSH si elle n'existe pas déjà, copie cette clé sur la machine virtuelle, copie certains fichiers nécessaires sur la machine virtuelle, puis configure le réseau sur la machine virtuelle en appelant la fonction `configure_network`.

3. **Définition de la fonction `configure_network` :**  
   Cette fonction configure le réseau sur la machine virtuelle en exécutant le script `config_reseau.sh` avec les paramètres nécessaires.

4. **Vérification et démarrage de la machine virtuelle Odoo :**  
   Si la machine virtuelle Odoo n'existe pas, elle est démarrée en utilisant la fonction `start_vm`, puis les outils Docker sont installés.

5. **Vérification et démarrage de la machine virtuelle de sauvegarde :**  
   Si la machine virtuelle de sauvegarde n'existe pas, elle est démarrée en utilisant la fonction `start_vm`, puis les outils de sauvegarde rsync sont installés.

6. **Démarrage de la machine virtuelle PostgreSQL :**  
   La machine virtuelle PostgreSQL est démarrée en utilisant la fonction `start_vm`, puis PostgreSQL est installé.

7. **Vérification de la connectivité avec la VM Odoo :**  
   Vérifie la connectivité avec la VM Odoo en effectuant un ping. Si le ping échoue, affiche un message d'erreur et quitte le script.

8. **Création d'une nouvelle instance d'Odoo**
   Pour cela, référez-vous à la [procédure d'Odoo](procedure_odoo.md#création-dune-nouvelle-instance-odoo) dans la partie _**Création d'une nouvelle instance**_.

De plus, pour chaque création de VM, le script vérifie si les adresses IP passées en paramètre ne sont pas déjà utilisées. Auquel cas, le script s'arrête et affiche une erreur vous alertant que l'adresse que vous voulez utiliser est déjà prise.
Pour accèder à Odoo sur votre machine physique, veuillez vous référer à la [procédure de configuration de ssh](configuration_ssh.md).