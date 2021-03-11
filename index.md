@def title = "Architecture in the Supercomputing Era"
@def tags = ["syntax", "code"]

```julia:setup
using DataFrames
using CSV
using Plots

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
of harware with huge energy demands.

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
regarding their computational demands, and reexecute the associated
programs in a supercomputer, to assess the effective gains.  It was
also important for us to evaluate the experience of using a
supercomputer, as these tend to run operating systems with very
specific characteristics and that differ significantly from those of a
typical off-the-shelf computer.


## Commodity Hardware

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

## The Supercomputing Hardware

Upon approval of our application to the FCT Call on Advanced Computing
Projects, we were given access to the Cirrus supercomputer, more
specifically, the `fct` partition containing four computing
nodes, each node providing 96 AMD EPYC 7552 cores, running at 2.2 GHz
and accessing 512 GB of RAM. In total, this partition allows 384
simultaneous threads of execution, using 2 TB of memory, although
these would be constrained by the supercomputer topology and the
available resources at each moment.  In any case, this represents a
significant amount of computing power when compared with current
comodity hardware that, typicaly, can simultaneously execute only 8
threads of execution using 16 GB of RAM.

It is also important to mention that users to not have direct access
to the computing nodes. Instead, they have to use a front-end machine
with an Intel Xeon CPU L5420 running at 2.5GHz with 32 GB of RAM.

## The Supercomputing Sofware

Despite the large differences between the hardware of the Cirrus
supercomputer and that of a typical laptop, the differences in
software were even bigger and caused the biggest headaches. First,
because the supercomputer uses CentOS 7, an operating system that is
very different from the most popular ones, such as Microsoft's Windows
or Apple's MacOS. Second, because it mostly operates in _batch mode_,
meaning that _scripts_ must be submitted describing the intended
executions and the resources needed, and there is no immediate
feedback, for example, to report errors in the code.  Fourth, the
_batch mode_ also implies that it only supports programs that do not
require interacting with the user and, therefore, do not use a
graphical user interface.

## The Plan

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

To this end, the plan required the following instalation steps:

1. Install the Julia language
1. Install the KhepriBase package
1. Install the BlackBoxOptim package, for multi- and single-objective optimization using meta-heuristic algorithms
1. Install the KhepriFrame3DD package, for structural analysis
1. Install the KhepriBlender and/or the KhepriPOVRay packages, for rendering

Unfortunately, as we will see, installing even this small selection of
programs was far from trivial.

## Installing Software

A major difficulty for accomplishing the plan is the lack of
administrative privileges, as it prevents the system-wide installation
of much needed libraries or software tools. Altough entirely
understandable due to the shared nature of the system, lacking these
priviliges makes it mandatory to use local installations.
Fortunately, some of the critical software that we planned to use,
such as the Julia programming language, can be installed locally.

Initially, we tried to use the release candidate version of Julia
version 1.6 because it promised to solve a pre-compilation problem
that occurred when multiple simultaneous Julia processes attempted to
pre-compile the software, triggering conflits in the saving of the
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

## Recompiling Software

Not all software that is available for Linux (or, more specifically,
Ubuntu) can directly run on the supercomputer.  Some can only run
after being recompiled for CentOS 7.  Given the difficulty of using
the frontend for anything more complex than just editing files or
submitting jobs, we decided to recompile the software on our own
machines and only move the resulting binaries to the supercomputer.
In the begining we were doing this using a Ubuntu installation running
on Windows Subsystem for Linux (WSL), which we expect would be very
similar to CentOS.  However, we quickly discovered that there were
errors related to differences in the libraries of Ubuntu and CentOS
7. To avoid being forced to recompile the software, we initially
attempted to solve these dependency errors but soon realized that it
would not end up well.

In the end, to avoid errors due to different software versions, we
installed the exact same operating system on a virtual machine. This
allowed us to more easily recompile the software, and only after
successfully testing them on our own virtual machine, to move it to
the supercomputer.  At that moment, however, we discovered that
despite running the exact same operating system, executing some of the
recompiled programs in the frontend computer triggered an `Illegal
instruction` error. After much unsuccessful debuging, we discovered
that these errors did not occur when the programs were executed in the
computing nodes.

Unfortunately, the time and effort spent making just one of the
programs run on the supercomputer consumed a significant fraction of
the time that was given us to use the machine.  To avoiding wasting
the entire time just on the task of making the programs run, we
decided to focus on those programs that we had already running and we
start collecting statistics of their execution using a different
number of processing units.

## Julia

The first tests attempted to determine how the Julia language
implementation scales across multiple cores. The following Julia
program computes an approximation of $\pi$ using the classical Monte
Carlo approach of sampling points on a square that circunscribes a
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

It is relevant to note that despite aparent exponential growth, the
scale is logarithmic and, thus, the computation time grows linearly
with the number of iterations.

The next step is to repeat the same computation but using parallel
processing.  To this end, Julia supports multi-threading and
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

The next fragment of code demonstrate the creation of workers. We take
the number of processes $n$ that was passed as a command-line argument
and we create $n-1$ additional workers so that the master and the
slaves use all available resources.

```julia
using Distributed

addprocs(parse(Int, ARGS[1])-1)
```

Despite the simplicity of the `addprocs` function, there is a lot
going on behind the scenes. Immediatly after its creation, each of the
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

# Compilation:
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
saveplot(plt,"userTimeParallelPi") # hide
```
\textoutput{plot4}

Now, we see that despite the considerable gains obtained, almost
halving the time needed, it only pays off to use up to 16
processes. Our guess for the lack of speedup after 16 processes is
that the time spent starting processes and managing them nullifies the
gains of the parallelization.  In order to improve these results, it
might be necessary to use a different process topology.
