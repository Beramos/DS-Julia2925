module DirectConvolution

const RootDir = pathof(DirectConvolution)

using StaticArrays
using LinearAlgebra

include("utils.jl")
include("linearFilter.jl")
include("directConvolution.jl")
include("SG_Filter.jl")
include("udwt.jl")

end # module
