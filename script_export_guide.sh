#!/bin/usr/env bash

## Appel avec `sh ./script_export_guide.sh` dans le dossier
## à partir du mac de Bruno

cd ~/Documents/guide2023/ &&

echo "~~ Création des books ~~" &&

Rscript render_book.R &&

echo "~~ Copie vers le NAS pour affichage web ~~ \n" &&

# Si le dossier existe, 

if ls /Volumes/web/guide/* 1> /dev/null 2>&1; 
then
  echo "~~ fichiers existants à effacer sur le NAS ~~ \n" &
  rm -rf /Volumes/web/guide/*
fi

## Commande pour copier le contenu du book vers NAS
`cp -R  ~/Documents/guide2023/git_book/_book/* /Volumes/web/guide`

echo "~~ Fin de la copie vers le NAS ~~ \n"

echo "~~ Ménage du dossier temporaire ~~\n"

# Effacer guide2023_files si existe encore dans 'git_book'
if ls ~/Documents/guide2023/git_book/ | grep guide2023_files 1> /dev/null 2>&1;
then
  rm -rf ~/Documents/guide2023/git_book/guide2023_files
fi