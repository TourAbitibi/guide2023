# Commande pour sortir le dag
# snakemake --dag | dot -Tpng > dag.png
#
# Pour forcer seulement la création du livre : (tag -R pour 1 rule, -F pour tout)
# snakemake -c1 -R R51_render_book
#

# Attention : l'output est effacé lors du démarrage de la règle
# Par exemele, elv_parcours.tif

rule Z_targets:
    input:
        "git_book/_book/index.html",
        "git_book_EN/_book/index.html",
        "git_book_organisateur/_book/index.html",
        "homepage/index.html",
        "homepage/index.Rmd",
        "resume_prog/prog.Rmd",
        "resume_prog/prog.html",
        "index.html",
        "prog/index.html",
        "organisateur/index.html",
        "FR/index.html",
        "EN/index.html",

        "git_book/index.Rmd",
        "git_book_EN/index.Rmd",
        "git_book_organisateur/index.Rmd",
        "rmd/MotsBienvenue.Rmd",
        "rmd/MotsBienvenue_EN.Rmd",
        "rmd/Programmation.Rmd",
        "rmd/Programmation_EN.Rmd",
        "code/programmation.R",
        "rmd/CO.Rmd",
        "rmd/FeuillesRoute.Rmd",
        "rmd/Etape1_EN.Rmd", "rmd/Etape2_EN.Rmd", "rmd/Etape3_EN.Rmd", "rmd/Etape4_EN.Rmd", "rmd/Etape5_EN.Rmd", "rmd/Etape6_EN.Rmd", "rmd/Etape7_EN.Rmd",
        "rmd/Etape1.Rmd", "rmd/Etape2.Rmd", "rmd/Etape3.Rmd", "rmd/Etape4.Rmd", "rmd/Etape5.Rmd", "rmd/Etape6.Rmd", "rmd/Etape7.Rmd",
        "rmd/Reglements.Rmd",
        "rmd/Reglements_EN.Rmd",
        "rmd/CarteAbitibi.Rmd",
        "rmd/Regl_sejour.Rmd",
        "rmd/Regl_sejour_EN.Rmd",
        "rmd/Locaux.Rmd",
        "rmd/CLMI_notes.Rmd",
        "rmd/Sites.Rmd",
        "rmd/FollowMee.Rmd",
        "rmd/ardoise.Rmd",
        "rmd/Repas.Rmd",
        "rmd/MedMasso.Rmd",
        "rmd/MedMasso_EN.Rmd",
        "rmd/CirculationCourse.Rmd",
        "rmd/CirculationCourse_EN.Rmd",

        "elevParcours/elev_parcours.csv",

        "img/cartes/input/Etape1_Full.png",
        "img/elev/Etape1_Full_FR.png",
        "img/elev/Etape1_Full_EN.png",
        "img/cartes/sign/E1_sign_01.png",

        "excel/Itineraires.xlsx",
        "excel/signalisation.xlsx",
        "excel/feuilleroute.xlsx",
        "excel/staff.xlsx",
        "excel/repas.xlsx",
        "excel/locaux.xlsx",
        "excel/med_masso.xlsx",
        "excel/prix.xlsx",
        "excel/ardoise_info.xlsx",

        "gpx/input/Course_1.gpx",
        "gpx/input/Course_2.gpx",
        "gpx/input/Course_3.gpx",
        "gpx/input/Course_4.gpx",
        "gpx/input/Course_5.gpx",
        "gpx/input/Course_6.gpx",
        "gpx/input/Course_7.gpx",

        "gpx/input/Signalisation_1.gpx",
        "gpx/input/Signalisation_2.gpx",
        "gpx/input/Signalisation_3.gpx",
        "gpx/input/Signalisation_7.gpx",

        "gpx/output/parcours.shp", "gpx/output/parcours.dbf", "gpx/output/parcours.prj", "gpx/output/parcours.shx",
        "gpx/output/points_parcours.shp", "gpx/output/points_parcours.dbf", "gpx/output/points_parcours.prj", "gpx/output/points_parcours.shx",
        "gpx/output/points_signalisation.shp", "gpx/output/points_signalisation.dbf", "gpx/output/points_signalisation.prj", "gpx/output/points_signalisation.shx",

        "rasterElevation/elv_parcours.tif"

    output:
        "dag.png"
    shell:
        """
        snakemake -s Snakefile --dag | dot -Tpng > dag.png

        echo "\n  ~~ Rsync vers PVE1 ~~ \n"

        rsync -avhP img/* bruno@192.168.101.120:/home/bruno/guide_web/guide/img/ --delete-after
        rsync -avhP FR/* bruno@192.168.101.120:/home/bruno/guide_web/guide/FR/ --delete-after
        rsync -avhP EN/* bruno@192.168.101.120:/home/bruno/guide_web/guide/EN/ --delete-after
        rsync -avhP prog/* bruno@192.168.101.120:/home/bruno/guide_web/guide/prog/ --delete-after
        rsync -avhP organisateur/* bruno@192.168.101.120:/home/bruno/guide_web/guide/organisateur/ --delete-after
        rsync -avhP index.html bruno@192.168.101.120:/home/bruno/guide_web/guide/index.html

	    echo "\n  ~~ Fin de la synchronisation ~~ \n"

        """



##########################################################################################################################
##########################################################################################################################
#
# Préparations des données parcours
#
##########################################################################################################################
##########################################################################################################################


rule R01_importExportGPX:
    input:
        "code/_importExportGPX.R", "excel/Itineraires.xlsx",
        "gpx/input/Course_1.gpx", "gpx/input/Course_2.gpx", "gpx/input/Course_3.gpx", "gpx/input/Course_4.gpx",
        "gpx/input/Course_5.gpx", "gpx/input/Course_6.gpx", "gpx/input/Course_7.gpx"
    output:
        "gpx/output/parcours.shp", "gpx/output/parcours.dbf", "gpx/output/parcours.prj", "gpx/output/parcours.shx"
    params:
        script = "code/_importExportGPX.R"
    shell:
        """ 
        {params.script}
        """



rule R02_elv_parcours:
    input:
        "code/_elv_parcours.R"  # ,   ## pose pendant la pédiode de test
        #"gpx/output/parcours.shp"

    output:
        "rasterElevation/elv_parcours.tif"
    params:
        script = "code/_elv_parcours.R"
    shell:
        """ 
        {params.script}
        """



rule R03_importExportElevation:
    input:
        "code/_importExportElevation.R",
        "rasterElevation/elv_parcours.tif"  # ,   ## pose pendant la pédiode de test
        #"gpx/output/parcours.shp"

    output:
        "elevParcours/elev_parcours.csv"
    params:
        script = "code/_importExportElevation.R"
    shell:
        """ 
        {params.script}
        """

##########################################################################################################################
##########################################################################################################################
#
# Préparations des cartes statiques et profil élévation
#
##########################################################################################################################
##########################################################################################################################

# Création des cartes statiques (full, départ, arrivée) et réduction de leur taille
# En pause pendant création
# rule R11_creationCartesStatiques:
#     input:
#         "code/_import_itineraire.R",
#         "code/CartesStatiques.R",
#         "excel/Itineraires.xlsx",
#         "gpx/output/parcours.shp"

#     output:
#         "img/cartes/input/Etape1_Full.png"
#     params:
#         script = "code/CartesStatiques.R"
#     shell:
#         """
#         echo "n  ~~ Création des cartes statiques ~~ \n"
#         {params.script}
#         echo "\n  ~~ Préparation des cartes statiques png de taille réduite ~~ \n"
#         optipng img/cartes/input/* -dir img/cartes/input/ -o1 -clobber -force -silent
#         echo "\n  ~~ Fin de l'optimisation des cartes statiques png ~~ \n"
#         """


# Création des graphiques d'élévation
# En pause pendant création
# rule R12_creationGraphElevation:
#     input:
#         "code/graphique_denivele.R",
#         "excel/Itineraires.xlsx",
#         "gpx/output/parcours.shp",
#         "rasterElevation/elv_parcours.tif",
#         "elevParcours/elev_parcours.csv"

#     output:
#         "img/elev/Etape1_Full_FR.png"
#     params:
#         script = "code/graphique_denivele.R"
#     shell:
#         """
#         echo "\n   ~~ Création des graphiques d'élévation ~~ \n"
#         {params.script}
#         """

##########################################################################################################################
##########################################################################################################################
#
# Préparations des données de signalisation
#
##########################################################################################################################
##########################################################################################################################



rule R31_importExportGPX_Signalisation:
    input:
        "code/_importExportGPX_Signalisation.R", "excel/Itineraires.xlsx", "excel/signalisation.xlsx",
        "gpx/input/Signalisation_1.gpx", "gpx/input/Signalisation_2.gpx"
    output:
        "gpx/output/points_signalisation.shp", "gpx/output/points_signalisation.dbf", "gpx/output/points_signalisation.prj", "gpx/output/points_signalisation.shx"
    params:
        script = "code/_importExportGPX_Signalisation.R"
    shell:
        """ 
        {params.script}
        """

rule R32_creationVignetteSignalisation:
    input:
        "code/_importExportGPX_Signalisation.R",
        "code/CartesStatiquesSignalisation.R",
        "excel/signalisation.xlsx",
        "gpx/output/points_signalisation.shp",
        "gpx/output/points_signalisation.dbf"
    output:
        "img/cartes/sign/E1_sign_01.png"
    params:
        script = "code/CartesStatiquesSignalisation.R"
    shell:
        """
        echo "n  ~~ Création des cartes statiques de signalisation (vignettes) ~~ \n"
        {params.script}
        echo "\n  ~~ Préparation des cartes statiques de signalisation png de taille réduite ~~ \n"
        optipng img/cartes/sign/*.png -dir img/cartes/sign/ -o1 -clobber -force
        echo "\n  ~~ Fin de l'optimisation des cartes de signalisation png ~~ \n"
        """



##########################################################################################################################
##########################################################################################################################
#
# Création des pages
#
##########################################################################################################################
##########################################################################################################################

rule R50_render_book_EN:
    input:
        "code/programmation.R",

        "gpx/output/parcours.shp",

        "img/cartes/input/Etape1_Full.png",

        "elevParcours/elev_parcours.csv",
        "img/elev/Etape1_Full_EN.png",

        "excel/staff.xlsx",
        "excel/Itineraires.xlsx",
        "excel/feuilleroute.xlsx",
        "excel/repas.xlsx",
        "excel/locaux.xlsx",
        "excel/prix.xlsx",
        "excel/med_masso.xlsx",

        "script/render_book.R",
        "git_book_EN/_bookdown.yml",
        "git_book_EN/_output.yml",

        "git_book_EN/index.Rmd",
        "rmd/MotsBienvenue_EN.Rmd",
        "rmd/Programmation_EN.Rmd",
        "rmd/CO.Rmd",
        "rmd/FeuillesRoute_EN.Rmd",
        "rmd/Etape1_EN.Rmd", "rmd/Etape2_EN.Rmd", "rmd/Etape3_EN.Rmd", "rmd/Etape4_EN.Rmd", "rmd/Etape5_EN.Rmd", "rmd/Etape6_EN.Rmd", "rmd/Etape7_EN.Rmd",
        "rmd/Reglements_EN.Rmd",
        "rmd/CirculationCourse_EN.Rmd",
        "rmd/Regl_sejour_EN.Rmd",
        "rmd/Repas.Rmd",
        "rmd/MedMasso_EN.Rmd",
        "rmd/Locaux.Rmd",
        "rmd/CarteAbitibi.Rmd"
    output:
        "git_book_EN/_book/index.html",
        "EN/index.html"
    params:
        guide_path = "git_book_EN",
        lang = "EN"
    shell:
        """
        Rscript -e "bookdown::render_book('{params.guide_path}')"

        # Copier les données html
        cp -R {params.guide_path}/_book/* {params.lang}

        echo "\nGuide disponible au : /Users/brunogauthier/Documents/guide2023/{params.lang}/index.html\n"
        """


rule R51_render_book:
    input:
        "code/programmation.R",

        "gpx/output/parcours.shp",

        "img/cartes/input/Etape1_Full.png",

        "elevParcours/elev_parcours.csv",
        "img/elev/Etape1_Full_FR.png",

        "excel/staff.xlsx",
        "excel/Itineraires.xlsx",
        "excel/feuilleroute.xlsx",
        "excel/repas.xlsx",
        "excel/locaux.xlsx",
        "excel/prix.xlsx",
        "excel/med_masso.xlsx",

        "script/render_book.R",
        "git_book/_bookdown.yml",
        "git_book/_output.yml",

        "git_book/index.Rmd",
        "rmd/MotsBienvenue.Rmd",
        "rmd/Programmation.Rmd",
        "rmd/CO.Rmd",
        "rmd/FeuillesRoute.Rmd",
        "rmd/Etape1.Rmd", "rmd/Etape2.Rmd", "rmd/Etape3.Rmd", "rmd/Etape4.Rmd", "rmd/Etape5.Rmd", "rmd/Etape6.Rmd", "rmd/Etape7.Rmd",
        "rmd/Reglements.Rmd",
        "rmd/CirculationCourse.Rmd",
        "rmd/Regl_sejour.Rmd",
        "rmd/Repas.Rmd",
        "rmd/MedMasso.Rmd",
        "rmd/Locaux.Rmd",
        "rmd/CarteAbitibi.Rmd"
    output:
        "git_book/_book/index.html",
        "FR/index.html"
    params:
        guide_path = "git_book",
        lang = "FR"
    shell:
        """
        Rscript -e "bookdown::render_book('{params.guide_path}')"

        # Copier les données html
        cp -R {params.guide_path}/_book/* {params.lang}

        echo "\nGuide disponible au : /Users/brunogauthier/Documents/guide2023/{params.lang}/index.html\n"
        """


rule R52_render_homepage:
    input:
        "homepage/index.Rmd",
    output:
        "homepage/index.html",
        "index.html"

    params:
        "homepage/index.html"
    shell:
        """
        Rscript -e "rmarkdown::render('{input}')"

        echo "\n  ~~ Copie index acceuil vers dossier local ~~ \n"
        
        cp -R {params} index.html
        """


rule R53_render_prog_prelim:
    input:
        "excel/Itineraires.xlsx",
        "gpx/output/parcours.shp",
        "resume_prog/prog.Rmd",
        "elevParcours/elev_parcours.csv"
    output:
        local = "resume_prog/prog.html",
        web = "prog/index.html"
    params:
        "resume_prog/prog.Rmd"
    shell:
        """
        Rscript -e "rmarkdown::render('{params}')"

        echo "\n  ~~ Copie programmation préliminaire vers dossier web local ~~ \n"

        cp -R {output.local} {output.web}
        cp -R resume_prog/prog_files prog/
        """


rule R54_render_book_organisateur:
    input:
        "code/programmation.R",

        "gpx/output/parcours.shp",
        "gpx/output/points_signalisation.shp", "gpx/output/points_signalisation.dbf", "gpx/output/points_signalisation.prj", "gpx/output/points_signalisation.shx",

        "img/cartes/input/Etape1_Full.png",
        "img/cartes/sign/E1_sign_01.png",

        "excel/staff.xlsx",
        "excel/Itineraires.xlsx",
        "excel/feuilleroute.xlsx",
        "excel/repas.xlsx",
        "excel/locaux.xlsx",
        "excel/signalisation.xlsx",
        "excel/ardoise_info.xlsx",

        "script/render_book.R",
        "git_book_organisateur/_bookdown.yml",
        "git_book_organisateur/_output.yml",

        "git_book_organisateur/index.Rmd",
        "rmd/MotsBienvenue.Rmd",
        "rmd/Programmation.Rmd",
        "rmd/CO.Rmd",
        "rmd/FeuillesRoute.Rmd",
        "rmd/Etape1.Rmd", "rmd/Etape2.Rmd", "rmd/Etape3.Rmd", "rmd/Etape4.Rmd", "rmd/Etape5.Rmd", "rmd/Etape6.Rmd", "rmd/Etape7.Rmd",
        "rmd/CLMI_notes.Rmd",
        "rmd/BoucleSignalisation.Rmd",
        "rmd/Signalisation_Details.Rmd",
        "rmd/Sites.Rmd",
        "rmd/FollowMee.Rmd",
        "rmd/ardoise.Rmd",
        "rmd/Reglements.Rmd",
        "rmd/CirculationCourse.Rmd",
        "rmd/Repas.Rmd",
        "rmd/Locaux.Rmd"
    output:
        "git_book_organisateur/_book/index.html",
        "organisateur/index.html"
    params:
        guide_path = "git_book_organisateur"
    shell:
        """
        Rscript -e "bookdown::render_book('{params.guide_path}')"

        # Copier les données html
        cp -R {params.guide_path}/_book/* organisateur

        echo "\nGuide d'organisateur disponible au : /Users/brunogauthier/Documents/guide2023/organisateur/index.html\n"
        """
