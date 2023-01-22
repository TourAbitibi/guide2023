#########################################################################################
# Créer le raster avec les données d'élévation et sauvegarder vers .tif                 #
# Opération manuelle à faire seulement si les parcours sortent de la région habituelle  #
#                                                                                       #
# Input : Shapefile contenant les gpx des parcours - "gpx/output/parcours.shp"          #
# Output : le Raster de la région complète "rasterElevation/elv_parcours.tif"           #
#                                                                                       #
#########################################################################################

# Tour Abitibi

## Préparer graphiques dénivelé des parcours


# -[ ] Vérifier comment calculer le pourcentage de pente pour passer comme couleur à la ligne du graphique d'élévation

here::i_am("guide2023.Rproj")

source(here::here("code","/_LibsVars.R"))

source(here("code","_import_itineraire.R"))

# Si besoin de mettre à jour à partir de nouveaux .gpx
#   source(here("code","_importExportGPX.R"))
#   source(here("code","_elv_parcours.R"))



# Lecture du shapefile enregistré contenant les parcours 
parcours <- st_read(here("gpx/output/parcours.shp"))
elv_parcours <- raster(here("rasterElevation/elv_parcours.tif"))

# Lecture des données d'élévations enregistrées
dist_df <-read_csv(here("elevParcours/elev_parcours.csv"), 
                   col_types = list(col_integer(), col_double(), col_integer()),
                   show_col_types = FALSE)

################################################################################
################################################################################

# Essais..

#Distance de la 1ere étape
# set_units(st_length(parcours[1,]), km) ## attention aux tours de circuits qui ne sont pas dans le gpx.. 


# Visualisation
# mapview(parcours, lwd = 2,
#         color = palette.colors(n=7, palette="ggplot2"),
#         layer.name = "Étape")
################################################################################

# Fonctions filtrant les derniers 3 km ou distance de circuit d'arrivée
filtrerDistanceFinale <- function(dist_df, num_etape){
  
  ## Si circuit, faire un df de la longueur du circuit,
  ## Sinon, faire un df des 3 derniers km : 
  
  if (iti_etape$Details$KM_par_tours[num_etape] == 0){km_a_enlever = 3} 
    else {km_a_enlever = iti_etape$Details$KM_par_tours[num_etape]}
  
  df <-  dist_df %>% 
    filter(etape == num_etape) %>% 
    filter(dist >= (max(dist) - km_a_enlever))

  return(df)
  
}

################################################################################

# - [ ] Français et Anglais
# - [ ] Symbole possible sur KOM, Sprint, $, ... 
#   - [ ] Automatiquement avec loop


### Avec ggplot
dist_df %>% 
  filter(etape == 1) %>% 
  # filtrerDistanceFinale(1) %>% 
  ggplot(aes(x= dist, y = elev))+
    geom_line(color=couleurs$bleuTour, linewidth=0.8)+
    ggtitle("Profil topographique du parcours")+
    xlab("Distance (km)")+
    ylab("Élévation (m)")+
    scale_x_continuous(n.breaks = 10)+
    theme_ipsum()
    
  
    #geom_vline(xintercept = 57.8, col = couleurs$vertMaillot, lwd = 1.5, alpha =0.4)
    #geom_vline(xintercept = 103, col = "red", lwd = 0.75, lty = 2)

                   
               