# This file was generated, do not modify it. # hide
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