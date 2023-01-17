#########################################################################################
# Créer le raster avec les données d'élévation et sauvegarder vers .tif                 #
# Opérations manuelle à faire seulement si les parcours sortent de la région habituelle #
#########################################################################################

source("code/_LibsVars.R")

# Shapefile incluant tous les parcours
parcours <- st_read("gpx/output/parcours.shp")

# Télécharger les élévations dans la zone couvrant les tracés
# Attention : long à télécharger
elv_parcours <- get_elev_raster(parcours,
                                z=12, 
                                neg_to_na = TRUE)

# Vérification si élévation négatives = 0
length(elv_parcours[getValues(elv_parcours) < 0]) == 0

# Sauvegarde du raster vers un fichier .tif
# Attention : longue opération
elv_parcours %>% 
  writeRaster("rasterElevation/elv_parcours.tif",
              overwrite=TRUE)

# Lecture du fichier enregistré
elv_parcours <- raster("rasterElevation/elv_parcours.tif")

# Visualisation du profil d'élévation
elev_map <- mapview(elv_parcours, 
        layer.name = "Elevation",
        col.region = hcl.colors(50, palette = "Earth"),
        maxpixels = 1e6)

elev_map@map
