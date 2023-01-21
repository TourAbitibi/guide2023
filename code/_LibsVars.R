################################################################################
# Importer les librairies
# Variables fixes communes à tous les fichiers
################################################################################

# Librairies

librarian::shelf(
  bookdown,
  knitr,
  rmarkdown,
  tidyverse,
  ggtext,
  lubridate,
  mapview,
  readxl,
  formattable,
  kableExtra,
  magick,
  webshot,
  hrbrthemes,
  glue,
  raster,
  rgdal,
  elevatr,
  rosm,
  sf,
  mapview,
  units,
  tmap,
  RColorBrewer,
  scales,
  conflicted
)


# Gestion des conflits
conflict_prefer("select", "dplyr")
conflict_prefer("filter", "dplyr")

# remotes::install_github("r-spatial/mapview")

#------------------------------------------------------------------------------#

# Liste des couleurs

couleurs <- list(
                  bleuTour = "#00414F",
                  jauneTour = "#eac11d",
                  brunMaillot = "#8B4513", # à valider
                  orangeMaillot = "#EE9A00", # à valider
                  vertMaillot = "#66CD00", # à valider
                  blueSprintMaire = "darkblue",
                  rougeDanger = "#D7261E"
                )

#------------------------------------------------------------------------------#

# Listes ordonnées

list_parcours <- c("parcours1", "parcours2", "parcours3", "parcours4", "parcours5", "parcours6", "parcours7")
list_parcours <- ordered(list_parcours, levels = list_parcours)

list_etapes <- c("Etape1", "Etape2", "Etape3", "Etape4", "Etape5", "Etape6", "Etape7")
list_etapes <- ordered(list_etapes, levels = list_etapes)
