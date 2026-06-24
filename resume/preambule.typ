// ============================================================
//  PRÉAMBULE — fiches d'examen
// ============================================================

// ---------- COULEURS (sobres) ----------
#let c-ink   = rgb("#1a1a1a")   // texte
#let c-soft  = rgb("#555555")   // texte secondaire / notes
#let c-rule  = rgb("#bcbcbc")   // filets
#let c-bg    = rgb("#f4f4f4")   // fond léger des blocs
#let c-line  = rgb("#000000")   // accents (filets, pastilles)

// ============================================================
//  FONCTION TEMPLATE (Gère les options de page et le style)
// ============================================================
#let template(body) = {
  // ---------- RÉGLAGES GLOBAUX ----------
  set text(font: "New Computer Modern", size: 9pt, lang: "fr", fill: c-ink)
  set par(justify: true, leading: 0.62em, spacing: 0.85em)
  
  set page(
    paper: "a4",
    margin: (x: 1.4cm, top: 2cm, bottom: 1.8cm),
    header-ascent: 0.9cm,
    footer-descent: 0.8cm,
    header: context {
      set text(size: 9pt, fill: c-soft)
      grid(columns: (1fr, 1fr), align: (left, right),
        [Optimisation], [MSE / HES-SO])
      v(2pt)
      line(length: 100%, stroke: 0.4pt + c-rule)
    },
    footer: context {
      set text(size: 9pt, fill: c-soft)
      line(length: 100%, stroke: 0.4pt + c-rule)
      v(2pt)
      align(center)[#counter(page).display("1 / 1", both: true)]
    },
  )

  // ---------- TITRES ----------
  show heading.where(level: 1): it => block(above: 1.3em, below: 0.7em)[
    #set text(size: 19pt, weight: "bold")
    #it.body
    #v(-5pt)
    #line(length: 100%, stroke: 1.4pt + c-line)
  ]
  show heading.where(level: 2): it => block(above: 1em, below: 0.4em)[
    #set text(size: 15pt, weight: "bold")
    #it.body
    #v(-5pt)
    #line(length: 100%, stroke: 0.5pt + c-rule)
  ]
  show heading.where(level: 3): it => block(above: 0.8em, below: 0.4em)[
    #set text(size: 12pt, weight: "bold", style: "italic")
    #it.body
  ]

  // IMPORTANT : C'est ici que Typst va injecter le contenu de tes autres fichiers
  body
}

// ============================================================
//  BLOCS (Restent à l'extérieur pour être importés)
// ============================================================
// ---- Définition / encadré neutre ----
#let def(titre: "Définition", body) = block(
  width: 100%, fill: c-bg, inset: 10pt, radius: 2pt,
  stroke: (left: 2pt + c-line), below: 0.9em)[
  #text(weight: "bold")[#titre.] #h(2pt) #body
]

// ---- Formule encadrée (filet simple) ----
#let formule(body, note: none) = block(
  width: 100%, inset: 10pt, radius: 2pt,
  stroke: 0.6pt + c-rule, below: 0.9em)[
  #align(center)[#body]
  #if note != none [#v(5pt) #align(center)[#text(size: 11pt, fill: c-soft)[#note]]]
]

// ---- Piège (filet épais à gauche, pas de couleur) ----
#let piege(body) = block(
  width: 100%, inset: 10pt, radius: 2pt,
  stroke: (left: 2pt + c-line, rest: 0.4pt + c-rule), below: 0.9em)[
  #text(weight: "bold")[Piège.] #h(2pt) #body
]

// ---- Réf. slide ----
#let slide(n) = text(size: 9.5pt, fill: c-soft)[\[slide #n\]]

// ---- ÉTAPES (pastille noire numérotée) ----
#let _stepctr = counter("etape")
#let etape(titre, body) = {
  _stepctr.step()
  block(width: 100%, below: 0.6em)[
    #grid(columns: (auto, 1fr), column-gutter: 10pt,
      align: (center + horizon, left + top),
      box(width: 26pt, height: 26pt, stroke: 1.2pt + c-line, radius: 50%)[
        #align(center + horizon)[#text(weight: "bold", size: 13pt)[
          #context _stepctr.display()]]
      ],
      block[
        #text(weight: "bold")[#titre]
        #v(-4pt)
        #body
      ],
    )
  ]
}
#let etapes(body) = { _stepctr.update(0); body }

// ---- PSEUDOCODE ----
#let pseudo(body) = block(
  width: 100%, fill: c-bg, inset: 10pt, radius: 2pt,
  stroke: 0.5pt + c-rule, below: 0.9em)[
  #set text(font: "DejaVu Sans Mono", size: 7pt)
  #set par(justify: false, leading: 0.7em)
  #body
]
#let kw(x) = text(weight: "bold")[#x]

// ---- UTILITAIRES ----
#let deuxcol(a, b) = grid(columns: (1fr, 1fr), column-gutter: 14pt, a, b)
#let coursimg(path, legende, w: 100%) = figure(
  image(path, width: w), caption: text(size: 10pt)[#legende])