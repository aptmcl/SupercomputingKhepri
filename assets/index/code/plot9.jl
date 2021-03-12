# This file was generated, do not modify it. # hide
#hideall
speedups_work_time = map(row->(work_per_id_bench[1,5])/(row[5]), eachrow(work_per_id_bench))
speedups_total_time = map(row->(work_per_id_bench[1,2]+work_per_id_bench[1,5])/(row[2]+row[5]), eachrow(work_per_id_bench))

plt=
plot(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  [speedups_work_time speedups_total_time],
  label=["Working Time" "Total Time"],
  legend=:topleft,
  xlabel="# Processes",
  ylabel="Speedup")
saveplot(plt,"speedUpWorkers")