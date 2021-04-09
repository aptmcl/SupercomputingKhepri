# This file was generated, do not modify it. # hide
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange=[(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals=5000, PopulationSize=500, Workers=workers())
using .MOOBData
plt = plot_opt(optxnes500_5000)
saveplot(plt,"xnes500_5000")
#\textoutput{plotopt6}