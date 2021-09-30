module RhoMesonLineshape

using Measurements
using Optim
using Statistics
using JSON

export mπ, mρ_pdg, Γρ_pdg
include("constants.jl")

export lineshape
export constwidthappr, depwidthapprox
export amplitude, phasespace, intenisty
include("model.jl")

export writejson, readjson
export mean_cov, pole_search
include("utils.jl")

end # module
