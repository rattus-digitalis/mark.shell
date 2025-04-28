mark.sh
Script de correction automatique pour petits projets C (par exemple : calculateur de factorielle).

Fonctionnement
Utilise le dossier projet/ s’il existe.

Sinon, décompresse un fichier .zip fourni en argument pour corriger le projet.

Vérifie la présence des fichiers suivants :

header.h

main.c

Makefile

readme.txt

Effectue plusieurs vérifications :

Compilation

Exécution de tests fonctionnels

Vérification du style du code

Application de bonus et de malus

À la fin de la correction, le script génère :

Un fichier CSV contenant la note.

Optionnellement, un rapport de correction au format Markdown (confirmation via Y/N).

Utilisation
bash
Copier
Modifier
./mark.sh
Optionnel : passer un fichier .zip contenant le projet en argument :

bash
Copier
Modifier
./mark.sh projet.zip
Fonctionnalités
Vérification de sécurité : détection des commandes interdites dans le Makefile.

Compilation : vérifie que le projet compile correctement avec make.

Tests fonctionnels : vérifie que le programme fonctionne comme attendu.

Vérification du style :

Détection des lignes de plus de 80 caractères

Vérification de l'indentation

Vérification du nettoyage : s'assure que make clean supprime bien l'exécutable.

Extraction du nom et prénom depuis readme.txt.

Calcul de la note finale en fonction des tests réussis et des erreurs constatées.

Rapport de correction
À la fin de la correction, il est proposé de générer un rapport de correction au format Markdown. La confirmation se fait simplement via une question Y/N.

