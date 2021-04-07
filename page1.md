@def title = "Introduction"

```julia:setup
#hideall
using Franklin
using DataFrames
using CSV
using Plots
using StatsPlots
using Statistics
using JSON

plotlyjs(size=(640,330))

bench_data(str) =
  DataFrame(CSV.File(IOBuffer(str), delim=" ", ignorerepeated=true))

saveplot(plt, name="", ext="svg") =
  fdplotly(json(Plots.plotlyjs_syncplot(plt))) # hide
  #savefig(joinpath(@OUTPUT, name * "." * ext))
```

# Introduction

\tableofcontents <!-- you can use \toc as well -->

#

My research group has been working for many years in the combination
between Architecture and Computer Science.  More specifically, we have
been researching in Algorithmic Design, Algorithmic Analysis,
Algorithmic Optimization, and Algorithmic Visualization. Algorithmic
Design focuses on the use of algorithms that generate designs,
particularly, building designs. Algorithmic Analysis deals with the
automation of analysis processes, such as lighting analysis or
structural analysis. Algorithmic Optimization takes advantage of the
two previous areas to optimize building designs according to given
metrics, e.g., structural performance. Finally, Algorithmic
Visualization is concerned with the algorithmic exploration of
cinematographic techniques to generate images and films of building
designs. Throughout the years, we have developed software systems that support of these research topics. Our most recent implementation is Khepri, a programming environment for Algorithmic Design, Analysis, Optimization, and Visualization.

Some of the previous areas have considerable computational
demands. Algorithmic Optimization and Algorithmic Visualization, in
particular, are extremely demanding from the computational point of
view: it is not unusual to have processes running for weeks in
high-performance computer workstations. Obviously, the typical
duration of these processes demotivates architects and
engineers from their use.

However, when we consider the evolution of the performance of the
computing systems, we verify that an enormous increase in computation
power occurred in the last decades. First, by increasing the number of
instructions a processors could execute in a given amount of time and,
then, by increasing the number of processors. The software that
nowadays runs on a mobile phone, required large rooms full
of hardware with huge energy demands only decades ago.

This shows that we should not take the currently available
computational power as the norm but only as another data point in the
trend for increasingly larger computational power. This point of view
is particularly relevant because it allows us to forecast future
computational power: what is nowadays out of reach
for commodity hardware but is already possible in supercomputing
devices will, in the near future, be possible in commodity hardware.

It was with this perception that we submitted an application for the
_Fundação para a Ciência e a Tecnologia_ (FCT) Call on Advanced
Computing Projects, which gave us the opportunity to use the High-Performance Computing (HPC)
capability provided by one of Portugal's supercomputing centers. Our goal was to look at some of our
previous and current research, whose computational demands were known to us, and re-execute the
associated programs in a supercomputer, to assess the effective gains. It was also important for us
to evaluate the experience of using a supercomputer, as these tend to run operating systems with
very specific characteristics and that differ significantly from those of
a typical off-the-shelf computer. Finally, this would also be a test for Khepri, as it would entail adapting it to run on the supercomputing environment.


### Commodity Hardware

Throughout time, our research has produced a series of programs
and programming environments. Given the research area, it is not surprising to
verify that many of them are intended to be used through a graphical
user interface.  In general, for most of their activities, our
researchers use laptops that have obvious computing power limitations.

For the most demanding computations, the highest-powered system we
used was a 2-CPU/16-core/64 GB RAM workstation running Windows-10.
This workstation was used, mostly, for tasks where user attention was
not critical, such as optimization and rendering. It was not unusual
for some of these tasks to require days or weeks of computation.

The fact that, several years ago, these tasks would take
months to complete, is still no consolation when results are needed
as soon as possible. Nowadays, users do not want to wait more than
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

It is also important to mention that users do not have direct access
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
feedback, for example, to report errors in the code. Third, the
_batch mode_ also implies that it only supports programs that do not
require user interaction and, therefore, do not use a
graphical user interface.

This operating mode is supported by Slurm's job scheduling system. Slurm is popular open source
cluster management system, which significantly helps, as there is a ton of information available
about it.

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
information for Slurm. Also note that this information does not affect
the script because a line that starts with `#` is treated as a comment
by `bash`. In this particular script we just specified some of the
job's parameters but many other options could be
provided.


### The Plan

Given that the available HPC resources are running Linux variants
which are very different from the Windows 10 operating system that
constitutes the usual environment for Khepri, the first step would be
to convert our software to Linux. Some of the required analysis tools
already run in Linux (e.g. Radiance, Frame3DD) but others would need
to be converted. We expected that this conversion would not require
advanced computing resources except for testing.

After that step, we planned to test the Julia programming language
capabilities for HPC. Although there are studies that show that Julia
is a good fit for those computing environments, we still needed to acquire
some experience in that kind of use.

After having Julia running on the supercomputer, we planned to explore
the Julia language to adapt our software to not only manage multiple
parallel runs of sequential optimization algorithms but also use
parallel optimization algorithms or open-source optimization
frameworks supporting parallelization.

Finally, if there was still time available, we would experiment
running Khepri and some of its backends in the supercomputer to
evaluate the scalability on different tasks, particularly, analysis,
and visualization.

However, given the fact that some of Khepri's backends only work in
Windows, we had to select only those that we knew, in advance,
could run in Linux.

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
understandable due to the shared nature of the system, the lack of these
privileges makes it mandatory to use local installations.
Fortunately, some of the critical software that we planned to use,
such as the Julia programming language, can be installed locally.

Initially, we tried to use the release candidate version of Julia 1.6 because it promised to solve a
problem that occurred when multiple simultaneous Julia processes attempted to
pre-compile the software, triggering conflicts in the saving of the compiled code to disk. However,
this version caused problems related to the foreign function interface that was critical for calling
our own DLL implementation of the structural analysis package Frame3DD.

After these failures, we went back to version 1.5.3, which we
installed locally, using the official version for Linux and FreeBSD,
hoping that the mentioned synchronization problems would not prevent
us from completing the planned experiments.

Unfortunately, not all software can be installed this way, making it
impossible to do some of the planned experiments. The first casualty
was Blender. Although there is a CentOS version of Blender, its
installation requires administrative privileges. We spend some time
trying alternative ways to install Blender but, given the limited time
available, we moved on to the next alternative -- POVRay.

### Recompiling Software

Not all software that is available for Linux (or, more specifically,
Ubuntu) can directly run on the supercomputer. Some can only run
after being recompiled for CentOS 7. Given the difficulty of using
the frontend for anything more complex than just editing files or
submitting jobs, we decided to recompile the software on our own
machines and only move the resulting binaries to the supercomputer.
In the beginning we were doing this using a Ubuntu installation
running on Windows Subsystem for Linux (WSL), which we expected would be
very similar to CentOS.  However, we quickly discovered that there
were errors related to differences in Ubuntu's and
CentOS 7's libraries. To avoid recompiling the software, we
initially attempted to solve these dependency errors but soon realized
that it would not end up well.

In the end, to avoid errors due to different software versions, we
installed the exact same operating system on a virtual machine. This
allowed us to more easily recompile the software and, only after
successfully testing them on our own virtual machine, move it to
the supercomputer. At that moment, however, we discovered that
even though we were using the exact same operating system, executing some of the
recompiled programs in the frontend computer triggered an `Illegal
instruction` error. After much unsuccessful debugging, we discovered
that these errors did not occur when the programs were executed in the
computing nodes.

Unfortunately, the time and effort spent making just one of the
programs run on the supercomputer consumed a significant fraction of
the time we were given to use the machine. To avoiding wasting
it all on the task of making the programs run, we
decided to focus on the programs that were already running and we
start collecting statistics of their execution using a different
number of processing units.

#
[<< Previous Chapter](/)

[Next Chapter >>](/page2/)
