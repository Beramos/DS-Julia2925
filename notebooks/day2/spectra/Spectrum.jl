# load processing functions
include("processing.jl")

# define the layout for the Spectrum composite type
# it has 2 fields: x and y
# x is the wavelengths of the spectrum
# y is the measured spectrum.
mutable struct Spectrum
    x::Array{Float64, 1}
    # can be one or two dimensional
    # if 2D, each column is an experiment (dimensions checked in constructor)
    y::Array{Float64}
    Spectrum(x, y) = size(x)[1] === size(y)[1] ? new(x,y) : error("first dimension does not match")
end

# show an instance of Spectrum in a nice way by adding two new methods to Base.show
Base.show(io::IO, ::MIME"text/plain", s::Spectrum) = print(io, "Instance of Spectrum\n", "spectrum divided into $(size(s.x)[1]) parts, ranging from $(s.x[1]) to $(s.x[end])\n", "this instance contains $(size(s.y)[2]==1 ? "1 spectrum" : "$(size(s.y)[2]) spectra")")
Base.show(io::IO, s::Spectrum) = print(io, "$(size(s.y)[2]==1 ? "1 spectrum" : "$(size(s.y)[2]) spectra"), defined between $(s.x[1]) to $(s.x[end])")


# define processing functions on the new composite data type Spectrum
# see processing.jl for original definitions
function snv(spectrum::Spectrum; std_offset=zero(1))
    Spectrum(spectrum.x, snv(spectrum.y; std_offset=std_offset))
end
function savitzkygolay(spectrum::Spectrum; halfWidth::Int=5, degree::Int=2, derivativeOrder::Int=0)
    Spectrum(spectrum.x, savitzkygolay(spectrum.y; halfWidth=halfWidth, degree=degree, derivativeOrder=derivativeOrder))
end

# load plotting functions
include("plotting.jl")

# load data IO functions
include("read_data.jl")
