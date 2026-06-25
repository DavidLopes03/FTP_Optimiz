#import "preambule.typ": *
== Introduction

#def(titre: "Graphe")[
  $G = (V, E)$ : $V$ ensemble des sommets, $E$ ensemble des arêtes. Une arête est un couple $(u, v)$.
]

Complexité : temps / mémoire, en fonction de $|V|$ et $|E|$.

#deuxcol(
  def(titre: "Non orienté")[
    Paire non ordonnée : $(u, v) = (v, u)$.
  ],
  def(titre: "Orienté (digraphe)")[
    Paire ordonnée : $(u, v) != (v, u)$.
  ],
)

#def(titre: "Adjacence")[
  $u$ adjacent à $v$ si $(u, v) in E$. Non orienté : dans les deux sens. Orienté : pas l'inverse.
]

#def(titre: "Pondéré")[
  Un poids associé à chaque arête : $w : E -> RR$.
]

=== Chaînes et cycles

#def(titre: "Chaîne")[ Suite de $k$ arêtes entre sommets. ]
#def(titre: "Chaîne élémentaire")[ Chaîne dont tous les sommets sont distincts, sauf les extrémités. ]
#def(titre: "Boucle")[ Arête $(u, u)$ : chaîne élémentaire de longueur $1$. ]
#def(titre: "Cycle")[ Chaîne de longueur $>= 3$ dont les deux extrémités sont identiques. Élémentaire si la chaîne l'est. ]
#def(titre: "Chemins et circuits")[ Équivalents de chaîne et cycle pour un digraphe. ]

Graphe simple : digraphe sans boucle.

=== Connexité et arbres

#def(titre: "Connexité")[ Un chemin relie n'importe quelle paire de sommets. ]
#def(titre: "Forte connexité")[ Digraphe : tout est relié, mais dans les deux sens. ]

#deuxcol(
  def(titre: "Arbre non orienté")[ Acyclique et connexe. ],
  def(titre: "Arbre enraciné")[ Acyclique, chemin unique vers la racine. ],
)

=== Structures de données

Densité : $|E| approx |V|^2$ dense ; $|E| approx |V|$ peu dense.

#def(titre: "Matrice d'adjacence")[
  $A (n times n)$, $A(i,j) = 1$ si sommets connectés. Symétrique si non orienté. Espace : $O(|V|^2)$.
]

#def(titre: "Liste d'adjacence")[
  Pour chaque sommet, la liste de ses voisins. Espace : $O(|V| + |E|)$.
]

#pagebreak()

== Parcours de graphes

#def(titre: "Principe")[
  Depuis une source, on traite les sommets un par un. Traiter un sommet = le marquer visité, puis insérer dans la structure ses *sommets adjacents* (voisins) non visités. L'*ordre d'extraction* fixe l'ordre de parcours.
  - *Largeur (BFS)* : *FIFO*, extraction dans l'ordre d'insertion.
  - *Profondeur (DFS)* : *LIFO*, extraction dans l'ordre inverse.
]

Complexité $O(|V| + |E|)$.

=== Exemple

#coursimg("images/graphe-parcours.png", "Voisins dans l'ordre de la liste d'adjacence", w: 30%)

#deuxcol(
  [
    *Largeur — FIFO* \
    Extraction par la gauche, insertion à droite.
    #pseudo[
      FIFO[A]        visite A \
      FIFO[B C]      visite B \
      FIFO[C D]      visite C \
      FIFO[D E]      visite D \
      FIFO[E]        visite E
    ]
    Ordre : *A B C D E*
  ],
  [
    *Profondeur — LIFO* \
    Extraction et insertion du même côté.
    #pseudo[
      LIFO[A]        visite A \
      LIFO[B C]      visite C \
      LIFO[B E D]    visite D \
      LIFO[B E E]    visite E \
      LIFO[B]        visite B
    ]
    Ordre : *A C D E B*
  ],
)

#pagebreak()

== Plus court chemin — Dijkstra

#def(titre: "Principe")[
  Plus courts chemins depuis une source $s$ dans un graphe pondéré à *poids positifs*. On maintient pour chaque sommet $v$ :
  - $"cost"[v]$ : coût provisoire du plus court chemin connu ($0$ pour $s$, $infinity$ sinon) ;
  - $"pred"[v]$ : prédécesseur sur ce chemin.
  Tant qu'il reste des sommets non visités : extraire celui de $"cost"$ minimal, le marquer définitif, puis relâcher ses arcs sortants.
]

#formule(
  $ "cost"[u] + w(u,v) < "cost"[v] ==> cases("cost"[v] <- "cost"[u] + w(u,v), "pred"[v] <- u) $,
  note: [relaxation de l'arc $(u, v)$],
)

#piege[
  Poids $>= 0$ obligatoire : un sommet extrait est figé définitivement. Un arc négatif pourrait l'améliorer après coup $->$ résultat faux.
]

Complexité avec tas binaire : $O((|V| + |E|) log |V|)$.

=== Exemple — source $= 1$

#coursimg("images/dijkstra-graphe.png", "Graphe pondéré orienté", w: 30%)

#let dtab(..rows) = table(
  columns: 3, align: center, stroke: 0.4pt + c-rule,
  table.header([*Sommet*], [*Coût*], [*Préd.*]),
  ..rows
)

#deuxcol(
  [
    *Étape 0* — initialisation. \
    $"cost"[1] = 0$, les autres à $infinity$.
    #dtab(
      [1], [0], [--],
      [2], [$infinity$], [--],
      [3], [$infinity$], [--],
    )
  ],
  [
    *Étape 1* — extraction de *1* (coût min $0$), figé. \
    Relaxation des arcs sortants : $(1,2)$ donne $0+4$, $(1,3)$ donne $0+7$.
    #dtab(
      [#strike[1]], [0], [--],
      [2], [4], [1],
      [3], [7], [1],
    )
  ],
)

#deuxcol(
  [
    *Étape 2* — extraction de *2* (coût min $4$), figé. \
    Relaxation de $(2,3)$ : $4+1 = 5 < 7$ $->$ on améliore 3 et son prédécesseur devient 2.
    #dtab(
      [#strike[1]], [0], [--],
      [#strike[2]], [4], [1],
      [3], [5], [2],
    )
  ],
  [
    *Étape 3* — extraction de *3* (coût $5$), figé. \
    Son seul arc $(3,1)$ pointe vers un sommet déjà définitif : aucune relaxation. Terminé.
    #dtab(
      [#strike[1]], [0], [--],
      [#strike[2]], [4], [1],
      [#strike[3]], [5], [2],
    )
  ],
)

Chemins obtenus : $1$ ; $1 -> 2$ (coût 4) ; $1 -> 2 -> 3$ (coût 5).

#pagebreak()

== Plus courts chemins — Floyd-Warshall

#def(titre: "Principe")[
  Plus courts chemins entre *toutes les paires* de sommets. On autorise progressivement les sommets $1, ..., n$ comme *intermédiaires*. À l'étape $k$, $D^k (i,j)$ est le coût minimal de $i$ à $j$ n'empruntant que des intermédiaires dans ${1, ..., k}$.
  - $D^0$ : matrice d'adjacence pondérée ($0$ sur la diagonale, $infinity$ si pas d'arc).
  - $P^k (i,j)$ : prédécesseur de $j$ sur ce chemin.
]

#formule(
  $ D^k (i,j) = min(D^(k-1)(i,j), space D^(k-1)(i,k) + D^(k-1)(k,j)) $,
  note: [passer par $k$ améliore-t-il le chemin $i -> j$ ?],
)

Si le chemin via $k$ est meilleur : $P^k (i,j) <- P^(k-1)(k,j)$. Admet les poids négatifs (pas de cycle négatif). Complexité $O(|V|^3)$.

=== Exemple

#let mtab(name, ..rows) = {
  align(center)[#name]
  table(
    columns: 4, align: center, stroke: 0.4pt + c-rule,
    table.header([], [*1*], [*2*], [*3*]),
    ..rows
  )
}

*$k = 0$* — initialisation (matrice d'adjacence) :
#deuxcol(
  mtab($D^0$,
    [*1*], [0], [4], [7],
    [*2*], [$infinity$], [0], [1],
    [*3*], [2], [$infinity$], [0],
  ),
  mtab($P^0$,
    [*1*], [--], [1], [1],
    [*2*], [--], [--], [2],
    [*3*], [3], [--], [--],
  ),
)

*$k = 1$* — intermédiaire 1. Seul gain : $D(3,2) = D(3,1) + D(1,2) = 2 + 4 = 6 < infinity$.
#deuxcol(
  mtab($D^1$,
    [*1*], [0], [4], [7],
    [*2*], [$infinity$], [0], [1],
    [*3*], [2], [*6*], [0],
  ),
  mtab($P^1$,
    [*1*], [--], [1], [1],
    [*2*], [--], [--], [2],
    [*3*], [3], [*1*], [--],
  ),
)

*$k = 2$* — intermédiaire 2. Gain : $D(1,3) = D(1,2) + D(2,3) = 4 + 1 = 5 < 7$, préd. $<- 2$.
#deuxcol(
  mtab($D^2$,
    [*1*], [0], [4], [*5*],
    [*2*], [$infinity$], [0], [1],
    [*3*], [2], [6], [0],
  ),
  mtab($P^2$,
    [*1*], [--], [1], [*2*],
    [*2*], [--], [--], [2],
    [*3*], [3], [1], [--],
  ),
)

*$k = 3$* — intermédiaire 3. Gain : $D(2,1) = D(2,3) + D(3,1) = 1 + 2 = 3 < infinity$, préd. $<- 3$.
#deuxcol(
  mtab($D^3$,
    [*1*], [0], [4], [5],
    [*2*], [*3*], [0], [1],
    [*3*], [2], [6], [0],
  ),
  mtab($P^3$,
    [*1*], [--], [1], [2],
    [*2*], [*3*], [--], [2],
    [*3*], [3], [1], [--],
  ),
)

#pagebreak()

== Flot maximal — Ford-Fulkerson

#def(titre: "But")[
  Réseau orienté avec une source $s$, un puits $t$, et un plafond (capacité) sur chaque arête. On cherche la plus grande quantité de flot envoyable de $s$ à $t$ sans dépasser le plafond d'aucune arête. Le flot se répartit sur plusieurs chemins en parallèle.
]

#def(titre: "Flot")[
  Un nombre $f$ posé sur chaque arête $=$ quantité qui y passe.
  - $0 <= f <= w$ (plafond) ;
  - sur tout sommet sauf $s$ et $t$ : flot entrant $=$ flot sortant.
  Valeur $|f| = $ flot sortant de $s$.
]

#def(titre: "Réseau résiduel")[
  Pour chaque arête $u -> v$ portant $f$ sur un plafond $w$ :
  - arête *avant* $u -> v$ valant $w - f$ (place libre) ;
  - arête *arrière* $v -> u$ valant $f$ (flot annulable).
  On garde les arêtes de valeur $> 0$. C'est dans ce graphe qu'on cherche les chemins.
]

#def(titre: "Chemin améliorant")[
  Chemin de $s$ à $t$ dans le réseau résiduel. On y pousse $delta = $ min des valeurs du chemin.
]

#def(titre: "Algorithme")[
  #etapes[
    #etape("Initialisation")[Flot $= 0$ sur toutes les arêtes.]
    #etape("Réseau résiduel")[Le construire à partir de l'état actuel du flot.]
    #etape("Chemin améliorant")[Chercher un chemin $s -> t$ dedans. Aucun $->$ fin.]
    #etape("Goulot")[$delta = $ plus petite valeur du chemin.]
    #etape("Mise à jour")[Arête avant $-> f += delta$ ; arête arrière $-> f -= delta$.]
    #etape("Boucle")[Retour à l'étape 2.]
  ]
]

#piege[
  L'arête *arrière* permet d'annuler un flot mal placé pour le réacheminer. On ne la choisit pas exprès : si un chemin du résiduel l'emprunte, l'annulation ($-delta$) se fait à la mise à jour. Inutile dans beaucoup de cas.
]

#def(titre: "Maximalité — coupe minimale")[
  Une coupe $(S, T)$ partage les sommets avec $s in S$, $t in T$. Sa capacité $C(S,T) = $ somme des plafonds des arêtes de $S$ vers $T$.
]

#formule(
  $ |f| = C(S, T) $,
  note: [flot max $=$ coupe min],
)

Le flot est maximal quand plus aucun chemin $s -> t$ n'existe dans le résiduel. À ce moment $S = $ sommets atteignables depuis $s$ dans le résiduel final, et la coupe $(S, T)$ est saturée.

Complexité (Edmonds-Karp, chemin par BFS) : $O(|V| dot |E|^2)$.

#pagebreak()

== Arbre couvrant minimal (MST)

#def(titre: "But")[
  Dans un graphe non orienté, pondéré et connexe, sélectionner un sous-ensemble d'arêtes qui relie tous les sommets, sans cycle (un arbre), de poids total minimal. Pour $n$ sommets : exactement $n - 1$ arêtes.
]

#deuxcol(
  def(titre: "Prim")[
    Fait grossir un seul arbre depuis un sommet de départ. À chaque étape, ajoute l'arête de poids minimal reliant un sommet de l'arbre à un sommet hors de l'arbre.
  ],
  def(titre: "Kruskal")[
    Trie toutes les arêtes par poids croissant. Les parcourt dans l'ordre et ajoute chaque arête sauf si elle crée un cycle (extrémités déjà reliées). Détection de cycle par union-find.
  ],
)

Les deux sont gloutons et donnent un MST de même poids total.

=== Exemple

#coursimg("images/mst-graphe.png", "Graphe non orienté pondéré", w: 30%)

==== Prim depuis A

#let ptab(..rows) = table(
  columns: 3, align: center, stroke: 0.4pt + c-rule,
  table.header([*Sommet*], [*Coût*], [*Préd.*]),
  ..rows
)

#deuxcol(
  [
    *Étape 0* — init. $A = 0$.
    #ptab(
      [A], [0], [--],
      [B], [$infinity$], [--],
      [C], [$infinity$], [--],
      [D], [$infinity$], [--],
    )
  ],
  [
    *Étape 1* — intégrer *A*. Maj des voisins.
    #ptab(
      [#strike[A]], [0], [--],
      [B], [4], [A],
      [C], [*1*], [A],
      [D], [3], [A],
    )
  ],
)

#deuxcol(
  [
    *Étape 2* — intégrer *C* (coût min 1). $C -> D = 5 > 3$ : pas de maj.
    #ptab(
      [#strike[A]], [0], [--],
      [B], [4], [A],
      [#strike[C]], [2], [A],
      [D], [*3*], [A],
    )
  ],
  [
    *Étape 3* — intégrer *D* (3). $B -> D = 2 < 4$ : *B mis à jour*.
    #ptab(
      [#strike[A]], [0], [--],
      [B], [*2*], [D],
      [#strike[C]], [2], [A],
      [#strike[D]], [3], [A],
    )
  ],
)

*Étape 4* — intégrer *B* (2). Arbre complet : $A-C, A-D, B-D$, poids $= 6$.

L'étape 3 est le point clé : $B$ valait 4 (via $A$), un chemin moins cher est découvert (via $D$), on relâche son coût à 2.

==== Kruskal

Arêtes triées : $A C : 1, space B D : 2, space A D : 3, space A B : 4, space C D : 5$.

#table(
  columns: 4, align: (center, center, left, left), stroke: 0.4pt + c-rule,
  table.header([*Arête*], [*Sûre*], [*Forêt $F$*], [*$A$ (sûres)*]),
  [$A C : 1$], [oui], [{A,C} {B} {D}], [A-C],
  [$B D : 2$], [oui], [{A,C} {B,D}], [A-C, B-D],
  [$A D : 3$], [oui], [{A,B,C,D}], [A-C, B-D, A-D],
  [$A B : 4$], [*non*], [{A,B,C,D}], [-- (cycle)],
)

L'arête $A B$ est rejetée : $A$ et $B$ sont déjà dans le même groupe, l'ajouter créerait un cycle. Arrêt à $n - 1 = 3$ arêtes, poids $= 6$.