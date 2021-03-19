# This file was generated, do not modify it. # hide
#hideall
work_per_id_bench = bench_data("""
Processes StartTime(s) StartAllocs(k) StartMemory(MiB) RunTime(s) RunAllocs(k) RunMemory(MiB)
2 1.417592 15.86 1.254 22.503356 247.07 10.499
4 1.560481 16.83 1.934 7.585491 248.19 10.535
8 1.286162 18.89 3.299 3.352620 248.10 10.542
16 1.751758 23.82 6.057 1.658032 248.08 10.542
32 1.748663 34.40 11.593 0.902268 248.66 10.565
48 1.925062 48.28 17.249 0.666988 248.76 10.544
64 1.915959 63.91 22.913 0.551525 250.47 10.617
80 1.942948 82.16 28.707 0.464072 250.09 10.610
96 2.129396 103.51 34.561 0.421452 251.00 10.647
""")
plt=
groupedbar(
  string.([2, 4, 8, 16, 32, 48, 64, 80, 96]),
  hcat(map(row->[row[5], row[2]], eachrow(work_per_id_bench))...)',
  bar_position=:stack,
  label=["Work time" "Launch time"],
  xlabel="# Processes",
  ylabel="Time(s)")
saveplot(plt,"workPerId")