#import "preambule.typ": *
== Problèmes à satisfaction de contraintes (PSC)
#def(titre: "But")[
  Modéliser un problème de décision sous forme générique (variables, domaines,
  contraintes) pour le résoudre avec des algorithmes universels, indépendants
  de la signification du problème.
]
#def(titre: "Principe")[
  Affecter une valeur à chaque variable, prise dans son domaine, sans violer
  aucune contrainte. Une affectation complète qui respecte toutes les
  contraintes est une #text(weight: "bold")[solution].
]
=== Formalisme
#deuxcol(
  [
    - $X_1, ..., X_n$ : variables (inconnues)
    - $D_i$ : domaine de $X_i$ (valeurs possibles, fini)
    - $A$ : affectation courante ${X_1 <- v_1, ..., X_k <- v_k}$
  ],
  [
    - $C_1, ..., C_p$ : contraintes (combinaisons de valeurs permises)
    - $k$ : nb de variables affectées ($0 <= k <= n$)
    - $d$ : taille des domaines
  ],
)
- $A$ #text(weight: "bold")[valide] : aucune contrainte violée par les variables affectées de $A$.
- #text(weight: "bold")[PSC binaire] : toute $C_k$ lie au plus 2 variables $arrow$ #text(weight: "bold")[graphe de contraintes] (nœud = variable, arête = contrainte).

=== Backtracking
#def[
  Recherche en profondeur : on affecte les variables une par une. Si l'on ne
  peut plus affecter de valeur valide (en fonction de la contrainte) à une variable, on #text(weight: "bold")[revient
  en arrière] sur la précédente pour essayer sa valeur suivante.
]


=== Forward checking
#def[

]


=== Heuristiques
- #text(weight: "bold")[Variable la plus contrainte] : affecter d'abord celle au plus petit domaine restant (minimise le facteur de branchement).
- #text(weight: "bold")[Variable la plus contraignante] : à égalité, celle liée au plus de contraintes sur des variables non affectées.
- #text(weight: "bold")[Valeur la moins contraignante] : essayer d'abord la valeur qui retire le moins d'options aux variables voisines.

=== Complexité
- $O(d^n)$ affectations complètes : recherche exhaustive irréaliste.
- Backtracking + forward checking + heuristiques rendent la recherche praticable.