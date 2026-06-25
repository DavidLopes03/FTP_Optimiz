#import "preambule.typ": *
#show: template

//== Algorithme de fourmis

// ============================================================
//  ALGORITHME DE FOURMIS — Fiche de résumé
// ============================================================

= Algorithme de Fourmis

== 1. Historique & Origine

#def(titre: "Origine")[
  Proposé par *Marco Dorigo et al.* dans les années *1990* pour la recherche de
  chemins optimaux dans un graphe. S'inspire du comportement des fourmis
  cherchant un chemin entre leur colonie et une source de nourriture.
]

Individuellement, les fourmis ont des capacités cognitives *limitées*, mais
collectivement elles sont capables de trouver le *chemin le plus court* entre
une source de nourriture et leur nid.

== 2. Mécanisme des phéromones

#def(titre: "Phéromone")[
  Substance odorante déposée par une fourmi sur son passage, détectable par
  les autres fourmis. Les phéromones sont *volatiles* : elles s'évaporent avec
  le temps.
]

#etapes[
  #etape("Dépôt")[Une fourmi (« éclaireuse ») explore l'environnement au hasard. Si elle
  découvre une source de nourriture, elle rentre au nid en laissant une *piste
  de phéromones*.]

  #etape("Attraction")[Les fourmis passant à proximité ont tendance à *suivre* la piste
  phéromonée et la *renforcent* en revenant au nid.]

  #etape("Sélection du plus court")[Si deux pistes existent, la plus *courte* est parcourue par
  *plus de fourmis* par unité de temps → elle accumule plus de phéromones →
  elle devient plus attractive.]

  #etape("Disparition de la longue piste")[La piste longue reçoit moins de renforcement et *disparaît* par évaporation.
  À terme, l'ensemble de la colonie converge vers le chemin le plus court.]
]

== 3. Description générale de la méthode

#def(titre: "Méta-heuristique à population")[
  Les algorithmes de colonies de fourmis sont des *algorithmes multi-agents
  probabilistes*. Chaque solution est représentée par une fourmi se déplaçant
  dans l'espace de recherche. Les fourmis marquent les *meilleures solutions*
  et tiennent compte des marquages précédents pour orienter leur recherche.
]

Les *4 éléments de base* d'un algorithme de fourmis :

+ *Représentation* appropriée du problème sous forme de graphe.
+ *Attractivité heuristique* des arêtes du graphe sous-jacent ($eta$).
+ *Règle de mise à jour* des phéromones sur les arêtes ($sigma$).
+ *Règle de transition probabiliste* fonction des phéromones et de l'attractivité heuristique.

Dans les versions adaptées aux *problèmes combinatoires*, la solution est
construite de manière *itérative*.

== 4. Application au voyageur de commerce (TSP)

=== Règles de déplacement d'une fourmi

À chaque étape, la fourmi choisit la prochaine ville selon 5 règles :

+ Elle ne peut *visiter qu'une fois* chaque ville.
+ Plus une ville est *loin*, moins elle a de chances d'être choisie (*visibilité*).
+ Plus la piste de *phéromone* sur un arc est intense, plus il est probable qu'il soit choisi.
+ Une fois son trajet terminé, la fourmi dépose *plus de phéromones* si le trajet est *court*.
+ Les pistes de phéromones *s'évaporent* à chaque itération.

=== Probabilité de transition

Probabilité d'aller du sommet $i$ au sommet $j$ pour la fourmi $k$ à l'itération $t$ :

#formule(
  note: [$J_i^k$ = sommets atteignables · $sigma_(i j)(t)$ = phéromone sur l'arc $(i,j)$ · $eta_(i j) = 1\/d_(i j)$ (visibilité) · $alpha, beta$ = paramètres d'importance]
)[
  $p_(i j)^k (t) = cases(
    display(frac(sigma_(i j)^alpha (t) \, eta_(i j)^beta, sum_(l in J_i^k) sigma_(i l)^alpha (t) \, eta_(i l)^beta)) quad & "si" j in J_i^k,
    0 & "sinon"
  )$
]

=== Quantité de phéromone déposée

#formule(
  note: [$T^k(t)$ = arcs parcourus par la fourmi $k$ · $L^k(t)$ = longueur du parcours · $Q$ = paramètre de réglage]
)[
  $Delta sigma_(i j)^k (t) = cases(
    display(Q / L^k (t)) quad & "si" (i,j) in T^k (t),
    0 & "sinon"
  )$
]

Plus le parcours est *court*, plus la quantité déposée est *importante*.

=== Mise à jour des phéromones

Sur chaque arc, on applique l'*évaporation* puis on ajoute les traces de toutes les fourmis :

#formule(
  note: [$m$ = nombre total de fourmis · $rho in ]0,1[$ = taux d'évaporation]
)[
  $sigma_(i j)(t+1) = (1 - rho) \, sigma_(i j)(t) + sum_(k=1)^m Delta sigma_(i j)^k (t)$
]

#piege[Si $rho$ est trop grand, les phéromones disparaissent trop vite → pas de mémoire collective. Si $rho$ est trop petit, l'algorithme converge prématurément vers une solution sous-optimale.]

=== Pseudo-code général

#pseudo[
  *Initialiser* les traces de phéromones $sigma_(i j) <- sigma_0$ (petites valeurs) \
  \
  *Répéter* \
  #h(1em) Sélectionner aléatoirement $K$ fourmis sur $M$ villes \
  #h(1em) *Pour* $i$ de $1$ à $M$ faire \
  #h(2em) *Pour* $j$ de $1$ à $K$ faire \
  #h(3em) Choisir la ville suivante via la règle probabiliste $p_(i j)^k (t)$ \
  #h(2em) *Fin pour* \
  #h(1em) *Fin pour* \
  #h(1em) Mettre à jour les phéromones : $sigma_(i j)(t+1) <- (1-rho) sigma_(i j)(t) + sum_k Delta sigma_(i j)^k (t)$ \
  *Jusqu'à* condition de fin (nb. d'itérations ou convergence)
]

== 5. Exemple TSP — 5 sommets

Paramètres : *4 fourmis*, $alpha = beta = 1$, $Q = 1$, $rho = 1\/2$, *8 itérations*,
phéromone initiale $= 1$ sur chaque arc, toutes les fourmis partent du sommet 1.

#deuxcol(
  [
    *Matrice des distances :*
    #table(
      columns: 6,
      fill: (x, y) => if y == 0 or x == 0 { rgb("#dde3ed") } else { white },
      [*d*],[*1*],[*2*],[*3*],[*4*],[*5*],
      [*1*],[x],[1],[2],[2],[2],
      [*2*],[1],[x],[1],[2],[2],
      [*3*],[2],[1],[x],[1],[2],
      [*4*],[2],[2],[1],[x],[10],
      [*5*],[2],[2],[2],[10],[x],
    )
  ],
  [
    *Convergence observée :*

    - *Itér. 1–3 :* Les fourmis explorent des chemins variés (longueurs entre 8 et 17).
    - *Itér. 4–6 :* Convergence progressive vers les meilleurs chemins (longueur 8–9).
    - *Itér. 7–8 :* *Toutes les fourmis* empruntent le tour optimal.

    #def(titre: "Tour optimal")[
      $1 → 2 → 5 → 3 → 4 → 1$ \
      Longueur $= bold(8)$
    ]
  ]
)

== 6. Applications & Conclusion

=== Domaines d'application

Les algorithmes de colonies de fourmis ont été appliqués à de nombreux
*problèmes d'optimisation combinatoire* :

- *Affectation quadratique* — ordonnancement, placement de circuits.
- *Repli de protéines* — bioinformatique.
- *Routage de véhicules* — logistique.
- *Routage réseau* — adaptation dynamique si le graphe change en cours d'exécution.

=== Conclusion

#def(titre: "Résumé de la méthode")[
  Un algorithme de fourmis alterne, pendant un certain nombre d'itérations,
  deux procédures :
  - *Construction/modification* de solutions par les fourmis (règle probabiliste).
  - *Mise à jour des phéromones* sur les arêtes du graphe (évaporation + dépôt).

  La *phéromone* encode la performance des solutions construites. \
  L'*heuristique locale* encode l'attractivité intrinsèque des arcs.
]
