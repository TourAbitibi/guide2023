#!/bin/usr/env bash

## Appel avec `sh ./script_export_guide.sh` dans le dossier

cd ~/Documents/guide2023/ &&

echo ~~"Création des books"~~ &&

Rscript render_book.R &&

echo ~~"Copie vers le NAS pour affichage web"~~ &&

# -[ ] Si le dossier existe, éléminier le dossier existent, les éliminer avec de copier


# -[ ] Recréation du dossier guide

## Commande pour copier le contenu du book vers NAS.
`cp -R  /Users/brunogauthier/Documents/guide2023/git_book/_book/* /Volumes/web/guide`



# - [ ] Effacer guide2023_files si existe encore dans 'git_book'