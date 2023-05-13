#!/usr/bin/env Rscript --vanilla

################################################################################
# Création des images des tableau de description détaillé des étapes
#
# Input : fichier Excel "excel/Itineraires.xlsx"
#         _import_itineraire.R
# Output : 
#  - images des tableaux en francais et anglais en format PDF
#  - dans les fichier guide_FR_PDF, guide_EN_PDF / details
#
# ref: https://www.rdocumentation.org/packages/kableExtra/versions/0.6.1/topics/kable_as_image
#
################################################################################

source(here::here("code","/_import_itineraire.R"))

# Librairies et here chargées dans le fichier précédent

################################################################################


ecrire_tableau <- function(Etape, lang){

  tableau_Descrip_Etape(Etape, lang) %>% save_kable(here(glue("guide_{lang}_PDF"), "details"  , glue("tableau_{Etape}.pdf")))

}

# Produire les tableaux en français
walk(1:7, ~ecrire_tableau(.x, "FR"))

# Produire les tableaux en anglais
walk(1:7, ~ecrire_tableau(.x, "EN"))

################################################################################

ecrire_tableau_CLMI <- function(Etape, lang){
  
  tableau_Descrip_Etape_CLMI(Etape, lang) %>% save_kable(here(glue("guide_{lang}_PDF"), "details"  , glue("tableau_{Etape}.pdf")))
  
}

# Écraser le tableau pour le CLMI - français
ecrire_tableau_CLMI(3, "FR")

# Écraser le tableau pour le CLMI - anglais
ecrire_tableau_CLMI(3, "EN")
