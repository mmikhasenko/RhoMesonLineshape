
abstract type lineshape end

struct constwidthappr{T} <: lineshape
    m::T
    Γ::T
end
amplitude(l::constwidthappr, e) = 1/(l.m^2-e^2-1im*l.m*l.Γ)


struct depwidthapprox{T} <: lineshape
    m::T
    Γ::T
end
function amplitude(l::depwidthapprox, e)
    depfactor = phasespace(e) / phasespace(l.m)
    Γ = l.Γ * depfactor
    1/(l.m^2-e^2-1im*l.m*Γ)
end

phasespace(e) = sqrt(1-4mπ^2/e^2)

intenisty(l::lineshape, e) = abs2(amplitude(l,e))*phasespace(e)
