export SG_Filter, maxDerivativeOrder, polynomialOrder, apply_SG_filter, apply_SG_filter2D

import Base: filter, length

function _Vandermonde(T::DataType=Float64;halfWidth::Int=5,degree::Int=2)::Array{T,2}
    
    @assert halfWidth>=0
    @assert degree>=0
    
    x=T[i for i in -halfWidth:halfWidth]

    n = degree+1
    m = length(x)
    
    V = Array{T}(undef,m, n)
    
    for i = 1:m
        V[i,1] = T(1)
    end
    for j = 2:n
        for i = 1:m
            V[i,j] = x[i] * V[i,j-1]
        end
    end

    return V
end


#+SG_Filters
#
# A structure to store Savitzky-Golay filters.
#
struct SG_Filter{T<:AbstractFloat,N}
    _filter_set::Array{LinearFilter_DefaultCentered{T,N},1}
end
#+SG_Filters
#
# Returns the filter to be used to compute the  smoothed derivatives of order *derivativeOrder*.
#
function filter(sg::SG_Filter{T,N};derivativeOrder::Int=0) where {T<:AbstractFloat,N}
    @assert 0<= derivativeOrder <= maxDerivativeOrder(sg)
    return sg._filter_set[derivativeOrder+1]
end 
#+SG_Filters
#
# Returns filter length, this is an odd number, see [[SG_Filters_Constructor][]]
length(sg::SG_Filter{T,N}) where {T<:AbstractFloat,N} = length(filter(sg))
#+SG_Filters
#
# Maximum order of the smoothed derivatives we can compute with *sg*
#
maxDerivativeOrder(sg::SG_Filter{T,N}) where {T<:AbstractFloat,N} = size(sg._filter_set,1)-1
#+SG_Filters
# Returns the degree of the polynomial used to construct the Savitzky-Golay filters, see [[SG_Filters_Constructor][]].
polynomialOrder(sg::SG_Filter{T,N}) where {T<:AbstractFloat,N} = maxDerivativeOrder(sg)
    
#+SG_Filters L:SG_Filters_Constructor
#
# Creates a set of Savitzky-Golay filters
#
# - filter length is 2*halfWidth+1
# - polynomial degree is degree
#
function SG_Filter(T::DataType=Float64;halfWidth::Int=5,degree::Int=2)::SG_Filter
    @assert degree>=0
    @assert halfWidth>=1
    @assert 2*halfWidth>degree
    
    V=_Vandermonde(T,halfWidth=halfWidth,degree=degree)
    Q,R=qr(V)
    # breaking change in Julia V1.0,
    # see https://github.com/JuliaLang/julia/issues/27397
    #
    # before Q was a "plain" matrix, now stored in compact form
    #
    # SG=R\Q'
    #
    # must be replaced by
    #
    # Q=Q*Matrix(I, size(V))
    # SG=R\Q'
    #
    Q=Q*Matrix(I, size(V))
    SG=R\Q'

    n_filter,n_coef = size(SG)

    buffer=Array{LinearFilter_DefaultCentered{T,n_coef},1}()
    
    for i in 1:n_filter
        SG[i,:]*=factorial(i-1)
        push!(buffer,LinearFilter(SG[i,:]))
    end
    
# Returns filters set
    return SG_Filter{T,n_coef}(buffer)
end

# +SG_Filters
#
# Applies SG filter to 1D signal
#
# *Returns:*
# - the smoothed signal
#
function apply_SG_filter(signal::Array{T,1},
                         sg::SG_Filter{T};
                         derivativeOrder::Int=0,
                         left_BE::Type{<:BoundaryExtension}=ConstantBE,
                         right_BE::Type{<:BoundaryExtension}=ConstantBE) where {T<:AbstractFloat}
    
    return directCrossCorrelation(filter(sg,derivativeOrder=derivativeOrder),
                                  signal,
                                  left_BE,
                                  right_BE)
end

# +SG_Filters
#
# Applies SG filter to 2D signal
#
# *Returns:*
# - the smoothed signal
#
function apply_SG_filter2D(signal::Array{T,2},
                           sg_I::SG_Filter{T},
                           sg_J::SG_Filter{T};
                           derivativeOrder_I::Int=0,
                           derivativeOrder_J::Int=0,
                           min_I_BE::Type{<:BoundaryExtension}=ConstantBE,
                           max_I_BE::Type{<:BoundaryExtension}=ConstantBE,
                           min_J_BE::Type{<:BoundaryExtension}=ConstantBE,
                           max_J_BE::Type{<:BoundaryExtension}=ConstantBE) where {T<:AbstractFloat}
    
    return directCrossCorrelation2D(filter(sg_I,derivativeOrder=derivativeOrder_I),
                                    filter(sg_J,derivativeOrder=derivativeOrder_J),
                                    signal,
                                    min_I_BE,
                                    max_I_BE,
                                    min_J_BE,
                                    max_J_BE)
end 
