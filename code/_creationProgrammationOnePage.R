#!/usr/bin/env Rscript --vanilla

################################################################################
# Création de la page de programmation en format PDF et png
#
# Input : fichier Excel "excel/Itineraires.xlsx"
#         _import_itineraire.R
# Output : 
#  - images du tableau de la programmation en francais et anglais en format PDF
#  - dans les fichier guide_FR_PDF, guide_EN_PDF / details
#
# ref: https://www.rdocumentation.org/packages/kableExtra/versions/0.6.1/topics/kable_as_image
#
################################################################################

source(here::here("code","/_import_itineraire.R"))

# Librairies et here chargées dans le fichier précédent


# Pour accès à la programmation - dff
source(here("code","programmation.R"))

################################################################################


# Tableau Français - Format kable 
prog_FR <- dff %>% 
  select(-presente) %>% 
  
  kbl( col.names = c("Date",  "Épreuve", "Départ", "Arrivée"),
       escape = F, # permet de passer les <br/>
       align = c(rep('c', times = 4))) %>% 
  
  kable_styling("striped",      # kable_minimal
                full_width = T, 
                font_size = 16) 
  


save_kable(prog_FR, here("guide_FR_PDF", "details", "prog.png"))

save_kable(prog_FR, here("guide_FR_PDF", "details", "prog.pdf"))

################################################################################
################################################################################

# Version anglaise à compléter 