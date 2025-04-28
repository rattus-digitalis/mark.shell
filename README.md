# mark.sh

Script de correction automatique pour petits projets C (exemple : calculateur de factorielle).

## Fonctionnement

- Utilise le dossier `projet/` s’il existe.
- Sinon, décompresse un fichier `.zip` fourni en argument pour corriger le projet.

Le script vérifie la présence des fichiers suivants :
- `header.h`
- `main.c`
- `Makefile`
- `readme.txt`

Il effectue plusieurs vérifications :
- **Compilation**
- **Exécution de tests fonctionnels**
- **Vérification du style du code**
- **Application de bonus et de malus**

À la fin de la correction, il génère :
- Un fichier **CSV** contenant la note.
- Optionnellement, un **rapport de correction** au format **Markdown** (confirmation via Y/N).

## Utilisation

```bash
./mark.sh
```

Optionnellement, passer un fichier `.zip` contenant le projet en argument :

```bash
./mark.sh projet.zip
```

## Fonctionnalités

- **Vérification de sécurité**  
  Détection des commandes interdites dans le `Makefile`.
  
- **Compilation**  
  Vérifie que le projet compile correctement avec `make`.
  
- **Tests fonctionnels**  
  Vérifie que le programme fonctionne comme attendu.
  
- **Vérification du style**
  - Détection des lignes de plus de 80 caractères
  - Vérification de l'indentation
  - Vérification du nettoyage : s'assure que `make clean` supprime bien l'exécutable.

- **Extraction des informations**
  - Extraction du nom et prénom depuis `readme.txt`.

- **Calcul de la note finale**
  - Basé sur les tests réussis et les erreurs constatées.

## Rapport de correction

À la fin de la correction, il est proposé de générer un rapport de correction au format **Markdown**.  
La confirmation se fait simplement via une question **Y/N**.
