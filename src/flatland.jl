module Flatland

using LinearAlgebra

abstract type Shape end

abstract type AbstractRectangle <: Shape end

mutable struct Rectangle <: AbstractRectangle
    x::Float64
    y::Float64
    l::Float64
    w::Float64
    function Rectangle((x, y); l=1.0, w=1.0)
        return new(x, y, l, w)
    end
end

function Rectangle((xmin, xmax), (ymin, ymax))
    @assert xmin < xmax && ymin < ymax "Corners have to be ordered: `xmin < xmax && ymin < ymax `"
    x = (xmin + xmax) / 2
    y = (ymin + ymax) / 2
    l = xmax - xmin
    w = ymax - ymin
    return Rectangle((x, y), l=l, w=w)
end

mutable struct Square <: AbstractRectangle
    x::Float64
    y::Float64
    l::Float64
    function Square((x, y); l=1.0)
        return new(x, y, l)
    end
end

lw(shape::Rectangle) = shape.l, shape.w
lw(shape::Square) = shape.l, shape.l

mutable struct RegularPolygon{N} <: Shape 
    x::Float64
    y::Float64
    R::Float64
    θ::Float64  # angle
    function RegularPolygon((x, y), n::Int; R=1.0, θ=0.0)
        @assert n ≥ 3 "polygons need a minimum of three corners"
        return new{n}(x, y, R, θ)
    end
end

#=
`Circle`s are pretty straightforward, having a center and a radius.
=#

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


ncorners(::AbstractRectangle) = 4
ncorners(::AbstractTriangle) = 3
ncorners(::Circle) = 0
ncorners(::RegularPolygon{N}) where {N} = N



function corners(shape::AbstractRectangle)
    x, y = center(shape)
    l, w = lw(shape)
    return [(x+l/2, y+w/2), (x-l/2, y+w/2), (x-l/2, y-w/2), (x+l/2, y-w/2)]
end

function corners(shape::RegularPolygon)
    x, y = center(shape)
    θ = shape.θ
    R = shape.R
    n = ncorners(shape)
    return [(x+R*cos(t+θ), y+R*sin(t+θ)) for t in range(0, step=2π/n, length=n)]
end

function corners(shape::Triangle)
    return [(shape.x1, shape.y1), (shape.x2, shape.y2), (shape.x3, shape.y3)]
end

center(shape::Shape) = shape.x, shape.y

function center(shape::Triangle)
    (x1, y1), (x2, y2), (x3, y3) = corners(shape)
    return ((x1 + x2 + x3) / 3, (y1 + y2 + y3) / 3)
end

# xycoords returns two of the outline vectors: ycoords and ycoords, for `Circle`, you can specify the number of points to take
# (50 by default).

xycoords(s::Shape) = [first(p) for p in corners(s)], [last(p) for p in corners(s)]

function xycoords(shape::Circle; n=50)
    ts = range(0, 2π, length=n)
    return shape.x .+ shape.R * cos.(ts), shape.y .+ shape.R * sin.(ts)
end

# x,y-bounding

#=
The fuctions below yield the outer limits of the x and y axes of your shape. Can you complete the method as a oneliner?

Hint: The function `extrema` could be useful here...
=#

xlim(shape::Shape) = extrema(xycoords(shape)[1])
xlim(shape::Circle) = (shape.x - shape.R, shape.x + shape.R)
xlim(shape::AbstractRectangle) = (shape.x - 0.5shape.l, shape.x + 0.5shape.l)

ylim(shape::Shape) = extrema(xycoords(shape)[2])
ylim(shape::Circle) = (shape.y - shape.R, shape.y + shape.R)
ylim(shape::AbstractRectangle) = (shape.y - 0.5lw(shape)[2], shape.y + 0.5lw(shape)[2])

boundingbox(shape::Shape) = Rectangle(xlim(shape), ylim(shape))

# # Area

#=
Next, we compute the area of our shapes. 
=#

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

#=
Moving, rotating and scaling should also work.
Important, the functions work in-place, meaning that the modify your structure (that is why use use `mutable` structures).

For `Circle` and `AbstractRectangle` types, `rotate!` leaves them unchanged.

Hint: Rotations are in radials, so between $0$ and $2\pi$.
=#

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

rotate!(shape::Union{Circle,AbstractRectangle}, dθ) = shape

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

# plotting utilities


using RecipesBase

#=
OK, let's take a look at our shapes! We use `RecipesBase` to allow plotting.
This falls back on `xycoords` (can you see how it works?), so make sure this method is operational.
=#

@recipe function f(s::Shape)
    xguide --> "x"
    yguide --> "y"
    label --> ""
    aspect_ratio := :equal
    seriestype := :shape
    x, y = xycoords(s)
    return x, y
end


Base.in((x, y), s::Circle) = (s.x - x)^2 + (s.y - y)^2 ≤ s.R^2

function Base.in((x, y), shape::AbstractRectangle)
    xc, yc = center(shape)
    l, w = lw(shape)
    return (xc - 0.5l ≤ x ≤ xc + 0.5l) && (yc - 0.5w ≤ y ≤ yc + 0.5w)
end

crossprod((x1, y1), (x2, y2)) = x1 * y2 - x2 * y1

"""
    same_side((a, b), p, q)

Given a line described by two points, `a` and `b`, check whether two points
`p` and `q` are on the same side.
"""
function same_side((a, b), p, q)
    # normal vector on the line
    n = (a[2] - b[2], b[1] - a[1])
    # check if they are on both sides by projection
	return sign(n ⋅ (p .- a)) == sign(n ⋅ (q .-a ))
end

"""
    linecross((p1, p2), (q1, q2))

Check whether line segments `(p1, p2)` and `(q1, q2)` intersect.
"""
function linecross((p1, p2), (q1, q2))
    v = p2 .- p1
    w = q2 .- q1
    vw = crossprod(v, w)
    t = crossprod(q1 .- p1, w) / vw
    s = crossprod(q1 .- p1, v) / vw
    return 0.0 ≤ t ≤ 1.0 &&  0.0 ≤ s ≤ 1.0
end

function Base.in(q, s::Triangle)
    p1, p2, p3 = corners(s)
    return same_side((p1, p2), p3, q) && 
            same_side((p2, p3), p1, q) &&
            same_side((p3, p1), p2, q)
end

function Base.in(q, shape::Shape)
    corns = corners(shape)
    n = ncorners(shape)
    c = center(shape)
    # check if q is always on the same side as the center
    for i in 1:n-1
        !same_side((corns[i], corns[i+1]), c, q) && return false
    end
    !same_side((corns[end], corns[1]), c, q) && return false
    return true
end

@inline function boundboxes_overlap(shape1::Shape, shape2::Shape)
    (xmin1, xmax1), (xmin2, xmax2) = xlim(shape1), xlim(shape2)
    (ymin1, ymax1), (ymin2, ymax2)  = ylim(shape1), ylim(shape2)
    # check for x and y overlap
    return (xmin1 ≤ xmin2 ≤ xmax1 || xmin1 ≤ xmax2 ≤ xmax1 || xmin2 ≤ xmin1 ≤ xmax2) &&
            (ymin1 ≤ ymin2 ≤ ymax1 || ymin1 ≤ ymax2 ≤ ymax1 ||ymin2 ≤ ymin1 ≤ ymax2)
end

Base.intersect(shape1::AbstractRectangle, shape2::AbstractRectangle) = boundboxes_overlap(shape1, shape2)

function Base.intersect(shape1::T, shape2::T) where {T<:Shape}
    (shape1.x - shape2.x)^2 + (shape1.y - shape2.y)^2 > (shape1.R + shape2.R)^2 && return false
    return center(shape1) ∈ shape2 ||
            center(shape2) ∈ shape1 ||
            any(c->c ∈ shape2, corners(shape1)) ||
            any(c->c ∈ shape1, corners(shape2))
end



function Base.intersect(shape1::Triangle, shape2::Triangle)
    # first check if the bounding boxes overlap
    boundboxes_overlap(shape1, shape2) || return false
    # yes? 
    # now check if one shape is within the other one
    p1, p2, p3 = corners(shape1)
    q1, q2, q3 = corners(shape2)
    (p1 ∈ shape2 || q1 ∈ shape1) && return true
    # if not, we have to check whether two lines intersect
    return linecross((p1, p2), (q1, q2)) ||
            linecross((p1, p2), (q2, q3)) ||
            linecross((p1, p2), (q1, q3)) ||
            linecross((p3, p2), (q1, q2)) ||
            linecross((p3, p2), (q2, q3)) ||
            linecross((p3, p2), (q1, q3))
end
    


function Base.intersect(shape1::Circle, shape2::Circle)
    c1 = center(shape1)
    c2 = center(shape2)
    d = sum(abs2, c1 .- c2) |> sqrt
    return d < shape1.R + shape2.R
end


# random generation

#=
Finally, `randplace!` takes a shape, rotates it randomly and moves it randomly within the bounds of the limits
`(xmin, xmax)` and `(ymin, ymax)`.
=#


function randplace!(shape::Shape, (xmin, xmax), (ymin, ymax); rotate=true)
    # random rotation
    rotate && rotate!(shape, 2π * rand())
    # random tranlation within bound
    dxmin, dxmax = (xmin, xmax) .- xlim(shape)
    dymin, dymax = (ymin, ymax) .- ylim(shape)
    dx = (dxmax - dxmin) * rand() + dxmin
    dy = (dymax - dymin) * rand() + dymin
    move!(shape, (dx, dy))
    return shape
end

function rejection_sampling!(shapes::Vector{<:Shape}, xlims, ylims)
    trials = 0
    n = length(shapes)
    while true
        trials += 1
        for (i, shape) in enumerate(shapes)
            randplace!(shape, xlims, ylims)
            # any intersection with previous shapes: start again
            overlap = false
            for j in 1:i-1
                if intersect(shape, shapes[j])
                    overlap = true
                    break
                end
            end
            overlap && break
            i==n && return shapes, trials
        end
    end
end

# function to place `n` copies of a given `shape`.

function rejection_sampling(shape, n, xlims, ylims)
    shapes = [deepcopy(shape) for i in 1:n]
    trials = rejection_sampling!(shapes, xlims, ylims)
    return shapes, trials
end

end