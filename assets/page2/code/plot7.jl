# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(w->resize(collect(w[:,2]), 95), reverse(work_per_id))...)',
  bar_position=:stack,
  legend=:none,
  xlabel="# Processes",
  ylabel="Work Units")
saveplot(plt,"workPerIdDivided")
#\textoutput{plot7}