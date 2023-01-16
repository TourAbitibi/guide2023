

# Test Tour Abitibi

## Préparer cartes et élévations


# -[ ] Vérifier comment calculer le pourcentage de pente pour passer comme couleur à la ligne du graphique d'élévation

library(elevatr)
library(here)
library(mapview)
library(sf)
library(raster)
library(rgdal)
library(units)

library(ggplot2)
library(hrbrthemes)


##############

path <- "gpx/input/"

gpx_files <- list.files(path = path,
                        pattern = "^Tour.*gpx$")

# Import des GPX

couche <- st_layers(paste0(path,gpx_files[1]))$name

parcours1 <- st_read(paste0(path,gpx_files[1]), layer = "tracks")
parcours2 <- st_read(paste0(path,gpx_files[2]), layer = "tracks")
parcours3 <- st_read(paste0(path,gpx_files[3]), layer = "tracks")
parcours4 <- st_read(paste0(path,gpx_files[4]), layer = "tracks")
parcours5 <- st_read(paste0(path,gpx_files[5]), layer = "tracks")
parcours6 <- st_read(paste0(path,gpx_files[6]), layer = "tracks")
parcours7 <- st_read(paste0(path,gpx_files[7]), layer = "tracks")

# manque les données Points sans abonnement premium
# points <- st_read("d:/Tour2022_1.gpx", layer = couche[1])


# Aggrégation de tous les parcours d'étape
parcours <- rbind(parcours1[,1], 
                  parcours2[,1],
                  parcours3[,1],
                  parcours4[,1],
                  parcours5[,1],
                  parcours6[,1],
                  parcours7[,1],
                  deparse.level = 0
                  )

# Correction manuelle (pas accès au gpx sur ridewithgps pour l'instant)
parcours[4,]$name <- "Tour 2022 - Étape 4 - Malartic"

# Distance de la 1ere étape
set_units(st_length(parcours[1,]), km) ## attention aux tours de circuits qui ne sont pas dans le gpx.. 

# Correction CRS
parcours <- st_transform(parcours, crs = 32198)

mapview(parcours, lwd = 2,
        color = palette.colors(n=7, palette="ggplot2"),
        layer.name = "Étape")


# Elevation incluant tous les parcours

elv_parcours <- get_elev_raster(parcours, z=12)

# Correction manuelle - élévation négatives -- à z=13 seulement ?
# elv_parcours[getValues(elv_parcours) < 0] <- 300


# Visualisation
mapview(parcours, lwd =2,
        layer.name = "Étapes",
        color = palette.colors(n=7, palette="ggplot2"))+ #hcl.colors(7, palette = "Spectral"))+ 
mapview(elv_parcours, 
        layer.name = "Elevation",
        col.region = hcl.colors(50, palette = "Earth"))
 


# Vérifier les crs
st_crs(elv_parcours) == st_crs(parcours)


# EXTRAIRE LES CELLULES D’ÉLÉVATION LE LONG DU PARCOURS

  ## En faire une fonction qui retourne le dist_df

etape <-1
dist_neutre <- 10


topo_elv <- extract(elv_parcours, st_as_sf(parcours[etape,]), along= TRUE, cellnumbers = TRUE)

dim(topo_elv[[1]])

colnames(topo_elv[[1]]) <- c("cellule_id", "elevation")
head(topo_elv[[1]])

# Obtenir le profil topo

df_pts <- as.data.frame(xyFromCell(elv_parcours, topo_elv[[1]][, 1]))
head(df_pts)

# transformer en sf
topo_pts <- st_as_sf(df_pts,
                     coords = c("x", "y"),
                     crs = st_crs(parcours) 
)

dist_pts <- st_distance(topo_pts[-1, ], topo_pts[-nrow(topo_pts),],
                        by_element = TRUE)

dist_parcourue <- cumsum(dist_pts)


# Transformer en df



dist_df <- data.frame(dist = as.numeric(dist_parcourue/1000) - dist_neutre, elev = topo_elv[[1]][, 2][-1])


################################################################################

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


plot(dist_df_3km, 
     main = "Profil topographique du parcours (3 derniers km)", 
     xlab = "Distance (en km)", 
     ylab = "Altitude (en mètre)", 
     type = "l", # pour utiliser une ligne
     lwd = 2 # augmente le trait de la ligne 
) 




### Test ggplot



ggplot(dist_df_3km, aes(x= dist, y = elev))+
  geom_line(color="#69b3a2", size=2)+
  ggtitle("Profil topographique du parcours (3 derniers km)")+
  xlab("Distance (km)")+
  ylab("Élévation (m)")+
  theme_ipsum()#+
  #geom_vline(xintercept = 103, col = "red", lwd = 0.75, lty = 2)

                   
               