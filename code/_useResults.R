#!/usr/bin/env Rscript --vanilla

################################################################################
# Utiliser les résultats traités dans `_importResults.R`
#
################################################################################

here::i_am("guide2023.Rproj")

source(here::here("code","/_LibsVars.R"))

################################################################################ 

### Import des données ###

### Les fichiers doivent exister pour éviter des erreurs ###

# Lecture  de la start list de coureurs vers un .csv
start_list_coureurs <- read_csv(here("results", "Liste_Coureurs.csv"), show_col_types = FALSE)

# Lecture des Maillots
## KOM - Montagne
file_path <- here("results", "KOM_General_results.csv")
if(file.exists(file_path)){
  Maillots_KOM <- read_csv(file_path, show_col_types = FALSE) %>% 
    filter(Position == 1) %>% 
    left_join(start_list_coureurs, by = "Bib") %>% 
    select(
      ApresEtape,
      Bib,
      Coureur,
      Team,
      PointsKOM
    )
  
  KOM_existe <- TRUE
} else KOM_existe <- FALSE

## ORANGE - Sprint
file_path <- here("results", "Points_General_results.csv")
if(file.exists(file_path)){
  Maillots_ORANGE <- read_csv(file_path, show_col_types = FALSE) %>%
  filter(Position == 1) %>% 
  left_join(start_list_coureurs, by = "Bib") %>% 
  select(
    ApresEtape,
    Bib,
    Coureur,
    Team,
    Points
  )
  
  ORANGE_existe <- TRUE
  
} else ORANGE_existe <- FALSE

## BRUN - Général
file_path <- here("results", "General_results.csv")
if(file.exists(file_path)){
  Maillots_BRUN <- read_csv(file_path, show_col_types = FALSE) %>% 
  filter(Position == 1) %>% 
  left_join(start_list_coureurs, by = "Bib") %>% 
  select(
    ApresEtape,
    Bib,
    Coureur,
    Team,
    TempsGeneral
  )

  BRUN_existe <- TRUE

} else BRUN_existe <- FALSE

## BLEU - Jeune
file_path <- here("results", "Jeune_General_results.csv")
if(file.exists(file_path)){
  Maillots_BLEU <- read_csv(file_path, show_col_types = FALSE) %>% 
  filter(Position == 1) %>% 
  left_join(start_list_coureurs, by = "Bib") %>% 
  select(
    ApresEtape,
    Bib,
    Coureur,
    Team,
    TempsGeneral
  )

  BLEU_existe <- TRUE

} else BLEU_existe <- FALSE

## Équipe
file_path <- here("results", "Equipe_General_results.csv")
if(file.exists(file_path)){
  Maillots_EQUIPE <- read_csv(file_path, show_col_types = FALSE) %>% 
  filter(Position == 1) %>% 
  select(
    ApresEtape,
    Team,
    TempsGeneral
  )

  EQUIPE_existe <- TRUE

} else EQUIPE_existe <- FALSE

# Lecture des podiums
file_path <- here("results", "Etapes_results.csv")
if(file.exists(file_path)){
  PODIUMS <- read_csv(file_path, show_col_types = FALSE) %>% 
  filter(Position %in% 1:3) %>% 
  left_join(start_list_coureurs, by = "Bib") %>% 
  select(
    Etape,
    Position,
    Bib,
    Coureur,
    Team,
    TempsEtape
  )

  PODIUM_existe <- TRUE

} else PODIUM_existe <- FALSE


# Lecture des porteurs de maillots
file_path <- here("results", "Maillots_Porteurs.csv")
if(file.exists(file_path)){
  Maillots_PORTEURS <- read_csv(file_path, show_col_types = FALSE) %>% 
  drop_na() %>% 
  mutate(
    Maillot = factor(Maillot, levels = maillots_liste$Maillot)
  ) %>% 
  left_join(start_list_coureurs, by = "Bib") %>% 
  select(
    ApresEtape,
    Maillot,
    Bib,
    Coureur,
    Team
  ) %>% 
  arrange(ApresEtape, Maillot)
  
  PORTEURS_existe <- TRUE
  
} else PORTEURS_existe <- FALSE


################################################################################ 

# Est-ce que les fichiers de résultats existent :

results_existent_tous <-  PODIUM_existe & 
                          BRUN_existe & 
                          BLEU_existe &
                          ORANGE_existe &
                          KOM_existe

# Est-ce que le fichier de porteurs de maillot existe
## Variable :  PORTEURS_existe

################################################################################ 


# Fonction pour voir si Podium et Maillots à la fin de l'étape existent

verif_resultats_complets <- function(Stage){
  
  PODIUMS %>% filter(Etape == Stage) %>% nrow() == 3  &
  Maillots_BRUN %>% filter(ApresEtape == Stage) %>%  nrow() == 1  &
  Maillots_BLEU %>% filter(ApresEtape == Stage) %>%  nrow() == 1  &
  Maillots_KOM %>% filter(ApresEtape == Stage) %>%  nrow() == 1  &
  Maillots_ORANGE %>% filter(ApresEtape == Stage) %>%  nrow() == 1  &
  Maillots_EQUIPE %>% filter(ApresEtape == Stage) %>%  nrow() == 1
}


# Fonction pour voir si Porteurs de maillots existe, retourne TRUE

verif_porteurs_complets <- function(AfterStage){
  
  Maillots_PORTEURS %>% filter(ApresEtape == AfterStage) %>% nrow() == 4
}


################################################################################ 

#TODO Fonction pour créer tableau du podium de l'étape

Stage = 1

podium_FR <- function(Stage){
  PODIUMS %>% filter(Etape == Stage) %>% 
    left_join(medaille_emoji, by = "Position") %>% 
    select(
      Classement = emoji,
      "No." = Bib,
      Coureur,
      "Équipe" = Team
    ) %>% 
    kbl(escape = F, # permet de passer les <br/>
        align = c('c', 'c', 'l', 'l')) %>% 
    kable_styling("striped",      # kable_minimal
                  full_width = T, 
                  font_size = 16)
}

podium_EN <- function(Stage){
  PODIUMS %>% filter(Etape == Stage) %>% 
    left_join(medaille_emoji, by = "Position") %>% 
    select(
      Position = emoji,
      "No." = Bib,
      Rider = Coureur,
      Team
    ) %>% 
    kbl(escape = F, # permet de passer les <br/>
        align = c('c', 'c', 'l', 'l')) %>% 
    kable_styling("striped",      # kable_minimal
                  full_width = T, 
                  font_size = 16)
}


#TODO Fonction pour créer tableau des maillots à la fin de l'étape

maillots_apres_etape<- function(Stage){
  tribble(
    ~Maillot, ~Jersey,  ~Bib,
    "Brun", "Brown", Maillots_BRUN %>% filter(ApresEtape == Stage) %>% pull(Bib),
    "Orange", "Orange", Maillots_ORANGE %>% filter(ApresEtape == Stage) %>% pull(Bib),
    "Pois", "KOM", Maillots_KOM %>% filter(ApresEtape == Stage) %>% pull(Bib),
    "Bleu", "Blue", Maillots_BLEU %>% filter(ApresEtape == Stage) %>% pull(Bib)) %>% 
  left_join(start_list_coureurs, by = "Bib")
}


maillots_apres_etape_tableau_FR <- function(Stage){
  maillots_apres_etape(Stage) %>% 
    select(
      Maillot,
      "No." = Bib,
      Coureur,
      "Équipe" = Team
    ) %>% 
    kbl(escape = F, # permet de passer les <br/>
        align = c('c', 'c', 'l', 'l')) %>% 
    kable_styling("striped",      # kable_minimal
                  full_width = T, 
                  font_size = 16) %>% 
    column_spec(1, bold = T) %>%
    row_spec(1, color = couleurs$brunMaillot) %>% 
    row_spec(2, color = couleurs$orangeMaillot) %>% 
    row_spec(3, color = couleurs$vertMaillot) %>% 
    row_spec(4, color = couleurs$blueSprintMaire)
}
  
maillots_apres_etape_tableau_EN <- function(Stage){
  
  maillots_apres_etape(Stage) %>% 
    select(
      Jersey,
      "No." = Bib,
      Rider = Coureur,
      Team
    ) %>% 
    kbl(escape = F, # permet de passer les <br/>
        align = c('c', 'c', 'l', 'l')) %>% 
    kable_styling("striped",      # kable_minimal
                  full_width = T, 
                  font_size = 16) %>% 
    column_spec(1, bold = T) %>%
    row_spec(1, color = couleurs$brunMaillot) %>% 
    row_spec(2, color = couleurs$orangeMaillot) %>% 
    row_spec(3, color = couleurs$vertMaillot) %>% 
    row_spec(4, color = couleurs$blueSprintMaire) 
} 
  
  
# Fonction pour créer le tableau des porteurs des maillots post étape


maillots_porteurs_tableau_FR <- function(Stage){
  
  Stage = Stage -1  #Résultats étape précédente
  
  Maillots_PORTEURS %>% 
    filter(ApresEtape == Stage) %>% 
    select(
      Maillot,
      "No." = Bib,
      Coureur,
      "Équipe" = Team
    ) %>% 
    kbl(escape = F, # permet de passer les <br/>
        align = c('c', 'c', 'l', 'l')) %>% 
    kable_styling("striped",      # kable_minimal
                  full_width = T, 
                  font_size = 16) %>% 
    column_spec(1, bold = T) %>%
    row_spec(1, color = couleurs$brunMaillot) %>% 
    row_spec(2, color = couleurs$orangeMaillot) %>% 
    row_spec(3, color = couleurs$vertMaillot) %>% 
    row_spec(4, color = couleurs$blueSprintMaire)
}

maillots_porteurs_tableau_EN <- function(Stage){
  
  Stage = Stage -1  #Résultats étape précédente
  
  Maillots_PORTEURS %>% 
    filter(ApresEtape == Stage) %>% 
    left_join(maillots_liste, by = "Maillot") %>% 
    select(
      Jersey,
      "No." = Bib,
      Rider = Coureur,
      Team
    ) %>% 
    kbl(escape = F, # permet de passer les <br/>
        align = c('c', 'c', 'l', 'l')) %>% 
    kable_styling("striped",      # kable_minimal
                  full_width = T, 
                  font_size = 16) %>% 
    column_spec(1, bold = T) %>%
    row_spec(1, color = couleurs$brunMaillot) %>% 
    row_spec(2, color = couleurs$orangeMaillot) %>% 
    row_spec(3, color = couleurs$vertMaillot) %>% 
    row_spec(4, color = couleurs$blueSprintMaire) 
} 
