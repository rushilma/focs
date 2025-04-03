#import "focs.typ": *

// #import "symbols.typ": *

= Proofs of Strong Low Degree Hardness

meow determinsitc Sigma_N valued assumption


// linear low degree hardness
#theorem[Hardness for LDP Algorithms][
  Let $g$ and $g'$ be $(1-epsilon)$-correlated standard Normal random vectors.
  Let $alg$ be any degree $D$ polynomial algorithm with $EE norm(alg(g))^2 <= C N$.
  Assume that
  + if $E = delta N$ for $delta > 0$, then $D <= o(2^(delta N slash 2))$;
  + if $omega(log N) <= E <= o(N)$, then $D <= o(2^(E slash 4))$.
  Then there exist $epsilon=epsilon(N,E)>0$ and $eta=eta(N,E)>0$ such that
  $ PP(alg(g) in Soln(g)) = o(1). $
]


#theorem[Hardness for LCD Algorithms][
  Let $g$ and $g'$ be $(1-epsilon)$-resampled standard Normal random vectors.
  Let $alg$ be any coordinate degree $D$ algorithm with $EE norm(alg(g))^2 <= C N$.
  Assume that
  + if $E = delta N$ for $delta > 0$, then $D <= o(N)$;
  + if $omega(log N) <= E <= o(N)$, then $D <= o(E slash log^2 E)$.
  Then there exist $epsilon=epsilon(N,D)>0$ and $eta=eta(N,E)>0$ such that
  $ PP(alg(g) in Soln(g)) = o(1). $
]
#proof[

]

== Preliminary Estimates



#proposition[
  For all $E <= O(N)$, there exists $eta=eta(N,E) > 0$ such that for $N$ sufficiently large,
  $ 2 eta log_2(1 / eta) < E / (4N). $
  In addition
  + if $E = Theta(N)$, this $eta$ is $O(1)$;
  + if $E <= o(N)$, this $eta$ satisfies $eta gt.tilde E slash N log_2(N)$.
] <prop_eta_choice>
#proof[
  (a) For $E=Theta(N)$, $E slash N$ is bounded by an $N$-independent constant $delta > 0$. It is thus possible to find some $eta= O(1)$ such that $- 2 eta log_2 eta < delta slash 4$, as desired.

  (b) Heuristically, if $0 < eta, E slash N << 1$ and $-eta log eta ~ E slash N$, then $E slash N = eta^(plus.minus o(1))$.
  Therefore, $log E slash N ~ (1 plus.minus o(1)) log eta$, whence $eta ~ E slash (N log N slash E)$.
  On these grounds, for $E <= o(N)$ we choose
  $ eta := E / (16 N log_2 (N slash E)) gt.tilde E / (N log_2 N) $
  where the 16 is an arbitrary universal constant.
  We can verify numerically that for $N$ sufficiently large (hence $E slash N$ sufficiently small) this choice gives $2 eta log_2(1 slash eta) < E slash 4N$.
]

== Conditional obstruction







#proof[
  Recall from @eq_poly_fundamental that it suffices to show that both $p^cor _"cond"$ and $p^cor _"unstable"$ vanish in the limit.
  /*
  Further, by @eq_def_pcond and @prop_correlated_fundamental, we have
  $
    p^cor_"cond" <= exp_2 (-E - 1 / 2 log_2 (epsilon) + 2 eta log_2 (1 / eta) N + O(log N)).
  $
  */
  Thus, first choose $eta$ sufficiently small, so that $2 eta log_2 (1 slash eta) < delta slash 4$; this results in $eta$ being independent of $N$.
  Next, choose $epsilon := exp_2 (- delta N slash 2)$.
  By @eq_def_pcond and @prop_correlated_fundamental, these choices give
  $
    p^cor_"cond" <= exp_2 (- delta N - 1 / 2 (-(delta N) / 2) + (delta N) / 4 + O(log N)) = exp_2 (- (delta N) / 2 + O(log N)) = o(1).
  $
  We conclude by observing that for $D <= o(exp_2 (delta N slash 2))$, @prop_alg_stability gives
  $
    p^cor_"unstable" <= (C D epsilon) / (2 eta) asymp (D epsilon) / eta asymp D dot exp_2 (- (delta N) / 2) = o(1). #qedhere
  $
  // By @eq_poly_fundamental, we that $(p^cor _"solve")^2 <= p^cor _"unstable" + p^cor _"cond" = o(1)$.
]

Next, we consider the sublinear energy regime $omega(log  N ) <= E <= o(N)$.
This bridges the gap from the statistically optimal energy threshold down to the computational threshold.
In particular, our method allows us to rule out degree $o(N^O(N))$ polynomial algorithms even for achieving the same energy threshold as the Karmarkar-Karp algorithm; this is expected however, as neither the original Karmarkar-Karp algorithm nor the simplified LDM algorithm are polynomial.

// sublinear poly low degree hardness
#theorem[
  Let $omega(log N) <= E <= o(N)$ and $g,g'$ be $(1-epsilon)$-correlated standard Normal r.v.s.
  Then, for any polynomial algorithm $alg$ with $EE norm(alg(g))^2 <= C N$ and degree $D <= o(exp_2 (E slash 4))$, there exist $epsilon, eta$ #h(1pt) s.t.
  $ p^cor_"solve" = PP(alg(g) in Soln(g)) = o(1). $
]
#proof[
  As in @thrm_sldh_poly_linear, it suffices to show both $p^cor _"cond"$ and $p^cor _"unstable"$ are $o(1)$.
  To do this, we choose
  $
    epsilon = exp_2 (-E/2), #h(5em) eta = E / (16 N log_2  (N slash E)).
  $
  Then, simple analysis shows that for $E / N << 1$,
  $ E / (4 N) > 2 eta log_2 (1 slash eta). $
  Thus, by @prop_correlated_fundamental, we get
  $
    p^cor_"cond" &<= exp_2 (-E - 1 / 2 log_2 (epsilon) + 2 eta log_2 (1 / eta) N + O(log N)) \
    &<= exp_2 (-E + E / 4 + E / 4 + O(log N)) = exp_2 (-E / 2 + O(log N)) = o(1),
  $
  using that $E >> log  N$.
  By @prop_alg_stability, the choice of $D = o(exp_2 (E slash 4))$ now gives
  $
    p^cor_"unstable" &<= (C D epsilon) / (2 eta)
    asymp (D epsilon N log_2 (N slash E)) / E \
    &= (D exp_2 (-E slash 2) N log_2 (N slash E)) / E
    <= (D exp_2 (-E slash 2) N log_2 (N)) / E \
    &<= D exp_2 (-E / 2 + log_2 (N) + log_2 log_2 (N) - log_2 (E)) \
    &<= exp_2 (-E / 4 + log_2 (N) + log_2 log_2 (N) - log_2 (E)) = o(1),
  $
  again following from $E >> log  N$.
  Ergo, by @eq_poly_fundamental, $(p^cor _"solve")^2 <= p^cor _"unstable" + p^cor _"cond" = o(1)$.
]


Discussion meow
== Conditional Landscape Obstruction

== Proof of
