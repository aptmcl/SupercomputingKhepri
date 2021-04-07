@def title = "Conclusions"

# Conclusions

\tableofcontents <!-- you can use \toc as well -->

#

Despite the clear advantages of having very large computing resources
available, there are some drawbacks to the use of those resources. The
first is on the software side, as programs that require a graphical
user interface can hardly run in a supercomputing environment. Even if
the software does not have that particular requirement, it usually
needs to be adapted to be able to run. Given the differences between
operating systems, this can be a considerable obstacle sometimes. The
lack of administrative privileges also makes it difficult to install
software or even just the libraries needed to compile it.

Not all software can benefit from the use of supercomputing
resources. In fact, different tasks can have very different benefits
from the use of those resources, including no benefits at all or even
having disadvantages. Structural analysis, for example, could not
benefit from the use of multiple CPUs (the software was not
parallelized), while rendering benefited considerably (up to 65X
speedup in some cases). Optimization using parallelized algorithms
also benefited but only up to a point. We found that for the
optimization problems we tested, there were considerable gains until
we reached 8 CPUs but no gains after that. Another factor is the time it
takes to launch the parallel tasks, which limits the amount of speedup
that can be extracted.

<!-- 8 -->

Given these limitations, it is important to plan the experiments in
advance. For example, if the goal is to study the structural behavior
of a building for different load cases, instead of hoping for the
parallelization of the structural analysis package, we can instead
parallelize the analysis of the different load cases. In the end, this
approach gives the same results but it is much easier to implement, as
it does not even require changing the software.

### Lessons Learned

1. Use a different job name for each experiment. Slurm has a great accounting system that gives a lot of information about everything we do but it then becomes critical to distinguish between different experiments.  Repeating the job names makes it more difficult to make that distinction.

2. Do not request more resources than the ones you really need. Slurm might be able to process your job sooner by using the capacity that is still available on a computing node that is running other jobs. However, if the nodes do not have enough free capacity to satisfy the requested resources, the job will remain waiting until that capacity arrives.

3. Resources include not only the number of nodes/tasks/CPUs needed but also the expected time. Obviously, we should estimate enough time to complete the job or it will be automatically cancelled when the time is over. It is _very_ annoying to see a job being cancelled just before finishing what it was doing for two or three days.

### Future Work

This research is a starting point for the use of supercomputing
resources to address architecture problems, leaving a large number of
paths that deserve to be explored.

An important one is to find ways to better accommodate design
exploration to the supercomputing environment. We envision the
possibility of pre-computing a sample of the design space in a
supercomputer, where each element of the sample corresponds to a
single task. Depending on the number of dimensions and the number of
values considered on each dimension, this might require as few as a
few dozens CPUs, or as many as a many thousands.

Another relevant research path is the parallelization of optimization
processes. We found large limitations on the speedups that the tested
algorithms could achieve and, thus, it is important to experiment
other algorithms. Depending on the available computing resources, a
less intelligent algorithm that makes better use of parallel
computation can beat a more intelligent algorithm that is hardly
parallelizable.

A further research path is the automatic management of the
supercomputing resources. To make them useful for less computer-savvy
users, as is typical in architecture, their use must be considerably
simplified. For example, we found that to better explore the
available computing resources at each moment, we had to first check
the current load on the computing nodes and then launch jobs that
requested only the remaining computing resources. Another problem is
the painful management of files that need to be exchanged between the
user's machine and the supercomputer. We plan to find ways to
eliminate these problems, e.g., through graphical user interfaces and
automatic file synchronization, making the use of supercomputing
resources as simple as using a regular computer.

#
[<< Previous Chapter](/page5/)
