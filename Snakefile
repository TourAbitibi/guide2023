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

        "git_book/index.Rmd", "rmd/Etape1.Rmd", "rmd/Etape2.Rmd", "rmd/Reglements.Rmd",

        "elevParcours/elev_parcours.csv",

        "excel/Itineraires.xlsx",

        "gpx/input/Tour2022_1.gpx", "gpx/input/Tour2022_2.gpx", "gpx/input/Tour2022_3.gpx", "gpx/input/Tour2022_4.gpx",
        "gpx/input/Tour2022_5.gpx", "gpx/input/Tour2022_6.gpx", "gpx/input/Tour2022_7.gpx",

        "gpx/output/parcours.shp", "gpx/output/parcours.dbf", "gpx/output/parcours.prj", "gpx/output/parcours.shx",

        "rasterElevation/elv_parcours.tif"

    output:
        "dag.png"
    shell:
        "snakemake --dag | dot -Tpng > dag.png"


##########################################################################################################################

rule R1_importExportGPX:
    input:
        "code/_importExportGPX.R", "excel/Itineraires.xlsx",
        "gpx/input/Tour2022_1.gpx", "gpx/input/Tour2022_2.gpx", "gpx/input/Tour2022_3.gpx", "gpx/input/Tour2022_4.gpx",
        "gpx/input/Tour2022_5.gpx", "gpx/input/Tour2022_6.gpx", "gpx/input/Tour2022_7.gpx"
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
        "script/render_book.R",
        "git_book/_bookdown.yml", 
        "git_book/_output.yml",
        "git_book/index.Rmd",
        "rmd/Etape1.Rmd",
        "rmd/Etape2.Rmd",
        "rmd/Reglements.Rmd"
    output:
        "git_book/_book/index.html"
    params:
        script = "script/render_book.R",
        guide_path = "git_book"
    shell:
        """
        {params.script} --path {params.guide_path} 
        """

rule R5_export_book_nas:
    input:
        script = "script/script_export_guide.sh",
        index = "git_book/_book/index.html"
    output:
        "/Volumes/web/guide/FR/index.html"
    params:
        guide_path = "git_book",
        lang = "FR"
    shell:
        """
        sh {input.script} {params.guide_path} {params.lang}
        """
