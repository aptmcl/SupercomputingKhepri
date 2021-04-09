# This file was generated, do not modify it. # hide
#hideall
#opt = bbsetup(displacement_obj; Method=:separable_nes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], PopulationSize=500, MaxFuncEvals = 5000,
using .MOOBData
plt = plot_opt(optsnes5000)
saveplot(plt,"snes5000")
#\textoutput{plotopt7}