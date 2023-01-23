#!/bin/usr/env bash

## Appel avec `sh ./script_export_guide.sh` dans le dossier

cd ~/Documents/guide2023/ &&

echo ~~"Création des books"~~ &&

Rscript render_book.R &&

echo ~~"Copie vers le NAS pour affichage web"~~ &&

## Commande pour copier le contenu du book vers NAS.
`cp -R  /Users/brunogauthier/Documents/guide2023/git_book/_book/* /Volumes/web/guide`
