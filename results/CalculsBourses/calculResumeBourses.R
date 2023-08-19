#!/usr/bin/env Rscript --vanilla

################################################################################
# Calculer les bourses de chaque coureurs avec les résultats
# Sauvegarder un fichier excel recapitulatif
#
################################################################################

here::i_am("guide2023.Rproj")

source(here::here("code","/_LibsVars.R"))

source(here("code","_import_itineraire.R"))

source(here("results", "CalculsBourses", "_importGrillesBourses.R"))

# df des détails
details <- iti_etape$Details
################################################################################

listeCoureurs <- read.csv(here("results", "Liste_Coureurs.csv")) %>% 
  select(Bib, Coureur, Equipe = Team)

################################################################################ 

# Bourses des Maires

boursesMaires <- read.csv(here("results", "Maires.csv")) %>% 
  as_tibble() %>% 
  drop_na() %>% 
  left_join(details %>% select(Etape,Nom_Courts_FR), by = "Etape") %>% 
  left_join(listeCoureurs, by = "Bib") %>% 
  select(Detail = Nom_Courts_FR,
         Etape,
         Sprint = SprintNumero,
         Bourse,
         Bib,
         Coureur,
         Equipe)

boursesMairesCumulCoureur <- boursesMaires %>% 
  group_by(Bib, Coureur, Equipe) %>% 
  summarise(Bourse = sum(Bourse),
            Nombre = n(),
            .groups = "drop") %>% 
  arrange(-Bourse, -Nombre)

boursesMairesCumulEquipe <- boursesMaires %>% 
  group_by(Equipe) %>% 
  summarise(Bourse = sum(Bourse),
            Nombre = n(),
            .groups = "drop") %>% 
  arrange(-Bourse, -Nombre)

write_csv(boursesMaires, 
          file = here("results", "CalculsBourses", "Maires_Details.csv"),
          append = FALSE)

write_csv(boursesMairesCumulCoureur, 
          file = here("results", "CalculsBourses", "Maires_CumulCoureurs.csv"),
          append = FALSE)

write_csv(boursesMairesCumulEquipe, 
          file = here("results", "CalculsBourses", "Maires_CumulEquipes.csv"),
          append = FALSE)

################################################################################ 
################################################################################ 


