# Améliorations site web pour 2024

## Structure dossier

- Changer la structure du site web pour qu'il soit entièrement dans un fichier `guide2024`plutôt qu'à `root`. Par la suite, on peut bâtir la page à partir de ce dossier directement.
- Cela facilitera le rsync local et conservera tout ce qui est site web au même endroit.
- Facilitera le déploiement github-pages ? Pas besoin d'essayer de compiler tout ?

## Déploiement github

- Faire le deploy sur une branche particulière ? Pour éviter de faire la mise à jour à tout push ?

## Adresse

- Trouver le moyen de faire une redirection `cname`fonctionnelle avec https://guide.tourabitibi.com

## Guide Sprint

- Créer un site simple pour le guide Sprint, un peu comme la page de programmation (one-pager).


## Noms des fichiers html

> For chapter and section, the HTML filenames will be determined by the header identifiers, e.g., the filename for the first chapter with a chapter title # Introduction will be introduction.html by default. For chapter+number and section+number, the chapter/section numbers will be prepended to the HTML filenames, e.g., 1-introduction.html and 2-1-literature.html. The header identifier is automatically generated from the header text by default,9 and you can manually specify an identifier using the syntax {#your-custom-id} after the header text, e.g.,
> # An Introduction {#introduction}
> The default identifier is `an-introduction` but we changed
it to `introduction`.