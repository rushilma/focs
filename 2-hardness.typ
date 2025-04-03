#import "focs.typ": *

= Hardness for Low Degree Algorithms

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
] <thrm_sldh_ldp>


#theorem[Hardness for LCD Algorithms][
  Let $g$ and $g'$ be $(1-epsilon)$-resampled standard Normal random vectors.
  Let $alg$ be any coordinate degree $D$ algorithm with $EE norm(alg(g))^2 <= C N$.
  Assume that
  + if $E = delta N$ for $delta > 0$, then $D <= o(N)$;
  + if $omega(log N) <= E <= o(N)$, then $D <= o(E slash log^2 E)$.
  Then there exist $epsilon=epsilon(N,D)>0$ and $eta=eta(N,E)>0$ such that
  $ PP(alg(g) in Soln(g)) = o(1). $
] <thrm_sldh_lcd>

== Preliminary Estimates

#lemma[Normal Small-Probability Estimate][
  Let $E,sigma^2 > 0$, and suppose $Z | mu ~ Normal(mu,sigma^2)$. Then
  $
    PP(abs(Z) <= 2^(-E) | mu) <= exp_2 (-E - 1 / 2 log_2 (sigma^2) + O(1)).
  $ <eq_normal_smallprob>
] <lem_normal_smallprob>
#proof[
  Observe that conditional on $mu$, the distribution of $Z$ is bounded as
  $
    phi_(Z|mu) (z) = 1 / sqrt(2 pi sigma^2) e^(-(z-mu)^2 / (2 sigma^2)) <= (2 pi sigma^2)^(-1 slash 2).
  $
  Integrating over $abs(z)<= 2^(-E)$ then gives @eq_normal_smallprob, via
  $
    PP(abs(Z) <= 2^(-E)) = integral_(abs(z) <= 2^(-E)) (2 pi sigma^2)^(-1 slash 2) dif z <= 2^(-E - 1 / 2 log_2 (2 pi sigma^2) + 1). #qedhere
  $
]

Note that @eq_normal_smallprob is a decreasing function of $sigma^2$. Thus, if there exists $gamma$ with $sigma^2 >= gamma > 0$, then @eq_normal_smallprob is bounded by $exp_2(-E - log_2(gamma) slash 2 + O(1))$.

// Chernoff-Hoeffding bound

#lemma[Chernoff-Hoeffding][
  Suppose that $K <= N slash 2$, and let $h(x)=-x log_2 (x) - (1-x) log_2 (x)$ be the binary entropy function. Then, for $p := K slash N$,
  $ sum_(k <= K) binom(N,k) <= exp_2 (N h(p)) <= exp_2 (2 N p log_2 (1 / p)). $
  // https://mathoverflow.net/questions/473730/bounding-a-binomial-coefficient-using-the-binary-entropy-function#mjx-eqn-20
] <lem_chernoff_hoeffding>
#proof[
  Consider a $"Bin"(N,p)$ random variable $S$. Summing its PMF from $0$ to $K$, we have
  $
    1 >= PP(S <= K) = sum_(k <= K) binom(N,k) p^k (1-p)^(N-k) >= sum_(k<= K) binom(N,k) p^K (1-p)^(N-K).
  $
  The last inequality follows by multiplying each term by $(p slash (1-p))^(K-k)<=1$. Rearranging gives
  $
    sum_(k <= K) binom(N,k) &<= p^(-K) (1-p)^(-(N-K)) \ &= exp_2 (-K log_2 (p) - (N-K) log_2 (1-p)) \
    &= exp_2 (N dot (-K / N log_2 (p) - ((N-K) / N) log_2 (1-p))) \
    &= exp_2 (N dot (-p log_2 (p) - (1-p) log_2 (1-p)) ) = exp_2 (N h(p)).
  $
  The final equality then follows from the bound $h(p) <= 2 p log_2 (1 slash p)$ for $p <= 1 slash 2$.
]



#proposition[
  For all $E <= O(N)$, there exists $eta=eta(N,E) in (0,1 slash 2)$ such that for $N$ sufficiently large,
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

Thus, within a small neighborhood of any $x in Sigma_N$, the number of nearby points is exponential in $N$, with a more nontrivial dependence on $eta$. The question is then how many of these are solutions to the correlated instance $g'$. This forms the heart of our conditional landscape obstruction.

#lemma[
  Let $(g,g')$ be a pair of either $(1-epsilon)$-correlated or $(1-epsilon)$-resampled instances.
  Let $x in Sigma_N$ be conditionally independent of $g'$ given $g$. Then for any $eta in (0,1 slash 2)$,
  $
    PP_corr(g,g',1-epsilon) &multiprob(
      exists x' in Soln(g') "such that",
      norm(x-x') <= 2sqrt(eta N),
    )\
    &<= exp_2(-E -1 / 2 log_2(epsilon) + 2 eta log_2(1 / eta) N + O(log N)),
  $ <eq_correlated_lowprob_disp>
  and
  $
    PP_resp(g,g',1-epsilon)
    &multiprobcond(
        g != g',
        exists x' in Soln(g') "such that",
        norm(x-x') <= 2sqrt(eta N),
    ) \
    &<= exp_2 (-E + 2 eta log_2 (1 / eta) N + O(1)).
  $ <eq_resampled_lowprob_disp>
] <lem_clo>
#proof[
  Throughout, abbreviate $eta_N := 2 sqrt(eta N)$.
  We first show @eq_correlated_lowprob_disp, by bounding the probability that
  $
    abs(ball(x,eta_N) inter Soln(g')) = sum_(x' in bball(x,eta_N)) I{ x' in Soln(g')}
  $
  is nonzero.
  By Markov's inequality, this is upper bounded by
  $
    EE[ sum_(x' in bball(x,eta_N)) I{x' in Soln(g')} ] &= EE[ sum_(x' in bball(x,eta_N)) EE[I{ x' in Soln(g')} | g] ] \
    &= EE[ sum_(x' in bball(x,eta_N)) PP(abs(inn(g',x')) <= 2^(-E) | g) ].
  $ <eq_clo_firstmoment>
  Note in particular that the range of this sum is independent of the inner probability, as $g'$ and $x$ are conditionally independent.
  // hypercube count
  To bound the number of terms in @eq_clo_firstmoment, let $k$ is the number of coordinates which differ between $x$ and $x'$ (i.e., the Hamming distance), so that
  $norm(x-x')^2=4k$.
  Thus $norm(x-x') <= 2 sqrt(eta N)$ if and only if $k <= N eta < N slash 2$, so by @lem_chernoff_hoeffding,
  $
    abs( bball(x,eta_N) ) = sum_(k <= N eta) binom(N,k) <= exp_2 (2 eta log_2 (1 slash eta)N ).
  $ <eq_hypercube_count>

  // correlated CLO
  #h(tabsize) To bound the inner probability under $corr(g,g',1-epsilon)$, fix any $x' in Sigma_N$ and write
  $ g' = p g + sqrt(1-p^2) tilde(g) $
  for $p := 1-epsilon$ and $tilde(g)$ an independent copy of $g$.
  We know $inn(tilde(g),x') ~ Normal(0,N)$, so this gives
  $ inn(g',x') | g ~ Normal(p inn(g,x'), (1-p^2)N). $
  This is nondegenerate for $(1-p^2) N >= epsilon N > 0$; by @lem_normal_smallprob, we get
  $
    PP_corr(g,g',1-epsilon)(abs(inn(g',x')) <= 2^(-E) | g) <= exp_2 (-E - 1 / 2 log_2 (epsilon) + O(log N)).
  $
  Combining with @eq_hypercube_count, this gives @eq_correlated_lowprob_disp by

  Alternatively, for @eq_resampled_lowprob_disp, we know that if $g=g'$, then the $ball(x,eta_N) inter Soln(g')$ will be nonempty if $x$ is chosen to be a solution to $g$; we thus condition on $g != g'$ throughout @eq_clo_firstmoment.
  To bound the corresponding inner term, again fix any $x' in Sigma_N$ and let $tilde(g)$ be an independent copy of $g$.
  Let $J subeq [N]$ be a random subset where each $i in J$ independently with probability $1-epsilon$, so $g'$ can be represented as
  $ g' = g_J + tilde(g)_(overline(J)). $
  Conditional on $(g,J)$, we know that $inn(tilde(g)_(overline(J)),x')$ is $Normal(0,N-abs(J))$ and $inn(g_J,x')$ is deterministic, so that
  $
    inn(g',x') | (g,J) ~ Normal(inn(g_J,x'), N - abs(J)).
  $
  As ${g != g'} = {abs(J) < N}$, we have $N - abs(J) >= 1$ conditional on $g!= g'$. Thus, @lem_normal_smallprob gives
  $
    PP_resp(g,g',1-epsilon)(abs(inn(g',x')) <= 2^(-E) | g, g!= g') <= exp_2 (-E + O(1)),
  $
  and we conclude @eq_resampled_lowprob_disp as in the previous case.
]

meow correlated pairs

#lemma[Adapted from @huangStrongLowDegree2025[Lem. 2.7]][
  Let $(g,g')$ be a pair of either $p$-correlated or $p$-resampled instances.
  Then for any set $S subset.eq RR^N$ and $p > 0$, with $q:= PP(g in S)$,
  $
    PP_corr(g,g',p)(g in S, g' in S) >= q^2
    #h(tabsize) "and" #h(tabsize)
    PP_resp(g,g',p)(g in S, g' in S) >= q^2.
  $
] <lem_correlated_solve_prob>
#proof[
  First, let $tilde(g), g^((0)), g^((1))$ be three i.i.d. copies of $g$, and observe $corr(g,g',p)$ are jointly representable as
  $
    g = sqrt(1-epsilon) tilde(g) + sqrt(epsilon) g^((0)), #h(4em)
    g' = sqrt(1-epsilon) tilde(g) + sqrt(epsilon) g^((1)).
  $
  Since $g,g'$ are conditionally independent given $tilde(g)$, we have by Jensen's inequality that
  $
    PP_corr(g,g',p)(g in S, g' in S) &= EE[ PP(g in S, g' in S | tilde(g)) ]
    &= EE[ PP(g in S | tilde(g))^2 ]
    &>= EE[ PP(g in S | tilde(g))]^2 = q^2.
  $

  Likewise, when $resp(g,g',p)$, let $J$ be a random subset of $[N]$ where each $i in J$ independently with probability $p$, so that $(g,g')$ are jointly representable as
  $
    g = tilde(g)_J + g^((0))_(overline(J)), #h(4em)
    g' = tilde(g)_J + g^((1))_(overline(J)).
  $
  Thus $g$ and $g'$ are conditionally independent given $(tilde(g),J)$, and we conclude in the same way.
]

#remark[
  Note that @lem_correlated_solve_prob also holds in the case where $alg(g,omega)$ is randomized, in the sense of @def_algorithm.
  meow
  Namely, write
  $
    p &= PP(alg(g, omega) in Soln(g)), &P& = PP(alg(g,omega) in Soln(g), alg(g',omega) in Soln(g')), \
    p(omega) &= PP(alg(g,omega) in Soln(g) | omega), #h(2em) &P(omega)& = PP(alg(g,omega) in Soln(g), alg(g',omega) in Soln(g') | omega).
  $
  @lem_correlated_solve_prob shows that for any $omega in Omega_N$, $P(omega) >= p(omega)^2$. Then, by Jensen's inequality,
  $ P = EE[P(omega)] >= EE[p(omega)^2] >= EE[p(omega)]^2 = p^2. $
  Thus, in combination with @rmk_randomized_L2_stable, the remainder of the proof also applies when $alg$ depends on an independent random seed $omega$.
] // <rmk_randomized_multiple_solve>


== Proof of Hardness for LDP Algorithms

// Hardness for Low Coordinate Degree Algorithms <section_hardness_lcd>

We consider the case where $alg$ is a polynomial algorithm with degree $D$.

Consider a pair of $(1-epsilon)$-correlated instances $(g,g')$.
Let $x := alg(g)$ and $x' := alg(g')$.

We define the events
$
  S_"solve" &:= {alg(g) in Soln(g), alg(g') in Soln(g')}, \
  S_"stable" &:= {norm(alg(g) - alg(g')) <= 2 sqrt(eta N) }, \
  S_"cond" (x) &:= multiset(
    exists.not x' in Soln(g') "such that",
    norm(x-x') <= 2sqrt(eta N),
  ).
$ <eq_poly_events>

Intuitively, the first two events ask that the algorithm solves both instances and is stable, respectively.
The last event, which depends on $x$, corresponds to the conditional landscape obstruction: for an $x$ depending only on $g$, there is no solution to $g'$ which is close to $x$.

#lemma[
  For $x := alg(g)$, we have $S_"solve" inter S_"stable" inter S_"cond" (x) = emptyset$.
] <lem_solve_disjoint>
#proof[
  Suppose that $S_"solve"$ and $S_"stable"$ both occur.
  Letting $x:=alg(g)$ (which only depends on $g$) and $x':=alg(g')$, we know $x' in Soln(g')$ and is within distance $2 sqrt(eta N)$ of $x$,
  contradicting $S_"cond" (x)$.
]

#proof[of @thrm_sldh_ldp][
  Let $p_"solve" := PP(alg(g) in Soln(g))$ be the probability that $alg$ solves one instance.
  By @lem_correlated_solve_prob, $PP_corr(g,g',1-epsilon) (S_"solve") >= p_"solve"^2$.

  In addition, let
  $
    p_"cond" := max_(x in Sigma_N) 1 - PP_corr(g,g',1-epsilon)(S_"cond" (x)).
    #h(4em)
    p_"unstable" := 1 - PP_corr(g,g',1-epsilon)(S_"stable"),
  $
  Set $epsilon := 2^(-E slash 2)$ and set $eta$ as in @prop_eta_choice.
  By @lem_clo, for $N$ sufficiently large,
  $
    p_"cond" &<= exp_2 (-E - 1 / 2 log_2 (epsilon) + 2 eta log_2 (1 / eta) N + O(log N)) \
    &<= exp_2 (-E + E / 4 + E / 4 + O(log N)) = exp_2 (-E / 2 + O(log N)) = o(1).
  $
  Next, (a) for $E = delta N$ and $D = o(exp_2(delta N slash 2))$, @prop_alg_stability gives
  $
    p_"unstable" lt.tilde D epsilon = D exp_2 (-(delta N) / 2) = o(1),
  $
  and (b) for $log N << E << N$ and $D = o(exp_2(E slash 4))$,
  $
    p_"unstable" &lt.tilde (D epsilon) / (eta) lt.tilde (D exp_2(-E slash 2) N log_2(N)) / E \
    &<= D exp_2 (-E / 2 + O(log N)) \
    &<= o(1) dot exp_2 (-E / 4 + O(log N)) = o(1).
  $
  That is, both $p_"cond"$ and $p_"unstable"$ vanish for large $N$.

  To conclude, @lem_solve_disjoint gives (for $PP = PP_corr(g,g',1-epsilon)$)
  $ PP(S_"solve") + PP(S_"stable") + PP(S_"cond" (x)) <= 2, $
  and rearranging yields
  $
    (p_"solve")^2 <= p_"unstable" + (1 - PP(S_"cond" (x)) <= p_"unstable" + p_"cond" = o(1). #qedhere
  $
]

Discussion meow

== Hardness for Low Coordinate Degree Algorithms <section_hardness_lcd>

// Degree $D$ functions

Next, let $alg$ have coordinate degree $D$.
Now consider a pair of $(1-epsilon)$-resampled instances $(g,g')$.
Let $x := alg(g)$ and $x' := alg(g')$.

$
  S_"diff" &:= { g != g'}, \
  S_"solve" &:= {alg(g) in Soln(g), alg(g') in Soln(g')}, \
  S_"stable" &:= {norm(alg(g) - alg(g')) <= 2 sqrt(eta N) }, \
  S_"cond" (x) &:= multiset(
    exists.not x' in Soln(g') "such that",
    norm(x-x') <= 2sqrt(eta N),
  ).
$ <eq_lcd_events>
Note that these are the same events as @eq_poly_events, plus the event that $g'$ is nontrivially resampled from $g$.

#lemma[
  For $g,g'$ being $(1-epsilon)$-resampled,
  $PP(S_"diff") = 1 - (1-epsilon)^N$.
] <lem_sdiff_prob>
#proof[
  This follows from the calculation
  $ PP(g=g') = product_(i=1)^N PP(g_i = g_i') = (1-epsilon)^N. #qedhere $
]

Given this meow
This is necessary as when $g=g'$, $S_"stable"$ always holds and $S_"cond" (x)$ always fails.
Note however that if we knew that $PP(S_"diff") = 1$ (which is always the case for $g,g'$ being $(1-epsilon)$-correlated), then these definitions agree with what we had in .
Again, we can define $p^res _"cond"$ via

As before, our proof follows from showing that for appropriate choices of $epsilon$ and $eta$ (depending on $D$, $E$, and $N$), $p^res _"unstable"$ and $p^res _"cond"$ are $o(1)$.
However, we are also required us to choose $epsilon >> 1/N$, so as to ensure that $g != g'$, as otherwise (a) $p^res _"cond"$ would be too large and (b) the $1-PP(S_"diff")$ term would fail to vanish.
This restriction on $epsilon$ stops us from showing hardness for algorithms with degree larger than $o(N)$, as we will see shortly.

#lemma[
  For $x:= alg(g)$, we have $S_"diff" inter S_"solve" inter S_"stable" inter S_"cond" (x) = emptyset$.
] <lem_lcd_solve_disjoint>
#proof[
  This follows from @lem_solve_disjoint, noting that the proof did not use that $g != g'$ almost surely.
]

We can interpret this as saying $S_"solve", S_"stable", S_"cond"$ are all mutually exclusive, conditional on $g != g'$.

#proof[of @thrm_sldh_lcd][
  Again let $p_"solve" := PP(alg(g) in Soln(g))$ be the probability that $alg$ solves one instance.
  By @lem_correlated_solve_prob, $PP_resp(g,g',1-epsilon) (S_"solve") >= p_"solve"^2$.
  We now redefine $p_"cond"$ and $p_"unstable"$ via
  $
    p_"cond" := max_(x in Sigma_N) 1 - PP_resp(g,g',1-epsilon)(S_"cond" (x) | S_"diff"),
    #h(2em)
    p_"unstable" := 1 - PP_resp(g,g',1-epsilon)(S_"stable" | S_"diff").
  $
  Setting $eta$ as in @prop_eta_choice, we have by @lem_clo that
  $
    p_"cond" <= exp_2 (- E + 2 eta log_2 (1 / eta) N + O(1) ) <= exp_2 (-(3 E) / 4 + O(1)) = o(1).
  $
  Next, set $epsilon := log_2 (N slash D) / N$.
  This clearly has $N epsilon >> 1$, so
  $
    PP(S_"diff") = 1 - (1-epsilon)^N >= 1 - e^(-epsilon N) -> 1.
  $ <eq_sdiff_to1>
  By @prop_alg_stability, we have for (a) $E = delta N$ and $D=o(N)$ that
  $
    p_"unstable" lt.tilde D epsilon = D / N log_2(N / D) = o(1).
  $
  Likewise, for (b) $log^2 N << E << N$ and $D = o(E slash log^2 N)$ we get
  $
    p_"unstable" lt.tilde (D epsilon) / eta lt.tilde (D log_2(N slash D) log_2(N)) / E <= (D log_2^2 N) / E = o(1).
  $
  Again, these choices of $epsilon$ and $eta$ ensure both $p_"cond"$ and $p_"unstable"$ vanish for large $N$.

  To conclude, @lem_lcd_solve_disjoint gives, for $x= alg(g)$, that $PP_resp(g,g',1-epsilon)(S_"solve",S_"stable",S_"cond" (x) |S_"diff") = 0$, so
  $
    PP(S_"solve"|S_"diff") + PP(S_"stable"|S_"diff") + PP(S_"cond" (x)|S_"diff") <= 2.
  $
  Thus, rearranging and multiplying by $PP(S_"diff")$ gives
  $
    PP(S_"solve",S_"diff") <= PP(S_"diff") dot (p_"unstable" + p_"cond") <= p_"unstable" + p_"cond".
  $
  Finally, adding $PP(S_"solve",attach(tl: not, S_"diff")) <= 1-P(S_"diff")$, which is $o(1)$ by our choice of $epsilon$, to both sides
  (so as to apply @lem_correlated_solve_prob) lets us conclude
  $
    p_"solve"^2 <= PP(S_"solve") <= p_"unstable" + p_"cond" + (1 - PP(S_"diff")) = o(1). #qedhere
  $
]



// Linear case
With this, we can show strong low degree hardness for low coordinate degree algorithms at linear energy levels $E=Theta(N)$. As before, this corresponds to hardness at the statistically optimal energy regime, but now applies to an extremely broad category of algorithms.


Finally, combining the ideas behind @thrm_sldh_poly_sublinear and our conditional landscape obstruction for $(1-epsilon)$-resampled Normal random variables, we can show hardness for algorithms with low coordinate degree at sublinear energy levels, ranging from $log^2 N << E << N$.
Here we have to increase our lower bound to $log^2 N$ as opposed to $log N$ from @thrm_sldh_poly_sublinear, to address the requirement that $epsilon=omega(1 slash N)$, but this still enables us to "close" the statistical-to-computational gap by proving hardness in this range.
Note also that our method also allows us to derive a clear tradeoff between solution energy and algorithm degree.

#remark[Tightness of Coordinate Degree Bounds][
  For any $E <= Theta(N)$, there is an easy method to achieve a discrepancy of $2^(-E)$ in $e^(O(E))$ time.
  #enum(
    [
      Pick a subset $J subeq[N]$ of $E$ coordinates.
    ],
    [
      Run LDM on the restricted NPP $g_overline(J)$ to find a partition $x_overline(J)$ with $inn(g_overline(J), x_overline(J)) <= 1$.
    ],
    [
      If we fix the values of $x_overline(J)$, the NPP given by $g$ turns into finding $x_J$ minimizing $abs(inn(g,x)) = abs(inn(g_J,x_J) + inn(g_overline(J), x_overline(J)))$. Note here that $inn(g,x)|(g_overline(J),x_overline(J)) ~ Normal(mu, E)$, for $mu=inn(g_overline(J), x_overline(J))$.
    ],
    [
      Given the statistical energy threshold is $Theta(N)$, we know $g$ has a solution with energy $E$ with high probability.
      Moreover, by the proof of @lem_normal_smallprob, the probability of any $x_J$ solving $g_J$ is independent of $O(1)$ constant shifts to the instance, so we can conclude that this restricted NPP also has an energy $E$ solution.
    ],
    [
      Thus, at this stage, we can brute force search over the remaining $J$ coordinates, which gives a solution with energy $E$ with high probability, in $e^(O(E))$ time.
    ],
  )
  In particular, this suggests that our results @thrm_sldh_lcd_linear and @thrm_sldh_lcd_sublinear are optimal under the low degree heuristic.
  Namely, low degree hardness of finding solutions with energy $E$ holds up to degree $tilde(o)(E)$, which implies finding such solutions requires at least time $e^(tilde(Omega)(E))$.
  This restricted brute force strategy shows that it is indeed possible to find these solutions in time $e^(tilde(O)(E))$, implying that our method gives the optimal energy-runtime tradeoff.
] <rmk_optimal>

It is worthwhile asking whether the low degree heuristic is truly appropriate in our brittle setting.
For instance, in most cases where it has been applied to a random optimization problem (e.g., by Huang and Sellke @huangStrongLowDegree2025), the objective under consideration has been fairly stable.
However, the NPP has a very one-dimensional landscape, lacking the "depth" which foils the low degree heuristic for, e.g., broadcasting on trees @huangOptimalLowDegree2025.
Moreover, the sharp energy-runtime tradeoff in @rmk_optimal is suggestive of the strength of this heuristic in this case.

As a final remark, consider that an algorithm with coordinate degree $Omega(N)$ (equivalently, $Theta(N)$) is one which considers nonlinear interactions between some constant fraction of all the coordinates as $N$ gets large.
Intuitively, such an algorithm is forced to look at how a large number of instance elements balance against each other, giving further evidence to the claim that any sufficiently local algorithm for the NPP will be no better than random search.
The good algorithms must be global, which reflects recent developments in heuristics for computing solutions to the NPP @kraticaTwoMetaheuristicApproaches2014 @corusArtificialImmuneSystems2019 @santucciImprovedMemeticAlgebraic2021.

== Extensions to Close Algorithms

In @section_hardness, we have established strong low degree hardness for both low degree polynomial and low coordinate degree algorithms.
However, our stability analysis assumed that the algorithms in question were $Sigma_N$-valued.
In this section, we show that this assumption is not in fact as restrictive as it might appear.

Throughout, let $alg$ denote a $RR^N$-valued algorithm.
We want to show that:
#enum(
  // numbering: "I.",
  [no low degree $alg$ can reliably output points _close_ -- within constant distance -- to a solution;],
  [no $Sigma_N$-valued algorithm $tilde(alg)$ coming from randomly rounding the output of $alg$, which changes an $omega(1)$ number of coordinates, can find a solution with nonvanishing probability.],
)
In principle, the first possibility fails via the same analysis as in @section_hardness, while the second fails because the landscape of solutions to any given NPP instance is sparse.

Why are these the only two possibilities? For $alg$ to provide a way to actually solve the NPP, we must be able to turn its outputs on $RR^N$ into points on $Sigma_N$. If $alg$ could output points within an constant distance (independent of the instance) of a solution, then we could convert $alg$ into a $Sigma_N$-valued algorithm by manually computing the energy of all points close to its output and returning the energy-maximizing point.

However, another common way to convert a $RR^N$-valued algorithm into a $Sigma_N$-valued one is by rounding the outputs, as in @alaouiSamplingSherringtonKirkpatrickGibbs2024a @huangStrongLowDegree2025.
Doing this directly can lead to difficulties in performing the stability analysis.
In our case, if we know that no $alg$ can reliably output points within constant distance of a solution, then any rounding scheme which only flips $O(1)$ many coordinates will assuredly fail.
Thus, the only rounding schemes worth considering must flip $omega(1)$ many coordinates.

We first show that no low degree $alg$ can find points within constant distance of a solution, effectively by reproducing the argument of @section_hardness_lcd.
We then turn to describing a landscape obstruction to randomized rounding, relying on what we term the _solution repulsion property_: solutions to any NPP instance are far away from each other, with this distance tradeoff controlled by the energy level of the solution set in consideration.
This can then be leveraged to show that any sufficiently randomized rounding scheme will always fail to find solutions at energies higher than the computational threshold.

------------

Throughout this section, fix a distance $r=O(1)$.
Consider the event that the $RR^N$-valued algorithm $alg$ outputs a point close to a solution for an instance $g$:
$
  S_"close" (r) = multiset(
    exists hat(x) in Soln(g) "s.t.",
    alg(g) in ball(hat(x), r)
  ) = {ball(alg(g), r) inter Soln(g) != emptyset }.
$
