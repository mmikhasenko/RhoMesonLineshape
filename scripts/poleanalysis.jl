using Pkg
cd(joinpath(@__DIR__,".."))
Pkg.activate(".")

using RhoMesonLineshape # my project

##                            _|            
##    _|_|_|    _|_|      _|_|_|    _|_|    
##  _|        _|    _|  _|    _|  _|_|_|_|  
##  _|        _|    _|  _|    _|  _|        
##    _|_|_|    _|_|      _|_|_|    _|_|_|  

# construct models
a1 = constwidthappr(mρ_pdg.val, Γρ_pdg.val)
a2 = depwidthapprox(mρ_pdg.val, Γρ_pdg.val)

# analysis the pole

val1 = pole_search(a1)
val2 = pole_search(a2)

const Nbootstrap = 1000

constwidth_pole_sample = [pole_search(constwidthappr(
		mρ_pdg.val+randn()*mρ_pdg.err,
		Γρ_pdg.val+randn()*Γρ_pdg.err)) for _ in 1:Nbootstrap]

depwidth_pole_sample = [pole_search(depwidthapprox(
		mρ_pdg.val+randn()*mρ_pdg.err,
		Γρ_pdg.val+randn()*Γρ_pdg.err)) for _ in 1:Nbootstrap]
# 
mean_cov1 = mean_cov(constwidth_pole_sample)
mean_cov2 = mean_cov(depwidth_pole_sample)

# save results
writejson(joinpath("results","poleanalysis.json"),
    Dict(
        :model1pars => Dict(
            :nom => val1,
            :mean => mean_cov1[1],
            :cov  => mean_cov1[2]),
        :model2pars => Dict(
            :nom => val2,
            :mean => mean_cov2[1],
            :cov  => mean_cov2[2])
    ))
