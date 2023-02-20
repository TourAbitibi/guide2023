#########################################################################################
# Page programmation                                                                    #
#                                                                                       #
# Input : Itinéraire.xlsx                                                               #
# Output : fonction pour création des tableaux en html ou PDF                           #
#########################################################################################

# Gestion avec here
here::i_am("guide2023.Rproj")

# Appel des librairies et variables partagées
source(here::here("code","_LibsVars.R"))

# Dates
source(here("code", "_Dates.R"))

# Pour accès aux données du fichier excel Itineraires.xlsx
source(here("code","_import_itineraire.R"))


# Edition  (52e en 2022)
edition <-(read_excel(here("excel", "Itineraires.xlsx"), sheet = "Details") %>% 
  slice(1) %>%  
    pull(Date) %>% 
    year()) - 2022 + 52

df <- iti_etape$Details

dates_prog <- str_replace(dates_FR$jsem_jour_mois, ", ", "<br>")


#########################################################################################

# Langue
lang <- "FR"

# Création du tibble #


# Lundi 
dff <- tibble(
  date =  glue('{dates_prog[2]}'),
  presente  =  glue('<img src="../img/logo/comm_0.png" width="100">'),
  epreuve =  glue('Présentation des équipes<br/>Challenge Sprint Abitibi<br/>'), 
  dep = glue('<strong>17h30</strong><br/><br/><strong>18h30</strong><br/>Amos, Cathédrale'),
  arr = glue('<strong>18h</strong><br/><br/><strong>20h</strong><br/>Amos, Cathédrale')
)

# Mardi 
dff <- tibble(
  date =  glue('{dates_prog[3]}<br/><br/><strong>Étape 1</strong>'),
  presente  =  glue('<img src="../img/logo/comm_1.png" width="100">'),
  epreuve =  glue('<strong>Route</strong><br/>{df$VilleDep[1]} - {df$VilleArr[1]}<br/>{df$Via[1]}<br/>Distance : {df$Descr_km[1]}<br/>({df$KM_Neutres[1]} km neutralisés au départ)'), 
  dep = glue('<strong>{df$time_depart[1]}</strong><br/>{df$VilleDep[1]}, {df$LieuDepFR[1]}'),
  arr = glue('<strong>{df$time_arrivee[1]}</strong><br/>{df$VilleArr[1]}, {df$LieuArrFR[1]}')
) %>% 
  bind_rows(dff,.)


# Mercredi 
dff <- tibble(
  date =  glue('{dates_prog[4]}<br/><br/><strong>Étape 2</strong>'),
  presente  =  glue('<img src="../img/logo/comm_2.png" width="200">'),
  epreuve =  glue('<strong>Route</strong><br/>{df$VilleDep[2]} - {df$VilleArr[2]}<br/>{df$Via[2]}<br/>Distance : {df$Descr_km[2]}<br/>({df$KM_Neutres[2]} km neutralisés au départ)'), 
  dep = glue('<strong>{df$time_depart[2]}</strong><br/>{df$VilleDep[2]}, {df$LieuDepFR[2]}'),
  arr = glue('Entrée en ville : <br/><strong>{df$HeureEntreeVille[2]}</strong> <br/>Arrivée finale : <br/><strong>{df$time_arrivee[2]}</strong><br/>{df$VilleArr[2]}, {df$LieuArrFR[2]}')
) %>% 
  bind_rows(dff,.)


# Jeudi AM 
dff <- tibble(
  date =  glue('{dates_prog[5]} (AM)<br/><br/><strong>Étape 3 (demi-étape)</strong>'),
  presente  =  glue('<img src="../img/logo/comm_3.png" width="100">'),
  epreuve =  glue('<strong>Contre-la-montre Individuel</strong><br/>{df$VilleDep[3]} - {df$Via[3]} - {df$VilleArr[3]}<br/>Distance : {df$Descr_km[3]}'), 
  dep = glue('Premier départ : <strong>{df$time_depart[3]}</strong><br/>Dernier départ : <strong>{df$DerDep[3]}</strong><br/>{df$VilleDep[3]}, {df$LieuDepFR[3]}'),
  arr = glue('Première arrivée : <strong>{df$time_arrivee[3]}</strong><br/>Dernière arrivée : <strong>{df$DerArr[3]}</strong><br/>{df$VilleArr[3]}, {df$LieuArrFR[3]}')
) %>% 
  bind_rows(dff,.)


# Jeudi PM 
dff <- tibble(
  date =  glue('{dates_prog[5]} (PM)<br/><br/><strong>Étape 4 (demi-étape)</strong>'),
  presente  =  glue('<img src="../img/logo/comm_4.png" width="100">'),
  epreuve =  glue('<strong>Route</strong><br/>{df$VilleDep[4]} - {df$Via[4]} - {df$VilleArr[4]}<br/>Distance : {df$Descr_km[4]}<br/>({df$KM_Neutres[4]} km neutralisés au départ)'), 
  dep = glue('<strong>{df$time_depart[4]}</strong><br/>{df$VilleDep[4]}, {df$LieuDepFR[4]}'),
  arr = glue('<strong>{df$time_arrivee[4]}</strong><br/>{df$VilleArr[4]}, {df$LieuArrFR[4]}')
) %>% 
  bind_rows(dff,.)


# Vendredi 
dff <- tibble(
  date =  glue('{dates_prog[6]}<br/><br/><strong>Étape 5</strong>'),
  presente  =  glue('<img src="../img/logo/comm_5.png" width="100">'),
  epreuve =  glue('<strong>Route</strong><br/>{df$VilleDep[5]} &#8634; {df$VilleArr[5]}<br/> {df$Via[5]}<br/>Distance : {df$Descr_km[5]}<br/>({df$KM_Neutres[5]} km neutralisés au départ)'), 
  dep = glue('<strong>{df$time_depart[5]}</strong><br/>{df$VilleDep[5]}, {df$LieuDepFR[5]}'),
  arr = glue('<strong>{df$time_arrivee[5]}</strong><br/>{df$VilleArr[5]}, {df$LieuArrFR[5]}')
) %>% 
  bind_rows(dff,.)


# Samedi
dff <- tibble(
  date =  glue('{dates_prog[7]}<br/><br/><strong>Étape 6</strong>'),
  presente  =  glue('<img src="../img/logo/comm_6.png" width="100">'),
  epreuve =  glue('<strong>Route</strong><br/>{df$VilleDep[6]} &#8635; {df$VilleArr[6]}<br/>{df$Via[6]} <br/>Distance : {df$Descr_km[6]}<br/>({df$KM_Neutres[6]} km neutralisés au départ)'), 
  dep = glue('<strong>{df$time_depart[6]}</strong><br/>{df$VilleDep[6]}, {df$LieuDepFR[6]}'),
  arr = glue('<strong>{df$time_arrivee[6]}</strong><br/>{df$VilleArr[6]}, {df$LieuArrFR[6]}')
) %>% 
  bind_rows(dff,.)

# Dimanche
dff <- tibble(
  date =  glue('{dates_prog[8]}<br/><br/><strong>Étape 7</strong>'),
  presente  =  glue('<img src="../img/logo/comm_7.png" width="100">'),
  epreuve =  glue('<strong>Route</strong><br/>{df$VilleDep[7]} - {df$VilleArr[7]}<br/>{df$Via[7]}<br/>Distance : {df$Descr_km[7]}<br/>({df$KM_Neutres[7]} km neutralisés au départ)'), 
  dep = glue('<strong>{df$time_depart[7]}</strong><br/>{df$VilleDep[7]}, {df$LieuDepFR[7]}'),
  arr = glue('Entrée en ville : <br/><strong>{df$HeureEntreeVille[7]}</strong> <br/>Arrivée finale : <br/><strong>{df$time_arrivee[7]}</strong><br/>{df$VilleArr[7]}, {df$LieuArrFR[7]}')
) %>% 
  bind_rows(dff,.)



#########################################################################################

#########################################################################################

# Langue
lang <- "EN"

# Création du tibble #