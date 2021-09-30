using RhoMesonLineshape # my project

using Plots

theme(:wong, lab="", grid=false, frame=:box,
	xlims=(:auto,:auto), ylims=(:auto,:auto), lw=2)

##                            _|            
##    _|_|_|    _|_|      _|_|_|    _|_|    
##  _|        _|    _|  _|    _|  _|_|_|_|  
##  _|        _|    _|  _|    _|  _|        
##    _|_|_|    _|_|      _|_|_|    _|_|_|  

a0 = constwidthappr(mρ_pdg.val, Γρ_pdg.val)
a1 = depwidthapprox(mρ_pdg.val, Γρ_pdg.val)


# not check the complex plane for fun

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
