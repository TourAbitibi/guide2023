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

# Définir les étapes selon STD, CLMI ou SOMMET
etapesStd <- c(1,2,4,5,6,7)
etapeCLMI <- 3
# etapeSOMMET <- c()
  
################################################################################
################################################################################


ecrire_tableau_STD <- function(Etape, lang){

  tableau_Descrip_Etape(Etape, lang) %>% save_kable(here(glue("guide_{lang}_PDF"), "details"  , glue("tableau_{Etape}.pdf")))

}

# Produire les tableaux STD - FR et EN
walk(etapesStd, ~ecrire_tableau_STD(.x, "FR"))
walk(etapesStd, ~ecrire_tableau_STD(.x, "EN"))



# Produire le tableau pour le CLMI - FR et EN

ecrire_tableau_CLMI <- function(Etape, lang){
  
  tableau_Descrip_BASE(Etape, lang) %>% save_kable(here(glue("guide_{lang}_PDF"), "details"  , glue("tableau_{Etape}.pdf")))
  
}

ecrire_tableau_CLMI(etapeCLMI, "FR")
ecrire_tableau_CLMI(etapeCLMI, "EN")



# Écraser le tableau pour l'arrivée au sommet - FR et EN

ecrire_tableau_SOMMET <- function(Etape, lang){
  
  tableau_Descrip_Etape_Sommet(Etape, lang) %>% save_kable(here(glue("guide_{lang}_PDF"), "details"  , glue("tableau_{Etape}.pdf")))
  
}

# ecrire_tableau_SOMMET(etapeSOMMET, "FR")
# ecrire_tableau_SOMMET(etapeSOMMET, "EN")

