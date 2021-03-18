# This file was generated, do not modify it. # hide
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