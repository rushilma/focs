#import "focs.typ": *

= Truly Random Rounding <section_rounding>

While deterministic algorithms fail to get close to NPP solutions, perhaps a randomized rounding scheme could work instead.
As discussed above, the failure of algorithms finding outputs within a constant distance of a solution motivates considering rounding schemes which are "truly random," in that they change a superconstant number of coordinates.
However, this approach is blunted by the same brittleness of the NPP landscape that established the conditional obstruction of () // @prop_correlated_fundamental and @prop_resampled_fundamental.
In particular, @thrm_solutions_repel shows that if one has a subcube of $Sigma_N$ with dimension growing slowly with $N$, then at most only one of those points will be a solution.

For this section, again let $alg$ be a deterministic $RR^N$-valued algorithm.
Moreover, assume we are searching for solutions with energy between $log^2 N << E <= N$; note that for lower values, the Karmarkar-Karp algorithm can already achieve discrepancies of $N^(-Theta(log N))$ energy in polynomial time.

To start, for any $x in RR^N$, we write $x^*$ for the coordinate-wise signs of $x$, i.e.,
$ x^*_i := cases(+1 #h(1em) &x_i > 0\,, -1 &x_i <= 0.) $
We can then define the deterministically rounded algorithm $alg^*(g) := alg(g)^*$.

#remark[
  Observe that if $alg$ was a low coordinate degree algorithm, then $alg^*$ has the same coordinate degree, so strong low degree hardness as proved in @section_hardness_lcd still applies. On the other hand, if $alg$ was a low polynomial degree algorithm, then $alg^*$ will not be polynomial, but as coordinate degree bounds polynomial degree, we can recover strong low degree hardness, albeit with worse bounds on $D$.
]

In contrast to deterministically rounding of the outputs of $alg$ by taking signs,
we can consider passing the output of $alg$ through a randomized rounding scheme. Let $round(x,omega) colon RR^N times Omega to Sigma_N$ denote any randomized rounding function, with randomness $omega$ independent of the input.
We will often suppress the $omega$ in the notation, and treat $round(x)$ as a $Sigma_N$-valued random variable.
We can describe such a randomized rounding function in the following way.
Define $p_1 (x),dots,p_N (x)$ by
$ p_i (x) := max(PP(round(x)_i != x^*_i), 1/2). $ <eq_rounding_changed_coord>

We need to guarantee that each $p_i (x) <= 1 slash 2$ for the following alternative description of $round(x)$.

#lemma[
  Fix $x in RR^N$. Draw $N$ coin flips $I_(x,i) ~ "Bern"(2p_i (x))$ as well as $N$ signs $S_i ~ "Unif"{plus.minus 1}$, all mutually independent; define the random variable $tilde(x) in Sigma_N$ by
  $ tilde(x)_i := S_i I_(x,i) + (1-I_(x,i)) x^*_i. $
  Then $tilde(x) ~ round(x)$.
] <lem_random_rounding_altdef>
#proof[
  Conditioning on $I_(x,i)$, we can check that
  $
    PP(tilde(x)_i != x_i) &= 2 p_i (x) dot PP(tilde(x)_i = x_i | I_(x,i) = 1) + (1-2p_i (x) ) dot PP(tilde(x)_i != x_i | I_(x,i) = 0)
    = p_i (x).
  $
  Thus, $PP(tilde(x)_i = x^*_i) = PP(round(x)_i = x^*_i)$.
]

By @lem_random_rounding_altdef, we can redefine $round(x)$ to be $tilde(x)$ as constructed above without loss of generality.

// What is tilde(x)?

It thus makes sense to define $tilde(alg)(g) := round(alg(g))$, which is now (a) $Sigma_N$-valued and (b) randomized only in the transition from $RR^N$ to $Sigma_N$ (i.e., the rounding does not depend directly on $g$, but only on the output $x = alg(g)$).
We should expect that if $tilde(alg)=alg^*$ (e.g., if $alg$ outputs values far outside the cube $[-1,1]^N$) with high probability, then low degree hardness will still apply, since $alg^*$ is deterministic.
However, in general, any $tilde(alg)$ which differs from $alg^*$ will fail to solve $g$ with high probability.
This is independent of any assumptions on $alg$: any rounding scheme will introduce so much randomness that $tilde(x)$ will effectively be a random point, which has a vanishing probability of being a solution because of how sparse and disconnected the NPP landscape is.

To see this, we first show that any randomized rounding scheme as in @lem_random_rounding_altdef which differs almost surely from simply picking the signs will resample a diverging number of coordinates.

#lemma[
  Fix $x in RR^N$, and let $p_1 (x),dots,p_N (x)$ be defined as in @eq_rounding_changed_coord.
  Then $tilde(x) != x^*$ with high probability if and only if $sum_i p_i (x) = omega(1)$.
  Moreover, assuming that $sum_i p_i (x)= omega(1)$, the number of coordinates in which $tilde(x)$ is resampled diverges almost surely.
] <lem_rounding_changes_soln>
#proof[
  Recall that for $x in [0,1 slash 2]$, $log_2 (1-x) = Theta(x)$.
  Thus, as each coordinate of $x$ is rounded independently, we can compute
  $
    PP(tilde(x) = x^*) = product_i (1-p_i (x)) = exp_2 (sum_i log_2 (1-p_i (x))) <= exp_2 (- Theta(sum_i p_i (x))).
  $
  Thus, $PP(tilde(x)=x^*) = o(1)$ if and only if $sum_i p_i (x) = omega(1)$.

  Next, following the construction of $tilde(x)$ in @lem_random_rounding_altdef, let $E_i = {I_(x,i) = 1}$ be the event that $tilde(x)_i$ is resampled from $ "Unif"{plus.minus 1}$, independently of $x^*_i$.
  The $E_i$ are independent, so by Borel-Cantelli, $sum_i PP(E_i) = 2 sum_i p_i (x) = omega(1)$ implies that $tilde(x)_i$ is resampled infinitely often with probability 1.
]

To take advantage of the above construction, we show @thrm_solutions_repel: this is a landscape obstruction for single instances of the NPP which shows that solutions resist clustering at a rate related to their energy level (i.e., higher energy solutions push each other further apart). This will let us conclude that any $tilde(alg)$ which is not equal to $alg^*$ with high probability fails to find solutions.

#theorem[Solutions Repel][
  Consider any distances $k = Omega(1)$ and energy levels $E >> k log N$.
  With high probability, there are no pairs of distinct solutions $x,x' in Soln(g)$ to an instance $g$ with $norm(x-x') <= 2 sqrt(k)$ (i.e., within $k$ sign flips of each other):
  $
    PP multiprob(
      exists (x,x') in Soln(g) "s.t.",
      norm(x-x') <= 2sqrt(k).
    )
    <= exp_2 (-E + O(k log N)) = o(1).
  $ <eq_solutions_repel>
] <thrm_solutions_repel>
#proof[
  Consider any $x != x'$, and let $J subeq [N]$ denote the coordinates in which $x,x'$ differ. Then
  $ x = x_(overline(J)) + x_J, #h(5em) x' = x_(overline(J)) - x_J. $
  Assuming both $x,x' in Soln(g)$, we can expand the inequalities
  $-2^(-E) <= inn(g,x), inn(g,x') <= 2^(-E)$
  into
  $
    -2^(-E) <= &inn(g,x_(overline(J))) + inn(g,x_J) <= 2^(-E), \
    -2^(-E) <= &inn(g,x_(overline(J))) - inn(g,x_J) <= 2^(-E).
  $
  Multiplying the lower equation by $-1$ and adding the resulting inequalities gives $abs(inn(g,x_J)) <= 2^(-E)$.

  Thus, finding pairs of distinct solutions within distance $2 sqrt(k)$ implies finding a subset $J subeq [N]$ of at most $k$ coordinates and $abs(J)$ signs $x_J$ such that $abs(inn(g_J,x_J)) <= 2^(-E)$.
  By @vershyninHighDimensionalProbabilityIntroduction2018[Exer. 0.0.5], there are
  $
    sum_(1 <= k' <= k)binom(N,k') <= ((e N) / k)^k <= (e N)^k = 2^(O(k log N))
  $
  choices of such subsets, and at most $2^k$ choices of signs.
  Now, $inn(g_J,x_J) ~ Normal(0,abs(J))$, and as $abs(J)>=1$, @lem_normal_smallprob and the following remark implies $PP(abs(inn(g_J,x_J)) <= 2^(-E)) <= exp_2(-E + O(1))$. Union bounding this over the $2^O(k log N)$ possibilities gives @eq_solutions_repel.
]

Here, our technique of converting pairs of solutions into subvectors of $g$ which must have small sum enables us to reduce the size of the set we union bound over from $2^(O(N))$ to $2^(O(k log N))$.
Moreover, observe that this proof can be adapted to show that for a fixed $x in Soln(g)$, there are no other solutions within $k$ sign flips with high probability.

Finally, we exhibit strong hardness for truly randomized algorithms. Roughly, this holds because if enough coordinates are resampled, the resulting point is random within a subcube of dimension growing slowly with $Sigma_N$, which overwhelms the brittleness in @thrm_solutions_repel.

#theorem[
  Let $x= alg(g)$, and define $x^*, tilde(x)$, etc., as previously.
  Moreover, assume that for any $x$ in the possible outputs of $alg$, we have $sum_i p_i (x) = omega(1)$.
  Then, for any $E >= omega(log^2 N)$, we have
  $ PP(tilde(alg)(g) in Soln(g)) = PP(tilde(x) in Soln(g)) <= o(1). $
]
#proof[
  Following the characterization of $tilde(x)$ in @lem_random_rounding_altdef, let $K := max(log_2 N, sum_i I_(x,i))$.
  By the assumptions on $sum_i p_i (x)$ and @lem_rounding_changes_soln, we know $K$, which is at least the number of coordinates which are resampled, is bounded as $1 << K <= log_2 N$, for any possible $x = alg(g)$.
  Now, let $J subeq [N]$ denote the set of the first $K$ coordinates to be resampled, so that $K = abs(J)$, and consider
  $ PP(tilde(x) in Soln(g) | tilde(x)_(overline(J))), $
  where we fix the coordinates outside of $J$ and let $tilde(x)$ be uniformly sampled from a $K$-dimensional subcube of $Sigma_N$.
  All such $tilde(x)$ are within distance $2sqrt(K)$ of each other, so by @thrm_solutions_repel, the probability that there is more than one such $tilde(x) in Soln(g)$ is bounded by
  $ exp_2 (-E + O(K log N)) <= exp_2(-E + O(log^2 N)) = o(1), $
  by assumption on $E$. Thus, the probability that any of the $tilde(x)$ is in $Soln(g)$ is bounded by $2^(-K)$, whence
  $
    PP(tilde(x) in Soln(g)) =
    EE[ PP(tilde(x) in Soln(g) | tilde(x)_(overline(J))) ] <= 2^(-K) <= o(1). #qedhere
  $
  // This should work as the rounding bounds are independent of the bounds pertaining to g, by assumption that sum_i p_i (x) = omega(1) for all x; can't have alg throw a bunch of x's where K = O(1).
]

While this rules out many possible randomized rounding schemes, there is still the potential for rounding in a way that depends on both $g$ and $x$ to find solutions with nonvanishing probability.
More generally, recent work by Li and Schramm has pointed out that the presence of an OGP or a conditional landscape obstruction is itself evidence of the brittleness of a random optimization problem @liEasyOptimizationProblems2024.
Thus, stable algorithms (e.g., Lipschitz, smooth, etc.) are intrinsically ill-suited for such tasks.
In light of this, low (coordinate) degree algorithms, which can be stable but are not required to be continuous or smooth, provide better intrinsic models.
Given that, new approaches on algorithms for the NPP could focus on non-stable algorithms, such as linear or semidefinite programming.
We invite these as interesting directions for potential future work.

