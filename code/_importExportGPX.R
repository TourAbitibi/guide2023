################################################################################
# Importer les fichiers GPX en input
# Sauvegarder vers un shapefile en output
# Opérations manuelle à faire seulement si nouveaux .gpx au dossier
#
# Input :fichiers gpx de chacune des étapes : "gpx/input/Tour20**_*.gpx"
# Output : Shapefile contenant tous les parcours : "gpx/output/parcours.shp" 
#
################################################################################

here::i_am("guide2023.Rproj")

source(here::here("code","/_LibsVars.R"))

path <- here("gpx","input/")

# Lire les fichiers GPX correspondant aux parcours du Tour dans le fichier input
gpx_files <- sort(list.files(path = path,
                             pattern = "^Tour.*gpx$",
                             full.names = TRUE))

names(gpx_files) <- list_parcours


# Import et concaténation des GPX
parcours <- map_dfr(1:length(gpx_files), ~st_read(gpx_files[.x], layer = "tracks")) %>% 
  select("name")

# manque les données Points sans abonnement premium - à suivre
## points <- st_read("d:/Tour2022_1.gpx", layer = couche[1])

# Correction manuelle (pas accès au gpx sur ridewithgps pour l'instant pour correction)
parcours$name[4] <- "Tour 2022 - Étape 4 - Malartic"


# Correction CRS
parcours <- st_transform(parcours, crs = 32198)


# Sauvegarde
st_write(parcours,
         here("gpx/output/parcours.shp"),
         append=FALSE) # pour écrire par dessus
