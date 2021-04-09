# This file was generated, do not modify it. # hide
#hideall
using .MOOBData
plt=
plot(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  [speedups_work_time speedups_total_time],
  label=["Working Time" "Total Time"],
  legend=:topleft,
  xlabel="# Processes",
  ylabel="Speedup")
saveplot(plt,"speedUpWorkers")
#\textoutput{plot9}