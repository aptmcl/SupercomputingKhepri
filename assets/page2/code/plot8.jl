# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(row->[row[5], row[2]], eachrow(work_per_id_bench))...)',
  bar_position=:stack,
  label=["Work time" "Launch time"],
  xlabel="# Processes",
  ylabel="Time(s)")
saveplot(plt,"workPerId")
#\textoutput{plot8}