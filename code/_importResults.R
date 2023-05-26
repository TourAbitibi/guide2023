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

path <- here("results","unrar")

# Lire les fichiers csv dans le dossier unrar
csv_files <- list.files(path = path,
                             pattern = ".*csv$",
                             full.names = TRUE)

df_files <- do.call(rbind.data.frame, as.list(csv_files)) %>% as_tibble()
names(df_files)[1] <- "file_path"

df_files <- df_files %>% 
  mutate(stageRSS = str_extract(file_path, "\\s(\\S+)$") %>% str_replace(".csv", "") %>% trimws(),
         stage = case_when(
           stageRSS == 1 ~ 1,
           stageRSS == 2 ~ 2,
           stageRSS == "3-1" ~ 3,
           stageRSS == "3-2" ~ 4,
           stageRSS == 4 ~ 5,
           stageRSS == 5 ~ 6,
           stageRSS == 6 ~ 7,
         ))


# Liste des étapes présentes en csv
distinct(df_files, stage) %>% drop_na() %>% arrange(stage)

################################################################################
