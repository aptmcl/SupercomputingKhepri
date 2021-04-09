@def title = "Julia for Parallel Processing"

```julia:setup
#hideall
include("MOOBData.jl")
```

# Julia for Parallel Processing

\tableofcontents <!-- you can use \toc as well -->

#

Before anything else, we decided to gain some experience in the use of
Julia's parallel processing capabilities.

Julia supports multi-threading and
distributed computing. Multi-threading allows multiple tasks to run
simultaneously on more than one thread or CPU core, sharing memory,
while distributed computing runs multiple processes with separate
memory spaces, possibly on different machines. Given that Khepri is
not thread-safe, we were particularly interested in testing the
distributed computing capabilities. These are provided by the
`Distributed` standard library as well as external packages such as
`MPI.jl` and `DistributedArrays.jl`.

The `Distributed` approach is based on the idea that one _master_
process launches a set of _slave_ processes, called workers, using the
`addprocs` function, to which it distributes units of work, waiting
for their completion. Despite being part of the standard library, the
`Distributed` module must be explicitly loaded on the master process
to access the `addprocs` function. The module is automatically loaded
on the worker processes.

### An Embarrassingly Parallel Problem

The first tests attempted to determine how the Julia language
implementation scales across multiple cores. The following Julia
program computes an approximation of $\pi$ using the classical Monte
Carlo approach of sampling points on a square that circumscribes a
circle of radius $r$. In that case, the area of the circle is $\pi r²$
while the area of the square is $(2r)²=4r²$. The ratio between these
areas is $\frac{\pi r²}{4r²}=\frac{\pi}{4}$, which means that,
independently of the radius of the circle, a uniformly distributed
sample of points over the square will have $\frac{\pi}{4}$ points
inside the circle.

Instead of computing the approximation to $\pi$ (whose value we
already know), we preferred to compute the absolute error.

```julia
using Statistics

approx_pi(n) =
  let count = 0
    for i in 1:n
      count += (rand()^2 + rand()^2) <= 1
    end
    abs(4*count/n - pi)
  end
```

Given the just-in-time compilation strategy used by Julia, we decided
to do some preliminary computations to force the compilation and only
then a benchmark is started. The benchmark computes approximations to
$\pi$ with a series of exponentially increasing number of iterations.
We evaluate the time spent with `@timev`:

```julia
# Force compilation:
approx_pi(100)

for i in 1:10
  println("approx_pi($(10^i)):", @timev approx_pi(10^i))
end
```

In order to run the code, we saved all of it in a file `ApproxPi.jl`
and we created a Slurm _batch_ file named `BatchPi.sh`, containing
the following:

```bash
#!/bin/bash

#SBATCH --job-name=SeqPi
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH -p ...
#SBATCH -q ...

time ./julia ApproxPi.jl
```

To launch the Slurm batch file, we simply used `sbatch BatchPi.sh`.
The benchmark results are the following:

```julia:plot1
#hideall
using .MOOBData
plt=
plot(approx_pi_single[:,1], approx_pi_single[:,2],
     labels="Single threaded",
     legend=:topleft,
     markers=:auto,
     ylimits=(-5,80),
     xticks=approx_pi_single[:,1],
     xscale=:log10,
     xlabel="Iterations",
     ylabel="Time (s)")
saveplot(plt, "approx_pi_single")
#\textoutput{plot1}
```
\fig{approx_pi_single}

It is relevant to note that despite the apparent exponential growth, the
scale is logarithmic and, thus, the computation time grows linearly
with the number of iterations.

The next step was to repeat the same computation but using parallel
processing. To that end, we decided to use a slightly different
`BatchPi.sh` Slurm batch file:

```bash
#!/bin/bash

#SBATCH --job-name=ParPi
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH -p ...
#SBATCH -q ...

time ./julia ApproxPi.jl $SLURM_NTASKS
```

Note that we provided the Julia program with the number of tasks that it can
use, although we did not specify that number in the Slurm script. We did
so simply because it was easier to provide that information on the
`sbatch` call using, e.g., `sbatch --ntasks=8 BatchPi.sh`

The next fragment of code demonstrates the creation of workers. We take
the number of processes $n$ that was passed as a command-line argument
and we create $n-1$ additional workers so that the master and the
slaves use all available resources.

```julia
using Distributed

addprocs(parse(Int, ARGS[1])-1)
```

Despite the simplicity of the `addprocs` function, there is a lot
going on behind the scenes. Immediately after its creation, each of the
workers creates a TCP/IP connection, writes on standard output the
corresponding host and port, and starts listening on that port. The
master receives the output of each worker and completes the TCP/IP
connection to each one. Then, it informs each worker of the connection
point of all other workers, so that they can establish connections
between themselves. To do this, each worker connects to all workers
whose _id_ is less than its own _id_.

Given that all these connections require time to establish, we decided
to measure its impact in time and allocated memory as the number of
processes increases. The results are the following:

```julia:plot2
#hideall
using .MOOBData
plt=
scatter(creating_workers[:,1], creating_workers[:,2],
     labels="Time",
     legend=:topleft,
     markers=:auto,
     ylimits=(0,2.5),
     xticks=creating_workers[:,1],
     smooth=true,
     #xscale=:log10,
     xlabel="Processes",
     ylabel="Time (s)")
plt=
plot!(twinx(), creating_workers[:,1], creating_workers[:,4],
     labels="Memory",
     legend=:topleft,
     markers=:auto,
     ylimits=(0,35),
     xticks=:none,
     color=:green,
     #xscale=:log10,
     ylabel="Memory (MiB)")
saveplot(plt, "timeMemoryWorkers")
#\textoutput{plot2}
```
\fig{timeMemoryWorkers}

This shows that using multiple processes entails an overhead with a fixed
part of around one second and a variable part of $0.01$ seconds per
process.

The following step was to divide the work among the workers. To that end,
each one needs to know what it is supposed to compute, and this is
another area where Julia shines. The macro `@everywhere` allows the
master to make requests to all workers. In our case, we need each
worker to define the function `approx_pi` that computes the $\pi$
approximation using the Monte Carlo method. To force Just-In-Time
compilation on each worker, we also request a corresponding function
call.

```julia
@everywhere approx_pi(n) =
  let count = 0
    for i in 1:n
      count += (rand()^2 + rand()^2) <= 1
    end
    abs(4*count/n - pi)
  end

# Force compilation:
@everywhere approx_pi(100)
```

Finally, to compute the approximation, we take advantage of Julia's
higher-level parallel operations, namely, `pmap`, which maps a
function over an array, but arranging for the applications to be done
in parallel by distributing the array values among the workers. We
defined the `p_approxi_pi` function that helps the distribution by
dividing the intended number of iterations between the workers and
then computing the `mean` of the results that came from the workers.

```julia
p_approx_pi(n) =
  mean(pmap(n->approx_pi(n),
            [n/nworkers() for i in 1:nworkers()]))
```

To evaluate the effectiveness of this strategy, we experimented a
series of computations using an exponentially larger number of
iterations, using an increasingly larger number of parallel processes.

```julia
for i in 1:10
  println("p_approx_pi($(10^i)):", @timev p_approx_pi(10^i))
end
```

Note that, with this scheme, when we use two processes, we are in fact
using just one worker, as the other one is just managing the
distribution of work and collection of results. In the next plot, we
also superimpose the results for the single-threaded case.

```julia:plot3
#hideall
using .MOOBData
plt=
plot(aprox_pi_multiple_2[:,1],
     hcat(approx_pi_single[:,2],
          aprox_pi_multiple_2[:,2],
	  aprox_pi_multiple_4[:,2],
	  aprox_pi_multiple_8[:,2],
	  aprox_pi_multiple_16[:,2],
	  aprox_pi_multiple_32[:,2],
	  aprox_pi_multiple_48[:,2],
	  aprox_pi_multiple_64[:,2],
	  aprox_pi_multiple_80[:,2],
	  aprox_pi_multiple_96[:,2]),
     labels=[1 2 4 8 16 32 48 64 80 96],
     legendtitle="# Processes",
     #size=(800,600),
     legend=:topleft,
     markers=:auto,
     ylimits=(0,80),
     xlabel="Iterations",
     #color=:green,
     xscale=:log10,
     ylabel="Time (s)")
saveplot(plt, "timeParallelPi")
#\textoutput{plot3}
```
\fig{timeParallelPi}

Results show that two processes, i.e., having just one worker doing
all the work, is very similar to the single-threaded case. The
performance impact is only 2.6%. However, it is not all good news, as
the results also show that parallelization only pays off when the
number of iterations reaches $10^8$.

On the other hand, when we compare the time it takes the entire
experiment to complete for a given number of processes, the results are a bit
surprising:

```julia:plot4
#hideall
using .MOOBData
plt=
plot(time_aprox_pi_multiple[:,1],
     time_aprox_pi_multiple[:,2],
     labels=[2 4 8 16 32 48 64 80 96],
     legend=:none,
     markers=:auto,
     ylimits=(0,180),
     xlabel="Processes",
     xticks=time_aprox_pi_multiple[:,1],
     ylabel="Time (s)")
saveplot(plt,"userTimeParallelPi")
#\textoutput{plot4}
```
\fig{userTimeParallelPi}

Now, we see that despite the considerable gains obtained, almost
halving the time needed, it only pays off to use up to 16
processes.

### Fairness

Our guess for the lack of speedup after 16 processes is that the time
spent starting processes and managing them nullifies the gains of the
parallelization. Another hypothesis is that, despite the number of
workers created, Julia is not taking advantage of them because it does
not fairly distribute the work among them. To refute (or confirm) this
hypothesis, we decided to make a different test.

The goal of this test was to distribute identical work units among the workers
and collect the number of units that were processed by each worker. To
that end, we used the following program:

```julia
using Distributed
addprocs(parse(Int, ARGS[1])-1)

@everywhere work(x) = (sleep(0.01); myid())
res = @time pmap(work, 1:2000)
```

Note that the work unit of each process is just a quick `sleep`. Each
process then returns its own _id_. The master, besides repeatedly
sending elements of the range `1:2000` to the available workers,
collects the results. This means that the range ends up being
converted into an array of process _id_s, where each _id_ represents
the process that handled that work unit.

After the range is exhausted, the array of _id_s is processed to count
the number of times each _id_ showed up. If the distribution is fair,
all processes will have more or less the same number of occurrences in
the array, meaning that all of them had to process a similar number of
work units.

```julia
distr = Dict([i=>0 for i in workers()])
for i in res
 distr[i]+=1
end
```

Finally, for each process _id_ we print the number of times it
occurred in the array, i.e., the number of work units that it had to
process.

```julia
for i in workers()
  println("$(i)=>$(distr[i])")
end
```

In the following bar chart, we plot that number for each process. Their _id_s are presented on the
horizontal axis.

```julia:plot5
#hideall
using .MOOBData
plt=
plot(
  work_per_id[1][:,1],
  work_per_id[1][:,2],
  xlimits=(2,96),
  #xticks=work_per_id[1][:,1],
  seriestype=:bar,
  legend=:none,
  xlabel="Process id",
  ylabel="Work Units")
saveplot(plt,"workPerId96")
#\textoutput{plot5}
```
\fig{workPerId96}

Note the fairly regular number of units of work that is done by each
worker. Similar plots could be made for different amounts of
processes. The next one shows the same statistics but using only 32
processors:

```julia:plot6
#hideall
using .MOOBData
plt=
plot(
  work_per_id[5][:,1],
  work_per_id[5][:,2],
  xlimits=(2,32),
  #xticks=work_per_id[5][:,1],
  seriestype=:bar,
  legend=:none,
  xlabel="Process id",
  ylabel="Work Units")
saveplot(plt,"workPerId32")
#\textoutput{plot6}
```
\fig{workPerId32}

Again, we see a relatively fair distribution of work. The same
behavior is seen in the following case, using just four processes:

```julia:plot6a
#hideall
using .MOOBData
plt=
plot(
  work_per_id[8][:,1],
  work_per_id[8][:,2],
  #xlimits=(2,4),
  xticks=[2,3,4], #work_per_id[8][:,1],
  seriestype=:bar,
  legend=:none,
  xlabel="Process id",
  ylabel="Work Units")
saveplot(plt,"workPerId8")
#\textoutput{plot6a}
```
\fig{workPerId8}

The following bar chart condenses the entire information in a single
plot, showing the division of labor for different numbers of
workers. As before, remember that the number of workers is one less
than the number of processes. That means that, e.g., for 2 processes,
there is just one worker doing all the heavy lifting.

```julia:plot7
#hideall
using .MOOBData
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(w->resize(collect(w[:,2]), 95), reverse(work_per_id))...)',
  bar_position=:stack,
  legend=:none,
  xlabel="# Processes",
  ylabel="Work Units")
saveplot(plt,"workPerIdDivided")
#\textoutput{plot7}
```
\fig{workPerIdDivided}

As is visible, the work was uniformly distributed among the workers,
independently of the number of workers being used.

### Speedup

The following bar chart reveals another interesting statistic that
confirms our previous hypothesis regarding the time spent managing the
workers _vs_ the time doing actual work. Here we measured the time
needed to launch the workers (the `addprocs` operation) and the total
time needed to process all work items.


```julia:plot8
#hideall
using .MOOBData
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(row->[row[5], row[2]], eachrow(work_per_id_bench))...)',
  bar_position=:stack,
  label=["Work time" "Launch time"],
  xlabel="# Processes",
  ylabel="Time(s)")
saveplot(plt,"workPerId")
#\textoutput{plot8}
```
\fig{workPerId}

Despite the enormous reduction in the time spent doing actual work
(that goes from 22.5 seconds using just one worker to 0.42 seconds
using 96 workers, i.e., $\frac{1}{54}$ of the original time), we can
see that the actual benefits become marginal when we use more than 32
processes and the situation gets actually worse with 96 processes, as
the time to launch all of them dominates the entire computation. With
that number of processors, the total time goes from 23.9 seconds to
2.55, i.e., $\frac{1}{10}$ of the original total time. The following
plot illustrates the difference between the speedups considering only
the time the workers spend doing useful work and the corresponding
speedups when we consider the total time.

```julia:plot9
#hideall
using .MOOBData
plt=
plot(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  [speedups_work_time speedups_total_time],
  label=["Working Time" "Total Time"],
  legend=:topleft,
  xlabel="# Processes",
  ylabel="Speedup")
saveplot(plt,"speedUpWorkers")
#\textoutput{plot9}
```
\fig{speedUpWorkers}

### Amdahl's Law

This phenomenon is an excellent example of Amdahl's law, presented by
1967 by Gene Amdahl, which establishes the theoretical limits of the
achievable speedup when only a fraction of a process can be
parallelized.

To derive the law, let us call $T$ the total duration of a process
that can be divided into two parts: $T=T_s+T_p$, where $T_s$ must be
executed sequentially and, thus, cannot benefit from parallelization,
and $T_p$ can be parallelized. Assuming that the parallelizable part
is a fraction $p=\frac{T_p}{T}$, then $T_p=pT$ and
$T_s=T-T_p=T-pT=(1-p)T$. Therefore, we have $T=(1-p)T + pT$.

After parallelization using $n$ processors, $T_p=pT$ becomes
$T'_p=\frac{T_p}{n}=\frac{pT}{n}$. Then, the total time becomes
$T'=T_s+T'_p =(1-p)T+\frac{p}{n}T$. The speedup, which is defined as
the ratio between the duration of the non-parallelized version and the
duration of the parallelized one, becomes
$S=\frac{T}{T'}=\frac{T}{(1-p)T+\frac{p}{n}T}=\frac{1}{1-p+\frac{p}{n}}$. Imagining
that the number of processors is unlimited, the maximum theoretical
speedup becomes $$\lim_{n\to\infty} S=\lim_{n\to\infty}
\frac{1}{1-p+\frac{p}{n}}=\frac{1}{1-p}$$

In our problem, the sequential time using only one worker took 22.5
seconds, of which 1.4 are wasted launching the additional
process. This means that the parallelizable part is a fraction
$p=\frac{22.5-1.4}{22.5}=0.938$. In this case, the maximum speedup
would not exceed 16, a far cry from the 10 that we obtained in the
best case. In practice, the situation is even worse, as $T_s$ is not
constant and, in fact, increases with $n$. For example, using 96
processors, $T_s$ is already $2.13$, which gives a maximum speedup of
13.5. Obviously, our example has other parts that cannot be
parallelized.

<!-- Esta ultima frase é esqusita e abrupta para acabar um capítulo. Não a percebo também, mas,
in all fareness, so percebi 20% desta explicação toda. Estou a ler na diagonal e isto é complexo -->

#
[<< Previous Chapter](/page1/)

[Next Chapter >>](/page3/)
