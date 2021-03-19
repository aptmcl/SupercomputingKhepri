# This file was generated, do not modify it. # hide
#hideall
using DataFrames
using CSV
using Plots
using StatsPlots
using Statistics
using JSON

plotlyjs(size=(640,330))

bench_data(str) =
  DataFrame(CSV.File(IOBuffer(str), delim=" ", ignorerepeated=true))

saveplot(plt, name="", ext="svg") =
  fdplotly(json(Plots.plotlyjs_syncplot(plt))) # hide
  #savefig(joinpath(@OUTPUT, name * "." * ext))