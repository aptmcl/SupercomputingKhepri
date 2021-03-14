# This file was generated, do not modify it. # hide
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

plot_povray(raw_data) =
  let time2seconds(s) =
        let m = match(r"(.+)m(.+)s", s)
          parse(Float64, m.captures[1])*60+parse(Float64, m.captures[2])
        end
      data = sort(combine(groupby(raw_data, :TraceThreads),
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