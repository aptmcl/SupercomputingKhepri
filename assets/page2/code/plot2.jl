# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
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
#\textoutput{plot2}