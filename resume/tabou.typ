#import "preambule.typ": *

== Algorithme de recherche tabou

#def(titre: "But")[
  Minimise la fonction coût $C$ sur un ensemble de solutions trop grand pour
  être énuméré.
]

#def(titre: "Principe")[
  Recherche du minimum en se déplaçant à chaque itération vers le voisin de
  plus faible coût, même s'il dégrade la fonction coût (sortie d'un minimum
  local). Possède une mémoire des solutions/mouvements déjà visités pour
  éviter les retours en arrière. La meilleure solution rencontrée est
  conservée à part et renvoyée à la fin.
]

=== Formalisme

#deuxcol(
  [
    - $x$ : solution courante
    - $x^*$ : meilleure solution rencontrée
    - $C$ : fonction coût
  ],
  [
    - $N(x)$ : voisinage de $x$
    - $T$ : liste tabou (mouvements interdits)
    - $underline(N)(x)$ : voisinage non tabou
  ],
)

=== Pseudocode

#pseudo[
  #kw("x")  ← solution initiale \
  #kw("x\*") ← x #h(2cm) // meilleure solution rencontrée \
  #kw("T")  ← liste vide #h(0.8cm) // mémoire (mouvements interdits) \
  \
  #kw("tant que") critère d'arrêt non atteint : \
  #h(1em) candidats ← { voisins de x atteints par un mouvement absent de T } \
  #h(1em) x ← candidat de plus faible coût #h(0.6cm) // peut coûter plus cher que x \
  #h(1em) #kw("si") C(x) < C(x\*) : \
  #h(2em) x\* ← x \
  #h(1em) ajouter le mouvement effectué à T #h(0.6cm) // FIFO de longueur t \
  \
  #kw("retourner") x\*
]

=== Critère d'arrêt

- Solution optimale atteinte (si connue) ou valeur prédéterminée
- Nombre d'itérations (ou temps de calcul) ou nombre d'itérations sans amélioration de $x^*$

#piege[
  « Plus faible coût » = minimum sur les voisins, pas forcément inférieur à
  $C(x)$. Dans un minimum local tous les voisins sont pires : le coût remonte,
  ce qui fait sortir du minimum. La mémoire stocke les mouvements. FIFO de longueur fixe $t$.
]