#=
Created on 05/01/2021 20:52:11
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Implementation of basic shapes as an introduction of the type system.
=#

abstract type Shape end

mutable struct Triangle <: Shape
    x1::Float64
    x2::Float64
    x3::Float64
    y1::Float64
    y2::Float64
    y3::Float64
end

xcoords(s::Shape) = [first(p) for p in corners(s)]
ycoords(s::Shape) = [last(p) for p in corners(s)]


Triangle((x1, y1), (x2, y2), (x3, y3)) = Triangle(x1, x2, x3, y1, y2, y3)

ncorners(::Triangle) = 3
corners(t::Triangle) = (t.x1, t.y1), (t.x2, t.y2), (t.x3, t.y3)

center(t::Triangle) = corners(t) |> (p1, p2, p3) -> (p1 .+ p2 .+ p3) / 3

Bill = Triangle((0, 0), (1, 0), (0.5, √(1-0.5)))


abstract type Quadrilateral end


using RecipesBase

@recipe function f(s::Shape)
    xguide --> "x"
    yguide --> "y"
    aspect_ratio := :equal
    x = xcoors(s)
    y = ycoors(s)
    seriestype := :shape
    xcoords(s), ycoords(s)
end

using Plots

plot(Bill, color=:yellow)

