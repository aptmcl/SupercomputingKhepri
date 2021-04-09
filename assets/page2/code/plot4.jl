# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
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
#\textoutput{plot4}