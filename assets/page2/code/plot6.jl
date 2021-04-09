# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
plot(
  work_per_id[5][:,1],
  work_per_id[5][:,2],
  xlimits=(2,32),
  #xticks=work_per_id[5][:,1],
  seriestype=:bar,
  legend=:none,
  xlabel="Process id",
  ylabel="Work Units")
saveplot(plt,"workPerId32")
#\textoutput{plot6}