# This file was generated, do not modify it. # hide
#hideall
#opt = bbsetup(displacement_obj3; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0), (1.0, 20.0)], MaxFuncEvals = 2000,
using .MOOBData
plt = plot_opt(optxnex3V)
saveplot(plt,"xnes3V")
#\textoutput{plotopt5}