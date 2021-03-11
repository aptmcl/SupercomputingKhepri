# This file was generated, do not modify it. # hide
#hideall
creating_workers = bench_data("""
Processes Time Allocations Memory
2 1.078188 15.80 1.148
4 1.205602 16.77 1.828
8 1.480043 18.95 3.196
16 1.379302 23.54 5.945
32 1.375842 34.15 11.478
48 1.691627 47.79 17.115
64 1.737718 63.30 22.810
80 1.843256 81.42 28.583
96 2.059247 102.70 34.435
""")
plt=
scatter(creating_workers[:,1], creating_workers[:,2],
     labels="Time",
     legend=:topleft,
     markers=:auto,
     ylimits=(0,2.5),
     xticks=creating_workers[:,1],
     smooth=true,
     #xscale=:log10,
     xlabel="Processes",
     ylabel="Time (s)")
plt=
plot!(twinx(), creating_workers[:,1], creating_workers[:,4],
     labels="Memory",
     legend=:topleft,
     markers=:auto,
     ylimits=(0,35),
     xticks=:none,
     color=:green,
     #xscale=:log10,
     ylabel="Memory (MiB)")
saveplot(plt, "timeMemoryWorkers")