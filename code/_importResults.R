#!/usr/bin/env Rscript --vanilla

################################################################################
# Importer les fichiers de résultats en input
# Sauvegarder vers des  csv en output
#
# Commande pour unrar : ` unrar e results/rar/Stage\ Race.rar results/unrar -o+ `
#
################################################################################

here::i_am("guide2023.Rproj")

source(here::here("code","/_LibsVars.R"))

source(here("code","_import_itineraire.R"))


# df des détails
details <- iti_etape$Details %>% rename(etape = Etape)

################################################################################

# Unrar du fichiers `StageRace.rar` provenant du logiciel de RSS

system(glue('unrar e {here("results","rar", "StageRace.rar")} {here("results","unrar")} -o+'))

################################################################################ 

# Import des fichiers CSV

# Lire les fichiers csv dans le dossier unrar
csv_files <- list.files(path = here("results","unrar"),
                             pattern = ".*csv$",
                             full.names = TRUE)

df_files <- do.call(rbind.data.frame, as.list(csv_files)) %>% 
  as_tibble() %>% 
  rename(file_path = names(.)[1]) %>% 
  mutate(
        stageRSS = str_extract(file_path, "\\s(\\S+)$") %>% str_replace(".csv", "") %>% trimws(),
         
         stage = case_when(
           stageRSS == 1 ~ 1,
           stageRSS == 2 ~ 2,
           stageRSS == "3-1" ~ 3,
           stageRSS == "3-2" ~ 4,
           stageRSS == 4 ~ 5,
           stageRSS == 5 ~ 6,
           stageRSS == 6 ~ 7),
         
         Etape = str_detect(file_path, "Etape") & 
           str_detect(file_path, "Jeune", negate = TRUE),
         
         EtapeJeune = str_detect(file_path, "Etape") & 
           str_detect(file_path, "Jeune"),
         
         General = str_detect(file_path, "General") & 
           str_detect(file_path, "sorted", negate = TRUE) & 
           str_detect(file_path, "Jeune", negate = TRUE),
         
         GeneralJeune = str_detect(file_path, "General") & 
           str_detect(file_path, "sorted", negate = TRUE) & 
           str_detect(file_path, "Jeune"),
         
         Equipe = str_detect(file_path, "Teams") &
           stageRSS != "Equipes" ,
         
         Points = str_detect(file_path, "Sprint"),
         
         KOM = str_detect(file_path, "grimpeur"),
         
         ListeCoureurs = stageRSS == "Coureurs",
         
         ListeEquipes = stageRSS == "Equipes",
         
         ) %>% 
  pivot_longer( !c(file_path, stageRSS, stage),
                names_to = "classification",
               )%>% 
  filter(value) %>% 
  select(-value) %>% 
  arrange(classification)

################################################################################ 

# Liste des étapes présentes en csv
etapes_distinctes_csv <- distinct(df_files, stage) %>% drop_na() %>% arrange(stage)
derniere_etape_terminee <- etapes_distinctes_csv %>% max()

################################################################################
################################################################################ 

# Fonction pour trouvée la ligne du CSV contenant les noms de colonnes

# class : classification pour trouver le bon fichier csv
# motCle : mot se retrouvant seulement dans les noms de colonnes

################################################################################ 

nb_lignes_skip_coureurs <- function(class, motCle){
  
  # Ouvrir la connection vers le fichier
  fc =  df_files %>% 
    filter(classification == class) %>% 
    pull(file_path) %>% 
    file(open = "r", encoding = "UTF-16LE")
  
  rangee_titre = 0 # initialisation
 
  # Trouver la ligne correspondante aux titres de colonnes
  while(length( (l <- readLines(fc, n = 1) ) > 0 )){ 
    
    rangee_titre = rangee_titre + 1
    
    is_detected <- str_detect(l, fixed(motCle))
    
    if(is_detected) {break}
    
  }
  
  return(rangee_titre)
}

################################################################################ 
################################################################################ 

################################################################################
################################################################################ 

# Fonction pour trouvée la ligne du CSV contenant le général de la dernière etape
# Sprints et KOM

# class : classification pour trouver le bon fichier csv
# motCle : mot se retrouvant seulement dans les noms de colonnes
# etape : dernière étape complétée, normalement, `derniere_etape_terminee`

################################################################################ 

nb_lignes_skip_resultat_etape <- function(class, motCle, etape = derniere_etape_terminee){
  
  # Ouvrir la connection vers le fichier
  fc =  df_files %>% 
    filter(classification == class,
           stage == etape) %>%
    pull(file_path) %>% 
    file(open = "r", encoding = "UTF-16LE")
  
  rangee_titre = 0 # initialisation
  
  # Trouver la ligne correspondante aux titres de colonnes
  while(length( (l <- readLines(fc, n = 1) ) > 0 )){ 
    
    rangee_titre = rangee_titre + 1
    
    is_detected <- str_detect(l, fixed(motCle))
    
    if(is_detected) {break}
    
  }
  
  return(rangee_titre)
}

################################################################################ 
################################################################################ 

# Création de la liste des coureurs

class <- "ListeCoureurs"

path_liste_coureurs <- df_files %>% 
  filter(classification == class) %>% 
  pull(file_path)


start_list_coureurs <- read.csv(path_liste_coureurs, 
         sep = ';', 
         skip = nb_lignes_skip_coureurs(class, motCle = 'License'),
         header = FALSE,
         fileEncoding = "UTF-16LE") %>% 
  as_tibble() %>% 
  select(-V9) %>% 
  drop_na() %>% 
  rename( 
    Bib = V1,
    PremAnnee = V2,
    Coureur = V3,
    Team = V4,
    TeamShort = V5,
    License = V6,
    Pays = V7,
    Naissance = V8) %>% 
  mutate(
    Jeune = str_detect(PremAnnee, "#"),
    Team = as_factor(Team),
    TeamShort = as_factor(TeamShort),
    Pays = as_factor(Pays),
    Naissance = as_factor(Naissance)
  ) %>% 
  select(-PremAnnee)

# Écriture de la start list de coureurs vers un .csv

start_list_coureurs %>% write_csv(here("results", "coureurs.csv"))

################################################################################ 

# Création de la liste des équipes
start_list_equipes <- start_list_coureurs %>% 
  mutate(BibCategory = 10  * Bib %/% 10 ) %>% 
  select(Team, TeamShort, BibCategory) %>% 
  unique()

# Écriture de la start list d'équipes vers un .csv
start_list_equipes %>% write_csv(here("results", "equipes.csv"))
  
################################################################################ 
################################################################################ 

# Création des résultats de KOM

class <- "KOM"


path_liste_KOM <- df_files %>% 
  filter(classification == class) 


# Gérer le fait que Stage 3 et 4 n'ont pas de KOM, donc pas de classement
## Étapes 3 et 4 utilisent les mêmes résultats que 2
etapes_effectives_resulstats_KOM <- tibble(etapes_relles = 1:7, etapes_effectives = c(1:  2, 2, 2, 5 : 7)) %>% 
  filter(etapes_relles <= derniere_etape_terminee)

#### Utiliser ces étapes pour un map

map_results_KOM <- function(etape_map){
  etape_relle <- etapes_effectives_resulstats_KOM %>% filter(etapes_relles == etape_map) %>% pull(etapes_relles)
  etape_effective <- etapes_effectives_resulstats_KOM %>% filter(etapes_relles == etape_map) %>% pull(etapes_effectives)
  
  read.csv(path_liste_KOM %>% 
                   filter(stage == etape_effective) %>% 
                  pull(file_path), 
           sep = ';', 
           skip = nb_lignes_skip_resultat_etape(class = class, 
                                                motCle = "General, Général", 
                                                etape = etape_effective),
           header = FALSE,
           fileEncoding = "UTF-16LE") %>% 
    as_tibble() %>% 
      select(-V3, -V4, -V5, -V6, -V7, -V8, -V10) %>% 
      drop_na() %>% 
      rename( 
        Postion = V1,
        Bib = V2,
        PointsKOM = V9) %>% 
      mutate(
        ApresEtape = etape_relle)
    
  }

# Écriture vers un fichier CSV de résultats des KOM
etapes_effectives_resulstats_KOM$etapes_relles %>% 
  map(\(etapes) .f = map_results_KOM(etapes)) %>% 
  list_rbind() %>% print(n=100) %>% 
  write_csv(here("results", "KOM_results.csv"))
  



# Création des résultats de Points (Orange)

class <- "Points"


path_liste_Points <- df_files %>% 
  filter(classification == class) 


# Gérer le fait que Stage 3 n'a pas de points, donc potentiellement pas de classement
# (voir KOM si ajustement requis)
etapes_effectives_resulstats_Points <- tibble(etapes_relles = 1:7, etapes_effectives = 1:7) %>% 
  filter(etapes_relles <= derniere_etape_terminee)

#### Utiliser ces étapes pour un map

map_results_Points <- function(etape_map){
  etape_relle <- etapes_effectives_resulstats_Points %>% filter(etapes_relles == etape_map) %>% pull(etapes_relles)
  etape_effective <- etapes_effectives_resulstats_Points %>% filter(etapes_relles == etape_map) %>% pull(etapes_effectives)
  
  read.csv(path_liste_Points %>% 
             filter(stage == etape_effective) %>% 
             pull(file_path), 
           sep = ';', 
           skip = nb_lignes_skip_resultat_etape(class = class, 
                                                motCle = "General", 
                                                etape = etape_effective),
           header = FALSE,
           fileEncoding = "UTF-16LE") %>% 
    as_tibble() %>% 
    select(-V3, -V4, -V5, -V6, -V7, -V8, -V10) %>% 
    drop_na() %>% 
    rename( 
      Postion = V1,
      Bib = V2,
      PointsKOM = V9) %>% 
    mutate(
      ApresEtape = etape_relle)
  
}

# Écriture vers un fichier CSV de résultats des Points
etapes_effectives_resulstats_Points$etapes_relles %>% 
  map(\(etapes) .f = map_results_Points(etapes)) %>% 
  list_rbind() %>% print(n=100) %>% 
  write_csv(here("results", "Points_results.csv"))


