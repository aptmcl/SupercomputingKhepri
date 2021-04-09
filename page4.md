@def title = "Optimization"

```julia:setup
#hideall
include("MOOBData.jl")
```

# Optimization

The next set of experiments measured the potential gains that
parallelization could provide to optimization problems. To focus on
the optimization itself, we used an objective function that was not
parallelized. More specifically, the case study was the optimization
of the structural properties of the previous truss, measured by the
maximum displacement of all its nodes. The variable vector to optimize
is the location of the truss' center, i.e., the point at the top where
all truss arcs join.

We started by considering only the X and Y coordinates of the truss'
center, fixing its height. This means we have two variables
to optimize. The objective function landscape is a very simple one,
as represented in the following plot where we show the maximum
displacement of the truss nodes for different locations $(X,Y)$ (at a
fixed height) of the truss' central node.

```julia:truss_center
#hideall
using .MOOBData
plt = plot_2d(truss_center_data)
saveplot(plt,"trussCenter")
#\textoutput{truss_center}
```
\fig{trussCenter}

To make the example more interesting (and to enlarge the range of
variation of the objective function), we decided to also apply an
horizontal force to the truss' nodes, changing the objective function's
landscape:

```julia:truss_offset
#hideall
using .MOOBData
plt = plot_2d(truss_offset_data)
saveplot(plt,"trussOffset")
#\textoutput{truss_offset}
```
\fig{trussOffset}

Given that we were interested in evaluating the scalability of the
optimization as the number of CPUs increases, we selected optimization
algorithms that we knew were already parallelized. A suitable
candidade is BlackBoxOptim, a parallelized optimization package
supporting both multi- and single-objective optimization problems
using metaheuristics algorithms.

BlackBoxOptim supports both multi-threaded and parallel execution,
allowing the optimization algorithm to evaluate many candidate
solutions at the same time. Since Khepri is not yet thread-safe,
we opted for parallel evaluation using multiple independent processes.
Following the BlackBoxOptim guidelines, we used the following
template:

```julia
using Distributed
using Random

addprocs(parse(Int, ARGS[1])-1)
@everywhere include("RandomDomeTruss.jl")
@everywhere using BlackBoxOptim

Random.seed!(12345)

opt = bbsetup(displacement,
        Method=:xnes,
        SearchRange = [(-6.0, 6.0), (-6.0, 6.0)],
        MaxFuncEvals = 1000,
        Workers = workers())

res = bboptimize(opt)

println("Solution candidate:", best_candidate(res))
println("Solution fitness:", best_fitness(res))
```

Note that the master process is responsible for running the
optimization algorithm and the workers are only responsible for
evaluating candidate solutions. Therefore, we fixed the seed of the master's
random number generator so that we could repeat the experiments with a
different number of workers but without changing the sequence of steps
taken. This ensures that the optimization always finds the same
solution after the same number of steps.

Note that BlackBoxOptim requires, first, that we setup the
optimization problem, using the `bbsetup` function. Here, the
`displacement` argument is the function to minimize. It measures the
maximum displacement of a truss' node. The next argument specifies the
optimization method to use, in this case, we selected the Exponential
Natural Evolution Strategy (xNES). Then, we specify the domain of the
two variables $x$ and $y$ representing the projection on the $XY$
plane of the point where all the truss' arcs join. Note that this is a
square that fits inside the slab that supports the truss. We also
specify the maximum number of objective function evaluations and the
set of workers that will be used to compute those evaluations.

After the setup, the function `bboptimize` does the job of
coordinating the workers, assigning them candidate solutions to
evaluate, collecting the results and deciding the evolution of the set
of candidates.

As before, we tested the script using an increasing number of workers
and we did three independent runs to smooth out the noise. We allowed
the optimization to do a maximum number of objective function
evaluations of 1000. In all cases, the solution found was the same, as
expected from the fixed random seed used that forced the optimization
to be deterministic. The following table presents the mean time spent
in the optimization process for different numbers of processes. Again,
note that the number of workers is one less than the number of
processes.

```julia:plotopt1
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals = 1000, Workers = workers())
using .MOOBData
plt = plot_opt(opt_xnes)
saveplot(plt,"xnes1000")
#\textoutput{plotopt1}
```
\fig{xnes1000}

Results show that the optimization clearly benefits from the use of
multiple workers evaluating candidate solutions in parallel but only
up to eight processes. After that, there is no benefit. We then
repeated the same experiment but now using a five times larger number
of objective function evaluations, i.e., 5000. The results were the
following:

```julia:plotopt2
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals = 5000, Workers = workers())
using .MOOBData
plt = plot_opt(optxnes5000)
saveplot(plt,"xnes5000")
#\textoutput{plotopt2}
```
\fig{xnes5000}

As we can see, increasing the number of objective function evaluations
only scales the bar chart. The overall speedups are exactly the same.

We hypothesized that the cause for the lack of scalability was the
limited size of the population that was used by default in xNES. Given
that BlackBoxOptim fixes the population size at 50, we experimented
increasing this to 100 in the hope that it would allow the algorithm
to have more evaluations to divide among the workers. The following
plots illustrates the results for a one-thousand limit in the number
of function evaluations:

```julia:plotopt3
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange=[(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals=1000, PopulationSize=100, Workers=workers())
using .MOOBData
plt = plot_opt(optxnes1000pop100)
saveplot(plt,"xnes1000pop100")
#\textoutput{plotopt3}
```
\fig{xnes1000pop100}

Once again, the speedups seem to be limited to eight processes and
given that there were no expected gains after that, we stopped the
process after collecting data for up to 64 processes.

We then experimented increasing both the population size and the
number of function evaluations to, respectively, 500 and 5000.

```julia:plotopt6
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange=[(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals=5000, PopulationSize=500, Workers=workers())
using .MOOBData
plt = plot_opt(optxnes500_5000)
saveplot(plt,"xnes500_5000")
#\textoutput{plotopt6}
```
\fig{xnes500_5000}

As visible, there are no significant differences. The optimization
seems not to scale beyond eight processes.

The next experiment was to increase the dimensionality of the design
space, by increasing the independent variables from two to three. Now,
besides the $X$ and $Y$ coordinates of the central node of the truss, we
also optimized its $Z$ coordinate, allowing it to vary between 1 and 20.
We also decided to experiment running the process using just one
thread, to better understand the advantages of parallelization. Fixing
the maximum number of evaluations at 2000, we obtained the following
results:

```julia:plotopt5
#hideall
#opt = bbsetup(displacement_obj3; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0), (1.0, 20.0)], MaxFuncEvals = 2000,
using .MOOBData
plt = plot_opt(optxnex3V)
saveplot(plt,"xnes3V")
#\textoutput{plotopt5}
```
\fig{xnes3V}

Given the time it takes to produce these results, we stopped the
experiment as soon as we were sure that there were no more
improvements. Note the considerable gains obtained moving from one
process to two, to four, and to height, with an almost constant speedup
of two, but it clearly stops after we reach height processes.

Finally, we decided to experiment with a different optimization
algorithm, this time Separable Natural Evolution Strategy (sNES). We
used the initial set of variables (just the $X$ and $Y$ coordinates of
the central truss node), an initial population size of 500 and a
maximum number of objective function evaluations of 5000.

```julia:plotopt7
#hideall
#opt = bbsetup(displacement_obj; Method=:separable_nes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], PopulationSize=500, MaxFuncEvals = 5000,
using .MOOBData
plt = plot_opt(optsnes5000)
saveplot(plt,"snes5000")
#\textoutput{plotopt7}
```
\fig{snes5000}

In this case, there is an important speedup (3X) in the transition
from two to four processes, that is explainable, possibly, by the fact that
the transition is, in fact, from 1 worker to 3 workers, meaning that
we can triple the number of objective function evaluations being done
on each step. It is less clear why the previous experiments did not
show the same initial speedup. In the end, we were not impressed with
the speedups that we obtained from all of these experiments. We can
conclude that for the specific algorithms and optimization problems
that we studied, there is no justification to use more than eight
processes. The good news is that this is the typical number of
computing threads that are currently available in most off-the-shelf
hardware. The bad news is that it does not make the case for the use
of supercomputers, which have much larger numbers of threads.

There is, however, a silver lining. In all of these experiments, we
used just one computing node for each specific algorithm, but we
managed to use different computing nodes for different
experiments. This means that, in practice, the time needed to do the
entire set of experiments is not the sum of the time needed for each
experiment but the maximum of all those times, subject to the
limitation that we could only explore four computing nodes and to the
fact that there were other jobs competing for those
resources. Nevertheless, it demonstrates the potential gains that can
be obtained when addressing the No Free Lunch theorem, which states
that no optimization algorithm is better than all others in all
cases. The consequence is that multiple algorithms need to be tested
and the ability to use multiple computing nodes allows these tests to
be done simultaneously, thus taking no more time than the time needed
to run the slowest of them.

#
[<< Previous Chapter](/page3/)

[Next Chapter >>](/page5/)
