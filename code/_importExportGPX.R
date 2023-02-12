#!/usr/bin/env Rscript --vanilla

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

# df des détails
details <- iti_etape$Details %>% rename(etape = Etape)

################################################################################

# Import des GPX

path <- here("gpx","input")

# Lire les fichiers GPX correspondant aux parcours du Tour dans le fichier input
gpx_files <- sort(list.files(path = path,
                             pattern = "^Course.*gpx$",
                             full.names = TRUE))

# Import et concaténation des GPX
parcours <- map_dfr(1:length(gpx_files), ~st_read(gpx_files[.x], layer = "tracks")) %>% 
  select(name)

# manque les données Points sans abonnement premium - à suivre
## points <- st_read("d:/Tour2022_1.gpx", layer = couche[1])

# Correction manuelle (pas accès au gpx sur ridewithgps pour l'instant pour correction)
parcours$name <- c("Étape 1 - Rouyn-Noranda", "Étape 2 - Val-d'Or", "Étape 3 - CLMI",
                   "Étape 4 - Malartic", "Étape 5 - Senneterre",  "Étape 6 - Boucle Preissac",
                    "Étape 7 - La Sarre")

# Sortir le numéro de l'étape à partir du nom
parcours <- parcours %>% 
  mutate(etape = str_replace(name, "Étape (\\d).*", "\\1") %>% as.double()) %>% 
  left_join(y=details, by = "etape") %>% 
  select(etape, name, Jour, Date, time_depart, time_arrivee, Descr_km, KM_Total, KM_Neutres, 
          Nb_tours, KM_par_tours) %>% 
  rename_all(tolower) %>% 
  rename (h_dep = time_depart,
          h_arr = time_arrivee)


# Correction CRS
parcours <- st_transform(parcours, crs = 32198)


# Sauvegarde
sauvegarde_requise <- function(){
  st_write(parcours,
         here("gpx/output/parcours.shp"),
         append=FALSE) # pour écrire par dessus
  
  print("Sauvegarde de `parcours.shp` faite!")
}

################################################################################

# Vérifier si les fichiers ont changés avant de faire la sauvegarde
# car création de longues opérations dans le Snakefile
# (création .tif, .csv aux prochaines étapes)

## Vérifier si le parcours.shp existe

parcours_en_memoire = NULL # assignation initiale

if (file.exists(here("gpx","output","parcours.shp"))) { parcours_en_memoire = st_read(here("gpx/output/parcours.shp"))}     

## Vérifier si les 2 parcours sont exactement les mêmes.
meme_parcours <- all(parcours == parcours_en_memoire)

a_sauvegarder <- ifelse(!is.na(meme_parcours) & meme_parcours, FALSE, TRUE)

## Sauvegarder seulement si a changé
ifelse(a_sauvegarder,  sauvegarde_requise(),
       "Pas besoin d'écrire `parcours.shp` à nouveau : aucun changmenet")
       
