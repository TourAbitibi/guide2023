#!/bin/usr/env bash

cd ~/Documents/guide2023/ &&

echo ~~fetch~~ &&
git fetch &&
echo ~~status~~ &&
git status &&
echo "\n~~ faire git pull si requis ~~" &&
open . &&




# open guide2023.Rproj

# Référence : https://learnbyexample.github.io/customizing-pandoc/

# Utilisation

# A appeler à partir du dossier TNx
# Ce dossier contient plusieurs fichier .md tel que
# Q1.md, Q2.md, ...
# Ces fichiers doivent être en ordre alphabétique !

# S1 -> nom du travail noté : ex : TN3


# Merge de tous les fichiers MarkDown - pas besoin, pandoc le fait automatiquement
# mdmerge -o output.md *.md 

# # Transformation en un pdf
# pandoc *.md \
#     -f markdown \
#     --template=/users/brunogauthier/pandoc/template.tex\
#     --listings \
#     -V listings-disable-line-numbers\
#     -F mermaid-filter\
#     --include-in-header ~/pandoc/inline_code.tex \
#     -o ./PDFs/output.pdf 

# # -V listings-disable-line-numbers\   : à ajouter pour enlever les numéros de lignes dans les blocs de codes

# # Efface le fichier markdown temporaire - plus besoin
# # rm output.md 

# # Effece le fichier temporaire pour mermaid, si existe.
# if [ -e mermaid-filter.err ];
# then
#    rm mermaid-filter.err
# fi

# # Change de dossier
# cd PDFs 

# # Effacer le fichier de travail existant pour éviter qu'il ne soit merger
# if [ -e INF1220_"$1"_BrunoGauthier.pdf ];
# then
#    echo "! Le fichier existe deja, nous le remplacons !" &

#    rm INF1220_"$1"_BrunoGauthier.pdf
# fi

# # Merge des PDFs, donc de la page titre et du corps du texte
# python /Users/brunogauthier/Desktop/Prog/PDF_merge/PDFmerge.py 

# # Efface le fichier pdf temporaire
# rm output.pdf


# # Change le nom vers le document à remettre
# mv merged.pdf INF1220_"$1"_BrunoGauthier.pdf

# echo "Document prêt à consulter !" &

# open INF1220_"$1"_BrunoGauthier.pdf