#=
Created on 30/01/2021 16:39:07
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Generates the figures for flatland.
=#

include("examples/flatland.jl")

# examples of shapes


square = Square((1, 1), l=2)
rectangle = Rectangle((2, 6), l=1, w=2.5)
circle = Circle((-2, 1), R=1)
pentagon = RegularPolygon((-3, 4), 5, R=1.2)
hexagon = RegularPolygon((-3.4, 7), 5, R=1.5, θ=0.7)
triangle = Triangle((-4, 1), (-1, -1), (-8, 1) )

plot(square, label="square", legend=:topleft)
plot!(rectangle, label="rectangle")
plot!(circle, label="circle")
plot!(pentagon, label="pentagon")
plot!(hexagon, label="hexagon")
plot!(triangle, label="triangle")
title!("Some shapes")
savefig("../img/boundingbox.svg")
savefig("../img/boundingbox.png")

# outline of regular polygon

plot(hexagon, legend=:topleft)
corn_hex = corners(hexagon)
scatter!(first.(corn_hex), last.(corn_hex), label="corners")
plot!([first(center(hexagon)), corn_hex[end][1]], [last(center(hexagon)), corn_hex[end][2]],
                label="radius R", lw=2, color="orange")
plot!([first(center(hexagon)), corn_hex[1][1]], [last(center(hexagon)), corn_hex[1][2]],
    label="angle theta", lw=2, color="red", ls=:dash)
hline!([7], lw=2, color="red", ls=:dash, label="")


# bounding box

plot(triangle)
vline!(xlim(triangle), label="xlims")
hline!(ylim(triangle), label="ylims")
plot!(boundingbox(triangle), ls=:dash, color="red", label="bounding box", fillcolor=nothing)

# in/out

points = [8rand(2) for i in 1:500]
pinrect = filter(p->p ∈ rectangle, points)
pnotinrect = filter(p->p ∉ rectangle, points)
plot(rectangle)
scatter!(first.(pinrect), last.(pinrect), label="point in shape")
scatter!(first.(pnotinrect), last.(pnotinrect), label="point not in shape")

# overlap

t1 = Triangle((0,0), (1, 0.4), (0.5, 0.7))
t2 = deepcopy(t1)
rotate!(t2, π/2)
move!(t2, (1, 0.2))
t3 = deepcopy(t1)
rotate!(t3, π/3)
move!(t3, (0.4, 0.2))

plot(t1, alpha=0.5)
plot!(t2, alpha=0.5)
plot!(t3, alpha=0.5)
plot!(boundingbox(t1), ls=:dash, color="red", fillcolor=nothing)
plot!(boundingbox(t2), ls=:dash, color="red", fillcolor=nothing)
plot!(boundingbox(t3), ls=:dash, color="red", fillcolor=nothing)
title!("Overlaping bounding boxes is a required,
    but not sufficient condition for overlap")
#title!("Overlaping bounding boxes is a required, but not sufficient condition for overlap")
savefig("../img/boundingbox.svg")
savefig("../img/boundingbox.png")


# examples

shapes1, trials1 = rejection_sampling(triangle, 50, (0, 100), (0, 100))
plotshapes(shapes1, title="50 triangles\n $trials1 trials")

small_large_squares = [Rectangle((0, 0), l=10, w=15) for i in 1:5]
append!(small_large_squares, [Rectangle((0, 0), l=1, w=1.5) for i in 1:25])
shapes2, trials2 = rejection_sampling!(small_large_squares, (0, 100), (0, 100))
plotshapes(small_large_squares, title="5 large and 25 small squares\n $trials2 trials")
