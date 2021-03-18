# This file was generated, do not modify it. # hide
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