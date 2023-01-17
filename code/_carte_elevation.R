# Tour Abitibi

## Préparer cartes et élévations


# -[ ] Vérifier comment calculer le pourcentage de pente pour passer comme couleur à la ligne du graphique d'élévation

source("code/_LibsVars.R")


# Si besoin de mettre à jour à partir de nouveaux .gpx
#   source("code/_carte_elevation.R")



# Lecture du shapefile enregistré contenant les parcours 
parcours <- st_read("gpx/output/parcours.shp")
elv_parcours <- raster("rasterElevation/elv_parcours.tif")



################################################################################
################################################################################


#Distance de la 1ere étape
# set_units(st_length(parcours[1,]), km) ## attention aux tours de circuits qui ne sont pas dans le gpx.. 


# Visualisation
mapview(parcours, lwd = 2,
        color = palette.colors(n=7, palette="ggplot2"),
        layer.name = "Étape")


# EXTRAIRE LES CELLULES D’ÉLÉVATION LE LONG DU PARCOURS

  ## -[ ] En faire une fonction qui sauvegarde le dist_df 
  ## en passant àa travers toutes les étapes

etape <-1
dist_neutre <- 5
dist_total <- 136.7  # incluant le neutralisé
dist_circuit <- 5.4

# Extraire les points d'élévation
topo_elv <- extract(elv_parcours, st_as_sf(parcours[etape,]), along= TRUE, cellnumbers = TRUE)

# Obtenir le profil topo en df
topo_pts <- as.data.frame(xyFromCell(elv_parcours, topo_elv[[1]][, 1])) %>% 
  st_as_sf(coords = c("x", "y"),
           crs = st_crs(parcours))
  
# Obtenir la distance entre les points et la distance cumulée
dist_pts <- st_distance(topo_pts[-1, ], topo_pts[-nrow(topo_pts),],
                        by_element = TRUE)
dist_parcourue <- as.numeric(set_units(cumsum(dist_pts), km))

# besoin de rescaler entre 0 et max de l'étape (avant d'enlever le neutralisé) 
# (erreur induite dans l'extraction à coup de 10m..)
dist_parcourue_corr <- rescale(dist_parcourue, to = c(0, dist_total))

# Transformer en df
dist_df <- data.frame(dist = (dist_parcourue_corr - dist_neutre), elev = topo_elv[[1]][, 2][-1])

## Si circuit ou pas circuit : 
dist_df_final <- if (dist_circuit ==0) { subset(dist_df, dist_df$dist >= (max(dist_df$dist) - 3))
  }else {
    subset(dist_df, dist_df$dist >= (max(dist_df$dist) - dist_circuit))
  }
# dernier tour de circuit


# Sauvegarde des fichiers en .csv

write_csv(dist_df, "elevParcours/elev_parcours1.csv")
write_csv(dist_df_final, "elevParcours/elevFinal_parcours1.csv")

################################################################################

# Partie graphiques

dist_df <-read_csv("elevParcours/elev_parcours1.csv", 
                   show_col_types = FALSE)


# Plot
plot(dist_df, 
     main = "Profil topographique du parcours", 
     xlab = "Distance (en km)", 
     ylab = "Altitude (en mètre)", 
     type = "l", # pour utiliser une ligne
     lwd = 2 # augmente le trait de la ligne 
) 


# Plot derniers 3 km

dist_df_3km <- subset(dist_df, dist_df$dist >= (max(dist_df$dist) - 3))


plot(dist_df_final, 
     main = "Profil topographique du parcours (derniers km)", 
     xlab = "Distance (en km)", 
     ylab = "Élévation (en mètre)", 
     type = "l", # pour utiliser une ligne
     lwd = 2 # augmente le trait de la ligne 
) 




### Avec ggplot

ggplot(dist_df, aes(x= dist, y = elev))+
  geom_line(color=couleurs$bleuTour, lwd=0.8)+
  ggtitle("Profil topographique du parcours")+
  xlab("Distance (km)")+
  ylab("Élévation (m)")+
  theme_ipsum()+
  geom_vline(xintercept = 57.8, col = couleurs$vertMaillot, lwd = 1.5, alpha =0.4)
  #geom_vline(xintercept = 103, col = "red", lwd = 0.75, lty = 2)

                   
               