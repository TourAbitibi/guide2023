#!/bin/usr/env bash

## Script d'ouverture du dossier 
## à partir du mac de Bruno


cd ~/Documents/guide2023/ &&

echo ~~fetch~~ &&
git fetch &&

echo ~~status~~ &&
git status &&

echo "\n~~ faire git pull si requis ~~" &&
open .