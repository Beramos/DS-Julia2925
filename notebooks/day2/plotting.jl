using Plots

#https://discourse.julialang.org/t/plots-only-one-series-as-primary-plot/24616
struct onlyone <: AbstractMatrix{Bool}
    v::Bool
end
function Base.iterate(o::onlyone, state=1)
      state == 1 ? o.v : !o.v, state+1
end
Base.size(o::onlyone) = (1,typemax(Int))
Base.length(o::onlyone) = typemax(Int)
Base.getindex(o::onlyone,i) = i == 1 ? o.v : !o.v
Base.getindex(o::onlyone,i,j) = j == 1 ? o.v : !o.v

# plot recipe for the spectrum
@recipe function plot(spectrum::Spectrum)
    #legend --> nothing # if legend is unset, make it nothing
    #label --> hcat(label, fill("",1,size(spectrum)[2]-1))
    xguide --> "wavelength"
    yguide --> "intensity"
    #linecolor --> :black
    primary := onlyone(true)
    #markercolor :=  customcolor  # force markercolor to be customcolor
    spectrum.x, spectrum.y # return the arguments (input data) for the next recipe
end


function plot_components(components::Dict{String, Spectrum})
    plot(palette=:Dark2_8)
    for component in keys(components)
        plot!(components[component]; label=component)
    end
    return current()
end