# This file was generated, do not modify it. # hide
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