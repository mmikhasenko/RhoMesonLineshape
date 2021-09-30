# Analysis example "Rho Meson Lineshape"

It is an example repository showing the transformation of the code from notebook to structured project.

## Notebook prototype
The analysis is prototyped in `Pluto` notebook. It can be run with
```julia
# open julia terminal
using Pluto
Pluto.run()
# open file notebooks/poleanalysis.jl
```
The notebook file contains description of all dependences in it. Might take some time for installing all requirements when run for the first time.

## Structured project
The code is split into the source code (building models, common utils, i/o interfaces) and put to `src/` folder.
The analysis is split into three parts:
1. model building `scripts/buildmodels.jl`: construct and test the models
2. analysis of the poles and error propagation `scripts/poleanalysis.jl`
3. plotting symmary `scripts/polesummary.jl`

The script `scripts/poleanalysis.jl` save intermediate results into JSON file that is read for plotting in `scripts/polesummary.jl`.

Running the analysis code:
```julia
# open julia terminal
cd(PROJECT_FILDER) # pwd() for novigation
] activate .
include("scripts/poleanalysis.jl") # to run the analysis
include("scripts/polesummary.jl") # to produce the plot with the summary
```
As the result, the plot `plots/polesummary.pdf` will get updated.


The code can also be run by `bash` with the line
```bash
julia scripts/poleanalysis.jl
```

Correct environment is set by placing the lines
```julia
using Pkg
cd(joinpath(@__DIR__,".."))
Pkg.activate(".")
```
at the beginning of every script.

## Further notes

Reproducibility:
 - `Project.toml` describe all explicit dependences of the project
 - `Manifest.toml` describe all dependences of the project with exact versions

Please create an issue to this repository in case something is not working.
