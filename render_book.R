#!/usr/bin/env Rscript --vanilla

################################################################################

# File : render_book.R

# Obj : automatiser la création des différents guides
#       peut être appelé à partir d'un script ou au terminal
#         ---> `Rscript render_book.R`

################################################################################

## Créer site web Guide Technique Français
bookdown::render_book("git_book")


