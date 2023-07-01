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
    "Bleu", "Blue") %>% 
  mutate(Maillot = Maillot %>% as.factor(),
         Jersey = Jersey %>%  as.factor())


# Liste des Médailles et emoji correspondant

  ## https://www.compart.com/fr/unicode/search?q=m%C3%A9daille#characters

medaille_emoji <- tribble(
  ~Position, ~emoji,
  1, "&#129351;",
  2, "&#129352;",
  3, "&#129353;"
)

################################################################################ 


# Liens règlements UCI
## PDF des règlements UCI

uci_p1_FR <- "https://assets.ctfassets.net/761l7gh5x5an/wQympSG6EWlKq6o6HKw9E/dc4f11d32bd13331be62c834d9070f1c/1-GEN-20230220-F.pdf"
uci_p2_FR <- "https://assets.ctfassets.net/761l7gh5x5an/6l7RYpnS5bOmq32rzaBdNx/77c464d49bad0f321e03f9b0e62e2be8/2-ROA-20230613-F.pdf"

uci_p1_EN <- "https://assets.ctfassets.net/761l7gh5x5an/wQympSG6EWlKq6o6HKw9E/d2911e42e627bbd055483f57cc0027fb/1-GEN-20230220-E.pdf"
uci_p2_EN <- "https://assets.ctfassets.net/761l7gh5x5an/3zdJc5antr1dA3GYeDKdBu/bef82a9d7336e9b798c364066db92581/2-ROA-20230613-E.pdf"

uci_financial <- "https://assets.ctfassets.net/761l7gh5x5an/4LhHQ0knlVpQFA1wf3X2Re/d6066b0cb0f95507c1117cf0e1afdb13/ROA-20220420_-_2023_Road_Financial_Obligations_-v2_PW_Lbo_Corrected_17.06.2022.pdf"
