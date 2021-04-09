# This file was generated, do not modify it. # hide
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange=[(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals=1000, PopulationSize=100, Workers=workers())
using .MOOBData
plt = plot_opt(optxnes1000pop100)
saveplot(plt,"xnes1000pop100")
#\textoutput{plotopt3}