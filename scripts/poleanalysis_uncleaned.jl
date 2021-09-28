
using Plots
using LaTeXStrings
using Measurements
using JLD2
using Optim
using StatsPlots
using Statistics

theme(:wong, lab="", grid=false, frame=:box,
	xlims=(:auto,:auto), ylims=(:auto,:auto), lw=2)

#
const mπ = 0.14
#
const mρ_pdg = 0.77526 ± 23e-3
const Γρ_pdg = 0.1474 ± 0.8e-3

#  _|_|_|  _|_|      _|_|    _|      _|    _|_|    
#  _|    _|    _|  _|    _|  _|      _|  _|_|_|_|  
#  _|    _|    _|  _|    _|    _|  _|    _|        
#  _|    _|    _|    _|_|        _|        _|_|_|  

phasespace(e) = sqrt(1-4mπ^2/e^2)

plot(phasespace, 2mπ, 1.5)

abstract type lineshape end
struct constwidthappr{T} <: lineshape
    m::T
    Γ::T
end

amplitude(l::constwidthappr, e) = 1/(l.m^2-e^2-1im*l.m*l.Γ)
intenisty(l::lineshape, e) = abs2(amplitude(l,e))*phasespace(e)

@recipe function f(::Type{Val{:intensityplot}}, x, y, z)
    seriestype := :path
    return (e->intenisty(x, e))
end

a0 = constwidthappr(mρ_pdg.val, Γρ_pdg.val)

save("constwidthappr.jld2", Dict("model" => a0))

plot(e->intenisty(a0, e), 2mπ, 1.5, l=:red)
# plot(a0, 2mπ, 1.4, seriestype=:intensityplot)


struct depwidthapprox{T} <: lineshape
    m::T
    Γ::T
end
function amplitude(l::depwidthapprox, e)
    depfactor = phasespace(e) / phasespace(l.m)
    Γ = l.Γ * depfactor
    1/(l.m^2-e^2-1im*l.m*Γ)
end

a1 = depwidthapprox(mρ_pdg.val, Γρ_pdg.val)

plot(e->intenisty(a1, e), 2mπ, 1.4, l=:red)
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

optimresult = optimize(x->abs2(1/amplitude(a1,x[1]+1im*x[2])), [mρ_pdg, Γρ_pdg/2])

Optim.minimizer(optimresult)

function pole_search(a::lineshape)
	optimresult = optimize(x->abs2(1/amplitude(a,x[1]+1im*x[2])), [mρ_pdg.val, Γρ_pdg.val/2])
	m_pole, Γ_pole_half = Optim.minimizer(optimresult)
	Γ_pole = -Γ_pole_half*2
	return (; m_pole, Γ_pole)
end

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

function mean_cov(sample)
	x = getindex.(sample,1)
	y = getindex.(sample,2)
	xy = [x,y]
	mean.([x,y]), [cov(i,j) for i in [x,y], j in [x,y]]
end


sqrt(5.99)

covellipse(mean_cov(constwidth_pole_sample)..., n_std=sqrt(5.99))
scatter!(constwidth_pole_sample)

covellipse( mean_cov(constwidth_pole_sample)..., n_std=sqrt(5.99))
covellipse!(mean_cov(depwidth_pole_sample)..., n_std=sqrt(5.99))
