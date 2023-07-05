#!/usr/bin/env Rscript --vanilla

################################################################################
# Produire un fichier excel contenant :
## Les lignes à tracer sur la route
## Les signaleurs drapeaux jaunes 
## Les motos drapeaux jaunes 
################################################################################ 

here::i_am("guide2023.Rproj")

source(here::here("code","/_LibsVars.R"))
library("xlsx")
source(here("code","_import_itineraire.R"))

################################################################################ 

resume_lignes <- function(stage = 1){
  calcul_iti_etape(stage) %>% 
    filter(Symbol %in% c("Climb", "Mayor","Sprint")) %>% 
    mutate(Etape = stage,
           Jour = iti_etape$Details %>% filter(Etape == stage) %>% pull(Jour)) %>% 
    select(Etape,
           Jour,
           "Heure passage" = time_arr_moy,
           Symbol,
           KM = KM_fait,
           Details)
  
}

map_dfr(1:7, resume_lignes) %>% 
  write.xlsx(file = here("export","lignes_tracer_brut.xlsx"),
            sheetName = "lignes_brut",
            row.names = FALSE)
