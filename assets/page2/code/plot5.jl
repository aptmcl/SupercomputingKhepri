# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
plot(
  work_per_id[1][:,1],
  work_per_id[1][:,2],
  xlimits=(2,96),
  #xticks=work_per_id[1][:,1],
  seriestype=:bar,
  legend=:none,
  xlabel="Process id",
  ylabel="Work Units")
saveplot(plt,"workPerId96")
#\textoutput{plot5}