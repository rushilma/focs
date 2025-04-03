/// `focs.typ`
/// Formatting and template for FOCS 2025

/// constants

#let purple = rgb(128, 0, 76)
#let tabsize = 1.2em

/// theorem environments

#import "@preview/ctheorems:1.1.3": *

#let thmpadding = (top: 0em, bottom: tabsize / 2)
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


#let focs(
  doc,
  title: none,
  abstract: none,
  date: datetime.today().display("[month repr:long] [day], [year]"),
  linkcolor: purple,
) = {
  set text(
    font: "Crimson Pro",
    size: 12pt,
    weight: "regular",
    // alternates: true,
  )
  set page(
    paper: "us-letter",
    numbering: "1",
    number-align: bottom + center,
    margin: (x: 1in, y: 1in),
  )
  set par(
    justify: true,
    spacing: tabsize,
    leading: tabsize / 2,
    first-line-indent: (amount: tabsize, all: false),
  )

  // enum
  set enum(numbering: "(a)", spacing: tabsize * 2 / 3, indent: tabsize)

  // references
  show ref: it => text(fill: linkcolor)[#it]

  // outline
  show outline.entry.where(level: 1): set outline.entry(fill: " ")
  show outline.entry.where(level: 1): set block(above: tabsize)

  // heading setup
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    pad(it, bottom: tabsize / 2)
  }
  show heading.where(level: 2): it => {
    pad(it, bottom: tabsize / 3)
  }
  show heading.where(level: 3): set heading(numbering: none, outlined: false)
  show heading.where(level: 3): it => {
    block(above: tabsize / 3) + strong(it.body + "." + h(0.2em)) + [ ]
  }

  // math equation setup
  // double numbering
  set math.equation(
    supplement: none,
    numbering: it => {
      let count = counter(heading.where(level: 1)).at(here()).first()
      if count > 0 {
        numbering("(1.1)", count, it)
      } else {
        numbering("(1)", it)
      }
    },
  )
  // no numbering for unlabeled equations
  show math.equation: it => {
    if it.block and not it.has("label") [
      #counter(math.equation).update(v => v - 1)
      #math.equation(it.body, block: true, numbering: none)#label("")
    ] else {
      it
    }
  }
  show math.equation: set text(size: 11pt)
  show math.equation: set block(breakable: true)
  // set math.accent(size: 150%)

  // titlepage
  pad(
    left: -0.01in,
    top: 0.7in,
    align(
      center,
      text(
        weight: "regular",
        size: 20pt,
        title,
      ),
    ),
  )
  pad(top: 0.15in, align(center, date))
  pad(
    top: 0.05in,
    x: 0.25in,
    text(size: 11pt)[
      #align(center, [*Abstract*])
      #abstract],
  )

  outline()

  doc
}

#import "symbols.typ": *
