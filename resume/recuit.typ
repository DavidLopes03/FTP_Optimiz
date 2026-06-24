#import "preambule.typ": *
== Algorithme du recuit simulé

#def(titre: "But")[
  Minimise la fonction coût $C$ sur un ensemble de solutions trop grand pour
  être énuméré.
]

#def(titre: "Principe")[
  Tient une seule solution à la fois et l'améliore par essais successifs.
  Avance par petite modification de la solution. Tolère des dégradations pour
  éviter les minima locaux : grande tolérance au début, puis diminuée.
]

=== Formalisme

#etapes[
  #etape("Tirer un voisin")[
    Tirer une nouvelle solution $Y$ dans le voisinage $cal(N)(x)$ de la
    solution courante $x$.
  ]
  #etape("Tester")[
    $ Delta E = C(Y) - C(x) quad cases(> 0 #h(4pt) "dégradation", < 0 #h(4pt) "amélioration") $
  ]
  #etape("Probabilité d'accepter une dégradation")[
    $ p = exp(- Delta E / T) $
    $p ≈ 0 →$ souvent rejeté #h(8pt) $p ≈ 1 →$ souvent accepté.
    $T$ : tolérance.
  ]
  #etape("Baisser la tolérance")[
    $ T_(n+1) = alpha dot T_n, quad 0 < alpha < 1 $
  ]
]

=== Pseudocode

#pseudo[
  #kw("X")  ← solution de départ \
  #kw("X\*") ← X #h(2cm) // meilleure solution rencontrée \
  #kw("T")  ← T0 \
  \
  #kw("répéter") \
  #h(1em) Y  ← tirer un voisin de X au hasard \
  #h(1em) ΔE ← C(Y) − C(X) \
  \
  #h(1em) #kw("si") ΔE ≤ 0 : \
  #h(2em) X ← Y #h(2.2cm) // amélioration : acceptée \
  #h(1em) #kw("sinon") : \
  #h(2em) tirer μ au hasard dans \[0,1\] \
  #h(2em) #kw("si") μ < exp(−ΔE/T) : \
  #h(3em) X ← Y #h(1.5cm) // dégradation : acceptée \
  \
  #h(1em) #kw("si") C(X) < C(X\*) : \
  #h(2em) X\* ← X \
  \
  #h(1em) T ← α·T \
  #kw("jusqu'à") T = 0 \
  \
  #kw("retourner") X\*
]

=== Cas d'utilisation

- Placement de composants sur circuit / FPGA (minimiser longueur des fils).
- Problème de l'affectation quadratique (QAP).
- Problème des horaires (contraintes ajoutables à tout moment).

=== Avantages / Inconvénients

#deuxcol(
  [
    *Avantages*
    - Solutions de bonne qualité
    - Méthode générale (tout problème dont $C$ est évaluable, voisinage connexe)
    - Facile à programmer
    - Convergence prouvée vers l'optimum si refroidissement assez lent
  ],
  [
    *Inconvénients*
    - Temps de calcul : solution exacte exponentielle ;
      solution approchée à 2 % en $O(N^3)$
    - Performances très sensibles au choix de $T_0$, $alpha$ et du voisinage
  ],
)

#piege[
  En minimisation, $Delta E > 0$ = dégradation. L'exponentielle ne porte que
  sur les dégradations ($Delta E ≤ 0$ acceptée d'office). $X^*$ ≠ $X$ final :
  garder le meilleur à part et le renvoyer.
]