@def title = "Architecture in the Supercomputing Era"
@def tags = ["syntax", "code"]

```julia:setup
#hideall
using DataFrames
using CSV
using Plots
using StatsPlots
using Statistics

plotlyjs(size=(640,330))

bench_data(str) =
  DataFrame(CSV.File(IOBuffer(str), delim=" ", ignorerepeated=true))

saveplot(plt, name="", ext="svg") =
  fdplotly(json(Plots.plotlyjs_syncplot(plt))) # hide
  #savefig(joinpath(@OUTPUT, name * "." * ext))
```

# Architecture in the Supercomputing Era

\tableofcontents <!-- you can use \toc as well -->

## Introduction

My research group has been working for many years in the combination
between Architecture and Computer Science.  More specifically, we have
been researching in Algorithmic Design, Algorithmic Analysis,
Algorithmic Optimization, and Algorithmic Visualization.  Algorithmic
Design focus on the use of algorithms that generate designs,
particularly, building designs. Algorithmic Analysis deals with the
automation of analysis processes, such as lighting analysis or
structural analysis. Algorithmic Optimization takes advantage of the
two previous areas to optimize building designs according to given
metrics, e.g., structural performance. Finally, Algorithmic
Visualization is concerned with the algorithmic exploration of
cinematographic techniques to generate images and films of building
designs.

Some of the previous areas have considerable computational
demands. Algorithmic optimization and Algorithmic Visualization, in
particular, are extremely demanding from the computational point of
view: it is not unusual to have processes running for weeks in
high-performance computer workstations. Obviously, the typical
duration of these processes makes it less likely that architects and
engineers are eager to wait for so long for their completion and,
thus, they end up not using them.

However, when we consider the evolution of the performance of the
computing systems, we verify that an enormous increase in computation
power occurred in the last decades. First, by increasing the number of
instructions a processors could execute in a given amount of time and,
then, by increasing the number of processors. The software that
nowadays runs on a mobile phone, decades ago required large rooms full
of hardware with huge energy demands.

This shows that we should not take the currently available
computational power as the norm but only as another data point in the
trend for increasingly larger computational power. This point of view
is particularly relevant because it allows us to forecast future
computational power and to realize that what is nowadays out of reach
for commodity hardware but is already possible in supercomputing
devices will, in the near future, be possible in commodity hardware.

It was with this perception that we submitted an application for the
FCT Call on Advanced Computing Projects, which gave us the opportunity
to use the High-Performance Computing (HPC) capability provided by one
of Portugal's supercomputing centers.  Our goal was to look at some of
our previous and current research, from which we already had data
regarding their computational demands, and re-execute the associated
programs in a supercomputer, to assess the effective gains.  It was
also important for us to evaluate the experience of using a
supercomputer, as these tend to run operating systems with very
specific characteristics and that differ significantly from those of a
typical off-the-shelf computer.


### Commodity Hardware

Throughout the time, our research has produced a series of programs
and programming environments.  Given the area, it is not surprising to
verify that many of them are intended to be used through a graphical
user interface.  In general, for most of their activities, our
researchers use laptops that have obvious computing power limitations.

For the most demanding computations, the highest-powered system we
used was a 2-CPU/16-core/64 GB RAM workstation running Windows-10.
This workstation was used, mostly, for tasks where user attention was
not critical, such as optimization and rendering. It was not unusual
for some of these tasks to require days or weeks of computation.

Despite the fact that, several years ago, these tasks would take
months to complete, this was no consolation when results were needed
as soon as possible.  Nowadays, users do not want to wait more than
one day and that is already assuming that the task will be done
overnight so that results are available in the morning.

### The Supercomputing Hardware

Upon approval of our application to the FCT Call on Advanced Computing
Projects, we were given access to the Cirrus supercomputer, more
specifically, the `fct` partition containing four computing
nodes, each node providing 96 AMD EPYC 7552 cores, running at 2.2 GHz
and accessing 512 GB of RAM. In total, this partition allows 384
simultaneous threads of execution, using 2 TB of memory, although
these would be constrained by the supercomputer topology and the
available resources at each moment.  In any case, this represents a
significant amount of computing power when compared with current
commodity hardware that, typically, can simultaneously execute only 8
threads of execution using 16 GB of RAM.

It is also important to mention that users to not have direct access
to the computing nodes. Instead, they have to use a front-end machine
with an Intel Xeon CPU L5420 running at 2.5GHz with 32 GB of RAM.

### The Supercomputing Software

Despite the large differences between the hardware of the Cirrus
supercomputer and that of a typical laptop, the differences in
software were even bigger and caused the biggest headaches. First,
because the supercomputer uses CentOS 7, an operating system that is
very different from the most popular ones, such as Microsoft's Windows
or Apple's MacOS. Second, because it mostly operates in _batch mode_,
meaning that _scripts_ must be submitted describing the intended
executions and the resources needed, and there is no immediate
feedback, for example, to report errors in the code.  Third, the
_batch mode_ also implies that it only supports programs that do not
require interacting with the user and, therefore, do not use a
graphical user interface.

This mode of operation is supported by Slurm's job scheduling system.
Slurm is an open source cluster management system that is very
popular. This helps significantly, as there is a ton of information
available about Slurm.

Creating the Slurm _script_ is easy. For our experiments, we used the
following template:

```
#!/bin/bash

#SBATCH --job-name=<the job name>
#SBATCH --time=<the time limit>
#SBATCH --nodes=<number of nodes>
#SBATCH --ntasks=<number of tasks>
#SBATCH -p <my partition identifier>
#SBATCH -q <my qos identifier>

<do something, maybe using some environment variables, such as $SLURM_CPUS_ON_NODE>
```

Note that anything that starts with `#SBATCH` is treated as relevant
information for Slurm. Note also that this information does not affect
the script because a line that starts with `#` is treated as a comment
by `bash`. In this particular script we specified just some of the
job's parameters but there are many other options that can be
provided.



### The Plan

Given that the available HPC resources are running Linux variants
which are very different from the Windows 10 operating system that
constitutes the usual environment for Khepri, the first step would be
to convert our software to Linux. Some of the required analysis tools
already run in Linux (e.g. Radiance, Frame3DD) but others would need
to be converted. We expect that this conversion would not need the use
of the advanced computing resources except for testing.

After that step, we planned to test the Julia programming language
capabilities for HPC. Although there are studies that show that Julia
is a good fit for those computing environments, we still need to get
some experience in that kind of use.

After having Julia running on the supercomputer, we planned to explore
the Julia language to adapt our software to not only manage multiple
parallel runs of sequential optimization algorithms but also use
parallel optimization algorithms or open-source optimization
frameworks supporting parallelization.

Finally, if there was still time available, we would experiment
running Khepri and some of their backends in the supercomputer to
evaluate its scalability on different tasks, particularly, analysis,
and visualization.

However, given the fact that some of Khepri's backends only work in
Windows, we had to select only those that we knew, in advance, that we
could have running in Linux.

To this end, the plan required the following installation steps:

1. Install the Julia language
1. Install the KhepriBase package
1. Install the BlackBoxOptim package, for multi- and single-objective optimization using meta-heuristic algorithms
1. Install the KhepriFrame3DD package, for structural analysis
1. Install the KhepriBlender and/or the KhepriPOVRay packages, for rendering

Unfortunately, as we will see, installing even this small selection of
programs was far from trivial.

### Installing Software

A major difficulty for accomplishing the plan is the lack of
administrative privileges, as it prevents the system-wide installation
of much needed libraries or software tools. Although entirely
understandable due to the shared nature of the system, lacking these
privileges makes it mandatory to use local installations.
Fortunately, some of the critical software that we planned to use,
such as the Julia programming language, can be installed locally.

Initially, we tried to use the release candidate version of Julia
version 1.6 because it promised to solve a pre-compilation problem
that occurred when multiple simultaneous Julia processes attempted to
pre-compile the software, triggering conflicts in the saving of the
compiled code to disk.  However, this version caused problems related
to the foreign function interface that was critical for calling our
own DLL implementation of the structural analysis package Frame3DD.

After these failures, we went back to version 1.5.3, which we
installed locally, using the official version for Linux and FreeBSD,
hoping that the mentioned synchronization problems would not prevent
us from doing the planned experiments.

Unfortunately, not all software can be installed this way, making it
impossible to do some of the planned experiments. The first casualty
was Blender. Although there is a CentOS version of Blender, its
installation requires administrative privileges. We spend some time
trying alternative ways to install Blender but, given the limited time
available, we moved on to the next alternative -- POVRay.

### Recompiling Software

Not all software that is available for Linux (or, more specifically,
Ubuntu) can directly run on the supercomputer.  Some can only run
after being recompiled for CentOS 7.  Given the difficulty of using
the frontend for anything more complex than just editing files or
submitting jobs, we decided to recompile the software on our own
machines and only move the resulting binaries to the supercomputer.
In the beginning we were doing this using a Ubuntu installation
running on Windows Subsystem for Linux (WSL), which we expect would be
very similar to CentOS.  However, we quickly discovered that there
were errors related to differences in the libraries of Ubuntu and
CentOS 7. To avoid being forced to recompile the software, we
initially attempted to solve these dependency errors but soon realized
that it would not end up well.

In the end, to avoid errors due to different software versions, we
installed the exact same operating system on a virtual machine. This
allowed us to more easily recompile the software, and only after
successfully testing them on our own virtual machine, to move it to
the supercomputer.  At that moment, however, we discovered that
despite running the exact same operating system, executing some of the
recompiled programs in the frontend computer triggered an `Illegal
instruction` error. After much unsuccessful debugging, we discovered
that these errors did not occur when the programs were executed in the
computing nodes.

Unfortunately, the time and effort spent making just one of the
programs run on the supercomputer consumed a significant fraction of
the time that was given us to use the machine.  To avoiding wasting
the entire time just on the task of making the programs run, we
decided to focus on those programs that we had already running and we
start collecting statistics of their execution using a different
number of processing units.

## Julia for Parallel Processing

Before anything else, we decided to gain some experience in the use of
Julia's parallel processing capabilities.

Julia supports multi-threading and
distributed computing.  Multi-threading allows multiple tasks to run
simultaneously on more than one thread or CPU core, sharing memory,
while distributed computing runs multiple processes with separate
memory spaces, possibly on different machines.  Given that Khepri is
not thread-safe, we were particularly interested in testing the
distributed computing capabilities. These are provided by the
`Distributed` standard library as well as external packages such as
`MPI.jl` and `DistributedArrays.jl`.

The `Distributed` approach is based on the idea that one _master_
process launches a set of _slave_ processes, called workers, using the
`addprocs` function, to which it distributes units of work, waiting
for their completion.  Despite being part of the standard library, the
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
already know), we prefer to compute the absolute error.

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

To launch the Slurm batch file, we just need to use `sbatch BatchPi.sh`.
The benchmark results are the following:

```julia:plot1
#hideall
using JSON
approx_pi_single = bench_data("""
Iterations   Time          AbsoluteError
10           0.000008      0.3415926535897933
100          0.000003      0.2584073464102068
1000         0.000009      0.0984073464102071
10000        0.000074      0.025592653589793013
100000       0.000754      0.007967346410207021
1000000      0.007515      0.0015486535897930587
10000000     0.074811      0.00013014641020703266
100000000    0.749354      0.000152533589793169
1000000000   7.493605      0.0000792664102067242
10000000000  75.014382     0.00002537398979329808
""")
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
```
\textoutput{plot1}

It is relevant to note that despite the apparent exponential growth, the
scale is logarithmic and, thus, the computation time grows linearly
with the number of iterations.

The next step is to repeat the same computation but using parallel
processing.  To that end, we decided to use a slightly different
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

Note that we provided the Julia program the number of tasks that it can
use, although we did not specify that number in the Slurm script. We did
it like this simply because it was easier to provide that information on the
`sbatch` call using, e.g., `sbatch --ntasks=8 BatchPi.sh`

The next fragment of code demonstrate the creation of workers. We take
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
whose id is less than its own id.

Given that all these connections require time to establish, we decided
to measure its impact in the time and allocate memory as the number of
processes is increased. The results are the following:

```julia:plot2
#hideall
creating_workers = bench_data("""
Processes Time Allocations Memory
2 1.078188 15.80 1.148
4 1.205602 16.77 1.828
8 1.480043 18.95 3.196
16 1.379302 23.54 5.945
32 1.375842 34.15 11.478
48 1.691627 47.79 17.115
64 1.737718 63.30 22.810
80 1.843256 81.42 28.583
96 2.059247 102.70 34.435
""")
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
```
\textoutput{plot2}

This shows using multiple processes entails a overhead with a fixed
part of around one second and a variable part of $0.01$ seconds per
process.

The next step is to divide the work among the workers. To that end,
each needs to know what it is supposed to be computed and this is
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
distribution of work and collection of results.  In the next plot, we
also superimpose the results for the single-threaded case.

```julia:plot3
#hideall
aprox_pi_multiple_2 = bench_data("""
 Iterations Time Allocations Memory
         10 0.856018 745.84 39127
        100 0.000391 0.119 5.016
       1000 0.000182 0.119 5.016
      10000 0.000178 0.119 5.016
     100000 0.000856 0.119 5.016
    1000000 0.007842 0.119 5.016
   10000000 0.080284 0.120 5.047
  100000000 0.776677 0.120 5.047
 1000000000 8.230821 0.120 5.047
10000000000 77.264732 0.156 7.984
""")

aprox_pi_multiple_4 = bench_data("""
 Iterations Time Allocations Memory
         10 0.847039 746.15 39142
        100 0.003264 0.331 15.453
       1000 0.000225 0.296 12.531
      10000 0.000153 0.297 12.562
     100000 0.000414 0.298 12.891
    1000000 0.002873 0.304 13.203
   10000000 0.026081 0.300 12.656
  100000000 0.257399 0.298 12.594
 1000000000 2.751700 0.299 12.922
10000000000 26.270629 0.309 13.359
""")

aprox_pi_multiple_8 = bench_data("""
 Iterations Time Allocations Memory
         10 0.854364 746.81 39173
        100 0.001206 0.683 29.578
       1000 0.000410 0.680 28.219
      10000 0.000310 0.677 28.547
     100000 0.000461 0.682 29.109
    1000000 0.001537 0.682 28.656
   10000000 0.011333 0.687 28.391
  100000000 0.110858 0.681 28.625
 1000000000 1.147449 0.689 29.328
10000000000 11.570491 0.696 29.094
""")

aprox_pi_multiple_16 = bench_data("""
 Iterations Time Allocations Memory
         10 1.089487 748.23 39241
        100 0.001074 1.54 61.406
       1000 0.000708 1.54 61.938
      10000 0.000690 1.55 61.781
     100000 0.000682 1.56 63.219
    1000000 0.001329 1.54 64.609
   10000000 0.006278 1.54 60.844
  100000000 0.056760 1.56 61.406
 1000000000 0.562188 1.55 61.094
10000000000 5.599749 1.57 63.359
""")

aprox_pi_multiple_32 = bench_data("""
 Iterations Time Allocations Memory
         10 0.896568 751.48 39371
        100 0.002596 3.62 133.672
       1000 0.001506 3.61 132.234
      10000 0.001533 3.64 133.844
     100000 0.001501 3.63 139.219
    1000000 0.001477 3.63 133.359
   10000000 0.003643 3.64 132.172
  100000000 0.026056 3.66 134.406
 1000000000 0.251256 3.67 133.141
10000000000 2.518703 3.67 134.562
""")

aprox_pi_multiple_48 = bench_data("""
 Iterations Time Allocations Memory
         10 0.988248 755.19 39501
        100 0.003823 6.23 220.297
       1000 0.002412 6.21 212.531
      10000 0.002424 6.22 213.047
     100000 0.002398 6.22 212.688
    1000000 0.002382 6.22 218.781
   10000000 0.003472 6.30 217.625
  100000000 0.018110 6.21 210.359
 1000000000 0.169489 6.26 211.953
10000000000 1.745023 6.26 218.141
""")

aprox_pi_multiple_64 = bench_data("""
 Iterations Time Allocations Memory
         10 0.950720 759.46 39656
        100 0.004167 9.36 302.781
       1000 0.003167 9.32 299.766
      10000 0.003195 9.36 301.062
     100000 0.003153 9.37 301.500
    1000000 0.003184 9.34 308.484
   10000000 0.003510 9.46 305.875
  100000000 0.014892 9.34 297.672
 1000000000 0.130532 9.38 298.766
10000000000 1.306310 9.39 299.047
""")

aprox_pi_multiple_80 = bench_data("""
 Iterations Time Allocations Memory
         10 0.960334 764.24 39812
        100 0.005236 12.92 392.938
       1000 0.004120 12.93 394.703
      10000 0.004182 12.98 397.797
     100000 0.004170 12.96 404.234
    1000000 0.004118 12.94 395.578
   10000000 0.004086 13.02 401.797
  100000000 0.017604 13.00 394.406
 1000000000 0.155060 13.12 398.031
10000000000 1.173751 13.09 423.344
""")

aprox_pi_multiple_96 = bench_data("""
 Iterations Time Allocations Memory
         10 0.947769 769.50 40006
        100 0.006393 17.05 497.703
       1000 0.005020 17.09 503.891
      10000 0.005109 17.11 500.875
     100000 0.064166 17.17 502.859
    1000000 0.004894 17.10 499.984
   10000000 0.004888 17.20 502.484
  100000000 0.013053 17.54 517.047
 1000000000 0.103313 17.15 497.469
10000000000 0.954526 17.17 498.062
""")
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
```
\textoutput{plot3}

Results show that two processes, i.e., having just one worker doing
all the work, is very similar to the single-threaded case. The
performance impact is just 2.6%. However it is not all good news, as
the results also show that it only pays off to parallelize when the
number of iterations reaches $10^8$.

On the other hand, when we compare the time it takes the entire
experiment for a given number of processes, the results are a bit
surprising:

```julia:plot4
#hideall
time_aprox_pi_multiple = bench_data("""
Processes Time
2  174.818
4  117.889
8  101.636
16 96.311
32 95.354
48 96.136
64 95.539
80 96.951
96 98.881
""")
plt=
plot(time_aprox_pi_multiple[:,1],
     time_aprox_pi_multiple[:,2],
     labels=[2 4 8 16 32 48 64 80 96],
     legend=:none,
     markers=:auto,
     ylimits=(0,180),
     xlabel="Processes",
     xticks=time_aprox_pi_multiple[:,1],
     #color=:green,
     #xscale=:log10,
     ylabel="Time (s)")
saveplot(plt,"userTimeParallelPi")
```
\textoutput{plot4}

Now, we see that despite the considerable gains obtained, almost
halving the time needed, it only pays off to use up to 16
processes.

### Fairness

Our guess for the lack of speedup after 16 processes is that the time
spent starting processes and managing them nullifies the gains of the
parallelization. Another hypothesis is that, despite the number of
workers created, Julia is not taking advantage of them because it does
not fairly distribute the work among them. To refute (or confirm) this
hypothesis, we decide to make a different test.

The goal, now, is to distribute identical work units among the workers
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
the number of times each _id_ shows up. If the distribution is fair,
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

In the following bar graph, we plot that number for each process,
whose _id_ is presented on the horizontal axis.

```julia:plot5
#hideall
work_per_id = [bench_data("""
Id Units
2 23
3 23
4 22
5 22
6 21
7 21
8 21
9 21
10 21
11 21
12 21
13 21
14 21
15 22
16 22
17 21
18 21
19 21
20 21
21 22
22 21
23 22
24 21
25 21
26 20
27 21
28 20
29 21
30 21
31 20
32 21
33 21
34 20
35 20
36 21
37 20
38 20
39 20
40 21
41 22
42 21
43 21
44 21
45 21
46 20
47 20
48 21
49 20
50 22
51 22
52 21
53 21
54 20
55 20
56 21
57 21
58 21
59 22
60 20
61 21
62 20
63 21
64 22
65 22
66 21
67 20
68 22
69 21
70 22
71 22
72 22
73 22
74 21
75 20
76 22
77 21
78 22
79 21
80 21
81 20
82 22
83 21
84 22
85 22
86 22
87 20
88 22
89 20
90 20
91 21
92 22
93 20
94 21
95 20
96 20
"""), bench_data("""
Id Units
2 27
3 27
4 25
5 25
6 25
7 25
8 25
9 26
10 25
11 25
12 25
13 26
14 26
15 26
16 26
17 25
18 26
19 25
20 26
21 25
22 26
23 25
24 25
25 25
26 25
27 25
28 25
29 25
30 25
31 25
32 25
33 25
34 25
35 25
36 25
37 25
38 25
39 24
40 25
41 25
42 25
43 25
44 26
45 25
46 25
47 25
48 25
49 25
50 26
51 25
52 26
53 26
54 26
55 25
56 25
57 25
58 25
59 25
60 26
61 25
62 25
63 25
64 26
65 24
66 26
67 25
68 25
69 26
70 25
71 25
72 26
73 24
74 26
75 26
76 26
77 25
78 26
79 26
80 26
"""), bench_data("""
Id Units
2 34
3 33
4 31
5 32
6 32
7 31
8 31
9 32
10 32
11 33
12 32
13 33
14 32
15 31
16 33
17 31
18 31
19 33
20 33
21 32
22 31
23 31
24 32
25 31
26 32
27 32
28 31
29 33
30 33
31 33
32 32
33 33
34 31
35 31
36 31
37 32
38 32
39 32
40 31
41 31
42 32
43 31
44 30
45 31
46 32
47 33
48 30
49 31
50 31
51 30
52 32
53 31
54 32
55 33
56 32
57 31
58 32
59 32
60 31
61 31
62 32
63 32
64 31
"""), bench_data("""
Id Units
2 46
3 45
4 43
5 43
6 43
7 42
8 42
9 44
10 42
11 42
12 44
13 42
14 42
15 42
16 42
17 42
18 42
19 42
20 43
21 42
22 43
23 42
24 42
25 42
26 42
27 43
28 43
29 42
30 42
31 43
32 42
33 42
34 43
35 43
36 42
37 43
38 42
39 44
40 42
41 42
42 42
43 42
44 43
45 43
46 42
47 42
48 42
"""), bench_data("""
Id Units
2 67
3 66
4 64
5 66
6 65
7 64
8 64
9 64
10 64
11 64
12 65
13 64
14 66
15 64
16 64
17 65
18 65
19 65
20 64
21 64
22 65
23 64
24 65
25 64
26 64
27 64
28 64
29 64
30 64
31 64
32 64
"""), bench_data("""
Id Units
2 135
3 134
4 133
5 134
6 133
7 133
8 133
9 132
10 133
11 133
12 132
13 134
14 134
15 134
16 133
"""), bench_data("""
Id Units
2 288
3 288
4 284
5 285
6 286
7 286
8 283
"""), bench_data("""
Id Units
2 669
3 666
4 665
"""), bench_data("""
Id Units
2 2000
""")]
plt=
plot(
  work_per_id[1][:,1],
  work_per_id[1][:,2],
  xlimits=(2,96),
  #xticks=work_per_id[1][:,1],
  seriestype = :bar,
  legend=:none,
  xlabel="Process Id",
  ylabel="Work Units")
saveplot(plt,"workPerId96")
```
\textoutput{plot5}

Note the fairly regular number of units of work that is done by each
worker. Similar plots could be made for other numbers of
processes. The next one shows the same statistics but using only 32
processors:

```julia:plot6
#hideall
plt=
plot(
  work_per_id[5][:,1],
  work_per_id[5][:,2],
  xlimits=(2,32),
  #xticks=work_per_id[5][:,1],
  seriestype = :bar,
  legend=:none,
  xlabel="Process Id",
  ylabel="Work Units")
saveplot(plt,"workPerId32")
```
\textoutput{plot6}

Again, we see a relatively fair distribution of work. The same
behavior is seen in the following case, using just four processes:

```julia:plot6a
#hideall
plt=
plot(
  work_per_id[8][:,1],
  work_per_id[8][:,2],
  #xlimits=(2,4),
  xticks=[2,3,4], #work_per_id[8][:,1],
  seriestype = :bar,
  legend=:none,
  xlabel="Process Id",
  ylabel="Work Units")
saveplot(plt,"workPerId8")
```
\textoutput{plot6a}

The following bar graph condenses the entire information in a single
plot that shows the division of labor for different numbers of
workers. As before, remember that the number of workers is one less
than the number of processes. That means that, e.g., for 2 processes,
there is just one worker doing all the heavy lifting.

```julia:plot7
#hideall
resize(v, n) = vcat(v, zeros(Int, n - length(v)))
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(w->resize(collect(w[:,2]), 95), reverse(work_per_id))...)',
  bar_position=:stack,
  #size=(700,1000),
  legend=:none,
  #xlabels=,
  xlabel="# Processes",
  ylabel="Work Units"
  )
saveplot(plt,"workPerId")
```
\textoutput{plot7}

As is visible, the work was uniformly distributed among the workers,
independently of the number of workers being used.

### Speedup

The following bar graph reveals another interesting statistic that
confirms our previous hypothesis regarding the time spent managing the
workers _vs_ the time doing actual work. Here we measured the time
needed to launch the workers (the `addprocs` operation) and the total
time needed to process all work items.

```julia:plot8
#hideall
work_per_id_bench = bench_data("""
Processes StartTime(s) StartAllocs(k) StartMemory(MiB) RunTime(s) RunAllocs(k) RunMemory(MiB)
2 1.417592 15.86 1.254 22.503356 247.07 10.499
4 1.560481 16.83 1.934 7.585491 248.19 10.535
8 1.286162 18.89 3.299 3.352620 248.10 10.542
16 1.751758 23.82 6.057 1.658032 248.08 10.542
32 1.748663 34.40 11.593 0.902268 248.66 10.565
48 1.925062 48.28 17.249 0.666988 248.76 10.544
64 1.915959 63.91 22.913 0.551525 250.47 10.617
80 1.942948 82.16 28.707 0.464072 250.09 10.610
96 2.129396 103.51 34.561 0.421452 251.00 10.647
""")
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(row->[row[5], row[2]], eachrow(work_per_id_bench))...)',
  bar_position=:stack,
  label=["Work time" "Launch time"],
  xlabel="# Processes",
  ylabel="Time(s)")
saveplot(plt,"workPerId")
```
\textoutput{plot8}

Despite the enormous reduction in the time spent doing actual work
(that goes from 22.5 seconds using just one worker to 0.42 seconds
using 96 workers, i.e., $\frac{1}{54}$ of the original time), we can
see that the actual benefits become marginal when we use more than 32
processes and the situation gets actually worse with 96 processes, as
the time to launch all of them dominates the entire computation. With
that number of processors, the total time goes from 23.9 seconds to
2.55, i.e., $\frac{1}{10}$ of the original total time. The following
plot illustrates the difference between the speedups considering only
the time when the workers are doing useful work and the corresponding
speedups when we consider the total time.

```julia:plot9
#hideall
speedups_work_time = map(row->(work_per_id_bench[1,5])/(row[5]), eachrow(work_per_id_bench))
speedups_total_time = map(row->(work_per_id_bench[1,2]+work_per_id_bench[1,5])/(row[2]+row[5]), eachrow(work_per_id_bench))

plt=
plot(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  [speedups_work_time speedups_total_time],
  label=["Working Time" "Total Time"],
  legend=:topleft,
  xlabel="# Processes",
  ylabel="Speedup")
saveplot(plt,"speedUpWorkers")
```
\textoutput{plot9}

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
$T_s=T-T_p=T-pT=(1-p)T$.  Therefore, we have $T=(1-p)T + pT$.

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

## Design Exploration

Design space exploration is one of the simplest applications of
supercomputing. The idea is to study the impact of a parameter in the
performance of a given design. By dividing the domain of the parameter
among different computing threads, it becomes possible to do multiple
performance evaluations at the same time, each using a different
design generated from that parameter.

To evaluate the benefits of the approach, we decided to experiment the
design space exploration of a simple truss structure. We were
interested in simulating the behavior of the structure as different
parameters were changed. To have a metric for the structural
performance, we focused on the maximum displacement of the structure
elements.

Khepri supports two different structural analysis backends, namely
KhepriRobot that connects to AutoDesk's Robot and KhepriFrame3DD,
which directly accesses a DLL that wraps Frame3DD, static and dynamic
structural analysis package for 2D and 3D frames, developed by
Prof. Henri P. Gavin of the Department of Civil and Environmental
Engineering of Duke University. Given that Robot does not work in
non-Windows environments while Frame3DD does not require a graphical
user interface, the choice for Khepri's backend KhepriFrame3DD was
obvious.

Inspired by Gaudi's ideas, we decided to create a truss where each of
the truss' legs is defined by a catenary that connects the leg
endpoints. The legs are interconnected using different schemes, for
example, just a single bar between corresponding pairs of nodes, or
diagonal bars between pairs of pairs of nodes. To make the example
more interesting, we decided to design a truss made of Bamboo, placed
on a slab with a randomized outline, as follows:

\fig{/VDomeTrussRibsDeform2-frame-000.png}

This means that the truss does not have an axis of symmetry and,
therefore, will be less resistant. For the structural simulation we
used an approximation of the material properties of Bamboo, namely, a
Young's modulus of $E=1.39 GPa$, a Kirchoff's modulus of $G=0.64 GPa$,
and a density of $d=5880.0 Kg/m^3$.

Our first experiment was to test a vertical load of increasing
magnitude being applied to all the non-supported truss nodes.  The
load started at zero and went up to 100 N.  For each load case, the
structured was analyzed by KhepriFrame3DD and the computed truss node
displacements were used to show the shape of the truss under load. To
make the displacement more obvious, we applied a factor of 100. This
means that the actual truss deformation is one hundred times smaller
than what is illustrated. The following movie shows the truss behavior
under increasing load:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/VDomeTrussRibsDeform2.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

The entire analysis, containing 200 different load cases whose results
were rendered in FHD, required 1h46m to generate. One problem we had
was that each structural analysis was entirely sequential and, thus,
could not benefit from multiple CPUs or multiple computing nodes. On
the other hand, it is relevant to mention that the largest fraction of
the time (around 99%) is spent rendering, which is already highly
parallelized and takes full advantage of the 96 CPUs available.

Another experiment was the addition of an horizontal force, which we
established as one tenth of the vertical one. This small addition
considerably impacts the structural behavior of the truss. The
following movie compares the base load case, with this one.

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/WDomeTrussRibsDeform23.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

The second analysis, again with 200 load cases, took 1h48m.  Although
we did the experiments one after the other, it would have been
possible to run them in two different computing nodes, making the
total time just the maximum of both times, i.e., 1h48m instead of
their sum, i.e., 3h34.

On a further experiment, we studied the impact of the truss bars
radius on the structural performance. The following movie illustrates
the behavior of a truss that is loaded with a constant force of -10N
on each truss node and where the radius of the truss bars goes from
3cm to 5mm. The entire analysis was completed in 1h03m.

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/DomeTrussRibsDeformRadiusW35.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

To have a different perspective on the truss behavior, observe the
following movie that more clearly shows the radius reduction and its
effect on the structure shape under load.

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/DomeTrussRibsDeformRadius.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

This previous analysis required 1h04m to produce. Again, it would have
been possible to explore multiple computing nodes, to make multiple
analysis to be executed at the same time. In fact, the limitation is
not on the computing power available but, instead, on the human power
available, as we the motivation for further analyses only emerges
after studying the results of the previous one.

Finally, we decided to do a different design space exploration: this
time, instead of exploring one design parameter, we explored different
truss topologies. The difference lies in the bracings between nodes,
as illustrated in the following image:

\fig{/TrussTopology}

Although the two imagens on the right look very similar, they are
different, as the one at the bottom has two independent bar connecting
alternating nodes, while the top one has one extra node on the
crossing between bars, effectively making them four independent bars
connected at that extra node.  This has a considerable effect on the
truss behavior as it makes it much more difficult to resist
compressive forces.

The behavior of the different truss topologies is illustrated in the
following movie. All trusses were subjected to the same load case, an
increasingly larger vertical force and an horizontal force that is one
tenth of the vertical one. Remember that the displacement is amplified
by a factor of 100.

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/WDomeTrussRibsDeform6789.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

Seen from the inside of the structure, the behavior seems a bit more
impressive, as is visible in the following movie:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/DomeTrussRibsDeform6789.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

It is interesting to note that with one exception, these different
topologies take approximately the same time to evaluate, slightly
under one hour. The exception is the structure at the top right
corner, which has significantly more bars and nodes than the others,
which cause KhepriFrame3DD to take an inordinate amount of time to
analyze the structure (7h33m). Just in case, we repeated the four
simulations twice but the results came almost exactly the same.

Given that the structural analysis is single threaded but is chained
with the rendering, which is multi-threaded, the best we can do is to
analyze multiple cases in different computing nodes. The total time,
though, is the maximum, that is, 7h33.


## Optimization

The next set of experiments measured the potential gains that
parallelization could provide to optimization problems. To focus on
the optimization itself, we used an objective function that was not
parallelized. More specifically, the case study was the optimization
of the structural properties of the previous truss, measured by the
maximum displacement of all its nodes. The variable vector to optimize
is the location of the truss' center, i.e., the point at the top where
all truss legs join.

We started by considering only the X and Y location of the truss'
center, fixing its height. This means that we will have two variables
to optimize.  The objective function landscape is a very simple one,
as represented in the following plot where we show the maximum
displacement of the truss nodes for different locations $(X,Y)$ (at a
fixed height) of the truss' central node.

```julia:truss_center
#hideall
plot_2d(raw_data) =
  let data = raw_data
    plot(-6.0:0.5:6.0,
         -6.0:0.5:6.0,
         reshape(data[:,3], (25, 25)),
         st=:surface,
         #legend=:none,
         #markers=:auto,
         #ylimits=(0,180),
         xlabel="X",
         ylabel="Y",
         zlabel="Max Displacement",
         #color=:green,
         #xscale=:log10,
         )
  end

plt = plot_2d(bench_data("""
X Y MaxDisplacement
-6.0 -6.0 0.17019783521210327
-6.0 -5.5 0.1575668173538984
-6.0 -5.0 0.14574156707203664
-6.0 -4.5 0.13480812059062885
-6.0 -4.0 0.12474320429632176
-6.0 -3.5 0.11552573430065137
-6.0 -3.0 0.1095088058068711
-6.0 -2.5 0.10563325707954485
-6.0 -2.0 0.1026045115073573
-6.0 -1.5 0.10039943784349667
-6.0 -1.0 0.09897436454036211
-6.0 -0.5 0.0982814815426216
-6.0 0.0 0.09827775058033124
-6.0 0.5 0.09892536776306275
-6.0 1.0 0.10018821658287994
-6.0 1.5 0.10202912063800543
-6.0 2.0 0.10441033077261186
-6.0 2.5 0.10729788725487692
-6.0 3.0 0.11067150027673552
-6.0 3.5 0.11454580232743694
-6.0 4.0 0.11901390037590893
-6.0 4.5 0.12439409457484084
-6.0 5.0 0.13327089723036029
-6.0 5.5 0.14393466659539453
-6.0 6.0 0.15612288688561826
-5.5 -6.0 0.15821646956402813
-5.5 -5.5 0.1464248368354598
-5.5 -5.0 0.1352039035077912
-5.5 -4.5 0.12468591345928191
-5.5 -4.0 0.114963036711939
-5.5 -3.5 0.10608820550935
-5.5 -3.0 0.0983697322791679
-5.5 -2.5 0.09459614895205523
-5.5 -2.0 0.0916050084129462
-5.5 -1.5 0.08938881837012068
-5.5 -1.0 0.08792253414122901
-5.5 -0.5 0.08717205025866469
-5.5 0.0 0.08710073235948983
-5.5 0.5 0.0876723623355891
-5.5 1.0 0.08885189297685962
-5.5 1.5 0.09060647301770244
-5.5 2.0 0.0929087422962224
-5.5 2.5 0.09574379744269902
-5.5 3.0 0.09912141397963785
-5.5 3.5 0.1030954688500291
-5.5 4.0 0.10778972448145083
-5.5 4.5 0.11462354609699721
-5.5 5.0 0.12356684426980219
-5.5 5.5 0.1339136615767626
-5.5 6.0 0.1453980672885024
-5.0 -6.0 0.147994153174528
-5.0 -5.5 0.1365128369730352
-5.0 -5.0 0.12565956312880908
-5.0 -4.5 0.11549134527259564
-5.0 -4.0 0.10604087185658491
-5.0 -3.5 0.09737860158585551
-5.0 -3.0 0.0895693074544651
-5.0 -2.5 0.08427090386398013
-5.0 -2.0 0.08130545481043368
-5.0 -1.5 0.07907372817910494
-5.0 -1.0 0.07756500517013097
-5.0 -0.5 0.07675793205485065
-5.0 0.0 0.07662486455161217
-5.0 0.5 0.07713538196550514
-5.0 1.0 0.07825925076155127
-5.0 1.5 0.07996992627015308
-5.0 2.0 0.08224972276469796
-5.0 2.5 0.08509744387210633
-5.0 3.0 0.08853872220160097
-5.0 3.5 0.09263790006178933
-5.0 4.0 0.09781674660617164
-5.0 4.5 0.10551448187878702
-5.0 5.0 0.11433512221929655
-5.0 5.5 0.12434264774220076
-5.0 6.0 0.13533179281369154
-4.5 -6.0 0.13965953077476367
-4.5 -5.5 0.12805908940892607
-4.5 -5.0 0.11729288605633417
-4.5 -4.5 0.10729104569690083
-4.5 -4.0 0.09802893915529158
-4.5 -3.5 0.08950419381654011
-4.5 -3.0 0.08177500884984966
-4.5 -2.5 0.07490381359077981
-4.5 -2.0 0.07169193422099356
-4.5 -1.5 0.06942577236048632
-4.5 -1.0 0.06786470009526971
-4.5 -0.5 0.06699935679598634
-4.5 0.0 0.06681203275903132
-4.5 0.5 0.06727971896640324
-4.5 1.0 0.06837788685413312
-4.5 1.5 0.07008523852232737
-4.5 2.0 0.07238962723099912
-4.5 2.5 0.07529500320967028
-4.5 3.0 0.07882853811664114
-4.5 3.5 0.08304572044020725
-4.5 4.0 0.0893791674107572
-4.5 4.5 0.09701040107605656
-4.5 5.0 0.1056467214197882
-4.5 5.5 0.11530855077498124
-4.5 6.0 0.12587742323218035
-4.0 -6.0 0.13274880711634998
-4.0 -5.5 0.12092034796939763
-4.0 -5.0 0.11008047467598864
-4.0 -4.5 0.1000979042755253
-4.0 -4.0 0.09090072803282381
-4.0 -3.5 0.08245469780885431
-4.0 -3.0 0.07475051465126409
-4.0 -2.5 0.06784667263806873
-4.0 -2.0 0.06275668939113928
-4.0 -1.5 0.06042306400577937
-4.0 -1.0 0.05878885914054229
-4.0 -0.5 0.05785679988667314
-4.0 0.0 0.05761969919882199
-4.0 0.5 0.058062162305724356
-4.0 1.0 0.05916416867334297
-4.0 1.5 0.06090626411201784
-4.0 2.0 0.0632757205382708
-4.0 2.5 0.06627265535566831
-4.0 3.0 0.06991469756057134
-4.0 3.5 0.07491536789194332
-4.0 4.0 0.08159566749476418
-4.0 4.5 0.08912143190625961
-4.0 5.0 0.09754830054418889
-4.0 5.5 0.10686238694667549
-4.0 6.0 0.11707750054145451
-3.5 -6.0 0.12682579665419258
-3.5 -5.5 0.11484111644492402
-3.5 -5.0 0.10388955702336032
-3.5 -4.5 0.09384802178008067
-3.5 -4.0 0.08462866863174931
-3.5 -3.5 0.07617710325730927
-3.5 -3.0 0.06846639714763651
-3.5 -2.5 0.06149215799611488
-3.5 -2.0 0.055325878809792846
-3.5 -1.5 0.05204862825663532
-3.5 -1.0 0.0503077910172785
-3.5 -0.5 0.04929087744242297
-3.5 0.0 0.049007306587357934
-3.5 0.5 0.04943953695735311
-3.5 1.0 0.05058132892639331
-3.5 1.5 0.05240286157220822
-3.5 2.0 0.05488343566842728
-3.5 2.5 0.058011022776898284
-3.5 3.0 0.06193564266335145
-3.5 3.5 0.06786334682565535
-3.5 4.0 0.07452266655127604
-3.5 4.5 0.08193742887883029
-3.5 5.0 0.09011959099951161
-3.5 5.5 0.10014608879135209
-3.5 6.0 0.11127037675032801
-3.0 -6.0 0.12165618260334513
-3.0 -5.5 0.1096132909207199
-3.0 -5.0 0.09857304266263886
-3.0 -4.5 0.08844895640818418
-3.0 -4.0 0.07916036026506072
-3.0 -3.5 0.07064627291605734
-3.0 -3.0 0.06286874136117454
-3.0 -2.5 0.05581317221908446
-3.0 -2.0 0.0494890200005611
-3.0 -1.5 0.044313770244764246
-3.0 -1.0 0.04242274151989389
-3.0 -0.5 0.04129584953573479
-3.0 0.0 0.040954459146058234
-3.0 0.5 0.04139899109386248
-3.0 1.0 0.04260924317570849
-3.0 1.5 0.04455093866805207
-3.0 2.0 0.047185623419657444
-3.0 2.5 0.05047986905462374
-3.0 3.0 0.05550705466960598
-3.0 3.5 0.06148787827740019
-3.0 4.0 0.06813517592728342
-3.0 4.5 0.07594853075116477
-3.0 5.0 0.08535254368666577
-3.0 5.5 0.09550020569389714
-3.0 6.0 0.10633908414900844
-2.5 -6.0 0.11714777267800947
-2.5 -5.5 0.10510948226840543
-2.5 -5.0 0.09401569059468907
-2.5 -4.5 0.08381458140535238
-2.5 -4.0 0.07444040605040476
-2.5 -3.5 0.06583345862865907
-2.5 -3.0 0.057949799414076644
-2.5 -2.5 0.05076655032494465
-2.5 -2.0 0.0442868044619911
-2.5 -1.5 0.03856676139614342
-2.5 -1.0 0.035098210715134526
-2.5 -0.5 0.03380609799180369
-2.5 0.0 0.033386498523752715
-2.5 0.5 0.03385228678860737
-2.5 1.0 0.03517554735280884
-2.5 1.5 0.037297794721295206
-2.5 2.0 0.040148681080325974
-2.5 2.5 0.0443096802735
-2.5 3.0 0.049756418368542346
-2.5 3.5 0.05581471150355281
-2.5 4.0 0.06373522854051614
-2.5 4.5 0.0723857566837057
-2.5 5.0 0.08173465394715376
-2.5 5.5 0.09178620494163099
-2.5 6.0 0.10248759497463344
-2.0 -6.0 0.1132775375944251
-2.0 -5.5 0.10126214777437495
-2.0 -5.0 0.09014198183872237
-2.0 -4.5 0.07988049817298795
-2.0 -4.0 0.07042435440597433
-2.0 -3.5 0.06171670279181853
-2.0 -3.0 0.05370939669459762
-2.0 -2.5 0.04637125201412337
-2.0 -2.0 0.03969620754162407
-2.0 -1.5 0.033715193977161724
-2.0 -1.0 0.02858799143955769
-2.0 -0.5 0.026790056623899643
-2.0 0.0 0.026256408579795297
-2.0 0.5 0.026764064724955173
-2.0 1.0 0.02826667129959141
-2.0 1.5 0.030656036712218553
-2.0 2.0 0.034091546034044067
-2.0 2.5 0.039109764604222545
-2.0 3.0 0.04536247930021404
-2.0 3.5 0.0528254257656633
-2.0 4.0 0.060902934640743325
-2.0 4.5 0.06964109419613715
-2.0 5.0 0.0790297182165075
-2.0 5.5 0.08905482506128172
-2.0 6.0 0.09973574843558164
-1.5 -6.0 0.11048617993781978
-1.5 -5.5 0.09829030375707755
-1.5 -5.0 0.08696947871280088
-1.5 -4.5 0.07661579199149238
-1.5 -4.0 0.06708457727115333
-1.5 -3.5 0.05828684965226571
-1.5 -3.0 0.05016022199141015
-1.5 -2.5 0.04266361433080543
-1.5 -2.0 0.03577699601908835
-1.5 -1.5 0.02955794155529642
-1.5 -1.0 0.02403365846937911
-1.5 -0.5 0.020328717011146254
-1.5 0.0 0.019636430355783715
-1.5 0.5 0.020219692444574083
-1.5 1.0 0.02198975490652518
-1.5 1.5 0.024772220407754487
-1.5 2.0 0.02946087158662226
-1.5 2.5 0.03594530886225149
-1.5 3.0 0.04300690612070368
-1.5 3.5 0.05062960591039485
-1.5 4.0 0.05885735427298579
-1.5 4.5 0.06768544018108497
-1.5 5.0 0.07712263630569899
-1.5 5.5 0.08719921416967288
-1.5 6.0 0.0979557567434935
-1.0 -6.0 0.10872378152278311
-1.0 -5.5 0.09651493100411668
-1.0 -5.0 0.08514974448818985
-1.0 -4.5 0.07460506254898111
-1.0 -4.0 0.06483391102958495
-1.0 -3.5 0.055778765030445925
-1.0 -3.0 0.04738151896788884
-1.0 -2.5 0.039699358912238025
-1.0 -2.0 0.03264990215585223
-1.0 -1.5 0.02616350999173534
-1.0 -1.0 0.020289574828120632
-1.0 -0.5 0.015252514420841592
-1.0 0.0 0.013462920811919691
-1.0 0.5 0.01418794314712007
-1.0 1.0 0.016433948663187373
-1.0 1.5 0.021292958174214605
-1.0 2.0 0.027435283245282927
-1.0 2.5 0.034192740991204486
-1.0 3.0 0.04143991913801628
-1.0 3.5 0.0491938206300848
-1.0 4.0 0.057534541361502184
-1.0 4.5 0.06644613833098567
-1.0 5.0 0.07596536029092937
-1.0 5.5 0.08613429311785925
-1.0 6.0 0.09700408445986619
-0.5 -6.0 0.10758518486723827
-0.5 -5.5 0.09536200905182413
-0.5 -5.0 0.08398201057302118
-0.5 -4.5 0.07341267235114216
-0.5 -4.0 0.06360201093255315
-0.5 -3.5 0.05448847576179011
-0.5 -3.0 0.04600814041568462
-0.5 -2.5 0.03813673151991051
-0.5 -2.0 0.030788969483432335
-0.5 -1.5 0.02391387045131318
-0.5 -1.0 0.01764853110488434
-0.5 -0.5 0.012046021250470365
-0.5 0.0 0.008162959089628483
-0.5 0.5 0.009119180644038518
-0.5 1.0 0.01403589314824849
-0.5 1.5 0.019934833749837993
-0.5 2.0 0.026340557305669393
-0.5 2.5 0.033254998096114534
-0.5 3.0 0.04061852714828045
-0.5 3.5 0.048484890528232884
-0.5 4.0 0.05688516522892286
-0.5 4.5 0.06588148943276928
-0.5 5.0 0.07549131822402397
-0.5 5.5 0.08576058178678074
-0.5 6.0 0.09673804812149132
0.0 -6.0 0.10707072911947783
0.0 -5.5 0.09484103793276807
0.0 -5.0 0.08346671480161341
0.0 -4.5 0.07290424288139026
0.0 -4.0 0.06309653733370096
0.0 -3.5 0.05397984575538557
0.0 -3.0 0.04549107681736916
0.0 -2.5 0.03761084336371327
0.0 -2.0 0.030227399409589108
0.0 -1.5 0.023318450733320534
0.0 -1.0 0.01695202202108289
0.0 -0.5 0.011052227769446333
0.0 0.0 0.007271440482137469
0.0 0.5 0.008773348846545832
0.0 1.0 0.013869569780488533
0.0 1.5 0.019836537418009326
0.0 2.0 0.026212052742700557
0.0 2.5 0.033166944495657644
0.0 3.0 0.04059836069570546
0.0 3.5 0.048519523971453364
0.0 4.0 0.05697240411007191
0.0 4.5 0.06600046755265539
0.0 5.0 0.07568377428781183
0.0 5.5 0.0860535605274415
0.0 6.0 0.09712797928627531
0.5 -6.0 0.10720378324587279
0.5 -5.5 0.09500303342512119
0.5 -5.0 0.08367519615799643
0.5 -4.5 0.07316790957167084
0.5 -4.0 0.06342135958337652
0.5 -3.5 0.05437276947932982
0.5 -3.0 0.045960492797440605
0.5 -2.5 0.03812802047490103
0.5 -2.0 0.03085736678981002
0.5 -1.5 0.02411247341627147
0.5 -1.0 0.017974125708771715
0.5 -0.5 0.013661147162532439
0.5 0.0 0.011725356341413144
0.5 0.5 0.012105543758859642
0.5 1.0 0.01576511953919886
0.5 1.5 0.021365164790939417
0.5 2.0 0.02761000351854244
0.5 2.5 0.03446449011023478
0.5 3.0 0.04180917125117347
0.5 3.5 0.04966733949577693
0.5 4.0 0.05807385088564479
0.5 4.5 0.06706799207287445
0.5 5.0 0.076731896918008
0.5 5.5 0.08707225789292637
0.5 6.0 0.09809698449682275
1.0 -6.0 0.10809206780060748
1.0 -5.5 0.09591898937325483
1.0 -5.0 0.08463425185886093
1.0 -4.5 0.07418354896300697
1.0 -4.0 0.06450878598235009
1.0 -3.5 0.0555519007103308
1.0 -3.0 0.04725955306562868
1.0 -2.5 0.039588911977584816
1.0 -2.0 0.03251663316489984
1.0 -1.5 0.026175807904504043
1.0 -1.0 0.02204108944470367
1.0 -0.5 0.019206972412155552
1.0 0.0 0.017686846244888574
1.0 0.5 0.01773535875458149
1.0 1.0 0.02017916842325401
1.0 1.5 0.024506185406697144
1.0 2.0 0.029963915414785134
1.0 2.5 0.03661613908464238
1.0 3.0 0.04386482779702059
1.0 3.5 0.05168365696768594
1.0 4.0 0.06009330549961734
1.0 4.5 0.06912392408163998
1.0 5.0 0.07885716820863939
1.0 5.5 0.089277789418935
1.0 6.0 0.10038562256974029
1.5 -6.0 0.10969570146235957
1.5 -5.5 0.09755345382140833
1.5 -5.0 0.0863134167724146
1.5 -4.5 0.07592679028678595
1.5 -4.0 0.0663401957096629
1.5 -3.5 0.057501893632431654
1.5 -3.0 0.04936832418138284
1.5 -2.5 0.04191163805555201
1.5 -2.0 0.03588901402504139
1.5 -1.5 0.03135451075452821
1.5 -1.0 0.02790537411037277
1.5 -0.5 0.025417909107605708
1.5 0.0 0.024094503409369514
1.5 0.5 0.02402027642100193
1.5 1.0 0.025392511625557328
1.5 1.5 0.029338348375894416
1.5 2.0 0.034156673835203176
1.5 2.5 0.03967740498176871
1.5 3.0 0.04661543190790419
1.5 3.5 0.05435044871002407
1.5 4.0 0.06272586916200133
1.5 4.5 0.07176636858024663
1.5 5.0 0.0815427337087306
1.5 5.5 0.09202669272463108
1.5 6.0 0.1032144899916712
2.0 -6.0 0.11211677153456547
2.0 -5.5 0.0999747239110113
2.0 -5.0 0.08875932423879199
2.0 -4.5 0.0784283148550871
2.0 -4.0 0.06893138431992522
2.0 -3.5 0.060221472435737
2.0 -3.0 0.05297206789974298
2.0 -2.5 0.04652531213642657
2.0 -2.0 0.04156513392548718
2.0 -1.5 0.03764349872550263
2.0 -1.0 0.03451799462307812
2.0 -0.5 0.03228977973899729
2.0 0.0 0.031058198832362025
2.0 0.5 0.030886281052488872
2.0 1.0 0.031849190294880286
2.0 1.5 0.034852356567882534
2.0 2.0 0.039415688650527886
2.0 2.5 0.04471364090156447
2.0 3.0 0.050684207885912554
2.0 3.5 0.05766358015816188
2.0 4.0 0.06600402557815238
2.0 4.5 0.07504050964807539
2.0 5.0 0.08479497582052278
2.0 5.5 0.09532483171541185
2.0 6.0 0.10659349593838281
2.5 -6.0 0.11544894835908838
2.5 -5.5 0.10323721915464373
2.5 -5.0 0.09200707191751643
2.5 -4.5 0.08170968860106498
2.5 -4.0 0.07302077447017416
2.5 -3.5 0.06523227458753825
2.5 -3.0 0.058210036629209504
2.5 -2.5 0.05275569499360017
2.5 -2.0 0.04834671543578368
2.5 -1.5 0.04465377470368196
2.5 -1.0 0.04173749890560954
2.5 -0.5 0.039669843305728016
2.5 0.0 0.03849284382653768
2.5 0.5 0.03824049132138307
2.5 1.0 0.038914262793768514
2.5 1.5 0.04097985118024086
2.5 2.0 0.04532735985363559
2.5 2.5 0.05043698944729149
2.5 3.0 0.05626061989202589
2.5 3.5 0.06277084970311202
2.5 4.0 0.06995754944389775
2.5 4.5 0.07891404078971344
2.5 5.0 0.08868129120508479
2.5 5.5 0.09921458123998887
2.5 6.0 0.1105381559694318
3.0 -6.0 0.11971588966020465
3.0 -5.5 0.10735592345810148
3.0 -5.0 0.09692624232102312
3.0 -4.5 0.08748997620239433
3.0 -4.0 0.07892394773064822
3.0 -3.5 0.07116265765227879
3.0 -3.0 0.06514108909731955
3.0 -2.5 0.060152071063758236
3.0 -2.0 0.055896322663934475
3.0 -1.5 0.05234476893863641
3.0 -1.0 0.049544636313092284
3.0 -0.5 0.047576436099791994
3.0 0.0 0.046423209361578885
3.0 0.5 0.04610274027540527
3.0 1.0 0.046618399477304395
3.0 1.5 0.04828281308781417
3.0 2.0 0.05186910470393694
3.0 2.5 0.056846749553816654
3.0 3.0 0.06259397058924107
3.0 3.5 0.06903481251880603
3.0 4.0 0.0761652236117206
3.0 4.5 0.08401756966669177
3.0 5.0 0.09317687503653527
3.0 5.5 0.10373439212118268
3.0 6.0 0.11510331101922414
3.5 -6.0 0.12586765073941983
3.5 -5.5 0.114251911400146
3.5 -5.0 0.10375586158811524
3.5 -4.5 0.09424839206475218
3.5 -4.0 0.0856460313264866
3.5 -3.5 0.07887422394334533
3.5 -3.0 0.07320314672523548
3.5 -2.5 0.06831459995547025
3.5 -2.0 0.06414247002434183
3.5 -1.5 0.060682637536998325
3.5 -1.0 0.058005613874087134
3.5 -0.5 0.056089335353022345
3.5 0.0 0.054938809628469094
3.5 0.5 0.0545603400236789
3.5 1.0 0.054957015043118645
3.5 1.5 0.05634221756352602
3.5 2.0 0.059048323112588286
3.5 2.5 0.06394206950136841
3.5 3.0 0.06964070915367568
3.5 3.5 0.07606230347898446
3.5 4.0 0.08320232624567234
3.5 4.5 0.09105946386467621
3.5 5.0 0.09966494963799083
3.5 5.5 0.10903428615787655
3.5 6.0 0.12031285997876685
4.0 -6.0 0.133792145149595
4.0 -5.5 0.12206499479627937
4.0 -5.0 0.11146700114689294
4.0 -4.5 0.10186454074602272
4.0 -4.0 0.09418377264877643
4.0 -3.5 0.08772176543516065
4.0 -3.0 0.0820764047743747
4.0 -2.5 0.0772077219594533
4.0 -2.0 0.07308024982411171
4.0 -1.5 0.06971025700759262
4.0 -1.0 0.06710202328253884
4.0 -0.5 0.06522712879652033
4.0 0.0 0.06407790117733198
4.0 0.5 0.06365266208275742
4.0 1.0 0.06395570593307875
4.0 1.5 0.06506960381759554
4.0 2.0 0.06747175914215608
4.0 2.5 0.07174258558181792
4.0 3.0 0.07743800200878338
4.0 3.5 0.08388735586865755
4.0 4.0 0.09108728791092392
4.0 4.5 0.09903205128087511
4.0 5.0 0.10770701935671877
4.0 5.5 0.1171179095976792
4.0 6.0 0.12725508680895073
4.5 -6.0 0.14251731518187546
4.5 -5.5 0.13079234359397504
4.5 -5.0 0.1200802600050456
4.5 -4.5 0.11131656818936357
4.5 -4.0 0.10392224116797841
4.5 -3.5 0.09738476235299591
4.5 -3.0 0.09170467242634588
4.5 -2.5 0.0868217625184239
4.5 -2.0 0.08272226723731291
4.5 -1.5 0.07942072306568614
4.5 -1.0 0.07686471203463068
4.5 -0.5 0.07502497903263568
4.5 0.0 0.07387957119589768
4.5 0.5 0.07341940505336114
4.5 1.0 0.07365045362088911
4.5 1.5 0.07459081032641238
4.5 2.0 0.07685985632305131
4.5 2.5 0.08031780123563345
4.5 3.0 0.08603239012387602
4.5 3.5 0.09256516535112001
4.5 4.0 0.09988876236789454
4.5 4.5 0.1080020405330592
4.5 5.0 0.11688310817824318
4.5 5.5 0.12645920459164933
4.5 6.0 0.1366322315647201
5.0 -6.0 0.1523328637892237
5.0 -5.5 0.14054781587690227
5.0 -5.0 0.13052983233669407
5.0 -4.5 0.12205039554787647
5.0 -4.0 0.11448046730582813
5.0 -3.5 0.10783138431853664
5.0 -3.0 0.10206619066117782
5.0 -2.5 0.09714667576214403
5.0 -2.0 0.0930850481909242
5.0 -1.5 0.08982914644494729
5.0 -1.0 0.08732702796352815
5.0 -0.5 0.08552973825002326
5.0 0.0 0.0843991220385463
5.0 0.5 0.0839176211800932
5.0 1.0 0.08409340126249273
5.0 1.5 0.08495785377584197
5.0 2.0 0.08703996997807417
5.0 2.5 0.09011891102447459
5.0 3.0 0.09547365519239712
5.0 3.5 0.10215016621575546
5.0 4.0 0.10966196205611348
5.0 4.5 0.1180304927623302
5.0 5.0 0.12726703636773867
5.0 5.5 0.1372865050327117
5.0 6.0 0.1478064919610664
5.5 -6.0 0.1636053552487786
5.5 -5.5 0.15212475561909347
5.5 -5.0 0.14235249659702867
5.5 -4.5 0.1335735300779554
5.5 -4.0 0.12579513686101415
5.5 -3.5 0.11900223921967643
5.5 -3.0 0.11313449935457229
5.5 -2.5 0.10819010219770432
5.5 -2.0 0.10414956170413354
5.5 -1.5 0.10094948589717258
5.5 -1.0 0.09851922230349994
5.5 -0.5 0.09678557585564584
5.5 0.0 0.09568989337692183
5.5 0.5 0.09520311161344956
5.5 1.0 0.09533527528740036
5.5 1.5 0.0961354364384711
5.5 2.0 0.09804994539264066
5.5 2.5 0.1011788782487751
5.5 3.0 0.10584208413312782
5.5 3.5 0.11270085054290253
5.5 4.0 0.12044861656558571
5.5 4.5 0.1291132018413605
5.5 5.0 0.13881885187727533
5.5 5.5 0.14960729922078633
5.5 6.0 0.1611476715258596
6.0 -6.0 0.17654735317050663
6.0 -5.5 0.16505669257793532
6.0 -5.0 0.15479188392548418
6.0 -4.5 0.14574728158590441
6.0 -4.0 0.1377961837178277
6.0 -3.5 0.13085674447548182
6.0 -3.0 0.12488846636273106
6.0 -2.5 0.11991653949418705
6.0 -2.0 0.11590576275041145
6.0 -1.5 0.11278784211279848
6.0 -1.0 0.11046405727610159
6.0 -0.5 0.10882988890631616
6.0 0.0 0.10779986009578621
6.0 0.5 0.10732790503326602
6.0 1.0 0.1074228254884247
6.0 1.5 0.10815528544853145
6.0 2.0 0.10991460554177046
6.0 2.5 0.11313217510665137
6.0 3.0 0.11728859913249637
6.0 3.5 0.12429781029700211
6.0 4.0 0.13231121829971745
6.0 4.5 0.14119256704814415
6.0 5.0 0.15126415998247217
6.0 5.5 0.16297208655716253
6.0 6.0 0.17623285734016597
"""))
saveplot(plt,"trussCenter")
```
\textoutput{truss_center}

To make the example more interesting (and to enlarge the range of
variation of the objective function, we decided to also apply an
horizontal force to the truss' nodes, changing the objective function
landscape:

```julia:truss_offset
#hideall
plt = plot_2d(bench_data("""
X Y MaxDisplacement
-6.0 -6.0 3.280240406125791
-6.0 -5.5 2.9691762278004514
-6.0 -5.0 2.666919633307022
-6.0 -4.5 2.3737414101669834
-6.0 -4.0 2.089920904560191
-6.0 -3.5 1.8157329515195715
-6.0 -3.0 1.551439981405726
-6.0 -2.5 1.2972981116428763
-6.0 -2.0 1.053587908197901
-6.0 -1.5 0.8206957506080172
-6.0 -1.0 0.6021532188349097
-6.0 -0.5 0.40709433920737514
-6.0 0.0 0.24351638372589246
-6.0 0.5 0.29342088163104774
-6.0 1.0 0.4760946921181181
-6.0 1.5 0.692734066733828
-6.0 2.0 0.917662941622969
-6.0 2.5 1.1455693797021294
-6.0 3.0 1.3747014791976653
-6.0 3.5 1.6043592553743338
-6.0 4.0 1.8342029958091857
-6.0 4.5 2.064004178098286
-6.0 5.0 2.2935668101309448
-6.0 5.5 2.522776507121736
-6.0 6.0 2.751619813824027
-5.5 -6.0 3.2766959603004064
-5.5 -5.5 2.9651539147590595
-5.5 -5.0 2.6625576654457186
-5.5 -4.5 2.369212751131049
-5.5 -4.0 2.085407415697921
-5.5 -3.5 1.81141830751969
-5.5 -3.0 1.5475130748266153
-5.5 -2.5 1.2939595803693587
-5.5 -2.0 1.05105324942714
-5.5 -1.5 0.8191899451399706
-5.5 -1.0 0.6025854081326557
-5.5 -0.5 0.408677937133637
-5.5 0.0 0.24506364203581743
-5.5 0.5 0.2959121192195627
-5.5 1.0 0.46976969954126135
-5.5 1.5 0.6822341567932866
-5.5 2.0 0.9030829400848848
-5.5 2.5 1.126964805223051
-5.5 3.0 1.3521166464121086
-5.5 3.5 1.577847789984069
-5.5 4.0 1.8038565662288872
-5.5 4.5 2.0300046297525887
-5.5 5.0 2.256259716916201
-5.5 5.5 2.482720336190461
-5.5 6.0 2.7095983348115507
-5.0 -6.0 3.2713799277010795
-5.0 -5.5 2.9599341443203984
-5.0 -5.0 2.6573809846739307
-5.0 -4.5 2.3641325460203757
-5.0 -4.0 2.0805302460784807
-5.0 -3.5 1.8068804418000786
-5.0 -3.0 1.5434718818945212
-5.0 -2.5 1.2905912889145477
-5.0 -2.0 1.0485510824871747
-5.0 -1.5 0.8177573462513495
-5.0 -1.0 0.6030504167096572
-5.0 -0.5 0.41057490129985075
-5.0 0.0 0.2469090498383643
-5.0 0.5 0.29846931237404656
-5.0 1.0 0.46316714962512673
-5.0 1.5 0.6713115585016198
-5.0 2.0 0.8879441816458585
-5.0 2.5 1.1076792007087568
-5.0 3.0 1.3287492017040317
-5.0 3.5 1.5504818788816064
-5.0 4.0 1.7726180614953275
-5.0 4.5 1.9950902283134304
-5.0 5.0 2.2179574004129483
-5.0 5.5 2.441399686893275
-5.0 6.0 2.680129797081917
-4.5 -6.0 3.2648529319023267
-4.5 -5.5 2.953785569279526
-4.5 -5.0 2.651534957054542
-4.5 -4.5 2.3585937153332046
-4.5 -4.0 2.075359809771146
-4.5 -3.5 1.8021785222449387
-4.5 -3.0 1.5393675311662263
-4.5 -2.5 1.2872373465897196
-4.5 -2.0 1.0461196970607685
-4.5 -1.5 0.8164322570164987
-4.5 -1.0 0.6035957898861563
-4.5 -0.5 0.41276180541644175
-4.5 0.0 0.24901583553277562
-4.5 0.5 0.3011394410571958
-4.5 1.0 0.4641359879502224
-4.5 1.5 0.6599955191844358
-4.5 2.0 0.8722807260801484
-4.5 2.5 1.0877555969319694
-4.5 3.0 1.3046517554553418
-4.5 3.5 1.5223175217628748
-4.5 4.0 1.7405315155832737
-4.5 4.5 1.9592764987753934
-4.5 5.0 2.1786614616809006
-4.5 5.5 2.424609492418035
-4.5 6.0 2.681920163846265
-4.0 -6.0 3.2576861249077487
-4.0 -5.5 2.9470544514069026
-4.0 -5.0 2.6452350363957735
-4.0 -4.5 2.352739986091921
-4.0 -4.0 2.0700006492414342
-4.0 -3.5 1.7973944792716696
-4.0 -3.0 1.5352674151942542
-4.0 -2.5 1.2839544044404976
-4.0 -2.0 1.0438076385950872
-4.0 -1.5 0.8152571502345679
-4.0 -1.0 0.6042722332152773
-4.0 -0.5 0.41523715642882336
-4.0 0.0 0.25137194357368403
-4.0 0.5 0.30396498225831514
-4.0 1.0 0.46640173136811447
-4.0 1.5 0.6483153634121375
-4.0 2.0 0.856122512259547
-4.0 2.5 1.067226156120669
-4.0 3.0 1.2798569882168682
-4.0 3.5 1.4933822411689075
-4.0 4.0 1.7076114001321356
-4.0 4.5 1.931310688135417
-4.0 5.0 2.175237649179227
-4.0 5.5 2.4262766217546905
-4.0 6.0 2.684153141797731
-3.5 -6.0 3.2502237464947785
-3.5 -5.5 2.940021242808576
-3.5 -5.0 2.6386903683561447
-3.5 -4.5 2.346726465534524
-3.5 -4.0 2.0645711209999593
-3.5 -3.5 1.7926220753413904
-3.5 -3.0 1.5312481786766767
-3.5 -2.5 1.2808068326464817
-3.5 -2.0 1.0416699454429923
-3.5 -1.5 0.8142799071390044
-3.5 -1.0 0.6051327169977736
-3.5 -0.5 0.41801443219050854
-3.5 0.0 0.253982339782518
-3.5 0.5 0.3069839631317403
-3.5 1.0 0.4689403707429824
-3.5 1.5 0.6421438754117815
-3.5 2.0 0.8394927166977816
-3.5 2.5 1.0461120409107096
-3.5 3.0 1.2543824031832376
-3.5 3.5 1.4670450686174437
-3.5 4.0 1.6960073956179063
-3.5 4.5 1.9327640344526555
-3.5 5.0 2.17700728219752
-3.5 5.5 2.4284469969654974
-3.5 6.0 2.686800128017926
-3.0 -6.0 3.24262257186628
-3.0 -5.5 2.932866879078714
-3.0 -5.0 2.6320659942846945
-3.0 -4.5 2.3406921362945883
-3.0 -4.0 2.0591857640774913
-3.0 -3.5 1.787956018234305
-3.0 -3.0 1.5273891608762176
-3.0 -2.5 1.277862038912268
-3.0 -2.0 1.039764760673138
-3.0 -1.5 0.813551349195087
-3.0 -1.0 0.60623135757977
-3.0 -0.5 0.4211169724782567
-3.0 0.0 0.2568639269271454
-3.0 0.5 0.3102309684345628
-3.0 1.0 0.47178682915722736
-3.0 1.5 0.6445822145697464
-3.0 2.0 0.8322922120249036
-3.0 2.5 1.0356017556377999
-3.0 3.0 1.2478942917576556
-3.0 3.5 1.4687651901448588
-3.0 4.0 1.6978454710764879
-3.0 4.5 1.9347954126098463
-3.0 5.0 2.1792986205081464
-3.0 5.5 2.431054575443392
-3.0 6.0 2.689770901012013
-2.5 -6.0 3.2349481616710243
-2.5 -5.5 2.925699431928863
-2.5 -5.0 2.6254810782092997
-2.5 -4.5 2.334750577168581
-2.5 -4.0 2.053946257606835
-2.5 -3.5 1.7834850799704627
-2.5 -3.0 1.5237673871537238
-2.5 -2.5 1.2751870794361961
-2.5 -2.0 1.0381509021851685
-2.5 -1.5 0.8131234756288034
-2.5 -1.0 0.6076225492691177
-2.5 -0.5 0.42457444524572363
-2.5 0.0 0.2600422905026241
-2.5 0.5 0.3137385451534751
-2.5 1.0 0.47497202595634014
-2.5 1.5 0.6474379718528033
-2.5 2.0 0.8346401256069325
-2.5 2.5 1.037870396271867
-2.5 3.0 1.250151793323654
-2.5 3.5 1.471075309602326
-2.5 4.0 1.7002653401149226
-2.5 4.5 1.9373736421250154
-2.5 5.0 2.1820730591091273
-2.5 5.5 2.4340498004360818
-2.5 6.0 2.6929949761416108
-2.0 -6.0 3.2272390633677945
-2.0 -5.5 2.9185901258538918
-2.0 -5.0 2.619023532834992
-2.0 -4.5 2.3289935216912037
-2.0 -4.0 2.0489405989552685
-2.0 -3.5 1.7792901320148162
-2.0 -3.0 1.5204557166604222
-2.0 -2.5 1.2728471571654456
-2.0 -2.0 1.0368867258532004
-2.0 -1.5 0.8130486135186232
-2.0 -1.0 0.6093605641854403
-2.0 -0.5 0.42842061221786426
-2.0 0.0 0.263549695800665
-2.0 0.5 0.3175386320576312
-2.0 1.0 0.47852527505483633
-2.0 1.5 0.6507367074750093
-2.0 2.0 0.8374829602295727
-2.0 2.5 1.040682749869582
-2.0 3.0 1.25298352174251
-2.0 3.5 1.473969717008298
-2.0 4.0 1.7032570512514698
-2.0 4.5 1.940486841988562
-2.0 5.0 2.185319152066068
-2.0 5.5 2.4374239086929985
-2.0 6.0 2.696470010129084
-1.5 -6.0 3.2195378747579424
-1.5 -5.5 2.911599645211625
-1.5 -5.0 2.6127666589930754
-1.5 -4.5 2.3234996745481746
-1.5 -4.0 2.0442472093437436
-1.5 -3.5 1.7754458688187489
-1.5 -3.0 1.5175235129458673
-1.5 -2.5 1.2709058675481488
-1.5 -2.0 1.0360302001450694
-1.5 -1.5 0.8133794144543646
-1.5 -1.0 0.6122476464520931
-1.5 -0.5 0.43269210747446146
-1.5 0.0 0.26742391129321424
-1.5 0.5 0.321663810033142
-1.5 1.0 0.4824762679877439
-1.5 1.5 0.654504738338219
-1.5 2.0 0.8408364915544877
-1.5 2.5 1.0440499624041732
-1.5 3.0 1.256396760044088
-1.5 3.5 1.4774534256115923
-1.5 4.0 1.706825870164317
-1.5 4.5 1.9441440770182683
-1.5 5.0 2.1890547252043238
-1.5 5.5 2.4412112641683144
-1.5 6.0 2.7002613215899376
-1.0 -6.0 3.2119037684739036
-1.0 -5.5 2.9047934748617448
-1.0 -5.0 2.6067819611872514
-1.0 -4.5 2.318343650497515
-1.0 -4.0 2.0399406069450734
-1.0 -3.5 1.772024277951578
-1.0 -3.0 1.515038778155525
-1.0 -2.5 1.2694265482898268
-1.0 -2.0 1.0356397780916071
-1.0 -1.5 0.8141694140814042
-1.0 -1.0 0.617341253829252
-1.0 -0.5 0.4374279380632287
-1.0 0.0 0.2717075479478582
-1.0 0.5 0.3261482869067049
-1.0 1.0 0.48685654136489953
-1.0 1.5 0.6587709859501543
-1.0 2.0 0.8447204452122187
-1.0 2.5 1.0479890043010724
-1.0 3.0 1.260406950861574
-1.0 3.5 1.4815423169224686
-1.0 4.0 1.7109909812089437
-1.0 4.5 1.9483718606346654
-1.0 5.0 2.19331941975585
-1.0 5.5 2.4454735488748995
-1.0 6.0 2.704467187002476
-0.5 -6.0 3.2127615773010705
-0.5 -5.5 2.9045237361738976
-0.5 -5.0 2.6055781755947622
-0.5 -4.5 2.3164482288394366
-0.5 -4.0 2.037644783085809
-0.5 -3.5 1.769667401200569
-0.5 -3.0 1.5130705545234142
-0.5 -2.5 1.268473916304102
-0.5 -2.0 1.035775501712454
-0.5 -1.5 0.8171430090126126
-0.5 -1.0 0.6230062380814733
-0.5 -0.5 0.4426694225067538
-0.5 0.0 0.27646675889641126
-0.5 0.5 0.3310285972969471
-0.5 1.0 0.4917004241925889
-0.5 1.5 0.6635680558683072
-0.5 2.0 0.8491593607499063
-0.5 2.5 1.052523179090125
-0.5 3.0 1.2650374759454175
-0.5 3.5 1.4862617134483005
-0.5 4.0 1.7157821730083078
-0.5 4.5 1.9532078004624682
-0.5 5.0 2.1981631235639467
-0.5 5.5 2.450278858286889
-0.5 6.0 2.7091812786817315
0.0 -6.0 3.2214698398087473
0.0 -5.5 2.9133784171450903
0.0 -5.0 2.614447536282122
0.0 -4.5 2.32522254838408
0.0 -4.0 2.0462349753163815
0.0 -3.5 1.7780043505470506
0.0 -3.0 1.5210390604691488
0.0 -2.5 1.2758354074408085
0.0 -2.0 1.042874257726227
0.0 -1.5 0.8239115760255369
0.0 -1.0 0.6292811354037965
0.0 -0.5 0.44846030228748385
0.0 0.0 0.2817606545715172
0.0 0.5 0.33634402773642685
0.0 1.0 0.4970455004932857
0.0 1.5 0.6689326391563248
0.0 2.0 0.8541826560331034
0.0 2.5 1.057681748911487
0.0 3.0 1.2703185580840894
0.0 3.5 1.4916441840282784
0.0 4.0 1.721236020198237
0.0 4.5 1.95869435928487
0.0 5.0 2.20363613197402
0.0 5.5 2.4556868272478005
0.0 6.0 2.7144721793312607
0.5 -6.0 3.2306062271948655
0.5 -5.5 2.922758174513151
0.5 -5.0 2.623918777141002
0.5 -4.5 2.334656415068708
0.5 -4.0 2.0555246025863525
0.5 -3.5 1.7870644335740113
0.5 -3.0 1.5298053158149758
0.5 -2.5 1.2842636081127314
0.5 -2.0 1.0509387998556405
0.5 -1.5 0.8313784886236734
0.5 -1.0 0.6362060772297977
0.5 -0.5 0.4548467902405652
0.5 0.0 0.2876115469754075
0.5 0.5 0.34213678619270566
0.5 1.0 0.5029326338128111
0.5 1.5 0.6749053247068734
0.5 2.0 0.8598240173263454
0.5 2.5 1.063498896466607
0.5 3.0 1.2762856621705634
0.5 3.5 1.4977272364420922
0.5 4.0 1.727392705759442
0.5 4.5 1.96487466498092
0.5 5.0 2.209783999848195
0.5 5.5 2.4617433572897403
0.5 6.0 2.7203810777015414
1.0 -6.0 3.2402282979192987
1.0 -5.5 2.9327072584895753
1.0 -5.0 2.634029413417667
1.0 -4.5 2.3447842101984993
1.0 -4.0 2.065546799376445
1.0 -3.5 1.796880589671882
1.0 -3.0 1.5393371311373556
1.0 -2.5 1.2934538079640432
1.0 -2.0 1.0597494291969043
1.0 -1.5 0.8395802872581747
1.0 -1.0 0.6438227251648225
1.0 -0.5 0.46187735552889536
1.0 0.0 0.2940774350912065
1.0 0.5 0.34851083406813915
1.0 1.0 0.5094056011785713
1.0 1.5 0.6815298977490507
1.0 2.0 0.8661202077342125
1.0 2.5 1.070012154740237
1.0 3.0 1.2829775827587682
1.0 3.5 1.5045511676653764
1.0 4.0 1.7342938494272988
1.0 4.5 1.97179072741534
1.0 5.0 2.2166469457197153
1.0 5.5 2.4684828043768086
1.0 6.0 2.726929819516542
1.5 -6.0 3.2503831430699943
1.5 -5.5 2.943264861555791
1.5 -5.0 2.6448156957807587
1.5 -4.5 2.355640905971408
1.5 -4.0 2.0763358631220035
1.5 -3.5 1.8074868915822409
1.5 -3.0 1.5496689021674563
1.5 -2.5 1.3034413964248308
1.5 -2.0 1.0693433259353637
1.5 -1.5 0.8485538755961168
1.5 -1.0 0.6521736390922366
1.5 -0.5 0.4696020841490904
1.5 0.0 0.30121858198192825
1.5 0.5 0.3555686595385146
1.5 1.0 0.5165103864586471
1.5 1.5 0.6888521898328044
1.5 2.0 0.8779995393859337
1.5 2.5 1.0827410379499434
1.5 3.0 1.2960693706497557
1.5 3.5 1.5174830988459258
1.5 4.0 1.7465438658566923
1.5 4.5 1.9828537623810234
1.5 5.0 2.2260434516235197
1.5 5.5 2.4759338489350022
1.5 6.0 2.734132019065219
2.0 -6.0 3.261092717785366
2.0 -5.5 2.9544590069835563
2.0 -5.0 2.6563097139452223
2.0 -4.5 2.3672599768286404
2.0 -4.0 2.0879251785835407
2.0 -3.5 1.8189163778940391
2.0 -3.0 1.5608338160500799
2.0 -2.5 1.3142604617336788
2.0 -2.0 1.0797567131300179
2.0 -1.5 0.8583349717497194
2.0 -1.0 0.6613009671547216
2.0 -0.5 0.4780714937419477
2.0 0.0 0.3090961624621106
2.0 0.5 0.363264377287931
2.0 1.0 0.5242941894581815
2.0 1.5 0.6969185469386872
2.0 2.0 0.890819292635058
2.0 2.5 1.0971030291137776
2.0 3.0 1.31184674443812
2.0 3.5 1.5345301534380618
2.0 4.0 1.7647035644846552
2.0 4.5 2.001960651960973
2.0 5.0 2.2459250960564114
2.0 5.5 2.49624459035316
2.0 6.0 2.752591601446756
2.5 -6.0 3.272351086555648
2.5 -5.5 2.966308242511369
2.5 -5.0 2.668540026938044
2.5 -4.5 2.379672043580192
2.5 -4.0 2.1003444654154473
2.5 -3.5 1.831197671700285
2.5 -3.0 1.5728603913351278
2.5 -2.5 1.3259410827783278
2.5 -2.0 1.0910220269454554
2.5 -1.5 0.8689557016692327
2.5 -1.0 0.6712444085968454
2.5 -0.5 0.4873347193765945
2.5 0.0 0.31811080772838624
2.5 0.5 0.3716501357737926
2.5 1.0 0.5328042125776948
2.5 1.5 0.7057739921383198
2.5 2.0 0.9042801204495905
2.5 2.5 1.1121141151013938
2.5 3.0 1.3282778777339543
2.5 3.5 1.552229902344862
2.5 4.0 1.7835073124765783
2.5 4.5 2.0216929983969956
2.5 5.0 2.2663996655990486
2.5 5.5 2.517263443044007
2.5 6.0 2.773947667835753
3.0 -6.0 3.2841481729201476
3.0 -5.5 2.97883453678867
3.0 -5.0 2.681535278057233
3.0 -4.5 2.3929029513578017
3.0 -4.0 2.1136155093563387
3.0 -3.5 1.844350045497559
3.0 -3.0 1.5857676881588545
3.0 -2.5 1.3385039689259535
3.0 -2.0 1.1031641388281612
3.0 -1.5 0.8804413995057173
3.0 -1.0 0.682038455453149
3.0 -0.5 0.49743701972885757
3.0 0.0 0.3285170929966596
3.0 0.5 0.38077894517853256
3.0 1.0 0.5420862758202636
3.0 1.5 0.7179550560388934
3.0 2.0 0.9183923465897285
3.0 2.5 1.127775063365131
3.0 3.0 1.3453557466074757
3.0 3.5 1.570569080957711
3.0 4.0 1.8029376553102738
3.0 4.5 2.042032194509772
3.0 5.0 2.2874513411602626
3.0 5.5 2.538812390187521
3.0 6.0 2.7957563072433746
3.5 -6.0 3.2965188278565147
3.5 -5.5 2.992079761762674
3.5 -5.0 2.695324229914686
3.5 -4.5 2.4069679533781905
3.5 -4.0 2.127744755285934
3.5 -3.5 1.8583765766418703
3.5 -3.0 1.599559374586305
3.5 -2.5 1.351956367474888
3.5 -2.0 1.1161959049129675
3.5 -1.5 0.8928765258590683
3.5 -1.0 0.6937089656242361
3.5 -0.5 0.5084165755358484
3.5 0.0 0.3397513103066822
3.5 0.5 0.39070385641389516
3.5 1.0 0.5521832618133999
3.5 1.5 0.7311091163022223
3.5 2.0 0.9331610858242473
3.5 2.5 1.1440802436247803
3.5 3.0 1.3630652816027249
3.5 3.5 1.5895245646968015
3.5 4.0 1.822965428935801
3.5 4.5 2.062947153469268
3.5 5.0 2.3090548100111716
3.5 5.5 2.5608825239859265
3.5 6.0 2.8180327108928003
4.0 -6.0 3.309580032146962
4.0 -5.5 3.0061016514184016
4.0 -5.0 2.7099198887708758
4.0 -4.5 2.4218557916230767
4.0 -4.0 2.1427118961405185
4.0 -3.5 1.8732559661636403
4.0 -3.0 1.614217505610666
4.0 -2.5 1.3662863527714844
4.0 -2.0 1.130113521103199
4.0 -1.5 0.9063207717458814
4.0 -1.0 0.7062691488456891
4.0 -0.5 0.5203005551907874
4.0 0.0 0.3583674454615448
4.0 0.5 0.4014768851730555
4.0 1.0 0.5631332839174654
4.0 1.5 0.7449504344363203
4.0 2.0 0.9485843205151244
4.0 2.5 1.1610148268111515
4.0 3.0 1.3813805340761198
4.0 3.5 1.609059936963071
4.0 4.0 1.8435440131609675
4.0 4.5 2.084383614596613
4.0 5.0 2.331157877897805
4.0 5.5 2.5834447662393543
4.0 6.0 2.8407997398142317
4.5 -6.0 3.3234855763505498
4.5 -5.5 3.0209169270652065
4.5 -5.0 2.7252780329481836
4.5 -4.5 2.4375052704952624
4.5 -4.0 2.1584572760883582
4.5 -3.5 1.8889357614561482
4.5 -3.0 1.629697940834148
4.5 -2.5 1.3814588340659293
4.5 -2.0 1.1448923485330305
4.5 -1.5 0.9206441000012615
4.5 -1.0 0.7197150440165642
4.5 -0.5 0.5331003934171796
4.5 0.0 0.3784269760083542
4.5 0.5 0.41314741754804835
4.5 1.0 0.5749673098898026
4.5 1.5 0.7594834361230043
4.5 2.0 0.9646489113296812
4.5 2.5 1.1785512806762808
4.5 3.0 1.4002620558939338
4.5 3.5 1.6291237430939771
4.5 4.0 1.8646061211958282
4.5 4.5 2.1062538692256494
4.5 5.0 2.353656721038332
4.5 5.5 2.6064077432870114
4.5 6.0 2.8640441132586836
5.0 -6.0 3.3382269368835407
5.0 -5.5 3.0363814817743044
5.0 -5.0 2.7412410205403317
5.0 -4.5 2.4537844418299284
5.0 -4.0 2.174877095055518
5.0 -3.5 1.9053321883970287
5.0 -3.0 1.6459300757010762
5.0 -2.5 1.3974138857292546
5.0 -2.0 1.1604838939337716
5.0 -1.5 0.9358112830253906
5.0 -1.0 0.7340205318100115
5.0 -0.5 0.5468061624745916
5.0 0.0 0.3999696181039931
5.0 0.5 0.4271471278537288
5.0 1.0 0.5877058423054323
5.0 1.5 0.774699571920353
5.0 2.0 0.9813250897057986
5.0 2.5 1.1966437030979022
5.0 3.0 1.4196534295006018
5.0 3.5 1.6496503181257114
5.0 4.0 1.8860680466192212
5.0 4.5 2.1284368168432626
5.0 5.0 2.3763762548135903
5.0 5.5 2.6295600449332257
5.0 6.0 2.8876180331442396
5.5 -6.0 3.3533047898274133
5.5 -5.5 3.052075110359471
5.5 -5.0 2.757515845445716
5.5 -4.5 2.4705011475213627
5.5 -4.0 2.1918393451129923
5.5 -3.5 1.9223417949039439
5.5 -3.0 1.6628226410754217
5.5 -2.5 1.4140681382646871
5.5 -2.0 1.176814392518188
5.5 -1.5 0.9517609560640681
5.5 -1.0 0.7491319367507839
5.5 -0.5 0.5613798310595735
5.5 0.0 0.4230482407345408
5.5 0.5 0.44622527093297965
5.5 1.0 0.6013543730831169
5.5 1.5 0.7905711921793726
5.5 2.0 0.9985576355362733
5.5 2.5 1.2158411534332003
5.5 3.0 1.4404491523860956
5.5 3.5 1.670560782418027
5.5 4.0 1.9078452723097137
5.5 4.5 2.150804082170979
5.5 5.0 2.3990877500134253
5.5 5.5 2.6525482266531792
5.5 6.0 2.9111327591458287
6.0 -6.0 3.367626875335638
6.0 -5.5 3.067364553442861
6.0 -5.0 2.773757571188218
6.0 -4.5 2.4906819312079884
6.0 -4.0 2.2173340218961934
6.0 -3.5 1.9542118174120708
6.0 -3.0 1.6954749658661854
6.0 -2.5 1.4422285426248598
6.0 -2.0 1.199447924509244
6.0 -1.5 0.9697249833538801
6.0 -1.0 0.7649625702061827
6.0 -0.5 0.5767472057998081
6.0 0.0 0.4476961366019809
6.0 0.5 0.46664752421194755
6.0 1.0 0.621557224806606
6.0 1.5 0.808113213838698
6.0 2.0 1.0200048629972338
6.0 2.5 1.2408469991377995
6.0 3.0 1.4678569430630655
6.0 3.5 1.6995949261961305
6.0 4.0 1.935137596280732
6.0 4.5 2.1737941813580006
6.0 5.0 2.4216052667017363
6.0 5.5 2.6750064534273856
6.0 6.0 2.9341403073927084
"""))
saveplot(plt,"trussOffset")
```
\textoutput{truss_offset}

Given that we were interested in evaluating the scalability of the
optimization as the number of CPUs increases, we selected optimization
algorithms that we knew were already parallelized. A suitable
candidade is BlackBoxOptim, a parallelized optimization package
supporting both multi- and single-objective optimization problems
using meta-heuristics algorithms.

BlackBoxOptim supports both multithreaded and parallel execution,
allowing the optimization algorithm to evaluate many candidate
solutions at the same time. Given that Khepri is not yet thread-safe,
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

Given that the master process is responsible for running the
optimization algorithm and the workers are only responsible for
evaluating candidate solutions, we fixed the seed of the master's
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

opt_xnes = bench_data("""
Processes StopTime Steps_per_second Evals_per_second OptTime RealTime UserTime SysTime
2 26833.04 0.01 0.04 26838.224 447m49.938s 0m31.358s 0m0.457s
4 13317.67 0.02 0.08 13323.388 222m35.464s 0m31.426s 0m0.422s
8 6781.98 0.04 0.15 6788.712 113m44.461s 0m31.954s 0m0.561s
16 6765.22 0.04 0.15 6773.607 113m28.715s 447m54.407s 0m38.400s
32 6714.40 0.04 0.15 6727.071 112m43.982s 0m31.895s 0m0.517s
48 6640.26 0.04 0.15 6657.509 111m38.424s 0m31.228s 0m0.886s
64 6740.63 0.04 0.15 6761.836 113m23.802s 229m11.795s 1m0.496s
80 6756.99 0.04 0.15 6782.62 113m49.160s 0m32.236s 0m1.031s
96 6635.27 0.04 0.15 6665.09 111m54.052s 0m32.493s 0m0.866s
2 26755.25 0.01 0.04 26760.192 446m32.486s 0m31.680s 0m0.419s
4 13274.71 0.02 0.08 13280.038 221m53.130s 154m29.379s 0m14.096s
8 6844.90 0.04 0.15 6851.566 114m45.113s 334m22.435s 0m26.500s
16 6722.62 0.04 0.15 6731.171 112m49.012s 1m38.713s 0m5.266s
32 6705.68 0.04 0.15 6718.478 112m36.428s 0m32.141s 0m0.578s
48 6710.32 0.04 0.15 6727.487 112m48.958s 0m31.598s 0m0.839s
64 6795.03 0.04 0.15 6816.605 114m19.968s 6m37.853s 0m36.368s
80 6726.75 0.04 0.15 6753.048 113m19.512s 0m33.015s 0m0.756s
96 6634.48 0.04 0.15 6664.732 111m52.357s 0m32.479s 0m0.792s
2 26755.23 0.01 0.04 26760.215 446m31.747s 0m31.197s 0m0.409s
4 13256.53 0.02 0.08 13261.939 221m34.096s 0m31.289s 0m0.385s
8 6706.34 0.04 0.15 6712.648 112m25.434s 442m33.363s 0m41.845s
16 6642.89 0.04 0.15 6651.758 111m29.050s 0m32.435s 0m0.757s
32 6739.13 0.04 0.15 6751.755 113m9.908s 0m32.003s 0m0.652s
48 6716.19 0.04 0.15 6733.753 112m56.609s 0m32.974s 0m0.875s
64 6830.02 0.04 0.15 6852.656 114m56.796s 5m4.119s 0m31.796s
80 6731.74 0.04 0.15 6758.042 113m24.351s 0m32.819s 0m0.899s
96 6701.73 0.04 0.15 6732.446 113m0.614s 0m32.101s 0m0.777s
""")

time2seconds(s) =
  let m = match(r"(.+)m(.+)s", s)
    parse(Float64, m.captures[1])*60+parse(Float64, m.captures[2])
  end

plot_opt(raw_data) =
  let data = sort(combine(groupby(raw_data, :Processes),
                          :RealTime => it->mean(map(time2seconds, it))),
                  :Processes)
    bar(string.(data[:,1]),
         data[:,2],
         legend=:none,
         markers=:auto,
         #ylimits=(0,180),
         xlabel="Processes",
         #color=:green,
         #xscale=:log10,
         ylabel="Time (s)")
  end

plt = plot_opt(opt_xnes)
saveplot(plt,"xnes1000")
```
\textoutput{plotopt1}

Results show that the optimization clearly benefits from the use of
multiple workers evaluating candidate solutions in parallel but only
up to eight processes. After that, there is no benefit. We then
repeated the same experiment but now using a five times larger number
of objective function evaluations, i.e., 5000. The results were the
following:

```julia:plotopt2
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals = 5000, Workers = workers())

plt = plot_opt(bench_data("""
Processes StopTime Steps_per_second Evals_per_second OptTime RealTime UserTime SysTime
2 133190.0 0 0 0 2219m48s 0m0s 0m0s
4 66448.18 0.02 0.08 66454.99 1108m14.800s 0m35.658s 0m0.764s
8 33777.36 0.04 0.15 33783.924 563m37.545s 0m58.303s 0m1.454s
16 33226.69 0.04 0.15 33235.892 554m33.191s 0m33.010s 0m0.871s
32 33785.62 0.04 0.15 33798.45 563m56.404s 0m32.420s 0m0.717s
48 33542.42 0.04 0.15 33560.061 560m2.998s 0m33.508s 0m1.067s
64 33868.17 0.04 0.15 33890.237 565m34.886s 0m33.657s 0m1.247s
80 33400.07 0.04 0.15 33425.944 557m51.121s 0m32.613s 0m1.003s
96 33138.92 0.04 0.15 33169.674 553m37.801s 0m33.379s 0m1.041s
"""))
saveplot(plt,"xnes1000")
```
\textoutput{plotopt2}

As is obvious, increasing the number of objective function evaluations
only scales the bar graph. The overall speedups are exactly the same.

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

plt = plot_opt(bench_data("""
Processes StopTime Steps_per_second Evals_per_second OptTime RealTime UserTime SysTime
2 26741.22 0.01 0.04 26746.945 446m20.485s 0m33.765s 0m5.557s
4 13101.47 0.02 0.08 13107.262 219m0.522s 0m33.282s 0m5.648s
8 6783.39 0.04 0.15 6789.837 113m44.586s 1m2.184s 0m7.351s
16 6772.83 0.04 0.15 6781.835 113m38.535s 0m34.213s 0m6.184s
32 6742.70 0.04 0.15 6755.581 113m13.762s 0m33.719s 0m6.371s
48 6650.14 0.04 0.15 6667.443 111m47.097s 0m32.935s 0m6.323s
64 6637.45 0.04 0.15 6658.865 111m42.543s 223m20.020s 0m44.278s
"""))
saveplot(plt,"xnes1000pop100")
```
\textoutput{plotopt3}

Once again, the speedups seem to be limited to eight processes and
given that there were no expected gains after that, we stopped the
process after collecting data for up to 64 processes.

We then experimented increasing both the population size and the
number of function evaluations to, respectively, 500 and 5000.

```julia:plotopt6
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange=[(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals=5000, PopulationSize=500, Workers=workers())

plt = plot_opt(bench_data("""
Processes StopTime Steps_per_second Evals_per_second OptTime RealTime UserTime SysTime
2 131346.0 0 0 0 2189m6s 0m0s 0m0s
4 68098.63 0.02 0.07 68104.313 1135m37.980s 0m57.256s 1m29.594s
8 34128.00 0.04 0.15 34134.464 569m28.687s 0m57.995s 1m34.001s
16 34066.71 0.04 0.15 34075.057 568m31.238s 2m40.776s 1m36.928s
32 33536.74 0.04 0.15 33549.778 559m48.894s 1m0.333s 1m34.755s
48 33526.71 0.04 0.15 33544.316 559m45.777s 1m1.544s 1m34.427s
64 33554.69 0.04 0.15 33576.358 560m20.215s 1m1.307s 1m34.675s
80 33487.30 0.04 0.15 33513.25 559m19.562s 1m1.823s 1m34.290s
96 33175.78 0.04 0.15 33206.042 554m15.315s 1m1.331s 1m34.962s
"""))
saveplot(plt,"xnes500_5000")
```
\textoutput{plotopt6}

As visible, there is not significant differences. The optimization
seems to not scale beyond eight processes.

The next experiment was to increase the dimensionality of the design
space, by increasing from two to three independent variables. Now,
besides the $X$ and $Y$ location of the central node of the truss, we
also optimized it $Z$ location, allowing it to vary between 1 and
20. We also decided to experiment running the process using just one
thread, to better understand the advantages of parallelization. Fixing
the maximum number of evaluations at 2000, we obtain the following
results:

```julia:plotopt5
#hideall
#opt = bbsetup(displacement_obj3; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0), (1.0, 20.0)], MaxFuncEvals = 2000,

plt = plot_opt(bench_data("""
Processes StopTime Steps_per_second Evals_per_second OptTime RealTime UserTime SysTime
1 53816.55 0.01 0.04 53821.47 897m37.442s 895m8.262s 2m12.626s
2 30723.26 0.01 0.07 30728.769 512m44.172s 0m36.939s 0m14.485s
4 15415.51 0.02 0.13 15421.022 257m34.989s 896m1.726s 2m28.686s
8 8014.55 0.04 0.25 8021.053 134m21.591s 257m43.612s 1m3.304s
16 7838.72 0.04 0.26 7847.56 131m24.990s 0m47.160s 0m55.770s
"""))
saveplot(plt,"xnes3V")
```
\textoutput{plotopt5}

Given the time it takes to produce these results, we stopped the
experiment as soon as we were sure that there were no more
improvements. Note the considerable gains obtained moving from one
process to two to four and to height, with an almost constant speedup
of 2, but it clearly stops after we reach height processes.

Finally, we decided to experiment with a different optimization
algorithm, this time Separable Natural Evolution Strategy (sNES). We
used the initial set of variables (just the $X$ and $Y$ coordinates of
the central truss node), an initial population size of 500 and a
maximum number of objective function evaluations of 5000.

```julia:plotopt7
#hideall
#opt = bbsetup(displacement_obj; Method=:separable_nes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], PopulationSize=500, MaxFuncEvals = 5000,

plt = plot_opt(bench_data("""
Processes StopTime Steps_per_second Evals_per_second OptTime RealTime UserTime SysTime
2 131653.0 0 0 0 2194m12s 0m0s 0m0s
4 44180.32 0.02 0.11 44183.87 736m58.052s 0m30.462s 0m0.853s
8 22385.47 0.04 0.22 22389.606 373m44.417s 367m0.174s 0m59.470s
16 22571.66 0.04 0.22 22578.332 376m53.987s 0m30.383s 0m1.400s
32 22396.59 0.04 0.22 22407.144 374m5.288s 0m30.275s 0m1.252s
48 22494.03 0.04 0.22 22509.223 375m50.909s 0m30.698s 0m1.504s
64 22261.78 0.04 0.22 22281.23 372m3.320s 0m30.651s 0m1.489s
80 22616.02 0.04 0.22 22639.678 378m6.548s 12m58.036s 1m54.225s
96 22169.91 0.04 0.23 22197.799 370m44.658s 0m30.396s 0m1.568s
"""))
saveplot(plt,"snes5000")
```
\textoutput{plotopt7}

In this case, there is an important speedup (3X) in the transition
from 2 to 4 processes, that is explainable, possibly, by the fact that
the transition is, in fact, from 1 worker to 3 workers, meaning that
we can triple the number of objective function evaluations being done
on each step. It is less clear why the previous experiments did not
show the same initial speedup.  In the end, we were not impressed with
the speedups that we obtained from all of these experiments. We can
conclude that for the specific algorithms and optimization problems
that we studied, there is no justification to use more than 8
processes.  The good news is that this is the typical number of
computing threads that are currently available in most off-the-shelf
hardware. The bad news is that it does not make the case for the use
of supercomputers which have much larger numbers of threads.

There is, however, a silver lining. In all of these experiments, we
used just one computing node for each specific algorithm, but we
managed to use different computing nodes for different
experiments. This means that, in practice, the time needed to do the
entire set of experiments is not the sum of the times needed for each
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


## Rendering

Rendering is a extremely time-consuming task. At the same time, it is
one that can have significant speedups when there are sufficient
resources available.  In this section, we experimented different
rendering tasks and measured the effective gains.

### Rendering an Image

In this experiment, we tested the scalability of the popular raytracer
POVRay. This is one of Khepri's rendering backends and, therefore, we
used Khepri to generate the following 3D structure containing
different materials (metal, glass, etc):

\fig{/DomeTrussRibs}

Usually, Khepri handles POVRay without any help from the user but, in
this experiment, we did not want to include the time it takes for
Khepri to generate the information to POVRay and then to start it.
Therefore, we took the input files generated by Khepri for POVRay and
we tested them directly.

We knew that, by default, POVRay uses all available CPUs to divide
most of the raytracing process between them. However, we found it
difficult to make it use fewer CPUs, even when we specified so on the
batch script. We were able to solve the problem by using the
`Work_Threads` option of POVRay, which specifies the number of threads
that it should use. The corresponding Slurm script looked like this:

```bash
#!/bin/bash

#SBATCH --job-name=TestPOVRay
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -p <...>
#SBATCH -q <...>

time povray Work_Threads=$SLURM_CPUS_ON_NODE DomeTrussRibs.ini
```

In this experiment, to avoid fluctuations in the load of the computing
node, we decided to repeat the test three times and present the
average. First, we attempted to render a 1024 by 768 image. The real
time spent for different numbers of threads is the following:

```julia:plot10
#hideall
povray_1024x768 = bench_data("""
RadiosityTime RadiosityThreads RadiosityTotal TraceTime TraceThreads TraceTotal RealTime UserTime SysTime
0.818 3 2.368 31.231 64 1941.229 0m36.337s 32m25.434s 0m0.635s
0.819 3 2.361 25.443 96 2107.544 0m30.455s 35m11.783s 0m0.637s
0.819 3 2.366 26.189 80 2017.256 0m31.304s 33m41.534s 0m0.597s
0.821 3 2.363 39.692 48 1840.427 0m44.731s 30m44.612s 0m0.600s
0.819 3 2.366 56.095 32 1774.080 1m1.169s 29m38.282s 0m0.568s
0.814 3 2.353 108.455 16 1729.514 1m53.464s 28m53.648s 0m0.626s
0.817 3 2.361 208.080 8 1659.078 3m33.054s 27m43.235s 0m0.624s
0.814 3 2.346 352.963 4 1410.929 5m57.999s 23m35.000s 0m0.666s
0.817 3 2.347 611.214 2 1221.676 10m16.227s 20m25.473s 0m0.964s
1.574 2 2.370 1207.878 1 1207.088 20m13.614s 20m11.462s 0m0.559s
1.572 2 2.370 1207.309 1 1206.513 20m13.098s 20m10.883s 0m0.571s
0.816 3 2.348 620.177 2 1239.598 10m25.139s 20m43.725s 0m0.642s
0.816 3 2.356 25.325 96 2126.921 0m30.392s 35m31.212s 0m0.591s
0.814 3 2.357 26.340 80 2027.735 0m31.387s 33m51.958s 0m0.585s
0.814 3 2.359 40.328 48 1872.833 0m45.326s 31m16.967s 0m0.659s
0.817 3 2.362 57.289 32 1816.192 1m2.315s 30m20.225s 0m0.734s
0.816 3 2.360 108.502 16 1729.631 1m53.534s 28m53.794s 0m0.599s
0.818 3 2.361 206.353 8 1648.052 3m31.356s 27m32.014s 0m0.749s
0.817 3 2.366 354.500 4 1417.245 5m59.522s 23m41.345s 0m0.618s
0.817 3 2.356 631.685 2 1262.454 10m36.675s 21m6.617s 0m0.757s
1.585 2 2.386 1226.822 1 1226.094 20m32.506s 20m30.473s 0m0.689s
0.816 3 2.354 647.005 2 1292.969 10m52.032s 21m36.416s 0m1.615s
0.813 3 2.350 370.097 4 1477.886 6m15.140s 24m41.825s 0m0.839s
0.816 3 2.357 212.190 8 1659.878 3m37.163s 27m44.064s 0m0.542s
0.820 3 2.372 113.396 16 1696.150 1m58.451s 28m20.363s 0m0.513s
0.824 3 2.371 56.236 32 1783.993 1m1.228s 29m48.213s 0m0.524s
0.816 3 2.363 32.138 64 1913.001 0m37.261s 31m57.256s 0m0.566s
0.814 3 2.357 26.156 80 2017.308 0m31.211s 33m41.559s 0m0.604s
0.823 3 2.373 25.497 96 2102.918 0m30.530s 35m7.262s 0m0.588s
""")

time2seconds(s) =
  let m = match(r"(.+)m(.+)s", s)
    parse(Float64, m.captures[1])*60+parse(Float64, m.captures[2])
  end

plot_povray(raw_data) =
  let data = sort(combine(groupby(raw_data, :TraceThreads),
                          :RealTime => it->mean(map(time2seconds, it))),
                  :TraceThreads)
    plot(data[:,1],
         data[:,2],
         xticks=data[:,1],
         legend=:none,
         markers=:auto,
         #ylimits=(0,180),
         xlabel="Threads",
         #color=:green,
         #xscale=:log10,
         ylabel="Time (s)")
  end

plt = plot_povray(povray_1024x768)
saveplot(plt,"POVRay1024x768")
```
\textoutput{plot10}

To have another data point, we then decided to change the point of
view, while also increasing the size of the image from the previous
1024x768 to 1920x1024. This changes not only the number of pixels, but
also the aspect ratio, producing the following image:

\fig{/DomeTrussRibsFHD2}

Again, we took the average of three different runs. The result is the following:

```julia:plot11
#hideall
povray_1920x1024 = bench_data("""
RadiosityTime RadiosityThreads RadiosityTotal TraceTime TraceThreads TraceTotal RealTime UserTime SysTime
0.779 3 2.001 102.021 96 9619.841 1m47.700s 160m24.887s 0m0.904s
0.762 3 1.985 118.116 80 9315.123 2m3.798s 155m20.004s 0m1.037s
0.789 3 2.017 137.704 64 8669.172 2m23.322s 144m33.953s 0m1.112s
0.778 3 1.996 255.177 32 8125.378 4m20.778s 135m30.414s 0m0.919s
0.768 3 1.991 176.663 48 8405.420 3m2.357s 140m10.271s 0m1.085s
0.764 3 1.972 514.804 16 8222.332 8m40.465s 137m7.376s 0m1.434s
0.779 3 1.996 778.487 8 6225.444 13m4.098s 103m50.300s 0m1.224s
0.764 3 1.972 1407.864 4 5628.796 23m33.505s 93m51.447s 0m3.593s
0.774 3 1.988 2808.148 2 5612.965 46m53.850s 93m38.552s 0m1.956s
1.372 2 2.001 5324.891 1 5321.549 88m51.048s 88m46.425s 0m3.231s
1.367 2 1.993 8705.511 1 8696.566 145m11.838s 145m3.143s 0m7.101s
0.778 3 1.996 3454.576 2 6902.697 57m40.354s 115m7.432s 0m5.056s
0.772 3 1.985 1500.587 4 5999.998 25m6.543s 100m5.298s 0m1.310s
0.779 3 1.993 955.979 8 7643.130 16m1.935s 127m28.370s 0m1.753s
0.777 3 2.007 521.439 16 8326.534 8m47.077s 138m51.595s 0m1.320s
0.779 3 1.999 272.784 32 8679.197 4m38.447s 144m41.701s 0m3.616s
0.777 3 1.995 175.634 48 8307.712 3m1.251s 138m32.662s 0m0.889s
0.782 3 2.001 142.765 64 8820.308 2m28.449s 147m5.241s 0m0.977s
0.772 3 1.983 120.288 80 9283.625 2m6.013s 154m48.632s 0m0.897s
0.787 3 2.024 105.754 96 9971.934 1m51.491s 166m17.003s 0m0.862s
1.515 2 2.194 7426.595 1 7418.852 123m52.975s 123m46.059s 0m4.959s
0.773 3 1.986 2886.633 2 5768.779 48m12.169s 96m14.905s 0m2.498s
0.774 3 1.986 1604.454 4 6408.280 26m49.993s 106m53.697s 0m1.581s
0.778 3 1.999 819.846 8 6550.907 13m45.409s 109m16.001s 0m1.120s
0.771 3 1.982 487.128 16 7772.255 8m12.680s 129m37.101s 0m1.092s
0.796 3 2.032 252.587 32 8035.035 4m18.244s 134m0.110s 0m0.851s
0.785 3 2.008 181.167 48 8443.545 3m6.722s 140m48.535s 0m0.895s
0.765 3 1.982 145.240 64 9035.470 2m30.855s 150m40.471s 0m0.908s
0.775 3 1.992 136.878 80 9359.387 2m22.592s 156m4.452s 0m0.878s
0.788 3 2.024 106.134 96 10010.192 1m51.786s 166m55.312s 0m0.851s
""")

plt = plot_povray(povray_1920x1024)
saveplot(plt,"POVRay1920x1024")
```
\textoutput{plot11}

Note there are relevant speedups up to the upper limit of
threads. Although it pales in comparison to the initial gains, from 80
threads to 96 threads, there is still a significant reduction from
130.8 seconds to 110.3 seconds.

By analyzing the speedups, we can determine the number of threads that
we should use.

```julia:plot12
#hideall
plot_povray_speedup(raw_data1, raw_data2) =
  let process_data(raw_data) =
            sort(combine(groupby(raw_data, :TraceThreads),
                         :RealTime => it->mean(map(time2seconds, it))),
                 :TraceThreads),
      data1 = process_data(raw_data1),
      data2 = process_data(raw_data2)
    plot(data1[:,1],
         [map(x->data1[1,2]/x, data1[:,2]) map(x->data2[1,2]/x, data2[:,2])],
         xticks=data1[:,1],
         label=["1024x768" "1920x1024"],
         legend=:topleft,
         markers=:auto,
         #ylimits=(0,180),
         xlabel="Threads",
         #color=:green,
         #xscale=:log10,
         ylabel="Time (s)")
  end

average96 =
  combine(filter(:TraceThreads => x->x==96, povray_1920x1024),
          :RealTime => it->mean(map(time2seconds, it)))

plt = plot_povray_speedup(povray_1024x768, povray_1920x1024)
saveplot(plt,"POVRay1024x768vs1920x1024")
```
\textoutput{plot12}

As is visible, for the small rendering task, it only pays off to use
up to 80 threads, for an almost 40x speedup compared to just one
thread. After that, the gains appear to be marginal.  In the case of
the large rendering task, despite the fluctuations, we were able to
reach a speedup of almost 65 and the trend line shows that there are
even bigger potential speedups waiting for us.  In fact, POVRay can
take advantage of 512 threads, so we are still a long way away from
that limit.

### Rendering a Movie

A movie is made of a sequence of images and, therefore, rendering a
movie implies rendering multiples images. For smooth visualization, we
should use a minimum of 30 frames per second, which means that a short
10-seconds movie requires at least 300 rendered images. If we further
assume that the images should be in Full HD, i.e., using 1920x1080
pixels, then it becomes obvious that even a short movie can take a
huge amount of time on a normal computer. In the recent past, we did
several of these movies and it was not unusual to wait days or weeks
for the completion of the rendering process.

As we saw in the previous section, using the Cirrus supercomputer the
time need to render each frame becomes acceptable and thus, it is
tempting to just generate all of the needed frames in sequence. This
relieves the programmer of having to coordinate multiple processes.
The following study of daylight, made of 157 frames at a resolution of
1024x768, was entirely done in 79m36s:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/DomeTrussRibsDay-film.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

Given that the speedup gets bigger at higher resolutions, we attempted the same but now using 1920x1080 pixels and for a smoother effect, 391 frames:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/DomeTrussRibsDayFHD-film.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

This time, it took 797m30s and, fitting the typical overnight rendering job.

We saw in the previous experiment that POVRay will explore all
available threads to render just one frame and, so, there are no more
computational resources available that we can use to further speedup
the process.  If we start more POVRay processes on the computing node,
the computing resources will be divided among them and, therefore, we
will slowdown all of them.  However, the Cirrus supercomputer has
multiple computing nodes. This means that although it might not be
possible to speedup up the rendering of one image beyond the 96
threads available in one computing node, it is possible to speedup the
rendering of a sequence of images by dividing the sequence among all
available computing nodes. In our case, we were allowed to use four
computing nodes and, although we did not experimented it because there
were other jobs running that made it impossible to reserve all
computing nodes for ourselves, it is clear that it would be possible
to divide the rendering tasks among the four different computing nodes
to achieve a further 4x speedup, allowing the rendering of a Full HD
movie to achieve a speedup of 250.

Another, easier to do, experiment is the production of different
movies. In this case, there is no need to coordinate the different
computing nodes as each one can do a completely separate job. To prove
this, we did a study on the different turbidity degrees of the
atmosphere.  First, we wrote a small Khepri script that would receive
the turbidity degree as a command line argument and would generate a
400-frames movie of an animated object that is being viewed by a
camera that rotates around it:

```julia
using KhepriPOVRay

turbidity=parse(Int, ARGS[1])
realistic_sky(turbidity=turbidity)

render_dir(@__DIR__)
render_size(1920, 1024)

chrome = material(povray=>povray_include("textures.inc", "texture", "Polished_Chrome"))
ground(-5)

start_film("MetalGlassTree$(turbidity)")
nframes = 400
for (rho, phi, z) in zip(division(80, 10, nframes),division(0, 2*pi, nframes),division(0, 40, nframes))
 delete_all_shapes()
 for i in 0:19
   p0 = cyl(23 - i, i, 2*i - 2*sin(4*phi))
   p1 = cyl(23 - i, i + pi, 2*i + 2*sin(4*phi))
   sphere(p0, 2 + 0.5*sin(4*phi), material=chrome)
   sphere(p1, 2 - 0.5*sin(4*phi), material=chrome)
   cylinder(p0, 1, p1, material=material_glass)
 end
 set_view(cyl(rho, phi, z), xyz(0, 0, 30), 20.0)
 save_film_frame()
end
```

We tested the script using eight different turbidity levels.  The
following videos illustrate the same animated object rendered under a
selection of such levels (more specifically, 2, 4, 6, and 8):

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/MetalGlassTreeMultiple.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

The videos for the eight turbidity levels took, respectively,
94m8.523s, 75m36.726s, 73m30.351s, 73m19.054s, 71m32.826s, 71m23.082s,
70m53.158s, and 70m28.809s.  Using just one computing node would
entail roughly 10 hours (more exactly, 600m52.529s) but, as we were
spreading the different independent jobs among the four computing
nodes that we could use, it took, at most, 2h50m (more exactly,
169m42.249s). This result could be improved if we could use more
computing nodes as each video could have been generated in a different
computing node, and the total computation would have take, at most,
1h34m (more exactly, 94m8.523s).

For a more architectonic example, here is a study on different materials applied to a building's façade:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/CarmoD-film.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/CarmoE-film.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/CarmoF-film.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

The 360 frames in each of the three videos, in total, required 106
minutes to complete. However by using three different nodes, we could
have divided this time, roughtly, by three.

We also experimented with the renderings of glass in white or black
backgrounds. To that end, we created the following Khepri program,
which uses a ratio from 0.1 to 1.0 to affect the radius of each
randomized sphere:

```julia
default_material(material_glass)

ratio = Parameter(0.1)

spheres_in_sphere(p, ri, re, rl, n) =
  if n == 0
    true
  else
    r = random_range(ri, re)
    sphere(p+vsph(r, random_range(0.0, 2*pi), random_range(0.0, pi)), (rl-r)*ratio())
    spheres_in_sphere(p, ri, re, rl, n-1)
  end
```

To generate the frames, we just iterate, increasing the ratio on each
frame, while we also rotate the spheres:

```
ground(-6, material(povray=>povray_definition(
  "Ground", "texture",
  "{ pigment { color rgb 1 } finish { reflection 0 ambient 0 }}")))
realistic_sky()
render_size(1080,1080)
render_dir(@__DIR__)
set_view(xyz(9.9307, -93.0178, 63.675), xyz(0.0841, -0.9705, 0.5236), 300)

start_film("RotatingGrowingSpheres")
for ϕ in division(0, 2π, 720)
  delete_all_shapes()
  set_random_seed(12345)
  with(current_cs, cs_from_o_phi(u0(), ϕ), ratio, ϕ/(2π)) do
    spheres_in_sphere(xyz(0, 0, 0), 4.0, 5.0, 5.0, 600)
  end
  save_film_frame()
end
```

Then just by changing the `rgb` color of the ground, we generate the
two different backgrounds. The results are the following:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/RotatingGrowingSpheres.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

The film with white background took 218m15.151s while the one with the
black background took real 89m36.919s. This is one example where
dividing the work among to computing nodes does not provide as much
benefit as we would like because one of the videos takes much longer
to produce than the other. Nevertheless, it still saves almost one and
a half hour in a job that would take 5 hours to complete, a still
significant 30% reduction.

Finally, given that the focus was architecture, we decided to repeat a
series of videos that we did in the past, at a time where we spent
weeks rendering images that, in some cases, would take one hour for
each frame. Given the differences in the available software, it is not
possible to exactly replicate the images, as the rendering engine is
necessarily different. However, it can give a sense of the trade-offs
between speed and image quality.

The first video shows a parametric exploration of Astana's National
Library (the video was 'filmed' at Full HD resolution but was reduced
to half its size to facilitate viewing):

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/Astana_rubber-film.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

For another example:

~~~
<video width="700" controls>
  <source src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/2_Tracking-Cyl.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>
~~~

### Evolution

We saw that supercomputers can have a dramatic effect on the time
needed for rendering tasks.  By parallelizing the rendering of a
single image through the multi-processing capabilities of a computing
node and then parallelizing the rendering of multiple imagens through
the use of multiple computing nodes, it becomes possible to achieve
very large speedups.

At the same time, it is relevant to consider that even commodity
hardware, nowadays, can efficiently run multiple threads in
parallel. This means that the speedups obtained in the previous
experiments must be contrasted not with the minimum computing power
that the supercomputer can provide but, instead, with the current
computing power that is available almost everywhere.  It is in this
analysis that the results do not look as good as they seemed.  As a
reference, using the maximum computing power available on one
computing node, i.e., 96 execution threads, we managed to render the
1920x1024 image in an average of 110.3 seconds. For comparison, a 2017
AMD ThreadRipper 1950X workstation providing 16 cores/32 threads
renders that same image in 615.5 seconds, which represents a speedup
of only 5.6. For an even more depressing comparison, a 2015 Intel 4
cores/8 threads i7-6700K CPU that costs around 250 EUR can render the
same image in 1946.4 seconds while doing other useful tasks at the
same time. Although the supercomputer gives us a speedup of 17.6, just
the CPU costs 18 times more. The ratio cost/performance seems to be,
at best, constant.

Despite the cost, the supercomputer does make the rendering task more
feasible. We decided to test some additional examples that, in the
past, were almost impractical.  As a first example, in 2010, the
following image, by Prateek Karandikar, took 16 hours and 19 seconds
to render on an Intel Pentium 1.8GHz machine with 1GB RAM.

\fig{/Photon}

The supercomputer could generate the same image in 51 _seconds_, which
is more than three orders of magnitude faster.

As another example, consider the classical POVRay Hall-of-Fame
_Pebbles_ example, which is entirely procedurally generated:

\fig{/pebbles}

According to its author, this image took 4.5 days to render on an
Athlon 5600+. We generated the exact same image on the supercomputer
in 2h49m. This is a speedup of almost 40, which opens the door to
other ideas. One was to use the exact same POVRay program do a short
movie just by changing the camera. The result is not very smooth but
it gives an idea of what becomes possible:

~~~
<img src="http://web.ist.utl.pt/antonio.menezes.leitao/ADA/SuperComputingFilms/PebblesZoomInOutFilm.gif" alt="">
~~~

## Conclusions

Despite the clear advantages of having very large computing resources
available, there are some drawbacks to the use of those resources. The
first is on the software side, as programs that require a graphical
user interface can hardly run in a supercomputing environment. Even if
the software does not have that particular requirement, it usually
needs to be adapted to be able to run. Given the differences between
operating systems, sometimes, this is a considerable obstacle. The
lack of administrative privileges also makes it difficult to install
software or even just the libraries needed to compile it.

Not all software can benefit from the use of supercomputing
resources. In fact, different tasks can have very different benefits
from the use of those resources, including no benefits at all or even
having disadvantages. Structural analysis, for example, could not
benefit from the use of multiple CPUs (the software was not
parallelized), while rendering benefited considerably (up to 65X
speedup in some cases). Optimization using parallelized algorithms
could benefit but only up to a point. We found that for the
optimization problems we tested, there were considerable gains until
we reach 8 CPUs but no gains after that. Another factor is the time it
takes to launch the parallel tasks, which limits the amount of speedup
that can be extracted.

Given these limitations, it is important to plan the experiments in
advance. For example, if the goal is to study the structural behavior
of a building for different load cases, instead of hoping for the
parallelization of the structural analysis package, we can instead
parallelize the analysis of the different load cases. In the end, this
approach gives the same results but it is much easier to implement, as
it does not even require changing the software.

### Lessons Learned

1. Use a different job name for each experiment. Slurm has a great
accounting system that gives a lot of information about everything we
do but it then becomes critical to be able to distinguish between
different experiments.

2. Don't request more resources than the ones you really need. Slurm
might be able to process your job sooner by using the capacity that is
still available on a computing node that is running other
jobs. However, if the nodes do not have enough free capacity to
satisfy the requested resources the job will remain waiting until that
capacity arrives.

3. Resources include not only the number of nodes/tasks/cpus needed
but also the expected time. Obviously, it should be enough to complete
the job or it will be automatically cancelled when the time is
over. This can be _very_ annoying when a job is cancelled just before
finishing what it was doing for two or three days.

### Future Work

This research is a starting point for the use of supercomputing
resources to address architecture problems, leaving a large number of
paths that deserve to be explored.

One important one is to find ways to better accommodate design
exploration to the supercomputing environment. We envision the
possibility of pre-computing a sample of the design space in a
supercomputer, where each element of the sample corresponds to a
single task. Depending on the number of dimensions and the number of
values considered on each dimension, this might require as few as a
few dozens of CPUs, or as many as a many thousands.

Another relevant research path is the parallelization of optimization
processes. We found large limitations on the speedups that the tested
algorithms could achieve and, thus, it is important to experiment
other algorithms. Depending on the available computing resources, a
less intelligent algorithm that makes better use of parallel
computation can beat a more intelligent algorithm that is hardly
parallelizable.

A further research path is the automatic management of the
supercomputing resources. To make them useful for less computer-savvy
users, as is typical in architecture, it is necessary to considerably
simplify their use.  For example, we found that to better explore the
available computing resources at each moment, we had to first check
the current load on the computing nodes and then launch jobs that
requested only the remaining computing resources. Another problem is
the painful management of files that need to be exchanged between the
user's machine and the supercomputer. We plan to find ways to
eliminate these problems, e.g., through graphical user interfaces and
automatic file synchronization, making the use of supercomputing
resources as simple as a regular computer.
