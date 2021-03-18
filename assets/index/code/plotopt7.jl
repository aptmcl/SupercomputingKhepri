# This file was generated, do not modify it. # hide
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