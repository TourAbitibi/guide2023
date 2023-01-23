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

source(here("code","_import_itineraire.R"))

details <- iti_etape$Details %>% rename(etape = Etape)

path <- here("gpx","input")

# Lire les fichiers GPX correspondant aux parcours du Tour dans le fichier input
gpx_files <- sort(list.files(path = path,
                             pattern = "^Tour.*gpx$",
                             full.names = TRUE))

names(gpx_files) <- list_parcours

############################

# # Import des GPX
# parcours1 <- st_read(gpx_files[1], layer = "tracks")
# parcours2 <- st_read(gpx_files[2], layer = "tracks")
# parcours3 <- st_read(gpx_files[3], layer = "tracks")
# parcours4 <- st_read(gpx_files[4], layer = "tracks")
# parcours5 <- st_read(gpx_files[5], layer = "tracks")
# parcours6 <- st_read(gpx_files[6], layer = "tracks")
# parcours7 <- st_read(gpx_files[7], layer = "tracks")
# 
# # manque les données Points sans abonnement premium - à suivre
# ## points <- st_read("d:/Tour2022_1.gpx", layer = couche[1])
# 
# # Correction manuelle (pas accès au gpx sur ridewithgps pour l'instant)
# parcours3$name <- "Tour 2022 - Étape 3 - CLMI"
# parcours4$name <- "Tour 2022 - Étape 4 - Malartic"
# 
# # Aggrégation de tous les parcours d'étape
# parcours <- rbind(parcours1[,1], 
#                   parcours2[,1],
#                   parcours3[,1],
#                   parcours4[,1],
#                   parcours5[,1],
#                   parcours6[,1],
#                   parcours7[,1],
#                   deparse.level = 0
# )


###########################

# Nouvelle façon  avec map

# Import et concaténation des GPX
parcours <- map_dfr(1:length(gpx_files), ~st_read(gpx_files[.x], layer = "tracks")) %>% 
  select(name)

# manque les données Points sans abonnement premium - à suivre
## points <- st_read("d:/Tour2022_1.gpx", layer = couche[1])

# Correction manuelle (pas accès au gpx sur ridewithgps pour l'instant pour correction)
parcours$name[3] <- "Tour 2022 - Étape 3 - CLMI"
parcours$name[4] <- "Tour 2022 - Étape 4 - Malartic"


# Sortir le numéro de l'étape à partir du nom
parcours <- parcours %>% 
  mutate(etape = str_replace(name, "^Tour \\d+ .* Étape (\\d).*", "\\1") %>% as.double()) %>% 
  left_join(y=details, by = "etape") %>% 
  select(etape, name, Date, time_depart, time_arrivee, Descr_km, KM_Total, KM_Neutres, 
          Nb_tours, KM_par_tours) %>% 
  rename_all(tolower) %>% 
  rename (heure_dep = time_depart,
          heure_arr = time_arrivee)

# fin nouvelle façon

###########################

# Correction CRS
parcours <- st_transform(parcours, crs = 32198)


# Sauvegarde
st_write(parcours,
         here("gpx/output/parcours.shp"),
         append=FALSE) # pour écrire par dessus
