# This file was generated, do not modify it. # hide
#hideall
time_aprox_pi_multiple = bench_data("""
Processes Time
2  174.818
4  117.889
8  101.636
16 96.311
32 95.354
48 96.136
64 95.539
80 96.951
96 98.881
""")
plt=
plot(time_aprox_pi_multiple[:,1],
     time_aprox_pi_multiple[:,2],
     labels=[2 4 8 16 32 48 64 80 96],
     legend=:none,
     markers=:auto,
     ylimits=(0,180),
     xlabel="Processes",
     xticks=time_aprox_pi_multiple[:,1],
     ylabel="Time (s)")
saveplot(plt,"userTimeParallelPi")