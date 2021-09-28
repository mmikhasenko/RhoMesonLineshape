
using Plots
using LaTeXStrings
using Measurements
using JLD2
using Optim
using StatsPlots
using Statistics

theme(:wong, lab="", grid=false, frame=:box,
	xlims=(:auto,:auto), ylims=(:auto,:auto), lw=2)

using RhoMesonLineshape

#                            _|            
#    _|_|_|    _|_|      _|_|_|    _|_|    
#  _|        _|    _|  _|    _|  _|_|_|_|  
#  _|        _|    _|  _|    _|  _|        
#    _|_|_|    _|_|      _|_|_|    _|_|_|  


a0 = constwidthappr(mρ_pdg.val, Γρ_pdg.val)

a1 = depwidthapprox(mρ_pdg.val, Γρ_pdg.val)

# plot(e->intenisty(a1, e), 2mπ, 1.4, l=:red)
# plot(a0, 2mπ, 1.3, seriestype=:intensityplot)

plotly()
let
    xv = 0.1:0.01:1
    surface(xv, -0.25:0.01:0.25,
            (x,y)->log(abs2(amplitude(a1,x+1im*y))),
        colorbar=false, xlab="Re e [MeV]", ylab="Im e [MeV]")
    plot!(xv, zero(xv), map(e->log(abs2(amplitude(a1, e+1e-7im))), xv), l=(3,:red))
end

gr()
contour(0.1:0.01:1, -0.25:0.01:0.25,
        (x,y)->log(abs2(1/amplitude(a1,x+1im*y))),
        levels=20, colorbar=false)
hline!([0], l=(:red,2))



Optim.minimizer(optimresult)

pole_search(a1)

pole_search(a0)



constwidth_pole_sample = [pole_search(constwidthappr(
		mρ_pdg.val+randn()*mρ_pdg.err,
		Γρ_pdg.val+randn()*Γρ_pdg.err)) for _ in 1:1000]

depwidth_pole_sample = [pole_search(depwidthapprox(
		mρ_pdg.val+randn()*mρ_pdg.err,
		Γρ_pdg.val+randn()*Γρ_pdg.err)) for _ in 1:1000]
# 
scatter(constwidth_pole_sample)
scatter!(depwidth_pole_sample)


sqrt(5.99)

covellipse(mean_cov(constwidth_pole_sample)..., n_std=sqrt(5.99))
scatter!(constwidth_pole_sample)

covellipse( mean_cov(constwidth_pole_sample)..., n_std=sqrt(5.99))
covellipse!(mean_cov(depwidth_pole_sample)..., n_std=sqrt(5.99))
