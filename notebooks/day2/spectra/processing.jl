import Statistics:mean, std

# the addition of SubArray to the type is necessary to allow the eachcol calls from a 2D input
function snv(y::Union{SubArray{Float64, 1}, Array{Float64, 1}}; std_offset=zero(1))::Array{Float64, 1}
    (y .- mean(y)) ./ (std(y) .+ std_offset)
end

function snv(y::Array{Float64, 2}; std_offset=zero(1))::Array{Float64, 2}
    hcat(snv.(eachcol(y); std_offset=std_offset)...)
end

include("DirectConvolution/DirectConvolution.jl")

function savitzkygolay(y::Union{SubArray{Float64, 1}, Array{Float64, 1}}; halfWidth::Int=5, degree::Int=2, derivativeOrder::Int=0)
    sg = DirectConvolution.SG_Filter(Float64, halfWidth=10, degree=5);
    smoothed = DirectConvolution.apply_SG_filter(y, sg, derivativeOrder=1)
    return smoothed
end

function savitzkygolay(y::Array{Float64, 2}; halfWidth::Int=5, degree::Int=2, derivativeOrder::Int=0)
    sg = DirectConvolution.SG_Filter(Float64, halfWidth=halfWidth, degree=degree);
    smoothed = hcat([DirectConvolution.apply_SG_filter(collect(y__), sg, derivativeOrder=derivativeOrder) for y__ in eachcol(y)]...)
    return smoothed
end


