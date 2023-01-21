# Dossier CODE

Ce dossier contient les différents fichiers de code permettant de préparer les données pour les différents rapports.

## `_LibsVars.R`

Librairies et variables communes à tous les documents `R`. À importer systématiquement.

## \`\_import_itineraire.R\`\`

Importation du fichier Excel `Itineraires.xlsx` contenant les détails généraux du Tour et le détails des parcours.

Détails généraux sont dans l'onglet `Details`.

Chacune des étapes a son parcours détaillé.

## `importExportGPX.R`

Code importe tous les fichiers `.gpx` et les transforme en un seul *shapefile* `.shp`

Première étape à réaliser pour donner *l'extent* des parcours.

Output : le shapefile contenant tous les parcours : "gpx/output/parcours.shp"

## `elv_parcours.R`

Créer le raster avec les données d'élévation et sauvegarder vers `.tif`.

Longue opération manuelle à faire seulement si les parcours sortent de la région habituelle (*extent*).

Output : le raster de la région complète "rasterElevation/elv_parcours.tif"

## `_carte_elevation.R`

Création d'un line plot a partir du relevé d'élévation au long du parcours.

Input : 
- "rasterElevation/elv_parcours.tif" 
- "gpx/output/parcours.shp"

Output : 
- à faire : fichiers CSV qui contiendront les élévations d'étapes (1 fichier, 1 colonne avec num d'étape et filtrer après) 
- à faire : fonctions qui créent le graphique d'élévation totale et le dernier 3 km ou dernier tour, en Fr en En.

*Potentiel de séparer en 2 fichiers* :
- 1 qui importe et crée un CSV, 
- l'autre qui importe le csv et qui se concencentre sur les fonctions
