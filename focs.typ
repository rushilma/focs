#let focs(
  doc,
  title: none,
  abstract: none,
  linkcolor: blue,
  tabsize: 1.2em,
) = {
  set text(
    font: "Crimson Pro",
    size: 12pt,
    weight: "regular",
    alternates: true,
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
    // leading: 1.2em,
    first-line-indent: (amount: tabsize, all: false),
  )

  // enum
  set enum(numbering: "(a)", indent: tabsize)

  // math equation stuff
  set math.equation(
    supplement: none,
    numbering: (..nums) => numbering("(1.1)", ..nums),
  )
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

  // references
  show ref: it => text(fill: linkcolor)[#it]

  // outline
  show outline.entry.where(level: 1): set outline.entry(fill: " ")
  show outline.entry.where(level: 1): set block(above: tabsize)


  // math numbering
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
    // set heading(numbering: none, outlined: false)
    block(above: tabsize / 3) + strong(it.body + "." + h(0.2em)) + [ ]
  }

  set math.equation(
    numbering: it => {
      let count = counter(heading.where(level: 1)).at(here()).first()
      if count > 0 {
        numbering("(1.1)", count, it)
      } else {
        numbering("(1)", it)
      }
    },
  )

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
  pad(top: 0.15in, align(center, [April 3, 2025]))
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
