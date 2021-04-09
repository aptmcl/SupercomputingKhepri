# This file was generated, do not modify it. # hide
#hideall
#opt = bbsetup(displacement_obj; Method=:xnes, SearchRange = [(-6.0, 6.0), (-6.0, 6.0)], MaxFuncEvals = 5000, Workers = workers())
using .MOOBData
plt = plot_opt(optxnes5000)
saveplot(plt,"xnes5000")
#\textoutput{plotopt2}