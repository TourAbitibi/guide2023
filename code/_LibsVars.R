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
  #rosm,
  sf,
  mapview,
  units,
  #tmap,
  RColorBrewer,
  scales,
  conflicted,
  here,
  png,
  usethis # https://usethis.r-lib.org/reference/ui.html --> ui_info, ui_todo, ...
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
                  orangePale = "#ffcf78",
                  vertMaillot = "#66CD00", # à valider
                  blueSprintMaire = "#00008B",
                  bluePale = "#d9d9ff",
                  rougeDanger = "#D7261E",
                  depart = "#006400"
                )

# Bon site de références pour couleurs complémentaires :
#  https://www.colorhexa.com/

#------------------------------------------------------------------------------#

# Listes ordonnées

list_parcours <- unlist(map(1:7, ~glue("parcours{.x}")))
list_parcours <- ordered(list_parcours, levels = list_parcours)

list_etapes <- unlist(map(1:7, ~glue("Etape{.x}")))
list_etapes <- ordered(list_etapes, levels = list_etapes)

df_POI <- tribble(
  ~label_fr,      ~label_en,      ~values,  ~labels, ~color,
  "Départ",       "Start",        "Green",  "",      couleurs$depart,
  "GPM",          "KOM",          "Climb",  "KOM",   couleurs$vertMaillot,
  "Sprint Bonif", "Bonif Sprint", "Sprint", "Bonus", couleurs$orangeMaillot,
  "Sprint Maire", "Mayor Sprint", "Mayor",  "$$",    couleurs$blueSprintMaire,
  "Arrivée",      "Finish",       "Finish", "Fin",   couleurs$brunMaillot
) %>% 
  mutate(values = ordered(values, levels = values))


################################################################################ 

# Liste des maillots

maillots_liste<- tribble(
    ~Maillot, ~Jersey,  
    "Brun", "Brown", 
    "Orange", "Orange", 
    "Pois", "KOM", 
    "Bleu", "Blue")


# Liste des Médailles et emoji correspondant

  ## https://www.compart.com/fr/unicode/search?q=m%C3%A9daille#characters

medaille_emoji <- tribble(
  ~Position, ~emoji,
  1, "&#129351;",
  2, "&#129352;",
  3, "&#129353;"
)

################################################################################ 