#=
Created on 05/01/2021 20:52:11
Last update: 26/01/2020

@author: Michiel Stock
michielfmstock@gmail.com

Implementation of basic shapes as an introduction of the type system.
=#



# TYPES
# -----

abstract type Shape end

abstract type AbstractRectangle end

mutable struct Rectangle <: AbstractRectangle
    x::Float64
    y::Float64
    l::Float64
    w::Float64
    function Rectangle((x, y); l=1.0, w=1.0)
        return new(x, y, l, w)
    end
end

mutable struct Square <: AbstractRectangle
    x::Float64
    y::Float64
    l::Float64
    function Square((x, y); l=1.0)
        return new(x, y, l)
    end
end

mutable struct RegularPolygon{N} <: Shape 
    x::Float64
    y::Float64
    R::Float64
    θ::Float64  # angle
    function RegularPolygon((x, y), n; R=1.0, θ=0.0)
        return new{n}(x, y, R, θ)
    end
end

mutable struct Circle <: Shape
    x::Float64
    y::Float64
    R::Float64
    function Circle((x, y); R=1.0)
        return new(x, y, R)
    end
end

abstract type AbstractTriangle <: Shape end

mutable struct Triangle <: AbstractTriangle
    x1::Float64
    x2::Float64
    x3::Float64
    y1::Float64
    y2::Float64
    y3::Float64
    Triangle((x1, y1), (x2, y2), (x3, y3)) = new(x1, x2, x3, y1, y2, y3)
end

# examples

rect = Rectangle((1, 2), l=1, w=2)
square = Square((0, 1))
triangle = Triangle((1, 2), (4, 5), (7, -10))
pent = RegularPolygon((0, 0), 5)
circle = Circle((10, 10))

# corners and center

ncorners(::AbstractRectangle) = 4
ncorners(::AbstractTriangle) = 3
ncorners(::Circle) = 0
ncorners(::RegularPolygon{N}) where {N} = N

lw(shape::Rectangle) = shape.l, shape.w
lw(shape::Square) = shape.l, shape.l

function corners(shape::AbstractRectangle)
    x, y = center(shape)
    l, w = lw(shape)
    return [(x+w/2, y+l/2), (x-w/2, y+l/2), (x-w/2, y-l/2), (x+w/2, y-l/2)]
end

function corners(shape::RegularPolygon)
    x, y = center(shape)
    θ = shape.θ
    R = shape.R
    n = ncorners(shape)
    return [(x+R*cos(t+θ), y+R*sin(t+θ)) for t in range(0, step=2π/n, length=n)]
end

center(shape::Shape) = shape.x, shape.y

function center(shape::Triangle)
    (x1, y1), (x2, y2), (x3, y3) = corners(shape)
    return ((x1 + x2 + x3) / 3, (y1 + y2 + y3) / 3)
end

xycoords(s::Shape) = [first(p) for p in corners(s)], [last(p) for p in corners(s)]

function xycoords(shape::Circle; n=50)
    ts = range(0, 2π, length=n)
    return shape.x .+ shape.R * cos.(ts), shape.y .+ shape.R * sin.(ts)
end


# area

area(shape::AbstractRectangle) = prod(lw(shape))

function area(shape::RegularPolygon)
    R = shape.R
    n = ncorners(shape)
    dθ = 2π / n  # angle of a triangle
    h = R * cos(dθ/2)
    b = R * sin(dθ/2)
    return b * h * n
end

function area(shape::Triangle)
    (x1, y1), (x2, y2), (x3, y3) = corners(shape)
    return abs(x1*y2 + x2*y3 + x3*y1 - y1*x2 - y2*x3 - y3*x1) / 2
end

area(shape::Circle) = shape.R^2 * π

# move, rotate and scale

function move!(shape::Shape, (dx, dy))
    shape.x += dx
    shape.y += dy
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

rotate!(shape::Circle, dθ) = shape

function rotate!(shape::RegularPolygon, dθ)
    shape.θ += dθ
    shape
end


function rotate!(shape::Triangle, dθ)
    xc, yc = center(shape)
    # center triangle
    move!(shape, (-xc, -yc))
    (x1, y1), (x2, y2), (x3, y3) = corners(shape)
    cosdθ = cos(dθ)
    sindθ = sin(dθ)
    shape.x1 = x1 * cos(dθ) - y1 * sin(dθ)
    shape.x2 = x2 * cos(dθ) - y2 * sin(dθ)
    shape.x3 = x3 * cos(dθ) - y3 * sin(dθ)
    shape.y1 = y1 * cos(dθ) + x1 * sin(dθ)
    shape.y2 = y2 * cos(dθ) + x2 * sin(dθ)
    shape.y3 = y3 * cos(dθ) + x3 * sin(dθ)
    # set to original position
    move!(shape, (xc, yc))
    shape
end

function scale!(shape::Union{Circle,RegularPolygon}, a)
    @assert a > 0 "scaling has to be a positive number"
    shape.R *= a
end

function scale!(shape::Rectangle, a)
    @assert a > 0 "scaling has to be a positive number"
    shape.w *= a
    shape.l *= a
end

function scale!(shape::Square, a)
    @assert a > 0 "scaling has to be a positive number"
    shape.w *= a
end

function scale!(shape::Triangle, a)
    @assert a > 0 "scaling has to be a positive number"
    xc, yc = center(shape)
    move!(shape, (-xc, -yc))
    shape.x1 *= a
    shape.x2 *= a
    shape.x3 *= a
    shape.y1 *= a
    shape.y2 *= a
    shape.y3 *= a
    move!(shape, (xc, yc))
    return shape
end

# in and interaction

Base.in((x, y), s::Circle) = (s.x-x)^2 + (s.y-y)^2 ≤ s.R^2

function Base.in((x, y), s::AbstractRectangle)
    xc, yc = center(s)
    l, w = lw(shape)
    return (xc - 0.5l ≤ x ≤ xc + 0.5l) && (yc - 0.5w ≤ y ≤ yc + 0.5w)
end

function same_side((a, b), p, q)
	n = (a[2] - b[2], b[1] - a[1])
	return sign(n⋅(p.-a)) == sign(n⋅(q.-a))
end

function Base.in(q, s::Triangle)
    p1, p2, p3 = corners(s)
    return same_side((p1, p2), p3, q) && 
            same_side((p2, p3), p1, q) &&
            same_side((p3, p1), p2, q)
end

function Base.in(q, shape::RegularPolygon)
    corners = corners(shape)
    c = center(shape)
end


# random generation






arthur = Rectangle((0, 0), 5)


# REGULAR POLYGON
# ---------------





# CIRCLE
# ------



Circle((x, y), R=1) = Circle(x, y, R)

ncorners(::Circle) = 0


# TRIANGLE
# --------





ncorners(::Triangle) = 3









bill = Triangle((0, 0), (1, 0), (0.5, √(1-0.5)))


# Plotting

using RecipesBase

@recipe function f(s::Shape)
    xguide --> "x"
    yguide --> "y"
    label --> ""
    aspect_ratio := :equal
    seriestype := :shape
    x, y = xycoords(s)
    return x, y
end

using Plots

plot(bill, color=:yellow)

