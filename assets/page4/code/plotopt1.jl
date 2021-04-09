# This file was generated, do not modify it. # hide
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals = 1000, Workers = workers())
using .MOOBData
plt = plot_opt(opt_xnes)
saveplot(plt,"xnes1000")
#\textoutput{plotopt1}