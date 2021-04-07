# This file was generated, do not modify it. # hide
#hideall
using Franklin
using DataFrames
using CSV
using Plots
using StatsPlots
using JSON

plotlyjs(size=(640,330))

bench_data(str) =
  DataFrame(CSV.File(IOBuffer(str), delim=" ", ignorerepeated=true))

saveplot(plt, name="", ext="svg") =
  fdplotly(json(Plots.plotlyjs_syncplot(plt))) # hide
  #savefig(joinpath(@OUTPUT, name * "." * ext))

function JSON.Writer.show_json(io::JSON.Writer.SC, s::JSON.Writer.CS, x::Union{AbstractVector, Tuple})
    JSON.Writer.begin_array(io)
    for i in eachindex(x)
        if x isa Tuple || isassigned(x, i)
          JSON.Writer.show_element(io, s, x[i])
      end
    end
    JSON.Writer.end_array(io)
end