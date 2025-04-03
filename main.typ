#import "focs.typ": *
#show: thmrules.with(qed-symbol: $square$)

#show: focs.with(
  title: [Strong Low Degree Hardness for \ the Number Partitioning Problem],
  abstract: [
    Finding good solutions to the _number partitioning problem (NPP)_ -- that is, finding a partition of a set of $N$ numbers to minimize the discrepancy between the sums of the two subsets -- is a well-studied optimization problem, with applications to statistics, physics, and computer science.
    Along with having numerous practical applications in the design of randomized control trials and processor scheduling,
    the NPP is famous for posessing a _statistical-to-computational gap_:
    assuming the $N$ numbers to be partitioned are i.i.d. standard Normal random variables, the optimal discrepancy is $2^(-Theta(N))$ with high probability, but the best polynomial-time algorithms only find solutions with a discrepancy of $2^(- Theta(log^2 N))$.
    This gap is a common feature in optimization problems over random combinatorial structures, and indicates the need for a theory of computational complexity beyond worst-case analysis.

    In this thesis, we prove a strong form of algorithmic hardness for the number partitioning problem, aiming to establish that this statistical-to-computational gap is an intrinsic feature of the NPP.
    We study _low degree algorithms_, as they provide both tunable stability behavior and are tractable models for a broad class of algorithms, under the widely successful _low degree heuristic_.
    Then, we establish a _brittleness property_ on the geometry of the solution set, which ensures that stable algorithms are unable to efficiently traverse this random landscape.
    By combining these notions, we are able to show _strong low degree hardness_, in that low degree algorithms will fail to find good solutions with high probability.
    In addition, while we show that low degree polynomial algorithms are structurally ill-suited to the NPP, our results for the more general class of _low coordinate degree algorithms_ demonstrate a sharp tradeoff between algorithmic runtime (vis-à-vis algorithmic complexity) and solution discrepancy, which our analysis suggests is optimal.

    Finally, we establish a _repulsion property_, giving a precise tradeoff between the the discrepancy of a solution to a fixed instance and its distance to other solutions.
    We then leverage this to show that any algorithm fed through a truly randomized rounding scheme will fail to find solutions with high probability.
    This work demonstrates the effectiveness of using landscape properties to address questions about algorithmic hardness, and suggests interesting directions for future study.
  ],
)

/// Introduction

#include "1-introduction.typ"

/// Algorithms

// #include "2-algorithms.typ"

/// Hardness

#include "2-hardness.typ"

/// Hardness

// #include "3-hardness.typ"

/// Rounding

#include "4-rounding.typ"

#bibliography(
  "references.bib",
  style: "ieee.csl",
  title: "References",
)
