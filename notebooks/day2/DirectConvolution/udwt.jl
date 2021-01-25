export UDWT_Filter_Haar, UDWT_Filter_Starck2
export ϕ_filter,ψ_filter,tildeϕ_filter,tildeψ_filter
export udwt, scale, inverse_udwt!, inverse_udwt

import Base: length



#+UDWT_Filter
#
# Abstract type defining the $\phi$, $\psi$, $\tilde{\phi}$ and
# $\tilde{\psi}$ filters associated to an undecimated biorthogonal
# wavelet transform
abstract type UDWT_Filter_Biorthogonal{T<:Number} end

#+UDWT_Filter
ϕ_filter(c::UDWT_Filter_Biorthogonal)::LinearFilter = c._ϕ_filter
#+UDWT_Filter
ψ_filter(c::UDWT_Filter_Biorthogonal)::LinearFilter = c._ψ_filter
#+UDWT_Filter
tildeϕ_filter(c::UDWT_Filter_Biorthogonal)::LinearFilter = c._tildeϕ_filter
#+UDWT_Filter
tildeψ_filter(c::UDWT_Filter_Biorthogonal)::LinearFilter = c._tildeψ_filter



#+UDWT_Filter
#
# A specialization of UDWT_Filter_Biorthogonal for *orthogonal* filters.
#
#
# For orthogonal filters we have: $\phi=\tilde{\phi}$ and $\psi=\tilde{\psi}$
# 
abstract type UDWT_Filter{T<:Number} <: UDWT_Filter_Biorthogonal{T}
end

#+UDWT_Filter
tildeϕ_filter(c::UDWT_Filter)::LinearFilter = ϕ_filter(c)

#+UDWT_Filter
tildeψ_filter(c::UDWT_Filter)::LinearFilter = ψ_filter(c)


# Filter examples


#+UDWT_Filter_Available
# Haar filter
struct UDWT_Filter_Haar{T<:AbstractFloat} <: UDWT_Filter{T}
    _ϕ_filter::LinearFilter_Default{T,2}
    _ψ_filter::LinearFilter_Default{T,2}

    #+UDWT_Filter_Available
    # Creates an instance
    UDWT_Filter_Haar{T}() where {T<:Real} = new(LinearFilter_Default{T,2}(SVector{2,T}([+1/2 +1/2]),0),
                                                LinearFilter_Default{T,2}(SVector{2,T}([-1/2 +1/2]),0))
end



#+UDWT_Filter_Available
# Starck2 filter
#
# Defined by Eq. 6 from http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4060954
struct UDWT_Filter_Starck2{T<:AbstractFloat} <: UDWT_Filter_Biorthogonal{T}
    _ϕ_filter::LinearFilter_DefaultCentered{T,5}
    _ψ_filter::LinearFilter_DefaultCentered{T,5}
    _tildeϕ_filter::LinearFilter_DefaultCentered{T,1}
    _tildeψ_filter::LinearFilter_DefaultCentered{T,1}

    #+UDWT_Filter_Available
    # Creates an instance
    UDWT_Filter_Starck2{T}() where {T<:Real} = new(LinearFilter_DefaultCentered{T,5}(SVector{5,T}([+1/16 +4/16 +6/16 +4/16 +1/16])),
                                                   LinearFilter_DefaultCentered{T,5}(SVector{5,T}([-1/16 -4/16 +10/16 -4/16 -1/16])),
                                                   LinearFilter_DefaultCentered{T,1}(SVector{1,T}([+1])),
                                                   LinearFilter_DefaultCentered{T,1}(SVector{1,T}([+1])))
end


#+UDWT
# A structure to store 1D UDWT
#
struct UDWT{T<:Number}

    filter::UDWT_Filter_Biorthogonal{T}
    # TODO also store boundary condition

    W::Array{T,2}
    V::Array{T,1}

    #+UDWT
    # Creates an instance
    #
    # *Parameters:*
    # - *filter*: used filter
    # - *scale* : max scale
    # - *n*: signal length
    #
    UDWT{T}(filter::UDWT_Filter_Biorthogonal{T};
            n::Int=0,
            scale::Int=0) where {T<:Number} =
                new(filter,
                    Array{T,2}(undef,n,scale),
                    Array{T,1}(undef,n))
end

#+UDWT
# Returns max scale
scale(udwt::UDWT)::Int = size(udwt.W,2)
#+UDWT
# Returns expected signal length
length(udwt::UDWT)::Int = size(udwt.W,1)

#+UDWT
#
# Performs an 1D undecimated wavelet transform
#
# $$(\mathcal{W}_{j+1}f)[u]=(\bar{g}_j*\mathcal{V}_{j}f)[u]$$
# $$(\mathcal{V}_{j+1}f)[u]=(\bar{h}_j*\mathcal{V}_{j}f)[u]$$
# 
function udwt(signal::AbstractArray{T,1},
              filter::UDWT_Filter_Biorthogonal{T};
              scale::Int=3) where {T<:Number}

    @assert scale>=0

    boundary = PeriodicBE
    n = length(signal)
    udwt_domain = UDWT{T}(filter,n=n,scale=scale)
    Ωγ = 1:n

    Vs = Array{T,1}(undef,n)
    Vsp1 = Array{T,1}(undef,n)
    Vs .= signal

    for s in 1:scale
        twoPowScale = 2^(s-1)
        Wsp1 = @view udwt_domain.W[:,s]
        
        # Computes Vs+1 from Vs
        #
        directConv!(ϕ_filter(filter),
                    twoPowScale,

                    Vs,
                    
                    Vsp1,
                    Ωγ,
                    
                    boundary,
                    boundary)

        
        # Computes Ws+1 from Ws
        #
        directConv!(ψ_filter(filter),
                    twoPowScale,

                    Vs,
                    
                    Wsp1,
                    Ωγ,
                    
                    boundary,
                    boundary)

        @swap(Vs,Vsp1)
        
    end

    udwt_domain.V .= Vs

    return udwt_domain
end

# +UDWT
#
# Performs an 1D *inverse* undecimated wavelet transform
#
# *Caveat:* uses a pre-allocated vector =reconstructed_signal=
#
function inverse_udwt!(udwt_domain::UDWT{T},
                       reconstructed_signal::AbstractArray{T,1}) where {T<:Number}

    @assert length(udwt_domain) == length(reconstructed_signal)

    boundary = PeriodicBE
    maxScale = scale(udwt_domain)
    n = length(reconstructed_signal)
    Ωγ = 1:n
    buffer = Array{T,1}(undef,n)
    
    reconstructed_signal .= udwt_domain.V

    
    for s in maxScale:-1:1
        twoPowScale = 2^(s-1)
        
        # Computes Vs from Vs+1
        #
        directConv!(tildeϕ_filter(udwt_domain.filter),
                    -twoPowScale,
                    
                    reconstructed_signal,
                    
                    buffer,
                    Ωγ,
                    
                    boundary,
                    boundary)

        # Computes Ws from Ws+1
        #
        Ws = @view udwt_domain.W[:,s]

        directConv!(tildeψ_filter(udwt_domain.filter),
                    -twoPowScale,
                    
                    Ws,
                    
                    buffer,
                    Ωγ,
                    
                    boundary,
                    boundary,
                    accumulate=true)

        for i in Ωγ
            @inbounds reconstructed_signal[i]=buffer[i]
        end
    end
end

#+UDWT
#
# Performs an 1D *inverse* undecimated wavelet transform
#
# *Returns:* a vector containing the reconstructed signal.
#
function inverse_udwt(udwt_domain::UDWT{T})::Array{T,1} where {T<:Number}
    reconstructed_signal=Array{T,1}(undef,length(udwt_domain))
    inverse_udwt!(udwt_domain,reconstructed_signal)
    return reconstructed_signal
end


