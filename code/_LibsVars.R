################################################################################
# Importer les librairies
# Variables fixes communes à tous les fichiers
################################################################################

# Librairies

librarian::shelf(quiet = TRUE,
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
  conflicted,
  here
)

# Gestion des conflits
conflict_prefer("select", "dplyr", quiet = TRUE)
conflict_prefer("filter", "dplyr", quiet = TRUE)

# remotes::install_github("r-spatial/mapview")

#------------------------------------------------------------------------------#

# Liste des couleurs

couleurs <- list(
                  bleuTour = "#00414F",
                  jauneTour = "#eac11d",
                  brunMaillot = "#8B4513", # à valider
                  orangeMaillot = "#EE9A00", # à valider
                  vertMaillot = "#66CD00", # à valider
                  blueSprintMaire = "#00008B",
                  rougeDanger = "#D7261E",
                  depart = "#006400"
                )

#------------------------------------------------------------------------------#

# Listes ordonnées

list_parcours <- unlist(map(1:7, ~glue("parcours{.x}")))
list_parcours <- ordered(list_parcours, levels = list_parcours)

list_etapes <- unlist(map(1:7, ~glue("Etape{.x}")))
list_etapes <- ordered(list_etapes, levels = list_etapes)

df_POI <- tribble(
  ~label_fr,      ~label_en,      ~values,  ~color,
  "Départ",       "Start",        "Green",  couleurs$depart,
  "GPM",          "KOM",          "Climb",  couleurs$vertMaillot,
  "Sprint Bonif", "Bonif Sprint", "Sprint", couleurs$orangeMaillot,
  "Sprint Maire", "Mayor Spritn", "Mayor",  couleurs$blueSprintMaire,
  "Arrivée",      "Finish",       "Finish", couleurs$brunMaillot
) %>% 
  mutate(values = ordered(values, levels = values))
