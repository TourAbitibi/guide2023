# Dossier : gpx

## input

Fichiers `.gpx` nécessaires à la création des parcours.

Le nom du gpx enregistré doit être : 
- `Tour2022_1.gpx`

Le `name` des étapes vient du nom d'enregistrement sur [Ride with GPS](https://ridewithgps.com). Le format de l'enregirtrement sur le site doit être tel que: 
- `Tour 2022 - Étape 1 - Ville-Ville`

## output

*Shapefiles* `.shp` travaillée et prêts à être utilisés vers sites tel que Google Earth.

Pour importer : `parcours <- st_read("gpx/output/parcours.shp")`
