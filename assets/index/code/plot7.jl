# This file was generated, do not modify it. # hide
#hideall
resize(v, n) = vcat(v, zeros(Int, n - length(v)))
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(w->resize(collect(w[:,2]), 95), reverse(work_per_id))...)',
  bar_position=:stack,
  #size=(700,1000),
  legend=:none,
  #xlabels=,
  xlabel="# Processes",
  ylabel="Work Units"
  )
saveplot(plt,"workPerId")