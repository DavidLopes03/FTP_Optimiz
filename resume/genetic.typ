#import "preambule.typ": *

== Algorithmes génétiques

#def(titre: "But")[
  Recherche d'une bonne solution à un problème en faisant évoluer une
  population de solutions candidates sur plusieurs générations.
]

#def(titre: "Principe")[
  On part d'un ensemble de solutions tirées au hasard. À chaque itération, les
  individus les mieux notés sont conservés et combinés entre eux (croisement),
  avec quelques modifications aléatoires (mutation), pour former la génération
  suivante. La population s'améliore ainsi jusqu'à obtenir une solution
  satisfaisante. La meilleure solution rencontrée est renvoyée à la fin.
]

=== Bases biologiques

#deuxcol(
  [
    - *Hérédité* : les descendants sont similaires aux parents
    - *Sélection* : les mieux adaptés survivent
  ],
  [
    - *Variabilité* : des changements aléatoires perturbent l'hérédité et augmentent la diversité
  ],
)

=== Terminologie

#deuxcol(
  [
    - *Individu* : une solution candidate
    - *Gène* : une partie de la solution
    - *Génotype* : le codage de la solution
    - *Phénotype* : la solution réelle codée par le génotype
  ],
  [
    - *Population* : groupe de solutions testées en même temps
    - *Fitness* : fonction qui note la qualité d'un individu
  ],
)

=== Pseudocode

#pseudo[
  Population~~~: ensemble de solutions candidates \
  Individu~~~~~: une solution candidate \
  Fitness~~~~~~: fonction qui note la qualité d'un individu \
  Parents~~~~~~: individus retenus pour se reproduire \
  Descendants~: nouveaux individus issus des parents \
  \
  Population ← solutions tirées au hasard \
  noter chaque Individu avec Fitness \
  \
  répéter jusqu'à solution satisfaisante : \
  #h(1em) Parents~~~~~← les individus les mieux notés \
  #h(1em) Descendants ← crossover des Parents \
  #h(1em) Descendants ← mutation des Descendants \
  #h(1em) noter chaque Descendant avec Fitness \
  #h(1em) Population~~← Descendants \
  \
  renvoyer le meilleur Individu
]

=== Opérateurs d'évolution

#deuxcol(
  [
    *Croisement (crossover)* : combine deux parents en échangeant des segments
    de leur génotype. Opérateur d'_exploitation_ : recombine des caractères
    déjà présents dans la population.
  ],
  [
    *Mutation* : modifie aléatoirement un gène (probabilité $p_m$ par gène).
    Opérateur d'_exploration_ : indispensable pour éviter les optimums locaux.
  ],
)

#figure(image("images/ag_crossover_mutation.png", width: 60%))

=== Sélection

#def(titre: "Proportionnelle")[
  Probabilité de sélection proportionnelle à la fitness :
  $p_i = f_i \/ sum_j f_j$ (roulette biaisée). Les meilleurs ont plus de chance,
  les moins bons en conservent une (leurs gènes peuvent être utiles).
]

=== Remplacement

- *Générationnel* : toute la population est remplacée par les descendants
- *Élitisme* : conservation systématique du (des) meilleur(s) individu(s) → fitness du meilleur non décroissante

=== Critère d'arrêt

- Optimum atteint (si connu) ou valeur prédéterminée
- Limite de temps / nombre de générations
- Aucune amélioration pendant plusieurs générations

#piege[
  Sélection ≠ remplacement : la sélection choisit _qui se reproduit_, le
  remplacement choisit _qui constitue la génération suivante_. L'élitisme
  protège le meilleur mais réduit la diversité → risque de convergence
  prématurée vers un optimum local. Point clef : maintenir la diversité
  génétique, car sa perte est irréversible en pratique.
]

=== Avantages et inconvénients

#deuxcol(
  [
    *Avantages*
    - Bon rapport coût / résultat sur une grande classe de problèmes
    - Parallélisme intrinsèque
    - Robuste, tolérant aux fautes
    - Applicable sans connaissance préalable du domaine
    - Simple à programmer
  ],
  [
    *Inconvénients*
    - Pas de garantie de convergence en temps fini
    - Fondements théoriques faibles
    - Gourmands en calcul (mais parallélisables)
    - Chaque individu doit être évalué, même les inadaptés
  ],
)

Particulièrement adaptés lorsque le problème comporte beaucoup de paramètres,
des paramètres interdépendants, et des optimums locaux. _« Everything is
problem dependent »_ : pas une panacée universelle.

== Programmation génétique

#def(titre: "But")[
  Utiliser l'évolution pour construire un *programme*, et non plus un simple
  jeu de paramètres. Proposée par Koza (1989). Aspect quasi-universel.
]

#def(titre: "Principe")[
  L'individu n'est plus un chromosome de longueur fixe mais un *arbre de taille
  variable* représentant une expression ou un programme. Les nœuds internes
  sont des *fonctions* ($+$, $times$, $sin$, if-then-else, while…) et les
  feuilles des *valeurs terminales* (variables $x$, $y$, constantes, vrai,
  faux). On cherche donc la structure elle-même, pas seulement ses paramètres.
]

=== Ensembles fonctions / terminaux

#deuxcol(
  [
    *Clos* : toute fonction doit accepter en argument tout terminal ou tout
    type retourné par les fonctions.
  ],
  [
    *Suffisant* : il doit exister au moins une solution constructible à partir
    de ces ensembles.
  ],
)

=== Opérateurs

- *Croisement* : échange de deux sous-arbres entre deux parents
- *Mutation* : remplacement d'un nœud ou d'un sous-arbre

=== Exemples

- *Régression symbolique* : trouver la formule $f(x)$ ajustant un nuage de points (structure inconnue → arbre)
- *Vie artificielle* : créatures virtuelles de Karl Sims, Golem Project

#piege[
  AG classique = chromosome de longueur *fixe* (on cherche des valeurs dans une
  structure connue). PG = arbre de taille *variable* (on cherche la structure).
  Contrepartie : croissance incontrôlée de la taille des arbres au fil des
  générations.
]