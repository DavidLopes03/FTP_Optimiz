# Fiches d'examen — Optimisation

Fiches de révision en Typst. Un fichier par algorithme, assemblés dans `main.typ`.

## Ajouter une fiche

1. Créer le fichier (ex. `tabou.typ`), commencer par :

```typst
   #import "preambule.typ": *

   == Titre de l'algorithme
```

2. L'inclure dans `main.typ` :

```typst
   #include "tabou.typ"
```

## Blocs disponibles

- `#def(titre: "But")[ ... ]` — encadré
- `#formule($ ... $, note: [ ... ])` — formule + note
- `#piege[ ... ]` — encadré « Piège »
- `#slide("5-11")` — référence slides
- `#pseudo[ ... ]` avec `#kw("si")` — pseudocode
- `#deuxcol(a, b)` — deux colonnes
- `#coursimg("images/x.png", [légende])` — image
- `#etapes[ #etape("...")[ ... ] ]` — étapes numérotées

Style et couleurs : dans `preambule.typ`.