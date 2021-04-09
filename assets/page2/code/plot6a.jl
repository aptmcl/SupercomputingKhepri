# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
plot(
  work_per_id[8][:,1],
  work_per_id[8][:,2],
  #xlimits=(2,4),
  xticks=[2,3,4], #work_per_id[8][:,1],
  seriestype=:bar,
  legend=:none,
  xlabel="Process id",
  ylabel="Work Units")
saveplot(plt,"workPerId8")
#\textoutput{plot6a}