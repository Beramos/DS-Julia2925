#=
Created on 05/01/2021 20:52:11
Last update: 8/01/2020

@author: Michiel Stock
michielfmstock@gmail.com

Implementation of basic shapes as an introduction of the type system.
=#

abstract type Shape end

# RECTANGLE
# ---------

xycoords(s::Shape) = [first(p) for p in corners(s)], [last(p) for p in corners(s)]

mutable struct Rectangle <: Shape
    x::Float64
    y::Float64
    l::Float64
    w::Float64
end

Rectangle((x, y), l, w=l) = Rectangle(x, y, l, w)

area(shape::Rectangle) = shape.l * shape.w
ncorners(::Rectangle) = 4
center(shape::Shape) = shape.x, shape.y

function scale!(shape::Rectangle, a)
    @assert a > 0
    shape.l *= a
    shape.w *= a
end

function corners(shape::Rectangle)
    x, y = center(shape)
    l, w = shape.l, shape.w
    return [(x+w/2, y+l/2), (x-w/2, y+l/2), (x-w/2, y-l/2), (x+w/2, y-l/2)]
end

function move!(shape::Shape, (dx, dy))
    shape.x += dx
    shape.y += dy
end

arthur = Rectangle((0, 0), 5)


# REGULAR POLYGON
# ---------------

mutable struct Polygon <: Shape
    x::Float64
    y::Float64
    n::Int
    R::Float64
end

Polygon((x, y), n, R=1) = Polygon(x, y, n, r)

ncorners(shape::Polygon) = shape.n

function corners(shape::Polygon)
    x, y = center(shape)
    R = shape.R
    n = shape.n
    return [(x+R*cos(θ), y+R*sin(θ)) for θ in range(0, step=2π/n, length=n)]
end

function area(shape::Polygon)
    R = shape.R
    n = shape.n
    θ = 2π / n  # angle of a triangle
    h = R * cos(θ/2)
    b = R * sin(θ/2)
    return b * h * n
end

# CIRCLE
# ------

mutable struct Circle <: Shape
    x::Float64
    y::Float64
    R::Float64
end

Circle((x, y), R=1) = Circle(x, y, R)

ncorners(::Circle) = 0
area(shape::Circle) = shape.R^2 * π

function xycoords(shape::Circle; n=50)
    θs = range(0, 2π, length=n)
    return shape.x .+ shape.R * cos.(θs), shape.y .+ shape.R * sin.(θs)
end

function scale!(shape::Union{Circle,Polygon}, a)
    shape.R *= a
    shape
end

# TRIANGLE
# --------

mutable struct Triangle <: Shape
    x1::Float64
    x2::Float64
    x3::Float64
    y1::Float64
    y2::Float64
    y3::Float64
end


Triangle((x1, y1), (x2, y2), (x3, y3)) = Triangle(x1, x2, x3, y1, y2, y3)

ncorners(::Triangle) = 3
corners(t::Triangle) = [(t.x1, t.y1), (t.x2, t.y2), (t.x3, t.y3)]

function center(t::Triangle)
    (x1, y1), (x2, y2), (x3, y3) = corners(t)
    return ((x1 + x2 + x3) / 3, (y1 + y2 + y3) / 3)
end

function area(t::Triangle)
    (x1, y1), (x2, y2), (x3, y3) = corners(t)
    return abs(x1*y2 + x2*y3 + x3*y1 - y1*x2 - y2*x3 - y3*x1) / 2
end


function move!(shape::Triangle, (dx, dy))
    shape.x1 += dx
    shape.x2 += dx
    shape.x3 += dx
    shape.y1 += dy
    shape.y2 += dy
    shape.y3 += dy
    shape
end

bill = Triangle((0, 0), (1, 0), (0.5, √(1-0.5)))


# Plotting

using RecipesBase

@recipe function f(s::Shape)
    xguide --> "x"
    yguide --> "y"
    label --> ""
    aspect_ratio := :equal
    seriestype := :shape
    y, y = xycoords(s)
    return y, y
end

using Plots

plot(bill, color=:yellow)

