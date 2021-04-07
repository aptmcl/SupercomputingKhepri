# This file was generated, do not modify it. # hide
#hideall
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