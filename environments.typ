/// Module for thesis environments

#import "@preview/ctheorems:1.1.3": *
#show: thmrules.with(qed-symbol: $square$)

#let thmpadding = (top: 0em, bottom: 0.6em)

#let thmthesis = thmbox.with(
  padding: thmpadding,
  breakable: true,
  inset: 0em,
  //namefmt: none, // name => emph([(#name)]),
  separator: [#h(0.0em)#strong(".")#h(0.2em)],
  titlefmt: strong,
  base_level: 1,
)

#let theorem = thmthesis(
  "theorem",
  "Theorem",
  bodyfmt: emph,
)
#let corollary = thmthesis(
  "theorem",
  "Corollary",
  bodyfmt: emph,
)
#let lemma = thmthesis(
  "theorem",
  "Lemma",
  bodyfmt: emph,
)
#let proposition = thmthesis(
  "theorem",
  "Proposition",
  bodyfmt: emph,
)

#let definition = thmthesis(
  "theorem",
  "Definition",
)
#let remark = thmthesis(
  "theorem",
  "Remark",
)
#let example = thmthesis(
  "example",
  "Example",
).with(numbering: none)


#let proof = thmproof(
  "proof",
  "Proof",
  inset: 0em,
  padding: thmpadding,
)
