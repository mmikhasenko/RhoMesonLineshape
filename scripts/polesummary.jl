using Pkg
cd(joinpath(@__DIR__,".."))
Pkg.activate(".")

using RhoMesonLineshape # my project

using Parameters
using Plots
using LaTeXStrings
using Measurements
using StatsPlots

theme(:wong, lab="", grid=false, frame=:box, lw=2)


#                            _|            
#    _|_|_|    _|_|      _|_|_|    _|_|    
#  _|        _|    _|  _|    _|  _|_|_|_|  
#  _|        _|    _|  _|    _|  _|        
#    _|_|_|    _|_|      _|_|_|    _|_|_|  

# read the results
poleanalysis = readjson(joinpath("results","poleanalysis.json"))
# 
@unpack model1pars = poleanalysis
nom1 = getindex.(vcat(model1pars["nom"]...),2)
mean1 = vcat(model1pars["mean"]...)
cov1  = hcat(model1pars["cov"]...)
# 
@unpack model2pars = poleanalysis
# 
nom2 = getindex.(vcat(model2pars["nom"]...),2)
mean2 = vcat(model2pars["mean"]...)
cov2  = hcat(model2pars["cov"]...)
# 

# plot summary
const chi2_95 = 5.99
# 
let
	plot(title=L"\rho\textrm{-}\mathrm{meson\,\,pole\,\,position}")
	covellipse!(mean1, cov1, n_std=sqrt(chi2_95), lab=L"\mathrm{model\,\,1}")
	covellipse!(mean2, cov2, n_std=sqrt(chi2_95), lab=L"\mathrm{model\,\,2}")
	scatter!([nom1[1] nom2[1]], [nom1[2] nom2[2]], c=[1 2], ms=5, lab="")
	plot!(xlab=L"\mathrm{pole\,\,mass\,\,[GeV]}",
		ylab=L"\mathrm{pole\,\,width\,\,[GeV]}")
end
savefig(joinpath("plots","polesummary.pdf"))