#import "preambule.typ": *

== Affectation quadratique (QAP)

#def(titre: "Définition")[
  Répartition de $n$ objets dans un espace de $n$ emplacements de sorte à
  minimiser le coût total des déplacements entre eux.
]

=== Données

- $n$ objets ; $F(i,j)$ : flot (poids de connexion) entre les objets $i$ et $j$
- $n$ emplacements ; $D(r,s)$ : distance entre les emplacements $r$ et $s$

=== Codage

Une solution est une permutation $pi$, où $pi(i)$ donne l'emplacement de
l'objet $i$. Espace des solutions : $n!$ permutations.

=== Coût d'un placement

#formule(
  $ C(pi) = sum_(i,j=1)^n F(i,j) dot D(pi(i), pi(j)) $,
  note: [pour chaque paire d'objets : flot x distance entre leurs emplacements, puis somme.],
)

=== Exemple

Avec $pi = [1, 3, 4, 5, 2]$ et les matrices ci-dessous :

#deuxcol(
  [
    *Flots $F$*
    $ mat(
      0,5,2,4,1;
      5,0,3,0,2;
      2,3,0,0,0;
      4,0,0,0,5;
      1,2,0,5,0;
    ) $
  ],
  [
    *Distances $D$*
    $ mat(
      0,1,1,2,3;
      1,0,2,1,2;
      1,2,0,1,2;
      2,1,1,0,1;
      3,2,2,1,0;
    ) $
  ],
)

Somme par objet $i$ (un terme par paire, $F(i,j) dot D(pi(i),pi(j))$) :
$22 + 12 + 7 + 22 + 15 = 78$.