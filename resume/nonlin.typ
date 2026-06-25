#import "preambule.typ": *


== Dichotomie

#def(titre: "Dichotomie")[
  Recherche d'une racine de $f$ continue sur $[a, b]$ ayant une seule racine, par division successive de l'intervalle : $m = (a + b) / 2$.
]

#pseudo[
  #kw[tant que] (b - a) > ε : \
  #h(1em) m ← (a + b) / 2 \
  #h(1em) #kw[si] f(a)·f(m) ≤ 0 : b ← m   #h(0.5em) // racine dans [a, m] \
  #h(1em) #kw[sinon] : a ← m           #h(1.5em) // racine dans [m, b] \
  #kw[retourner] m
]

#piege[
  Minimisation : on cherche le minimum de $f$, c.-à-d. $f'(x) = 0$ avec $f'(x) < 0$ à gauche et $> 0$ à droite. On fait donc la dichotomie sur $g(x) = f'(x)$.
]

Convergence linéaire : 1 bit par itération. Erreur après $n$ itérations :
#formule($ (b - a) / 2^n <= ε quad => quad n >= log_2 (b - a) / ε $)

== Newton

#def(titre: "Newton")[
  Approximation par la tangente : en $f(x_n)$ on prend la tangente, et le zéro de celle-ci est le prochain $x_n$.
]

#formule(
  $ x_(n+1) = x_n - f(x_n) / (f'(x_n)) $,
  note: [condition de convergence : $abs((f(x) f''(x)) / (f'(x))^2) < 1$],
)

#def(titre: "Méthode de la sécante")[
  Approximation de $f'(x_n)$ par taux d'accroissement (pas de dérivée à calculer) :
  $ f'(x_n) approx (f(x_n) - f(x_(n-1))) / (x_n - x_(n-1)) quad => quad x_(n+1) = x_n - f(x_n) (x_n - x_(n-1)) / (f(x_n) - f(x_(n-1))) $
]

#piege[Défaillance de Newton : $f'(x_n) != 0$, sinon division impossible (tangente horizontale).]

#coursimg("images/newton-tangente.png", "Itérations de Newton : zéros successifs des tangentes", w: 30%)

#pagebreak()

=== Newton à $n$ dimensions

Minimisation d'une fonction $f(x_1, ..., x_n)$. Matrice hessienne :
#formule($ H_(i j) = (partial^2 f) / (partial x_i partial x_j) quad "en 2D :" quad H = mat(f_(x_1 x_1), f_(x_1 x_2); f_(x_2 x_1), f_(x_2 x_2)) $)

#formule(
  $ x^(i+1) = x^(i) - (H(x^(i)))^(-1) nabla f(x^(i)) $,
  note: [formule d'optimisation],
)

#def(titre: "Rappel inversion 2×2")[
  $ M = mat(a, b; c, d) quad => quad M^(-1) = 1 / (a d - b c) mat(d, -b; -c, a) $
]

#pseudo[
  Donner x, ε \
  #kw[pour] i = 0, 1, 2, … : \
  #h(1em) g ← ∇f(x^(i)) \
  #h(1em) #kw[si] ‖g‖ < ε : #kw[retourner] x^(i) \
  #h(1em) H ← hessienne(x^(i)) \
  #h(1em) Δ ← H⁻¹ · g          // 2×2 à la main : formule ci-dessus \
  #h(1em) x^(i+1) ← x^(i) - Δ
]

- Convergence quadratique rapide.
- Inverser $H$ coûteux.
- Si $f$ quadratique : minimum exact atteint en 1 itération.

== Gradient

#def(titre: "Gradient")[
  Depuis $x^(i)$ on descend dans la direction de $-nabla f(x^(i))$, d'un pas $alpha_i$ choisi pour minimiser $f$ le long de cette droite.
]

#formule(
  $ nabla f = vec((partial f) / (partial x_1), (partial f) / (partial x_2), dots.v, (partial f) / (partial x_n)) quad quad x^(i+1) = x^(i) - alpha_i nabla f(x^(i)) $
)

#def(titre: "Recherche du pas")[
  Trouver $alpha$ : poser $h(alpha) = f(x^(i) - alpha nabla f(x^(i)))$, puis résoudre $h'(alpha) = 0$.
]

#pseudo[
  Donner x, ε \
  #kw[pour] i = 0, 1, 2, … : \
  #h(1em) g ← ∇f(x^(i)) \
  #h(1em) #kw[si] ‖g‖ < ε : #kw[retourner] x^(i)   // gradient ≈ 0 → point stationnaire \
  #h(1em) α_i ← argmin_α f(x^(i) - α·g)          // line search : h'(α) = 0 \
  #h(1em) x^(i+1) ← x^(i) - α_i·g
]

- Convergence lente.
- Oscillation vers l'optimal.
- Bonne approximation initiale puis Newton.

== Comparaison

#table(
  columns: 4, align: (left, center, center, left), stroke: 0.4pt + c-rule,
  table.header([*Méthode*], [*Vitesse*], [*Robustesse*], [*Point de départ*]),
  [Dichotomie], [lente], [robuste], [intervalle $[a, b]$],
  [Newton], [rapide], [peu robuste], [proche solution],
  [Gradient], [lente], [moyenne], [arbitraire],
)
#pagebreak()
== Le perceptron

#coursimg("images/perceptron.jpeg", [Neurone : somme pondérée $sum_i w_i x_i + b$ suivie d'une fonction d'activation], w: 50%)

#def(titre: "Perceptron")[
  Combinaison linéaire des entrées suivie d'une fonction d'activation (step) :
  $ z = "step"(sum_i w_i x_i + b) $
  $b$ : biais. $t$ : valeur attendue. $o$ : valeur de sortie.
]

#def(titre: "Fonction de coût")[
  $ E[arrow(w)] = 1 / 2 sum_l (t_l - o_l)^2 $
]

#def(titre: "Apprentissage — descente de gradient")[
  Mise à jour des poids dans la direction opposée au gradient du coût :
  $ w_i <- w_i - alpha (partial E) / (partial w_i) $
]

=== Fonctions d'activation

#coursimg("images/step-functions.png", [Step, sign, identity, sigmoid, hyperbolic tangent], w: 50%)

#deuxcol(
  [
    Step : $phi(u) = cases(1 "si" u >= 0, 0 "sinon")$ \
    Sign : $phi(u) = cases(1 "si" u >= 0, -1 "sinon")$ \
    Identity : $phi(u) = u$
  ],
  [
    Sigmoid : $phi(u) = 1 / (1 + e^(-u))$ \
    Tanh : $phi(u) = (e^u - e^(-u)) / (e^u + e^(-u))$
  ],
)
#pagebreak()
=== Rétropropagation (backpropagation)

#def(titre: "Principe")[
  Calcul du gradient $(partial E) / (partial w)$ pour tous les poids d'un réseau multicouche, par application de la règle de dérivation en chaîne, de la sortie vers l'entrée.
]

Pour un poids $w_(i j)$ (du neurone $i$ vers $j$), on décompose :
#formule(
  $ (partial E) / (partial w_(i j)) = (partial E) / (partial o_j) dot (partial o_j) / (partial "net"_j) dot (partial "net"_j) / (partial w_(i j)) $,
  note: [$"net"_j = sum_i w_(i j) o_i$, et $o_j = phi("net"_j)$],
)

#def(titre: "Signal d'erreur")[
  On définit $delta_j = (partial E) / (partial "net"_j)$, propagé de la sortie vers l'entrée :
  - couche de sortie : $delta_j = (o_j - t_j) phi'("net"_j)$ ;
  - couche cachée : $delta_j = (sum_k delta_k w_(j k)) phi'("net"_j)$.
]

#formule(
  $ (partial E) / (partial w_(i j)) = delta_j o_i quad quad w_(i j) <- w_(i j) - alpha delta_j o_i $
)

#piege[
  $delta$ d'une couche cachée dépend des $delta$ de la couche suivante : il faut donc calculer les $delta$ de la sortie *en premier*, puis remonter. C'est ce qui justifie le terme « rétro »-propagation.
]

Les activations dérivables (sigmoid, tanh) sont nécessaires : la step n'est pas dérivable, d'où son remplacement pour l'apprentissage par gradient.