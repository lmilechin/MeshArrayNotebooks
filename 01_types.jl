# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.4'
#       jupytext_version: 1.2.1
#   kernelspec:
#     display_name: Julia 1.1.0
#     language: julia
#     name: julia-1.1
# ---

# ## `MeshArrays` represent global gridded variables
#
# Each `MeshArray` contains an array of elementary arrays that (1) are connected at their edges and (2) collectively form a global grid. Global grid specifications are contained within `gcmgrid` instances.
#
# #### First, let's load the `MeshArrays.jl` package

using MeshArrays

# #### Select a pre-defined grid such as `LLC90`

mygrid=GridSpec("LLC90")

# And download the pre-defined grid if needed

!isdir("GRID_LLC90") ? run(`git clone https://github.com/gaelforget/GRID_LLC90`) : nothing

# #### Read a MeshArray from file
#
# Read a global field from binary file and convert it to `MeshArrays`'s `gcmfaces` type

D=mygrid.read(mygrid.path*"Depth.data",MeshArray(mygrid,Float64))
show(D)

p=dirname(pathof(MeshArrays));
using Plots; include(joinpath(p,"Plots.jl"));
heatmap(D,title="Ocean Depth",clims=(0.,6000.))


# The read / write functions can also be used to convert a MeshArray from / to Array

tmp1=write(D)
tmp2=read(tmp1,D)

# #### MeshArrays should behave just like Arrays
#
# Here are a few examples that would be coded similarly in both cases

# +
size(D)
eltype(D)
view(D,:)

D .* 1.0
D .* D
1000*D
D*1000

D[findall(D .> 300.)] .= NaN
D[findall(D .< 1.)] .= NaN

D[1]=0.0 .+ D[1]
tmp=cos.(D)
# -

