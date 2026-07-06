#=
Created on 22/01/2023 17:08:41
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Turns our pluto notebook in HTML pages.
=#

using PlutoSliderServer

notebooks = [
    "notebooks/day1/01-basics.jl",
    "notebooks/day1/01-basics-extra.jl",
    "notebooks/day1/02-collections.jl",
    "notebooks/day1/03-exercises.jl",
    "notebooks/day2/01-types.jl",
    "notebooks/day2/02-composite_types.jl",
    "notebooks/day2/03-fluky_fields.jl",
    "notebooks/day2/04-metaprogramming.jl"]

for path in notebooks
    println("running $path...")
    PlutoSliderServer.export_notebook(path)
end