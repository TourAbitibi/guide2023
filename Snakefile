# Commande pour sortir le dag
# snakemake --dag | dot -Tpng > dag.png
#
# Pour forcer seulement la création du livre : (tag -R pour 1 rule, -F pour tout)
# snakemake -c1 -R R4_render_book
#

rule Z_targets:
    input:
        "git_book/_book/index.html",
        "/Volumes/web/guide/FR/index.html",
        "homepage/index.html",
        "homepage/index.Rmd",
        "resume_prog/prog.Rmd",
        "resume_prog/prog.html",
        "web/index.html",
        "web/prog/index.html",
        "web/FR/index.html",

        "git_book/index.Rmd",
        "rmd/MotsBienvenue.Rmd",
        "rmd/Programmation.Rmd",
        "rmd/CO.Rmd",
        "rmd/FeuillesRoute.Rmd",
        "rmd/Etape1.Rmd",
        "rmd/Etape2.Rmd",
        "rmd/Reglements.Rmd",
        "rmd/CarteAbitibi.Rmd",
        "rmd/Regl_sejour.Rmd",
        "rmd/Locaux.Rmd",
        "rmd/Repas.Rmd",
        "rmd/MedMasso.Rmd",
        "rmd/CirculationCourse.Rmd",

        "elevParcours/elev_parcours.csv",

        "guide_FR_PDF/details/tableau_1.pdf",
        "guide_EN_PDF/details/tableau_1.pdf",

        "excel/Itineraires.xlsx",
        "excel/feuilleroute.xlsx",
        "excel/staff.xlsx",
        "excel/repas.xlsx",
        "excel/locaux.xlsx",
        "excel/med_masso.xlsx",
        "excel/prix.xlsx",

        "gpx/input/Course_1.gpx",
        "gpx/input/Course_2.gpx",
        "gpx/input/Course_3.gpx",
        "gpx/input/Course_4.gpx",
        "gpx/input/Course_5.gpx",
        "gpx/input/Course_6.gpx",
        "gpx/input/Course_7.gpx",

        "gpx/output/parcours.shp", "gpx/output/parcours.dbf",
        "gpx/output/parcours.prj", "gpx/output/parcours.shx",

        "rasterElevation/elv_parcours.tif"

    output:
        "dag.png"
    shell:
        "snakemake --dag | dot -Tpng > dag.png"


##########################################################################################################################

rule R1_importExportGPX:
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


# Rule partiellement en pause pendant création !!!!

rule R2_elv_parcours:
    input:
        "code/_elv_parcours.R"  # ,   ## pose pendant la pédiode de test
        # "gpx/output/parcours.shp"

    output:
        "rasterElevation/elv_parcours.tif"
    params:
        script = "code/_elv_parcours.R"
    shell:
        """ 
        {params.script}
        """


# Rule partiellement en pause pendant création !!!!

rule R3_importExportElevation:
    input:
        "code/_importExportElevation.R",
        "rasterElevation/elv_parcours.tif"  # ,   ## pose pendant la pédiode de test
        # "gpx/output/parcours.shp"

    output:
        "elevParcours/elev_parcours.csv"
    params:
        script = "code/_importExportElevation.R"
    shell:
        """ 
        {params.script}
        """


rule R4_render_book:
    input:
        "gpx/output/parcours.shp",

        "elevParcours/elev_parcours.csv",

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
        "rmd/Etape1.Rmd",
        "rmd/Etape2.Rmd",
        "rmd/Reglements.Rmd",
        "rmd/CirculationCourse.Rmd",
        "rmd/Regl_sejour.Rmd",
        "rmd/Repas.Rmd",
        "rmd/MedMasso.Rmd",
        "rmd/Locaux.Rmd",
        "rmd/CarteAbitibi.Rmd"
    output:
        "git_book/_book/index.html",
        "web/FR/index.html"
    params:
        guide_path = "git_book",
        lang = "FR"
    shell:
        """
        Rscript -e "bookdown::render_book('{params.guide_path}')"

        # Si les fichiers existent dans le dossier web
        if ls web/{params.lang}/* 1> /dev/null 2>&1; 
        then
            echo "~~ fichiers existants à effacer dans le dossier web ~~ \n" &
            rm -rf web/{params.lang}
        fi

        # Créer les fichiers
        mkdir -p web/{params.lang} web/img

        # Copier les données html
        cp -R {params.guide_path}/_book/* web/{params.lang}

        # Copier les images
        #cp -R {params.guide_path}/img/* web/img
        cp -R img/* web/img

        echo "\nGuide disponible au : /Users/brunogauthier/Documents/guide2023/web/{params.lang}/index.html\n"
        """


rule R5_render_homepage:
    input:
        "homepage/index.Rmd",
    output:
        "homepage/index.html",
        "web/index.html"
    params:
        "homepage/index.html"
    shell:
        """
        Rscript -e "rmarkdown::render('{input}')"
        echo "\n  ~~ Copie vers dossier web local ~~ \n"
        mkdir -p web
        cp -R {params} web
        """

rule R6_render_prog_prelim:
    input:
        "excel/Itineraires.xlsx",
        "gpx/output/parcours.shp",
        "resume_prog/prog.Rmd"
    output:
        local = "resume_prog/prog.html",
        web = "web/prog/index.html"
    params:
        "resume_prog/prog.Rmd"
    shell:
        """
        Rscript -e "rmarkdown::render('{params}')"
        echo "\n  ~~ Copie vers dossier web local ~~ \n"
        mkdir -p web/prog
        cp -R {output.local} {output.web}
        cp -R resume_prog/prog_files web/prog/
        """

# à modifier : je peux simplement copier le contenu du fichier web
# 2e script vers une copie du dossier web à l'extérieur : 2e repo public qui ne contiendrait que le site web ?

# Création des tableaux pdf individuels qui servent à créer les guides papier
## En pause pendant création
# rule R7_creationTableauxDetails:
#     input:
#         "code/_import_itineraire.R",
#         "code/_creationTableauxDetails.R",
#         "excel/Itineraires.xlsx"
#     output:
#         "guide_FR_PDF/details/tableau_1.pdf",
#         "guide_EN_PDF/details/tableau_1.pdf"
#     params:
#         script = "code/_creationTableauxDetails.R"
#     shell:
#         """ 
#         {params.script}
#         """

rule R_NAS_copy:
    input:
        "homepage/index.html",
        "resume_prog/prog.html",
        "git_book/_book/index.html"
    output:
        "/Volumes/web/guide/index.html",
        "/Volumes/web/guide/prog/index.html",
        "/Volumes/web/guide/FR/index.html"
    params:
        home_page = "homepage/index.html",
        prog_prelim = "resume_prog/prog.html",
        prog_prelim_files = "resume_prog/prog_files",
        script_export_gitbook = "script/script_export_guide.sh"
    shell:
        """
        echo "\n  ~~ Copie vers NAS ~~ \n"

        # Transfert page d'accueil temporaire
        mkdir -p /Volumes/web/guide /Volumes/web/guide/prog/
        cp -R {params.home_page} /Volumes/web/guide

        # Transfert programmation préliminaire
        cp -R {params.prog_prelim} /Volumes/web/guide/prog/index.html
        cp -R {params.prog_prelim_files} /Volumes/web/guide/prog/

        # Transfert git_book vers NAS - Francais
        sh {params.script_export_gitbook} git_book FR

        """
