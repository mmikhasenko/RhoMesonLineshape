using RhoMesonLineshape # my project

using Parameters
using Plots
using LaTeXStrings
using Measurements
using StatsPlots

theme(:wong, lab="", grid=false, frame=:box,
	xlims=(:auto,:auto), ylims=(:auto,:auto), lw=2)


#                            _|            
#    _|_|_|    _|_|      _|_|_|    _|_|    
#  _|        _|    _|  _|    _|  _|_|_|_|  
#  _|        _|    _|  _|    _|  _|        
#    _|_|_|    _|_|      _|_|_|    _|_|_|  

# read the results
poleanalysis = readjson(joinpath("results","poleanalysis.json"))
# 
@unpack model1pars = poleanalysis
mean1 = vcat(model1pars["mean"]...)
cov1  = hcat(model1pars["cov"]...)
# 
@unpack model2pars = poleanalysis
# 
mean2 = vcat(model2pars["mean"]...)
cov2  = hcat(model2pars["cov"]...)
# 

# plot summary
const chi2_95 = 5.99
# 
covellipse( mean1, cov1, n_std=sqrt(chi2_95))
covellipse!(mean2, cov2, n_std=sqrt(chi2_95))
