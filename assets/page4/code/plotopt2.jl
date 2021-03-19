# This file was generated, do not modify it. # hide
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