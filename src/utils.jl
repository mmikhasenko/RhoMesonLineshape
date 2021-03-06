# io

function writejson(path, obj)
    open(path, "w") do io
        JSON.print(io, obj, 4)
    end
end

function readjson(path)
    f = read(path, String)
    return JSON.parse(f)
end


# pole

function pole_search(a::lineshape)
	optimresult = optimize(x->abs2(1/amplitude(a,x[1]+1im*x[2])), [mρ_pdg.val, Γρ_pdg.val/2])
	m_pole, Γ_pole_half = Optim.minimizer(optimresult)
	Γ_pole = -Γ_pole_half*2
	return (; m_pole, Γ_pole)
end

# stat

function mean_cov(sample)
	x = getindex.(sample,1)
	y = getindex.(sample,2)
	xy = [x,y]
	mean.([x,y]), [cov(i,j) for i in [x,y], j in [x,y]]
end
