
using RhoMesonLineshape # my project

##                            _|            
##    _|_|_|    _|_|      _|_|_|    _|_|    
##  _|        _|    _|  _|    _|  _|_|_|_|  
##  _|        _|    _|  _|    _|  _|        
##    _|_|_|    _|_|      _|_|_|    _|_|_|  

# construct models
a0 = constwidthappr(mρ_pdg.val, Γρ_pdg.val)
a1 = depwidthapprox(mρ_pdg.val, Γρ_pdg.val)

# analysis the pole
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
            :mean => mean_cov1[1],
            :cov  => mean_cov1[2]),
        :model2pars => Dict(
            :mean => mean_cov2[1],
            :cov  => mean_cov2[2])
    ))
