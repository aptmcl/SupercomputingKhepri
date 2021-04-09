# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
plot(aprox_pi_multiple_2[:,1],
     hcat(approx_pi_single[:,2],
          aprox_pi_multiple_2[:,2],
	  aprox_pi_multiple_4[:,2],
	  aprox_pi_multiple_8[:,2],
	  aprox_pi_multiple_16[:,2],
	  aprox_pi_multiple_32[:,2],
	  aprox_pi_multiple_48[:,2],
	  aprox_pi_multiple_64[:,2],
	  aprox_pi_multiple_80[:,2],
	  aprox_pi_multiple_96[:,2]),
     labels=[1 2 4 8 16 32 48 64 80 96],
     legendtitle="# Processes",
     #size=(800,600),
     legend=:topleft,
     markers=:auto,
     ylimits=(0,80),
     xlabel="Iterations",
     #color=:green,
     xscale=:log10,
     ylabel="Time (s)")
saveplot(plt, "timeParallelPi")
#\textoutput{plot3}