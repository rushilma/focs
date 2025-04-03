#import "focs.typ": *
#show: thmrules.with(qed-symbol: $square$)

/// Abstract

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

= Introduction

Suppose that we have $N$ items, each with associated weights.
How should we divide these items into two groups so that the sum of their weights is as close as possible?
Or, is it possible to divide these items into two groups such that the absolute difference of the sums of their weights is below a certain threshold?
This question is known as the _number partitioning problem (NPP)_,
and has been a subject of fascination in statistics, physics, and computer science since its proposal in 1969 @grahamBoundsMultiprocessingTiming1969.

Formally, let $g_1,dots,g_N$ be $N$ real numbers.
The NPP is the problem of finding the subset $A$ of $[N]:={1,2,dots,N}$ which minimizes the discrepancy
$ abs(sum_(i in A) g_i - sum_(i in.not A) g_i). $
Alternatively, identify the instance $g_1,dots,g_N$ with a point $g in RR^N$.
Then, choosing a subset $A subset.eq [N]$ is equivalent to choosing a point $x$ in the $N$-dimensional binary hypercube $Sigma_N := {plus.minus 1}^N$, where $x_i = +1$ is the same as including $i in A$.
The discrepancy of $x$ is now $abs(inn(g,x))$, and solving the NPP means finding the $x$ minimizing this discrepancy:
$ min_(x in Sigma_N) abs(inn(g,x)). $ <eq_npp_first>

Rephrased as a decision problem -- whether there exists a subset $A subeq [N]$ (or a point $x in Sigma_N$) such that the discrepancy is zero, or sufficiently small -- the NPP is NP-complete; this can be shown by reduction from the subset sum problem.
In fact, the NPP is one of the six basic NP-complete problems of Garey and Johnson, and of those, the only one involving numbers @gareyComputersIntractabilityGuide1979[#sym.section 3.1].

// practical applications

Finding "good" solutions to this problem has a number of practical applications.
For instance, the NPP and MWNPP
#footnote[That is, the _multiway number partitioning problem (MWNPP)_, in which we want to partition $g_1,dots,g_N$ into $M$ subsets such that the within-subset sums are mutually close; what "mutually close" means precisely varies across the literature.]
were first formulated by Graham, who considered it in the context of multiprocessor scheduling: dividing a group of tasks with known runtimes across a pool of processors so as to minimize one core being overworked while others stall @grahamBoundsMultiprocessingTiming1969.
Later work by Coffman, Garey, and Johnson, as well as Tsai, looked at utilizing algorithms for the NPP for designing multiprocessor schedulers or large integrated circuits @coffmanjr.ApplicationBinPackingMultiprocessor1978 @tsaiAsymptoticAnalysisAlgorithm1992.
Coffman and Lueker also write on how the NPP can be applied as a framework for allocating material stocks, such as steel coils in factories, paintings in museums, or advertisements in newspapers @coffmanProbabilisticAnalysisPacking1991.

// application: randomized control trials

One particularly important application of the NPP in statistics comes from the design of _randomized controlled trials_.
Consider $N$ individuals, each with a set of covariate information $g_i in RR^d$.
Then the problem is to divide them into a treatment group (denoted $A_+$) and a control group (denoted $A_-$), subject each to different conditions, and evaluate the responses.
In order for such a trial to be accurate, it is necessary to ensure that the covariates across both groups are roughly the same.
In our notation, this equates to finding an $A_+$ (with $A_- := [N] without A_+$) minimizing
$
  min_(A_+ subeq [N]) norm( sum_(i in A_+) g_i - sum_(i in A_-) g_i )_infinity.
$ <eq_def_vbp>
This extension of the NPP is often termed the _vector balancing problem (VBP)_, and many algorithms for solving the NPP/VBP come from designing such randomized controlled trials @kriegerNearlyRandomDesigns2019 @harshawBalancingCovariatesRandomized2023.

// applications: cryptography

On the other hand, in 1976, Merkle and Hellman devised one of the earliest public key cryptography schemes, deriving its hardness from their belief that a variant of the NPP was computationally difficult to solve -- at the time, it was not yet known whether the NPP was NP-complete or not @merkleHidingInformationSignatures1978.
Their proposal was for the receiver, say Alice, to generate as a public key $N$ natural numbers $(a_1,dots,a_N)$, with $N$ typically around 100 and each $a_i$ around 200 bits long.
To encrypt a $N$-bit message $x = (x_1,dots,x_N) in {0,1}^N$, the sender, say Bob, could compute
$ b := sum_(i in N) a_i x_i $
and send the ciphertext $b$ to Alice.
Any eavesdropper would know $a_1,dots,a_N$, as well as $b$, and decrypting the message involved finding a subset of the $a_i$ adding up to $b$.
This is known as the _knapsack problem_, which is NP-complete, as can be shown by restriction to the NPP @gareyComputersIntractabilityGuide1979[3.2.1(6)].
However, such NP-completeness is only a worst-case hardness guarantee; Merkle and Hellman's scheme involved Alice choosing $a_1,dots,a_N$ by cryptographically scrambling a sequence $(a'_1,dots,a'_N)$ for which solving the NPP was easy, enabling the receiver to practically decrypt the message $x$ from the ciphertext $b$.
In 1984, Shamir -- one of the developers of the RSA cryptosystem still in use today -- showed that one could exploit this public key generation process to reduce the "hard" knapsack problem to one which was solvable in polynomial time, rendering the Merkle-Hellman scheme insecure @shamirPolynomialTimeAlgorithm1982.
While today, Merkle-Hellman is but a footnote in the history of cryptography, it demonstrates the importance of looking beyond worst-case hardness and expanding complexity theory to describe the difficulty of the average problem instance.

// physics and phase transition

=== Meow moe wmeow
Another major source of interest in the NPP, as well as potential explanations for when it is hard, come from statistical physics.
In the 1980s, Derrida introduced the eponymous _random energy model (REM)_, a simplified example of a spin glass in which, unlike the Sherrington-Kirkpatrick or other $p$-spin glass models, the possible energy levels are independent of each other @derridaRandomEnergyModelLimit1980 @derridaRandomenergyModelExactly1981 @baukeNumberPartitioningRandom2004.
Despite this simplicity, this model made possible heuristic analyses of the Parisi theory for mean field spin glasses, and it was suspected that arbitrary random discrete systems would locally behave like the REM @baukeUniversalityLevelStatistics2004 @kistlerDerridasRandomEnergy2014.
The NPP was the first system for which this local REM conjecture was shown @borgsProofLocalREM2009 @borgsProofLocalREM2009a.
In addition, in the case when the $g_i$ are independently chosen uniformly over ${1,2,...,2^M}$, Gent and Walsh conjectured that the hardness of finding perfect partitions (i.e., with discrepancy zero if $sum_i g_i$ is even, and one else) was controlled by the parameter $kappa := m/n$ @gentAnalysisHeuristicsNumber1998 @gentPhaseTransitionsAnnealed2000.
Mertens soon gave a nonrigorous statistical mechanics argument suggesting the existence of a phase transition from $kappa < 1$ to $kappa > 1$; that is, while solutions exist in the low $kappa$ regime, they stop existing in the high $kappa$ regime @mertensPhysicistsApproachNumber2001.
It was also observed that this phase transition coincided with the empirical onset of computational hardness for typical algorithms, and Borgs, Chayes, and Pittel proved the existence of this phase transition soon after @hayesEasiestHardProblem2002 @borgsPhaseTransitionFinitesize2001.

// algorithmic gap

== The Statistical-to-Computational Gap

Many problems involving searches over random combinatorial structures (i.e., throughout high-dimensional statistics) exhibit a statistical-to-computational gap: the optimal values which are known to exist via non-constructive, probabilistic methods are far better than those achievable by state-of-the-art algorithms.
In the pure optimization setting, examples such gaps are found in random constraint satisfaction @mezardClusteringSolutionsRandom2005 @achlioptasAlgorithmicBarriersPhase2008 @kothariSumSquaresLower2017, finding maximal independent sets in sparse random graphs @gamarnikLimitsLocalAlgorithms2014 @coja-oghlanIndependentSetsRandom2015, the largest submatrix problem @gamarnikFindingLargeSubmatrix2016 @gamarnikOverlapGapProperty2021a, and the $p$-spin and diluted $p$-spin models @gamarnikOverlapGapProperty2019 @chenSuboptimalityLocalAlgorithms2019.
These gaps also arise in various "planted" models, such as matrix or tensor PCA @berthetComputationalLowerBounds2013 @lesieurMMSEProbabilisticLowrank2015 @lesieurPhaseTransitionsSparse2015 @hopkinsTensorPrincipalComponent2015 @hopkinsPowerSumofsquaresDetecting2017 @arousAlgorithmicThresholdsTensor2020,
high-dimensional linear regression @gamarnikSparseHighDimensionalLinear2019 @gamarnikHighDimensionalRegressionBinary2019,
or the infamously hard planted clique problem @jerrumLargeCliquesElude1992 @deshpandeImprovedSumofSquaresLower2015 @mekaSumofsquaresLowerBounds2015 @barakNearlyTightSumofSquares2016 @gamarnikLandscapePlantedClique2019.
These indicate that these problems are "hard" in a way that goes beyond being NP; algorithms fail even on average-case instances.

The NPP is no exception: despite its apparent simplicity, its persistent importance in the random optimization literature comes from the shocking width of its associated statistical-to-computational gap.
On the statistical side, the landmark result here is by Karmarkar et al., who showed that when the $g_i$ are i.i.d.random variables, with distribution sufficiently nice,
#footnote[Specifically, having bounded density and finite fourth moment.] <foot_nice>
then the minimum discrepancy of @eq_npp_first is $Theta(sqrt(N) 2^(-N))$ with high probability as $N to infinity$ @karmarkarProbabilisticAnalysisOptimum1986.
Their result also extends to _even partitions_, where the sizes of each subset is equal (i.e., for $N$ even), worsening only to $Theta( N 2^(-N))$.
Yet the best known algorithms cannot achieve discrepancies close to this in polynomial time.

A first approach to the NPP, often termed the _greedy heuristic_, would be to sort the $N$ inputs, place the largest in one subset, and place the subsequent largest numbers in the subset with the smaller total running sum.
This takes $O(N log N)$ time (due to the sorting step), but achieves a discrepancy of $O(N^(-1))$, extremely far off from the statistical optimum @mertensEasiestHardProblem2003.
More recently, Krieger et al. developed an algorithm achieving a discrepancy of $O(N^(-2))$, but in exchange for this poor performance, their algorithm solves for a balanced partition, making it useful for randomized control trials @kriegerNearlyRandomDesigns2019.

The true breakthrough towards the statistical optimum came from Karmarkar and Karp, whose algorithm produced a discrepancy of $O(N^(-alpha log N))=2^(-O(log^2 N))$ with high probability.
Their algorithm is rather complicated, involving randomization and a resampling step to make their analysis tractable, but their main contribution is the _differencing heuristic_ @karmarkarDifferencingMethodSet1983.
The idea is as follows: if $S$ is a list of items, then putting $g,g' in S$ in opposite partitions is the same as removing $g$ and $g'$ and adding $abs(g-g')$ back to $S$.
Karmarkar and Karp propose two simpler algorithms based on this heuristic, the _partial differencing method (PDM)_ and _largest differencing method (LDM)_, which they conjectured could also achieve discrepancies of $O(N^(-alpha log N))$.
In both, the items are first sorted, and the differencing is performed on the pairs of the largest and second largest items.
However, in PDM, the remainders are ignored until all original numbers have been differenced, and then are resorted and repartitioned, while LDM reinserts the remainder in sorted order at each step; in any case, both algorithms are thus polynomial in $N$.
Lueker soon disproved the claim that PDM could achieve the Karmarkar-Karp discrepancy, showing that when $g_i$ were i.i.d. Uniform on $[0,1]$, then the expected discrepancy was $Theta(N^(-1))$, no better than the greedy algorithm @luekerNoteAveragecaseBehavior1987.
However, for $g_i$ i.i.d. Uniform or even Exponential, Yakir confirmed that LDM could achieve the performance of the original differencing algorithm, proving that its expected discrepancy was $N^(-Theta(log N))$ @yakirDifferencingAlgorithmLDM1996.
The constant $alpha$ was later estimated for LDM to be $alpha=1/(2 ln 2)$, via nonrigorous calculations @boettcherAnalysisKarmarkarKarpDifferencing2008.

Of course, at its most basic level, the NPP is a search problem over $2^N$ possible partitions, so given more and more time, an appropriate algorithm could keep improving its partition until it achieved the global optimum.
To this degree, Korf developed alternatives known as the _complete greedy_ and _complete Karmarkar-Karp_ algorithms which, if run for exponentially long time, can find the globally optimal partition @korfApproximateOptimalSolutions1995 @korfCompleteAnytimeAlgorithm1998.
This algorithm was later extended to multiway number partitioning @korfMultiwayNumberPartitioning2009.
See also Michiels et al. for extensions to balanced multiway partitioning @michielsPerformanceRatiosDifferencing2003.

For the multidimensional VBP case, Spencer showed in 1985 that the worse-case discrepancy of the VBP was at most $6sqrt(N)$ for $d=N$ and $norm(g_i)_infinity <= 1$ for all $1 <= i <= N$ @spencerSixStandardDeviations1985.
However, his argument is an application of the probabilistic method, and does not construct such a solution.
In the average case, Turner et al. proved that, under similar regularity assumptions on the $g_i$,@foot_nice the minimum discrepancy is $Theta(sqrt(N) 2^(-N slash d))$ for all $d <= o(N)$, with high probability @turnerBalancingGaussianVectors2020.
For the regime $delta=Theta(N)$, Aubin et al. conjecture that there exists an explicit function $c(delta)$ such that for $delta > 0$, the discrepancy in the $d=delta N$ regime is $c(delta) sqrt(N)$ with high probability @aubinStorageCapacitySymmetric2019.
To this end, Turner et al. also showed that for $d <= delta N$, one can achieve $O(sqrt(N) 2^(-1 slash delta))$ with probability at least 99% @turnerBalancingGaussianVectors2020.
On the algorithmic side, they generalized the Karmarkar-Karp algorithm to VBP, which, for $2 <= d = O(sqrt( log N))$ finds partitions with discrepancy $2^(-Theta(log^2 N slash d))$, reproducing the gap of classical Karmarkar-Karp.
On the other hand, in the superlinear regime $d >= 2 N$, this average-case discrepancy worsens to $tilde(O)(sqrt(N log(2d slash N)))$ @chandrasekaranIntegerFeasibilityRandom2013.
Yet, many proposed algorithms can achieve similar discrepancies, which is believed to be optimal for $d >= N$ @spencerSixStandardDeviations1985 @bansalConstructiveAlgorithmsDiscrepancy2010 @lovettConstructiveDiscrepancyMinimization2012 @rothvossConstructiveDiscrepancyMinimization2016.

== Algorithmic Hardness and Landscape Obstructions

Classical algorithmic complexity theory -- involving classes such as P, NP, etc. -- is poorly suited to describing the hardness of random optimization problems, as these classes are based on the worst-case performance of available algorithms.
In many cases, the statistically possible performance of solutions to random instances of these NP-complete problems will be far better than the worst-case analysis would suggest.
How then, can we extend complexity theory to describe problems which, like the NPP, are hard on average?
Along with the aforementioned statistical-to-computational gaps, the past two decades of research have shown that many methods can provide evidence of this average-case hardness, such as the failure of Markov chain algorithms
@jerrumLargeCliquesElude1992 @gamarnikAlgorithmicObstructionsRandom2021b @huangStrongLowDegree2025,
the failure of approximate message passing (AMP) algorithms
@zdeborovaStatisticalPhysicsInference2016 @bandeiraNotesComputationaltostatisticalGaps2018,
or lower bounding performance against the sum-of-squares hierarchy or the statistical query model
@hopkinsTensorPrincipalComponent2015 @hopkinsPowerSumofsquaresDetecting2017 @raghavendraHighdimensionalEstimationSumofsquares2019 @barakNearlyTightSumofSquares2016 @kearnsEfficientNoisetolerantLearning1998 @diakonikolasStatisticalQueryLower2017 @feldmanStatisticalAlgorithmsLower2016.

One particularly interesting approach is to prove average-case to worst-case reductions: if one shows that a polynomial-time algorithm for solving random instances could be used to design a polynomial-time algorithm for arbitrary instances, then assuming the problem was known to be in NP, it can be concluded that no such polynomial-time algorithm for the average case can exist @gamarnikOverlapGapProperty2021.
This method has been used to show hardness for sparse PCA, detecting planted independent subgraphs, and more by reducing to the random planted clique problem @berthetComputationalLowerBounds2013 @brennanOptimalAverageCaseReductions2019 @brennanReducibilityComputationalLower2019.
To this extent, Hoberg et al. provided such evidence of hardness for the NPP by showing that a polynomial-time approximation oracle achieving discrepancies around $O(2^sqrt(N))$ could give polynomial-time approximations for Minkowski's problem, the latter of which is known to be hard @hobergNumberBalancingHard2016.
More recently, Vafa and Vaikuntanathan showed that the Karmarkar-Karp algorithm's performance was nearly tight, assuming the worst-case hardness of the shortest vector problem on lattices @vafaSymmetricPerceptronsNumber2025.
Other conjectures suggested that the onset of algorithmic hardness was related to phase transitions in the solution landscapes, something which has been shown for random $k$-SAT, but this fails to describe hardness for optimization problems.

A more recent and widely successful approach is based on analyzing the geometry of the solution landscape.
Many "hard" random optimization problems have a certain disconnectivity property, known as the _overlap gap property (OGP)_ @gamarnikOverlapGapProperty2021.
Roughly, this means there exist $0 <= nu_1 < nu_2$ such that, for every two near-optimal states $x,x'$ for a particular instance $g$ of the problem either have $d(x,x')<nu_1$ or $d(x,x') > nu_2$.
That is, pairs of solutions are either close to each other, or much further away -- the condition that $nu_1 < nu_2$ ensures that the "diameter" of solution clusters is much smaller than the separation between these clusters.
#footnote[This is called the "overlap" gap property because, in the literature, this is often described in terms of the inner product of the solutions, as opposed to the distance between them.]
Beyond ruling out the existence of pairs of near solutions with $d(x,x') in [nu_1,nu_2]$, a common extension is the _multioverlap OGP ($m$-OGP)_: given an ensemble of $m$ strongly correlated instances, there do not exist $m$-tuples of near solutions all equidistant from each other.
This extension is often useful to lower the "threshold" at which the OGP starts to appear.
Once established, the OGP and $m$-OGP, which is intrinsic to the problem, can be used to rule out the success of wide classes of stable algorithms @achlioptasSolutionSpaceGeometryRandom2006 @achlioptasAlgorithmicBarriersPhase2008 @mezardClusteringSolutionsRandom2005 @gamarnikLimitsLocalAlgorithms2014 @rahmanLocalAlgorithmsIndependent2017 @weinOptimalLowDegreeHardness2020.

For the NPP, it was expected for decades that the "brittleness" of the solution landscape would be a central barrier in finding successful algorithms to close the statistical-to-computational gap. Mertens wrote in 2001 that any local heuristics, which only looked at fractions of the domain, would fail to outperform random search @mertensPhysicistsApproachNumber2001[#sym.section 4.3].
This was backed up by the failure of many algorithms based on locally refining Karmarkar-Karp-optimal solutions, such as simulated annealing
@arguelloRandomizedMethodsNumber1996 @storerProblemSpaceLocal1996 @johnsonOptimizationSimulatedAnnealing1989b @johnsonOptimizationSimulatedAnnealing1991 @alidaeeNewModelingSolution2005.
To that end, more recent approaches for algorithmic development are rooted in more global heuristics
@kraticaTwoMetaheuristicApproaches2014 @corusArtificialImmuneSystems2019 @santucciImprovedMemeticAlgebraic2021,
and some of the most interesting directions in algorithmic development for the NPP comes from quantum computing: as this is outside our scope, we encourage the interested reader to consult @asproniAccuracyMinorEmbedding2020 @wenOpticalExperimentalSolution2023.
The main result to this effect comes from Gamarnik and Kızıldağ, who proved that for $m$ of constant order, the $m$-OGP for NPP held for discrepancies of $2^(-Theta(N))$ (i.e., the statistical optimum), but was absent for smaller discrepancies of $2^(-E_N)$ with $omega(1) <= E_N <= o(N)$ @gamarnikAlgorithmicObstructionsRandom2021b.
They do show, however, that the $m$-OGP in for $E_N >= omega(sqrt(N log N))$ could be recovered for $m$ superconstant.
This allowed them to prove that for $epsilon in (0,1 slash 5)$, no stable algorithm (suitably defined) could find solutions with discrepancy $2^(-E_N)$ for $omega(N log^(-1/5 + epsilon) N) <= E_N <= o(N)$ @gamarnikAlgorithmicObstructionsRandom2021b[Thm. 3.2].
These results point to the efficacy of using landscape obstructions to show algorithmic hardness for the NPP, which we will take advantage of in @section_hardness.

== Our Results <section_intro_results>

In this thesis, we use a variant of the OGP, which we term a _conditional landscape obstruction_, to prove low degree algorithmic hardness guarantees for the NPP at a range of discrepancy scales.
Our obstruction is based on the observation that given a solution to one instance of the NPP, it is impossible to pin down the location of any solution to a strongly correlated instance, which prevents suitably stable algorithms from traversing the solution landscape.
This is the "brittleness" of the NPP -- even small changes in the instance drastically reshape the geometry of the solutions.

To start, let us formalize our terminology for the NPP.

#definition[
  Let $g in RR^N$ be an instance of the NPP, and let $x in Sigma_N$.
  The _energy_ of $x$ is
  $
    E(x;g) := - log_2 abs(inn(g,x)).
  $
  The _solution set $Soln(g)$_ is the set of all $x in Sigma_N$ that have energy at least $E$, i.e., that satisfy
  $
    abs(inn(g,x)) <= 2^(-E).
  $ // <eq_npp>
] <def_npp_statement>

Observe here that minimizing the discrepancy $abs(inn(g,x))$ corresponds to maximizing the energy $E(x;g)$.
This terminology is motivated by the statistical physics literature, wherein random optimization problems are often reframed as energy maximization over a random landscape @mertensPhysicistsApproachNumber2001.
We further know that the _statistically optimal energy level_ is $E=Theta(N)$, while the best _computational energy level_ (achievable in polynomial time) is $E=Theta(log^2 N)$.

For our purposes, an algorithm is a function $alg colon RR^N to Sigma_N$ mapping instances $g$ to partitions $x$.
We will discuss extensions to randomized algorithms (which can depend on a random seed $omega$ independent of $g$) and to $RR^N$-valued algorithms (which can be forced to give outputs on $Sigma_N$ via rounding) in later sections, but for our main analysis, considering deterministic $Sigma_N$-valued algorithms will suffice.
In particular, we consider the class of so-called _low degree algorithms_, given by either low degree polynomials or by functions with low _coordinate degree_.
Compared to analytically-defined classes of stable algorithms (e.g. Lipschitz, etc.), these algorithms have an algebraic structure making them amenable to precise stability analysis.
In addition, the _low degree heuristic_ suggests that degree $D$ algorithms (in either sense) are believed to serve as the simplest representatives for the class of $e^(tilde(O)(D))$-time algorithms @hopkinsStatisticalInferenceSum2018.
This is a reasonable expectation for number partitioning, enabling us to translate our results into heuristic runtime bounds.

Our results show _strong low degree hardness_ for the NPP at energy levels between the statistical and computational thresholds, in the sense of Huang and Sellke @huangStrongLowDegree2025.

#definition[Strong Low Degree Hardness @huangStrongLowDegree2025[Def. 3]][
  A sequence of random search problems, that is, a $N$-indexed sequence of random input vectors
  $ g_N in RR^(d_N) $
  and random subsets
  $ S_N = S_N (g_N) subeq Sigma_N $
  exhibits _strong low degree hardness (SLDH) up to degree $D <= o(D_N)$_ if, for all sequences of degree $o(D_N)$ algorithms $alg_N colon (g,omega) mapsto x$ with $EE norm(alg(y_N))^2 <= O(N)$, we have
  $ PP(alg_N (g_N,omega) in S_N) <= o(1). $
] <def_sldh>

There are two related notions of degree which we want to consider in @def_sldh.
The first is traditional polynomial degree, applicable for algorithms given in each coordinate by low degree polynomial functions of the inputs. In this case, we show

#theorem[Results of @section_hardness_ldp][
  The NPP exhibits SLDH for degree $D$ polynomial algorithms, for
  #enum(
    [$D <= o(exp_2(delta N slash 2))$ when $E = delta N$ for $delta > 0$;],
    [$D <= o(exp_2(E slash 4))$ when $omega(log N) <= E <= o(N)$.],
  )
] <thrm_sldh_poly_informal>

Under the low degree heuristic, this suggests that polynomial algorithms require double exponential time to achieve the statistical optimal discrepancy; given that brute-force search requires exponential time, this is strong evidence that polynomial algorithms are poor models for the NPP.

Thus, we turn to the second, more general notion of _coordinate degree_: a function $f colon RR^N to RR$ has coordinate degree $D$ if it can be expressed as a linear combination of functions depending on combinations of no more than $D$ coordinates.
While related to polynomial degree, this enables us to consider a far broader class of algorithms, in which case we show

#theorem[Results of @section_hardness_lcd][
  The NPP exhibits SLDH for coordinate degree $D$ algorithms, for
  + $D <= o(N)$ when $E = delta N$ for $delta > 0$;
  + $D <= o(E slash log^2 N)$ when $omega(log^2 N) <= E <= o(N)$.
] <thrm_sldh_lcd_informal>

These results are likely to be the best-possible under the low degree heuristic, which we discuss in @rmk_optimal. In particular, the energy-degree tradeoff of $D <= tilde(o)(E)$ implies finding solutions with energy $E$ requires time $e^(tilde(Omega)(E))$, and as we'll show, it is possible to achieve such discrepancies via a restricted exponential-time search. Given this, our method produces a sharp energy-runtime tradeoff, indicating there are no nontrivial algorithms that save more than a polylogarithmic factor in the runtime exponent over brute-force search.
Overall, our approach towards @thrm_sldh_poly_informal and @thrm_sldh_lcd_informal suggest that in the case of problems with brittle solution geometry, conditional landscape obstructions are an extremely powerful tool for proving algorithmic hardness.

The rest of the thesis is organized as follows.
We review the low degree heuristic and work with low coordinate degree algorithms in @section_algorithms.
// In particular, we provide a self-contained introduction to coordinate degree and related decompositions of $L^2$ functions in @section_algorithm_es.
Our main results then constitute @section_hardness; after giving an overview of our proof strategy, we prove @thrm_sldh_poly_informal in @section_hardness_ldp, and likewise prove @thrm_sldh_lcd_informal in @section_hardness_lcd.
We conclude in @section_rounding by extending our results to the case of $RR^N$-valued algorithms and finish by discussing directions for future research.

== Notations and Preliminaries <section_notations>

We use the standard Bachmann-Landau notations $o(dot), O(dot), omega(dot), Omega(dot), Theta(dot)$, in the limit $N to infinity$.
We abbreviate $f(N) asymp g(N)$, $f(N) << g(N)$, or $f(N) >> g(N)$ when $f(N)=Theta(g(N))$, $f(N) = o(g(N))$, $f(N) = omega(g(N))$, respectively.
// meow see how much these are used
In addition, we write $f(N) prop g(N)$, $f(N) lt.tilde g(N)$, or $f(N) gt.tilde g(N)$ when there exists an $N$-independent constant $C$ such that $f(N)=C g(N)$, $f(N) <= C g(N)$, or $f(N) >= C g(N)$ for all $N$, respectively.

We write $[N] := {1,dots,N}$. If $S subeq [N]$, then we write $overline(S) := [N] without S$ for the complimentary set of indices.
If $x in RR^N$ and $S subeq [N]$, then the _restriction of $x$ to the coordinates in $S$_ is the vector $x_S$ with
$ (x_S)_i := cases(x_i #h(2em) &i in S\,, 0 &"else.") $
In particular, for $x,y in RR^N$, $inn(x_S, y) = inn(x,y_S) = inn(x_S,y_S)$.

On $RR^N$, we write $norm(dot)$ for the Euclidean norm, and $ball(x,r) := { y in RR^N : norm(y-x) < r}$ for the Euclidean ball of radius $r$ around $x$.
In addition, we write
$
  bball(x,r) := ball(x,r) inter Sigma_N = { y in Sigma_N : norm(y-x) < r },
$
to denote points on $Sigma_N$ within distance $r$ of $x$.

We use $Normal(mu,sigma^2)$ to denote the scalar Normal distribution with given mean and variance. In addition, we write "i.i.d." to mean independently and identically distributed, and "r.v." to mean random variable (or random vector, if it is clear from context).

For $p in [0,1]$ and a pair $(g,g')$ of $N$-dimensional standard Normal random vectors, we say $(g,g')$ are _$p$-correlated_ if $g'$ is distributed as
$ g' = p g + sqrt(1-p^2) tilde(g), $
where $tilde(g)$ is an independent copy of $g$.
We say $(g,g')$ are _$p$-resampled_ if $g$ is a standard Normal random vector and $g'$ is drawn as follows: for each $i in [N]$ independently,
$
  g'_i = cases(g_i &"with probability" p\,, "drawn from" Normal(0,1) #h(1.2em)&"with probability" 1-p.)
$
We denote such a pair by $resp(g,g',p)$.

In both cases, $g$ and $g'$ are marginally multivariate standard Normal and have entrywise correlation $p$.


--- coordinate degree

Let $gamma_N$ be the $N$-dimensional standard Normal measure on $RR^N$.
The _$N$-dimensional Gaussian space_ is the space $L2normN$ of $L^2$ functions of $N$ i.i.d. standard Normal r.v.s.

For more details, see @kuniskyLowCoordinateDegree2024a[#sym.section 1.3] or @odonnellAnalysisBooleanFunctions2021[#sym.section 8.3].

For $g in RR^N$ and $S subeq [N]$.
$
  // #h(1in)
  V_S &:= { f in L^2(gamma_N) : f(g) "depends only on" g_S }, \
  V_(<= D) &:= sum_(J subeq [N] \ abs(J) <= D) V_T.
$
These subsets describe functions which only depend on some subset of coordinates, or on some bounded number of coordinates.
Note that $V_[N] = V_(<= N) = L2iid$.

The _coordinate degree_ of a function $f in L^2(gamma_N)$ is defined as $min {D : f in V_(<= D) }$.

Note that if $f$ is a degree $D$ polynomial, then it has coordinate degree at most $D$.

Moreover, we have

@odonnellAnalysisBooleanFunctions2021[Exer. 8.18]
$
  p^D EE abs(f(g))^2 <= EE_resp(g,g',p)[f(g) dot f(g')] <= EE abs(f(g))^2
$

@thrm_sldh_hat_lcd(a)



--- algorithms

For our purposes, a _randomized algorithm_ is a measurable function
$alg colon (g,omega) mapsto x in Sigma_N$
where $omega in Omega_N$ is an independent random variable in some Polish space $Omega_N$.
Such an $alg$ is _deterministic_ if it does not depend on $omega$.
meow We discuss extensions to when $alg$ is $RR^N$-valued in @section_hardness_close and @section_rounding.


We say $alg$ is a _degree $D$ polynomial algorithm_ if each output coordinate is given by a degree $D$ polynomial in the $N$ entries of $g$, for any fixed $omega$.
Similarly, $alg$ is a _coordinate degree $D$ algorithm_ if each output coordinate is given by a coordinate degree $D$ function.
When the degree is unimportant, we refer to such algorithms as _low degree polynomial (LDP)_ or _low coordinate degree (LCD)_, respectively.

== Stability of Low Degree Algorithms <section_algorithms>

meow

#proposition[Low Degree Stability][
  Suppose $alg colon RR^N -> RR^N$ is a deterministic algorithm with polynomial degree (resp. coordinate degree) $D$ and norm $EE norm(alg(g))^2 <= C N$.
  Then, for standard Normal r.v.s $g$ and $g'$ which are $(1-epsilon)$-correlated (resp. $(1-epsilon)$-resampled),
  $ EE norm(alg(g) - alg(g'))^2 <= 2C D epsilon N, $ <eq_alg_expected_stability>
  and thus for any $eta > 0$,
  $
    PP( norm(alg(g) - alg(g'))>= 2sqrt(eta N)) <= (C D epsilon) / (2 eta). // prop (D epsilon) / eta.
  $ <eq_alg_stability>
] <prop_alg_stability>
#proof[
  We show @eq_alg_expected_stability for the case where $alg$ has coordinate degree $D$ and $(g,g')$ are $(1-epsilon)$-resampled.
  See @huangStrongLowDegree2025[Prop. 1.7] for the case where $alg$ is polynomial.
  In both cases, Markov's inequality gives @eq_alg_stability.

  We follow the proof of @gamarnikAlgorithmsBarriersSymmetric2022[Lem. 3.4].
  Assume without loss of generality that $EE norm(alg(g))^2 = 1$.
  Writing $alg = (alg_1,...,alg_N)$, observe that for $resp(g,g',1-epsilon)$,
  $
    EE norm(alg(g)-alg(g'))^2
    = EE norm(alg(g))^2 + EE norm(alg(g'))^2 - 2 EE inn(alg(g),alg(g'))
    = 2 - 2 EE inn(alg(g), alg(g')).
  $
  By @odonnellAnalysisBooleanFunctions2021[Exer. 8.18], we know that for each $alg_i in V_(<= D)$ we have
  $
    (1-epsilon)^D EE abs(alg_i (g))^2 <= EE[alg_i (g) alg_i (g')] <= EE abs(alg_i (g))^2.
  $
  Summing this over $i$ gives
  $
    (1-epsilon)^D <= EE inn(alg(g),alg(g')) <= 1.
  $
  Combining this with the above, and using $1-(1-epsilon)^D <= epsilon D$, yields @eq_alg_expected_stability.
]

#remark[
  Note that @prop_alg_stability also holds for randomized algorithms.
  Namely, if $alg(g,omega)$ is a randomized algorithm with polynomial or coordinate degree $D$ and $EE_(g,omega) norm(alg(g,omega))^2 <= C N$, then applying Markov's inequality to $omega mapsto EE[norm(alg(g,omega))^2 | omega]$ allows us to reduce to the deterministic case, possibly after adjusting $C$.
] <rmk_randomized_L2_stable>


meow Consider algorithm outputting points close to solution


/*
Consider the event that the $RR^N$-valued algorithm $alg$ outputs a point close to a solution for an instance $g$:
$
  S_"close" (r) = multiset(
    exists hat(x) in Soln(g) "s.t.",
    alg(g) in ball(hat(x), r)
  ) = {ball(alg(g), r) inter Soln(g) != emptyset }.
$
*/
Throughout this section, fix a distance $r=O(1)$.

Note that since $r$ is of constant order, we can convert $alg$ into a $Sigma_N$-valued algorithm by first rounding the $alg(g)$ into the solid binary hypercube and then picking the best corner of $Sigma_N$ within constant distance of this output.
Such a modification requires additionally calculating the energy of $O(1)$-many points on $Sigma_N$, adding only $O(N)$ operations.

We can formalize this construction as follows.
Let $clip colon RR^N -> [-1,1]^N$ be the function which rounds $x in RR^N$ into the cube $[-1,1]^N$:
$
  clip(x)_i := cases(-1 #h(1em) &x_i <= -1\,, x_i &-1 < x_i < 1\,, 1 &x_i >= 1.)
$
Note that $clip$ is $1$-Lipschitz with respect to the Euclidean norm.

// definition of hat alg

#definition[
  Let $r>0$ and $alg$ be an algorithm. Define the $[-1,1]^N$-valued algorithm $hat(alg)_r$ by
  #set math.cases(gap: 0.7em)
  $
    hat(alg)_r (g) := cases(
      limits("argmin")_(x' in bball(clip(alg(g)),r)) abs(inn(g,x')) #h(tabsize) &bball(clip(alg(g)), r) eq.not emptyset\,,
      clip(alg(g)) &"else".
  )
  $ <eq_hat_alg>

  // If $ball(clip(alg(g)),r) inter Sigma_N = emptyset$, then set $hat(alg)_r (g) := clip(alg(g))$, which is necessarily not in $Sigma_N$.
] <def_hat_alg>


If $alg$ is low degree, then this modification $hat(alg)_r$ of $alg$ is also stable.

#lemma[
  Suppose $alg colon RR^N -> RR^N$ is a deterministic algorithm with polynomial degree (resp. coordinate degree) $D$ and norm $EE norm(alg(g))^2 <= C N$.
  Then, for $r=O(1)$ and standard Normal r.v.s $g$ and $g'$ which are $(1-epsilon)$-correlated (resp. $(1-epsilon)$-resampled),
  $hat(alg)_r$ as in @def_hat_alg satisfies,
  $
    EE norm(hat(alg)_r (g) - hat(alg)_r (g'))^2 <= 4C D epsilon N + 8 r^2.
  $ <eq_hat_alg_expectation>
  Thus for any $eta > 0$.
  $
    PP (norm(hat(alg)_r (g) - hat(alg)_r (g')) >= 2 sqrt(eta N)) <= (C D epsilon) / (eta) + (2 r^2) / (eta N).
  $
  <eq_hat_alg_stability>
] <lem_hat_alg_stability>
#proof[
  Observe that by the triangle inequality, $ norm(hat(alg)_r (g) - hat(alg)_r (g'))$ is bounded by
  $
    norm(hat(alg)_r (g) - clip(alg(g))) +
    norm(clip(alg(g)) - clip(alg(g'))) +
    norm(clip(alg(g')) - hat(alg)_r (g')) \
    <= 2r + norm(alg(g) - alg(g')).
  $
  This follows as $clip$ is $1$-Lipschitz and the corner-picking step in @eq_hat_alg only moves $hat(alg)_r (g)$ from $clip(alg(r))$ by at most $r$.
  By Jensen's inequality, squaring this gives
  $
    norm(hat(alg)_r (g) - hat(alg)_r (g'))^2 <=
    2( 4r^2 + norm(alg(g) - alg(g'))^2).
  $
  Combining this with @prop_alg_stability gives @eq_hat_alg_expectation, and @eq_hat_alg_stability follows from Markov's inequality.
]

meow
Of course, our construction of $hat(alg)_r$ is certainly never polynomial and does not preserve coordinate degree in a controllable way.
// Thus, we cannot directly hope for @thrm_sldh_ldp_linear, @thrm_sldh_ldp_sublinear, @thrm_sldh_lcd_linear, or @thrm_sldh_lcd_sublinear to hold.
However, because this rounding does not drastically alter the stability analysis, we are still able to show that for any $RR^N$-valued low coordinate degree algorithm $alg$ and $r=O(1)$, strong low degree hardness holds for $hat(alg)_r$.
The same argument proves hardness when $alg$ is a low degree polynomial algorithm; this is omitted for brevity.

/// Hardness

= Hardness for Low Degree Algorithms <section_hardness>

In this section, we prove @thrm_sldh_poly_informal and @thrm_sldh_lcd_informal -- that is, we exhibit strong low degree hardness for both low polynomial degree and low coordinate degree algorithms.

Our argument utilizes what can be thought of as a "conditional" version of the overlap gap property.
Traditionally, proofs of algorithmic hardness use the overlap gap property as a global obstruction: one shows that with high probability, there are no tuples of good solutions to a family of correlated instances which are all roughly the same distance apart.
Here, however, we show a local obstruction; we condition on being able to solve a single instance and show that after a small change to the instance, we cannot guarantee any solutions will exist close to the first one.
This is an instance of the "brittleness," so to speak, that makes NPP so frustrating to solve; even small changes in the instance break the landscape geometry, so that even if solutions exist, there is no way to know where they will end up.

This conditional landscape obstruction approach is partially inspired by Huang and Sellke's recent work on strong low degree hardness for finding optima in spin glasses @huangStrongLowDegree2025.
However, a main reason for not appealing to an OGP-style result is Gamarnik and Kızıldağ's disproof of the $m$-OGP for sublinear energy levels @gamarnikAlgorithmicObstructionsRandom2021b[Thm. 2.5].

// Our conditional obstruction (@prop_correlated_fundamental in the low degree polynomial case, and @prop_resampled_fundamental in the low coordinate degree case) is established by a first moment computation.
That is, we show that given "correlated" instances $g,g'$ and a point $x in Sigma_N$ such that $g',x$ are conditionally independent given $g$, then any fixed point $x' in Sigma_N$ has low probability of solving $g'$; then, the same must hold for all $x'$ in a suitably small neighborhood of $x$.
This is similar to the proof of the OGP in the linear energy regime @gamarnikAlgorithmicObstructionsRandom2021b, but our method allows us to work with sublinear energy levels.
Heuristically, this is because the cardinality of neighborhoods of $x$ grows exponentially in $N$, which means that the number of $m$-tuples of such points grows much faster than any sublinearly small probability.
In contrast, the disproof of the OGP in the sublinear energy regime of Gamarnik and Kızıldağ follows from a second moment computation:
they show that the majority of pairs of $m$-tuples of solutions are nearly "uncorrelated," which again implies that globally, looking at large ensembles of solutions fails to capture the brittleness of the NPP for cardinality reasons.

// The proof of @thrm_sldh_poly_inform//al, stated formally as @thrm_sldh_poly_linear and @thrm_sldh_poly_sublinear, is as follows.
#footnote[The proof of @thrm_sldh_lcd_informal requires only minor modifications.]
Let $E$ be an energy level and $D$ a maximum algorithm degree, both depending on $N$.
We assume that $D$ is bounded by a level depending on $E$ and $N$, corresponding to the low degree regime in which we want to show hardness.
We then choose parameters $eta$ (depending on $E$ and $N$) and $epsilon$ (depending on $E$, $D$, and $N$).
As described in @section_algorithms, assume $alg$ is a deterministic, $Sigma_N$-valued algorithm with polynomial degree at most $D$.
Our goal is to show that for our choices of $eta$ and $epsilon$,
$ PP(alg(g) in Soln(g)) -> 0 $
as $N to infinity$.
This is done in the following steps.

#enum(
  [
    Consider a $(1-epsilon)$-correlated pair $g,g'$ of NPP instances.
    These are $N$-dimensional standard Normal vectors which are $p$-correlated for $p=1-epsilon$ (when considering coordinate degree, we instead require them to be $p$-resampled).
  ],
  [
    For $epsilon$ small, $g$ and $g'$ have correlation close to 1.
    By @prop_alg_stability, this implies that the outputs of a low degree polynomial algorithm $alg$ will be within distance $2sqrt(eta N)$ of each other with high probability.
  ],
  [
    For $eta$ small and fixed $alg(g)$, @lem_clo shows that conditional on $g$, $g'$ has no solutions within distance $2 sqrt(eta N)$ of $alg(g)$. This is the conditional landscape obstruction we described above.
  ],
  [
    Put together, these points imply that it is unlikely for $alg$ to find solutions to _both_ $g$ and $g'$ such that the stability guarantee of @prop_alg_stability holds.
    By the positive correlation statement in @lem_correlated_solve_prob, we conclude that $alg(g) in.not Soln(g)$ with high probability.
  ],
)

We can summarize the parameters in our argument in the following table.


meow determinsitc Sigma_N valued assumption


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
  + if $omega(log^2 N) <= E <= o(N)$, then $D <= o(E slash log^2 E)$.
  Then there exist $epsilon=epsilon(N,D)>0$ and $eta=eta(N,E)>0$ such that
  $ PP(alg(g) in Soln(g)) = o(1). $
] <thrm_sldh_lcd>

== Preliminary Estimates <section_hardness_prelim>

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
] <lem_eta_choice>
#proof[
  (a) For $E=Theta(N)$, $E slash N$ is bounded by an $N$-independent constant $delta > 0$. It is thus possible to find some $eta= O(1)$ such that $- 2 eta log_2 eta < delta slash 4$, as desired.

  (b) Heuristically, if $0 < eta, E slash N << 1$ and $-eta log eta ~ E slash N$, then $E slash N = eta^(plus.minus o(1))$.
  Therefore, $log E slash N ~ (1 plus.minus o(1)) log eta$, whence $eta ~ E slash (N log N slash E)$.
  On these grounds, for $E <= o(N)$ we choose
  $ eta := E / (16 N log_2 (N slash E)) gt.tilde E / (N log_2 N) $
  where the 16 is an arbitrary universal constant.
  We can verify numerically that for $N$ sufficiently large (hence $E slash N$ sufficiently small) this choice gives $2 eta log_2(1 slash eta) < E slash 4N$.
]

== Conditional obstruction <section_hardness_clo>

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
  To bound the number of terms in @eq_clo_firstmoment, let $k$ be the number of coordinates which differ between $x$ and $x'$, so that
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


With this obstruction in hand, we can turn to showing strong low degree hardness for polynomial algorithms.
We start with hardness for linear energy levels, $E=Theta(N)$; this corresponds to the statistically optimal regime, as per @karmarkarProbabilisticAnalysisOptimum1986.
Our hardness result in this regime roughly corresponds to that of Gamarnik and Kızıldağ's Theorem 3.2, although their result applies to stable algorithms and does not show a low degree hardness-type statement
@gamarnikAlgorithmicObstructionsRandom2021b[Thm. 3.2].
// A key feature of considering polynomial algorithms is that in @prop_correlated_fundamental, we can let $epsilon$ be exponentially small in $E$, which in the linear regime allows for it to be exponentially small in $N$.
As we will see, this has rather extreme implications for the failure of polynomial algorithms under the low degree heuristic.

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
  Note that @lem_correlated_solve_prob also holds in the case where $alg(g,omega)$ is randomized, in the sense of ().
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


== Proof of Hardness for LDP Algorithms <section_hardness_ldp>

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
$ <eq_ldp_events>

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
  Set $epsilon := 2^(-E slash 2)$ and set $eta$ as in @lem_eta_choice.
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

With this obstruction in hand, we can turn to showing strong low degree hardness for polynomial algorithms.
We start with hardness for linear energy levels, $E=Theta(N)$; this corresponds to the statistically optimal regime, as per @karmarkarProbabilisticAnalysisOptimum1986.
Our hardness result in this regime roughly corresponds to that of Gamarnik and Kızıldağ's Theorem 3.2, although their result applies to stable algorithms and does not show a low degree hardness-type statement
@gamarnikAlgorithmicObstructionsRandom2021b[Thm. 3.2].
// A key feature of considering polynomial algorithms is that in @prop_correlated_fundamental, we can let $epsilon$ be exponentially small in $E$, which in the linear regime allows for it to be exponentially small in $N$.
As we will see, this has rather extreme implications for the failure of polynomial algorithms under the low degree heuristic.

Next, we consider the sublinear energy regime $omega(log  N ) <= E <= o(N)$.
This bridges the gap from the statistically optimal energy threshold down to the computational threshold.
In particular, our method allows us to rule out degree $o(N^O(N))$ polynomial algorithms even for achieving the same energy threshold as the Karmarkar-Karp algorithm; this is expected however, as neither the original Karmarkar-Karp algorithm nor the simplified LDM algorithm are polynomial.

Holistically, these results imply that polynomial algorithms require degree exponential in the energy level to achieve solutions of the desired discrepancy.
Under the low degree heuristic, this corresponds to requiring double exponential time -- this is clearly beaten by brute force search in exponential time.
In this case, strong low degree hardness of the NPP serves as evidence of polynomial algorithms being unsuited to these types of brittle random optimization problems.

#remark[Extending to Randomized Algorithms][
  //As discussed in @rmk_randomized_L2_stable and @rmk_randomized_multiple_solve, if $alg(g,omega)$ is a randomized $Sigma_N$-valued low degree polynomial algorithm satisfying the averaged bound $EE norm(alg(g,omega))^2 <= C N$, then for every $epsilon$, one can show @thrm_sldh_poly_linear and @thrm_sldh_poly_sublinear for $alg(-,omega)$ for any fixed random seed.
  // In particular, the conditional landscape obstruction @prop_correlated_fundamental works without change when conditioning on $omega$ throughout.
  Averaging these bounds then allows the proof to go through. We note that this extension to randomized algorithms also applies for low coordinate degree hardness.
] <rmk_randomized>


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
Note that these are the same events as @eq_ldp_events, plus the event that $g'$ is nontrivially resampled from $g$.

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
  $ <eq_def_lcd_pcondunstable>
  Setting $eta$ as in @lem_eta_choice, we have by @lem_clo that
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

meow

// Linear case
With this, we can show strong low degree hardness for low coordinate degree algorithms at linear energy levels $E=Theta(N)$. As before, this corresponds to hardness at the statistically optimal energy regime, but now applies to an extremely broad category of algorithms.


// Finally, combining the ideas behind @thrm_sldh_ldp_sublinear and our conditional landscape obstruction for $(1-epsilon)$-resampled Normal random variables, we can show hardness for algorithms with low coordinate degree at sublinear energy levels, ranging from $log^2 N << E << N$.
// Here we have to increase our lower bound to $log^2 N$ as opposed to $log N$ from @thrm_sldh_ldp_sublinear, to address the requirement that $epsilon=omega(1 slash N)$, but this still enables us to "close" the statistical-to-computational gap by proving hardness in this range.
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
  In particular, this suggests that @thrm_sldh_lcd is optimal under the low degree heuristic.
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

== Extensions to Close Algorithms <section_hardness_close>

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

Of course, our construction of $hat(alg)_r$ is certainly never polynomial and does not preserve coordinate degree in a controllable way.
// Thus, we cannot directly hope for @thrm_sldh_ldp_linear, @thrm_sldh_ldp_sublinear, @thrm_sldh_lcd_linear, or @thrm_sldh_lcd_sublinear to hold.
However, because this rounding does not drastically alter the stability analysis, we are still able to show that for any $RR^N$-valued low coordinate degree algorithm $alg$ and $r=O(1)$, strong low degree hardness holds for $hat(alg)_r$.
The same argument proves hardness when $alg$ is a low degree polynomial algorithm; this is omitted for brevity.

Throughout this section, fix a distance $r=O(1)$.
Consider the event that the $RR^N$-valued algorithm $alg$ outputs a point close to a solution for an instance $g$:
$
  S_"close" (r) = multiset(
    exists hat(x) in Soln(g) "s.t.",
    alg(g) in ball(hat(x), r)
  ) = {bball(alg(g), r) != emptyset }.
$

recall $hat(alg)$ from @section_algorithms

#theorem[Hardness for Close LCD Algorithms][
  Let $g$ and $g'$ be $(1-epsilon)$-resampled standard Normal random vectors.
  Let $r>0$ be an $N$-independent constant and $alg$ be any coordinate degree $D$ algorithm with $EE norm(alg(g))^2 <= C N$.
  Assume that
  + if $E = delta N$ for $delta > 0$, then $D <= o(N)$;
  + if $omega(log^2 N) <= E <= o(N)$, then $D <= o(E slash log^2 E)$.
  Then there exist $epsilon=epsilon(N,D)>0$ and $eta=eta(N,E)>0$ such that
  $ PP(S_"close" (r)) <= PP(hat(alg)_r (g) in Soln(g)) = o(1). $
] <thrm_sldh_hat_lcd>





Throughout this section, fix a distance $r=O(1)$.
Consider the event that the $RR^N$-valued algorithm $alg$ outputs a point close to a solution for an instance $g$:
$
  S_"close" (r) = multiset(
    exists hat(x) in Soln(g) "s.t.",
    alg(g) in ball(hat(x), r)
  ) = {ball(alg(g), r) inter Soln(g) != emptyset }.
$

meow explain ideas going on

/*

We recall the setup from @section_hardness_lcd.
Let $g,g'$ be $(1-epsilon)$-resampled standard Normal vectors and define the events
$
  S_"diff" &:= { g != g'}, \
  S_"solve" &:= { hat(alg)_r (g) in Soln(g), hat(alg)_r (g') in Soln(g')}, \
  S_"stable" &:= { norm(hat(alg)_r (g) - hat(alg)_r (g')) <= 2 sqrt(eta N) }, \
  S_"cond" (x) &:= multiset(
    exists.not x' in Soln(g') "such that",
    norm(x-x') <= 2sqrt(eta N),
  ).
$ <eq_lcd_hat_events>

These are the same events as in @eq_lcd_events, just adapted to $hat(alg)_r$. In particular, @lem_lcd_solve_disjoint holds unchanged.

Moreover, we define
$
  hat(p)^cor_"solve" := PP(hat(alg)_r (g) in Soln(g)) >= PP(S_"close" (r)),
$ <eq_def_lcd_hat_psolve>
$
  hat(p)^cor _"unstable" := 1 - PP(S_"stable" | S_"diff"), #h(3em)  hat(p)^cor _"cond" (x) := 1 - PP(S_"cond" (x) | S_"diff"),
$
along with $hat(p)^cor _"cond" := max_(x in Sigma_N) hat(p)^cor _"cond" (x)$, echoing () // @eq_def_lcd_punstablecond.
Observe that since $hat(p)^cor _"cond"$ makes no reference to any algorithm, the bound in (meow) holds without change.
Moreover, @lem_hat_alg_stability lets us control $hat(p)^cor _"unstable"$.
The final piece needed is an appropriate analog of () // @lem_resampled_solve_prob.

#lemma[
  For $g,g'$ being $(1-epsilon)$-resampled, we have
  $
    PP(S_"solve") = PP(hat(alg)_r (g) in Soln(g), hat(alg)_r (g') in Soln(g')) >= (hat(p)^cor_"solve")^2.
  $
] <lem_hat_resampled_solve_prob>
#proof[
  Observe that, letting $+$ denote Minkowski sum, we have
  $ { hat(alg)_r (g) in Soln(g) } = { clip(alg(g)) in Soln(g) + ball(0,r) }. $
  Expanding $Soln(g)$, the proof proceeds as in () // meow @lem_resampled_solve_prob.
]
*/

#proof[of @thrm_sldh_hat_lcd][
  We maintain the setup of the proof of @thrm_sldh_lcd.
  Let $x := hat(alg)_r (g)$
  and define the events $S_"diff"$, $S_"solve"$, $S_"stable"$, and $S_"cond" (x)$ as in @eq_lcd_events, replacing $alg$ with $hat(alg)_r$.
  Let $p_"solve" := PP(hat(alg)_r (g) in Soln(g))$; letting $S$ be the event ${ hat(alg)_r (g) in Soln(g) } = {clip(alg(g)) in Soln(g) + ball(0,r) }$, @lem_correlated_solve_prob ensures $PP_resp(g,g',1-epsilon) (S_"solve") >= p_"solve"^2$.

  and keep the same definitions of $p_"unstable"$ and $p_"cond"$ as in @eq_def_lcd_pcondunstable, replacing $alg$ with $hat(alg)_r$.
  We again choose $epsilon := log_2(N slash D)/N$, so that $PP(S_"diff") -> 1$.
  Additionally, choose $eta$ as @lem_eta_choice, so that $p_"cond" = o(1)$.

  It then suffices to show that $p_"unstable" = o(1)$. To see this, recall that
  when $E = delta N$, our choice of $eta$ is $O(1)$, so $r^2/(eta N) = o(1)$.
  In the sublinear case, for $eta= E slash (16 N log_2 (N slash E))$, we instead get
  $ eta N gt.tilde E / (N log_2 N) dot N >= E / (log_2 N) = omega(1), $
  since $E >> log^2 N$.
  Applying the properly modified @lem_hat_alg_stability -- knowing that the first term bounding $p_"unstable"$ is $o(1)$ with these choices of $epsilon$ and $eta$ -- we see that $hat(p)_"unstable" = o(1)$, as desired.
]

Note that as $p_"solve"$ upper bounds $PP(S_"close" (r))$, this argument shows algorithmic hardness for low degree $RR^N$-valued algorithms aiming to output points within constant distance of a solution.


/// Rounding

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

#bibliography(
  "references.bib",
  style: "ieee.csl",
  title: "References",
)
