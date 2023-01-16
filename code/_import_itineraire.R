###
# 
###

source("code/_LibsVars.R")

# Fonction pour importer les feuilles du fichier excel de travail
read_itinerairexlsx <- function(filename, tibble = FALSE) {
    sheets <- readxl::excel_sheets(filename)
    x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
    if(!tibble) x <- lapply(x, as.data.frame)
    names(x) <- sheets
    x
}


# Importer les itinéraires
iti_etape <- read_itinerairexlsx("excel/Itineraires.xlsx")


# Calcul des vitesses des étapes en km/h et km/min
speed <- data.frame( kmh_rapide = iti_etape$Details$Vit_rapide,
                     kmh_moy = iti_etape$Details$Vit_moy,
                     kmh_lent = iti_etape$Details$Vit_lent,
                     
                     # Transforme en km/min
                     km_min_rapide = iti_etape$Details$Vit_rapide / 60,
                     km_min_moy = iti_etape$Details$Vit_moy / 60,
                     km_min_lent = iti_etape$Details$Vit_lent / 60  )


  
# Calculs des temps de passage par étape

calcul_iti_etape <- function(Etape, lang = "FR"){

  orig_name <-paste0("iti_etape$Etape_", Etape, sep="")
  df_orig <- eval(parse(text=orig_name))
  
  heure_dep <- iti_etape$Details$Heure_dep[Etape]
  min_dep <- iti_etape$Details$min_dep[Etape]

  
  df <- df_orig %>% 
    mutate(KM_fait = round(KM_reel - iti_etape$Details$KM_Neut[Etape], 1),
           KM_a_faire = round(max(KM_fait)-KM_fait, 1),
           km_fait_reel = KM_reel - KM_a_faire,
           min_tot_rapide = KM_reel / speed$km_min_rapide[1],
           min_tot_moy = KM_reel / speed$km_min_moy[1],
           min_tot_lent = KM_reel / speed$km_min_lent[1],
           heure_arr_rapide = paste(floor((min_tot_rapide + min_dep)/60) + heure_dep,
                                 ifelse(round((min_tot_rapide + min_dep) %% 60,0)<10,
                                        paste0("0", round((min_tot_rapide + min_dep) %% 60,0)),
                                        round((min_tot_rapide + min_dep) %% 60,0)), sep=":"),
           heure_arr_moy = paste(floor((min_tot_moy + min_dep)/60) + heure_dep,
                                ifelse(round((min_tot_moy + min_dep) %% 60,0)<10,
                                       paste0("0", round((min_tot_moy + min_dep) %% 60,0)),
                                       round((min_tot_moy + min_dep) %% 60,0)), sep=":"),
           heure_arr_lent = paste(floor((min_tot_lent + min_dep)/60) + heure_dep,
                                ifelse(round((min_tot_lent + min_dep) %% 60,0)<10,
                                       paste0("0", round((min_tot_lent + min_dep) %% 60,0)),
                                       round((min_tot_lent + min_dep) %% 60,0)), sep=":")  ) %>% 
    select(-km_fait_reel,-min_tot_rapide,-min_tot_moy,-min_tot_lent) %>% 
    merge(x=., y = iti_etape$Lexique, by = "Symbol", all.x = TRUE ) %>% 
    arrange(KM_fait) %>% 
    {if (lang == "FR") select(.,-Details_ANG, -Info_ANG ) %>% rename(Details = Details_FR, Info = Info_FR) 
      else select(.,-Details_FR, -Info_FR)  %>% rename(Details = Details_ANG, Info = Info_ANG) }
    
  return(df)

}
# Création tableau description détaillée 

tableau_Descrip_Etape <- function(Etape, lang = "FR"){

  descr_iti <- calcul_iti_etape(Etape, lang)
  
  descr_iti %>% 
    select(KM_a_faire,
           KM_fait,
           Emoji,
           Details,
           heure_arr_rapide,
           heure_arr_moy,
           heure_arr_lent) %>% 
    kbl(col.names = NULL,
        escape = F, 
        align = c(rep('c', times = 7))) %>% # permet de passer les <br/>
    kable_minimal("striped",
                  full_width = T, 
                  font_size = 16) %>%
    
    # Conditions des colonnes
    column_spec(2, bold = T) %>%
    
    # Conditions de rangées
    row_spec(which(descr_iti$Symbol == "MAIRE",), bold = F, color = couleurs$blueSprintMaire ) %>% # , background = ""
    row_spec(which(descr_iti$Symbol == "SPRINT",), bold = F, color = couleurs$orangeMaillot ) %>%
    row_spec(which(descr_iti$Symbol == "GPM",), bold = F, color = couleurs$vertMaillot ) %>%
    row_spec(which(descr_iti$Symbol == "DANGER",), bold = F, color = couleurs$rougeDanger ) %>%
    row_spec(which(descr_iti$Symbol == "FIN",), bold = T, color = couleurs$brunMaillot) %>%
    
    # Header tableau
    add_header_above(  c({if (lang=="FR") "restant" else "to go"}, 
                         {if (lang=="FR") "fait" else "done"},
                         {if (lang=="FR") "parcours" else "info"}, 
                         iti_etape$Details$Descr_km[Etape],
                         speed$kmh_rapide[Etape],
                         speed$kmh_moy[Etape],
                         speed$kmh_lent[Etape])) %>% 
    add_header_above(c( "km"  = 2, 
                        {if(lang=="FR") "Info" else "Course"}, 
                        iti_etape$Details$Descr_Villes[Etape], 
                        "km/h" = 3 )) %>% 
    {if (lang == "FR")
    footnote(.,general  = c("Sprint bonification : 3-2-1 sec & 6-4-2 pts",
                         "Arrivée finale : 10-6-4 sec & 30-24-20-16-12-10-8-6-4-2 pts",
                         "GPM : 5-3-2 points"
                         ),
             general_title = "Points et bonifications :",
             title_format = c("italic", "bold"),
             escape= FALSE) else
      footnote(.,general  = c("Bonus sprint : 3-2-1 sec & 6-4-2 pts",
                            "Final Finish : 10-6-4 sec & 30-24-20-16-12-10-8-6-4-2 pts",
                            "KOM : 5-3-2 points"
      ),
      general_title = "Points and bonifications :",
      title_format = c("italic", "bold"),
      escape= FALSE)
    }

}


# Pour test : 

# tableau_Descrip_Etape(2, "FR") 

# -[ ] unicode de flèches et info ne fonctionnent pas sous mac actuellement
# -[x] Comment passer des commandes html (comme breakline) ? kbl(escape = F)
# - [x] Comment passer un emoji/ flèche dans le tableau ?? html code, voir fichier excel
# - [x] Possible de sauvegarder le tableau en tiff, png,.. pour faciliter import dans un rapport pdf ?
#         --> %>% save_kable("img/tableau_Etape1.png" )
