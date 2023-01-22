# Notes Bruno - divers

source("code/_LibsVars.R")

df_test <- tribble(
  ~a, ~b, ~c,
  1, 2, 3,
  4, 5, 6,
  7, 8, 9,
  10,11,12,
  13,14,15,
  16,17,18,
  19,20,21
)

## Case_when
df_test %>% 
mutate(
  chiffre = case_when(a == 1 ~ "un",
                  a == 4 ~ "quatre",
                  a== 6  ~ "six",
                  TRUE ~ NA_character_)
)

################################################################################

# Gestion des dates
## https://www.stat.berkeley.edu/~s133/dates.html 


## Pour construire le site web

## bookdown::render_book("bs4_book")
## bookdown::render_book("git_book")

################################################################################

# git branch issue_X
# git checkout issue_X

## a valider
# git commit -m ' xxxxx closes #1'  (https://stackoverflow.com/questions/60027222/github-how-can-i-close-the-two-issues-with-commit-message)
# git checkout main
# git merge issue_x
# git status
# git push
#
