### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 63f5861e-6244-11eb-268b-a16bc3f8265c
using LinearAlgebra

# ╔═╡ dfc779ee-6246-11eb-240b-4dc7a7d95641
using Plots, RecipesBase

# ╔═╡ 23bcbb02-62ef-11eb-27f9-13ed327ac098
# edit the code below to set your name and UGent username

student = (name = "Joel Janssen", email = "Joel.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 1657b9b2-62ef-11eb-062e-4758f9ea1075
begin 
	using DSJulia;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ b1d21552-6242-11eb-2665-c9232be7026e
md"""
# Flatland

## Introduction and goal
In this notebook, we will implement a variety of two-dimensional geometric shapes.
The different shapes might have drastically different representations. For example, we can describe a rectangle
by the coordinates of its center, its length and its width. A triangle, on the other hand,
is more naturally represented by its three points. Similarly, computing the area of a rectangle or a triangle
involves two different formulas. The nice thing about Julia is that you can hide this complexity from the users.
You have to create your structures, subtypes of the abstract `Shape` type and have custom methods that will work
for each type!

Below, we suggest a variety of shapes, each with its unique representation. For this assignment, you have to complete **one**
type and make sure all the provided functions `corners`, `area`, `move!`, `rotate!`,... work. Using `PlottingRecipes`, you can easily
plot all your shapes (provided you implemented all the helper functions).

Implementing such shapes can have various exciting applications, such as making a drawing tool or a ray tracer. Our
end goal is to implement a simulator of a toy statistical physics system. Here, we simulate a system with inert particles, leading to self-organization.
Our simple rejection sampling algorithm that we will use is computationally very demanding, an ideal case study for Julia!
"""

# ╔═╡ 7189b1ee-62ef-11eb-121a-8d7bb3df52c3
md"""
## Assignments
"""

# ╔═╡ 3a961b6e-62f1-11eb-250b-13a3f6f17eaa
checkbox(test::Bool)= test ? "✅" : "◯";

# ╔═╡ 7545c788-62f0-11eb-3f6e-01deeaf990e0
md"""
 $(checkbox(false)) add the correct *inner* constructor to your type;


 $(checkbox(false)) complete `corners` and `ncorners`, which return the corners and the number of corners, respecitively;


 $(checkbox(false)) complete `center` to return the center of mass of the shape;
 
 $(checkbox(false)) complete `xycoords`, which give two vectors with the x- and y-coordinates of the shape, used for plotting;
 
 $(checkbox(false)) complete `xlim` and `ylim` to give the range on the x- and y-axes of your shape, in addition to `boundingbox` to generate a bounding box of your shape;
 
 $(checkbox(false)) complete `area`, this computes the area of your shape;
 
 $(checkbox(false)) complete `move!`, `rotate!` and `scale!` to transform your shape **in place** (note: `AbstractRectangle`s cannot be rotated, they are always aligned to the axes);
 
 $(checkbox(false)) complete the function `in`, to check whether a point is in your shape;
 
 $(checkbox(false)) complete `intersect`, to check whether two shapes overlap;
 
 $(checkbox(false)) complete `randplace!`, which randomly moves and rotates a shape within a box;
 
 $(checkbox(false)) complete the rejection sampling algorithm and experiment with your shape(s).
 
Note: You will need to create specific methods for different types. It's your job to split the template for the functions in several methods and use dispatch.
"""

# ╔═╡ d65b61ba-6242-11eb-030d-b18a7518731b
md"## Types
We define all kinds of shapes. For the constructors, we follow the convention: `Shape((x,y); kwargs)` where `kwargs` are the keyword arguments determining
the shape.
"

# ╔═╡ e3f846c8-6242-11eb-0d12-ed9f7e534db8
abstract type Shape end

# ╔═╡ e7e43620-6242-11eb-1e2e-65874fe8e293
md"""
 `AbstractRectangle` is for simple rectangles and squares, for which the sides are always aligned with the axis.
They have a `l`ength and `w`idth attribute, in addition to an `x` and `y` for their center.


"""

# ╔═╡ f4b05730-6242-11eb-0e24-51d4c60dc451
abstract type AbstractRectangle <: Shape end

# ╔═╡ fe413efe-6242-11eb-3c38-13b9d996bc90
begin
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
end

# ╔═╡ 06520b30-62f4-11eb-2b90-1fcb3053945e
md"So we have defined a composite Rectangle type with an inner constructor to instantiate a Rectangle with center (`x`,`y`) and a default length and width of 1.0. Using multiple dispatch allows to defined multiple constructors for different scenario's. So we have defined an additional constructor where the extremum coordinates are provided (`xmin`, `xmin`), (`ymin`, `ymax`) assuming that the rectangle is aligned with the axes."

# ╔═╡ 12ddaece-6243-11eb-1e9d-2be312d2e22d
md"Squares are a special case of rectangle."

# ╔═╡ 16666cac-6243-11eb-0e0f-dd0d0ec53926
mutable struct Square <: AbstractRectangle
    x::Float64
    y::Float64
    l::Float64
    function Square((x, y); l=1.0)
        return new(x, y, l)
    end
end

# ╔═╡ 23ea0a46-6243-11eb-145a-b38e34969cfd
md"This small function to get `l` and `w` will allow you to treat `Square` and `Rectangle` the same!"

# ╔═╡ 1b129bf4-6243-11eb-1fa2-d7bd5563a1b4
begin
	lw(shape::Rectangle) = shape.l, shape.w
	lw(shape::Square) = shape.l, shape.l
end

# ╔═╡ 2ba1f3e6-6243-11eb-0f18-ef5e21e01a15
md"Regular polygons have a center (`x`, `y`), a radius `R` (distance center to one of the corners) and an angle `θ` how it is tilted.
The order of the polygon is part of its parametric type, so we give the compiler some hint how it will behave."

# ╔═╡ 33757f2c-6243-11eb-11c2-ab5bbd90aa6b
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

# ╔═╡ 381d19b8-6243-11eb-2477-5f0e919ff7bd
md"`Circle`'s are pretty straightforward, having a center and a radius."

# ╔═╡ 3d67d61a-6243-11eb-1f83-49032ad146da
mutable struct Circle <: Shape
    x::Float64
    y::Float64
    R::Float64
    function Circle((x, y); R=1.0)
        return new(x, y, R)
    end
end

# ╔═╡ 4234b198-6243-11eb-2cfa-6102bfd9b896
md"Triangles are described by their three points. Its center will be computed when needed."

# ╔═╡ 473d9b5c-6243-11eb-363d-23108e81eb93
abstract type AbstractTriangle <: Shape end

# ╔═╡ 50e45ac6-6243-11eb-27f9-d5e7d0e1dc01
mutable struct Triangle <: AbstractTriangle
    x1::Float64
    x2::Float64
    x3::Float64
    y1::Float64
    y2::Float64
    y3::Float64
    Triangle((x1, y1), (x2, y2), (x3, y3)) = new(x1, x2, x3, y1, y2, y3)
end

# ╔═╡ 55de4f76-6243-11eb-1445-a54d01242f64
rect = Rectangle((1, 2), l=1, w=2)

# ╔═╡ 5b6b9854-6243-11eb-2d5b-f3e41ecf2914
square = Square((0, 1))

# ╔═╡ 5f120f1a-6243-11eb-1448-cb12a75680b0
triangle = Triangle((1, 2), (4, 5), (7, -10))

# ╔═╡ 64fcb6a0-6243-11eb-1b35-437e8e0bfac8
pent = RegularPolygon((0, 0), 5)

# ╔═╡ 668f568a-6243-11eb-3f01-adf1b603e0e4
hex = RegularPolygon((1.2, 3), 6)

# ╔═╡ 7b785b7a-6243-11eb-31c2-9d9deea78842
circle = Circle((10, 10))

# ╔═╡ 9b94fb66-6243-11eb-2635-6b2021c741f0
myshape = missing

# ╔═╡ 7c80d608-6243-11eb-38ba-f97f7476b245
md"""
## Corners and center
Some very basic functions to get or generate the corners and centers of your shapes. The corners are returned as a list of tuples, e.g. `[(x1, y1), (x2, y2),...]`.
"""

# ╔═╡ a005992e-6243-11eb-3e29-61c19c6e5c7c
begin
	ncorners(::Circle) = 0  # this one is for free!
	ncorners(shape::Shape) = missing
	
end

# ╔═╡ ac423fa8-6243-11eb-1385-a395d208c42d
begin
	function corners(shape::Shape)
		return missing
	end
end

# ╔═╡ ddf0ac38-6243-11eb-3a1d-cd39d70b2ee0
begin
	center(shape::Shape) = (missing, missing)
end

# ╔═╡ ecc9a53e-6243-11eb-2784-ed46ccbcadd2
begin
	xycoords(s::Shape) = missing, missing

	function xycoords(shape::Circle; n=50)
		# compute `n` points of the circle
		return missing, missing
	end
end

# ╔═╡ 5de0c912-6244-11eb-13fd-bfd8328191a6
md"""
## x,y-bounding

The fuctions below yield the outer limits of the x and y axes of your shape. Can you complete the methods with a oneliner?
"""

# ╔═╡ 9ef18fda-6244-11eb-3751-5344dff96d3e
hint(md"The function `extrema` could be useful here...")

# ╔═╡ a89bdba6-6244-11eb-0b83-c1c64e4de17d
begin
	xlim(shape::Shape) = missing
end

# ╔═╡ b1372784-6244-11eb-0279-27fd755cda6a
begin
	ylim(shape::Shape) = missing
end

# ╔═╡ bd706964-6244-11eb-1d9d-2b60e53cdce1
md"This returns the bounding box, as the smallest rectangle that can completely contain your shape."

# ╔═╡ b91e1e62-6244-11eb-1045-0770fa92e040
boundingbox(shape::Shape) = missing

# ╔═╡ d60f8ca4-6244-11eb-2055-4551e4c10906
md"""
## Area

Next, we compute the area of our shapes.
"""

# ╔═╡ f69370bc-6244-11eb-290e-fdd4d7cc826a
hint(md"The area of a triangle can be computed as $${\frac {1}{2}}{\big |}(x_{A}-x_{C})(y_{B}-y_{A})-(x_{A}-x_{B})(y_{C}-y_{A}){\big |}$$.")

# ╔═╡ 69780926-6245-11eb-3442-0dc8aea8cb73
hint(md"A regular polygon consists of a couple of isosceles triangles.")

# ╔═╡ ebf4a45a-6244-11eb-0965-197f536f8e87
begin
	area(shape::Shape) = missing
end

# ╔═╡ 36cc0492-6246-11eb-38dd-4f42fb7066dc
md"""
## Moving, rotating and scaling

Important: the functions work *in-place*, meaning that the modify your object (that is why use use `mutable` structures).

For `Circle` and `AbstractRectangle` types, `rotate!` leaves them unchanged.

Note: rotations are in radials, so between $0$ and $2\pi$.
"""

# ╔═╡ 83c6d25c-6246-11eb-1a24-57e20f5e7262
begin
	function move!(shape::Shape, (dx, dx))
		# move the shape
		return shape
	end
end

# ╔═╡ a1b2a4f8-6246-11eb-00ea-8f6042c72f4e
begin
	function rotate!(shape::Shape, dθ)
		# rotate the shape, counterclockwise
		return shape
	end
end

# ╔═╡ b907e8fc-6246-11eb-0beb-bb44930d033c
begin
	function scale!(shape::Shape, a)
		@assert a > 0 "scaling has to be a positive number"
		# scale with a factor a
		return shape
	end
end

# ╔═╡ d08ab6d0-6246-11eb-08a8-152f9802cdfc
md"""
## Plotting 

OK, let's take a look at our shapes! We use `RecipesBase` to allow plotting.
This falls back on `xycoords` (can you see how it works?), so make sure this method is operational.
"""

# ╔═╡ e30d10d2-6246-11eb-1d59-332b5916712e
@recipe function f(s::Shape)
    xguide --> "x"
    yguide --> "y"
    label --> ""
    aspect_ratio := :equal
    seriestype := :shape
    x, y = xycoords(s)
    return x, y
end

# ╔═╡ e7e90744-6246-11eb-157c-cf67e8619d6e
"""Plots a list of shapes."""
function plotshapes(shapes; kwargs...)
    p = plot(;kwargs...)
    plot!.(shapes)
    return p
end

# ╔═╡ 1aec9fc2-6247-11eb-2942-edc370918f9e
md"Let's look!"

# ╔═╡ 16d0ea9c-6247-11eb-12c6-1709f6d0ac99
plot(myshape)

# ╔═╡ 287a7506-6247-11eb-2bad-0778802c00d5
plot(myshape, color="pink")

# ╔═╡ 221e09a2-6247-11eb-12a8-a13c0a2f96e7
md"""
## In and intersection

Here, we want to perform some geometric checks. 

```julia
(x, y) in shape
```
should return a Boolean whether the point.

Similarly, we want to check whether two shapes overlap (partly):

```julia
intersect(shape1, shape2)
```

By completing these functions, the following more mathematical syntax should also work:

```julia
(x, y) ∈ shape  # \in<TAB>
shape1 ∩ shape2  # \cap<TAB>
```

We have defined some functions you might find useful.
"""

# ╔═╡ dc124df4-6248-11eb-199a-dd4627122715
hint(md"Maybe you can perform very rapid checks to immediately check whether two shapes cannot possibly overlap?")

# ╔═╡ 0381fbba-6248-11eb-3e80-b37137438531
crossprod((x1, y1), (x2, y2)) = x1 * y2 - x2 * y1

# ╔═╡ 150f1dae-6248-11eb-276f-9bbf7eba58fd
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

# ╔═╡ 165b9192-6248-11eb-3c29-c7a8c166f731
same_side(((0, 0), (1, 1)), (0.6, 0.7), (12, 30))

# ╔═╡ 653af7c6-6248-11eb-2a7b-fbf7550ef92b
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

# ╔═╡ 6aa3519a-6248-11eb-193d-a3537f7d3bd0
linecross(((0, 0), (1, 1)), ((0, 1), (1, 0)))

# ╔═╡ 91273cd2-6248-11eb-245c-abb6269f916b
md"Note, Julia will parse composite arguments:"

# ╔═╡ e9a82498-6248-11eb-0f36-bbbdc5580c8d
@inline function boundboxes_overlap(shape1::Shape, shape2::Shape)
    (xmin1, xmax1), (xmin2, xmax2) = xlim(shape1), xlim(shape2)
    (ymin1, ymax1), (ymin2, ymax2)  = ylim(shape1), ylim(shape2)
    # check for x and y overlap
    return (xmin1 ≤ xmin2 ≤ xmax1 || xmin1 ≤ xmax2 ≤ xmax1 || xmin2 ≤ xmin1 ≤ xmax2) &&
            (ymin1 ≤ ymin2 ≤ ymax1 || ymin1 ≤ ymax2 ≤ ymax1 ||ymin2 ≤ ymin1 ≤ ymax2)
end

# ╔═╡ ab9775d2-6248-11eb-360a-8b1e048d5717
let
	p1 = (0, 0)
	p2 = (1, 1)
	q1 = (0, 1)
	q2 = (1, 0)
	linecross((p1, p2), (q1, q2))
end

# ╔═╡ e565d548-6247-11eb-2824-7521d4fa6b2b
begin
	function Base.in((x, y), s::Shape)
		# compute something
		return missing
	end
end

# ╔═╡ f4873fce-6249-11eb-0140-871354ca5430
let
	# verfication
	points = filter(p->p ∈ myshape, [5randn(2) for i in 1:10_000])
	scatter(first.(points), last.(points))
	plot!(myshape, alpha=0.2)
end

# ╔═╡ f97bf1c0-6247-11eb-1acc-e30068a277d0
md"""
## Random placement

Finally, `randplace!` takes a shape, rotates it randomly and moves it randomly within the bounds of the limits `(xmin, xmax)` and `(ymin, ymax)`. Note that the **whole** shape should be within these bounds, not only the center!
"""

# ╔═╡ 8d73b66c-624e-11eb-0a52-2309ef897b1c
function randplace!(shape::Shape, (xmin, xmax), (ymin, ymax); rotate=true)
    # random rotation
    
    # random tranlation within bound
    
    return shape
end

# ╔═╡ Cell order:
# ╟─1657b9b2-62ef-11eb-062e-4758f9ea1075
# ╠═23bcbb02-62ef-11eb-27f9-13ed327ac098
# ╠═63f5861e-6244-11eb-268b-a16bc3f8265c
# ╟─b1d21552-6242-11eb-2665-c9232be7026e
# ╟─7189b1ee-62ef-11eb-121a-8d7bb3df52c3
# ╟─7545c788-62f0-11eb-3f6e-01deeaf990e0
# ╟─3a961b6e-62f1-11eb-250b-13a3f6f17eaa
# ╠═d65b61ba-6242-11eb-030d-b18a7518731b
# ╠═e3f846c8-6242-11eb-0d12-ed9f7e534db8
# ╠═e7e43620-6242-11eb-1e2e-65874fe8e293
# ╠═f4b05730-6242-11eb-0e24-51d4c60dc451
# ╠═fe413efe-6242-11eb-3c38-13b9d996bc90
# ╠═06520b30-62f4-11eb-2b90-1fcb3053945e
# ╠═12ddaece-6243-11eb-1e9d-2be312d2e22d
# ╠═16666cac-6243-11eb-0e0f-dd0d0ec53926
# ╠═23ea0a46-6243-11eb-145a-b38e34969cfd
# ╠═1b129bf4-6243-11eb-1fa2-d7bd5563a1b4
# ╠═2ba1f3e6-6243-11eb-0f18-ef5e21e01a15
# ╠═33757f2c-6243-11eb-11c2-ab5bbd90aa6b
# ╠═381d19b8-6243-11eb-2477-5f0e919ff7bd
# ╠═3d67d61a-6243-11eb-1f83-49032ad146da
# ╠═4234b198-6243-11eb-2cfa-6102bfd9b896
# ╠═473d9b5c-6243-11eb-363d-23108e81eb93
# ╠═50e45ac6-6243-11eb-27f9-d5e7d0e1dc01
# ╠═55de4f76-6243-11eb-1445-a54d01242f64
# ╠═5b6b9854-6243-11eb-2d5b-f3e41ecf2914
# ╠═5f120f1a-6243-11eb-1448-cb12a75680b0
# ╠═64fcb6a0-6243-11eb-1b35-437e8e0bfac8
# ╠═668f568a-6243-11eb-3f01-adf1b603e0e4
# ╠═7b785b7a-6243-11eb-31c2-9d9deea78842
# ╠═9b94fb66-6243-11eb-2635-6b2021c741f0
# ╠═7c80d608-6243-11eb-38ba-f97f7476b245
# ╠═a005992e-6243-11eb-3e29-61c19c6e5c7c
# ╠═ac423fa8-6243-11eb-1385-a395d208c42d
# ╠═ddf0ac38-6243-11eb-3a1d-cd39d70b2ee0
# ╠═ecc9a53e-6243-11eb-2784-ed46ccbcadd2
# ╠═5de0c912-6244-11eb-13fd-bfd8328191a6
# ╠═9ef18fda-6244-11eb-3751-5344dff96d3e
# ╠═a89bdba6-6244-11eb-0b83-c1c64e4de17d
# ╠═b1372784-6244-11eb-0279-27fd755cda6a
# ╠═bd706964-6244-11eb-1d9d-2b60e53cdce1
# ╠═b91e1e62-6244-11eb-1045-0770fa92e040
# ╠═d60f8ca4-6244-11eb-2055-4551e4c10906
# ╠═f69370bc-6244-11eb-290e-fdd4d7cc826a
# ╠═69780926-6245-11eb-3442-0dc8aea8cb73
# ╠═ebf4a45a-6244-11eb-0965-197f536f8e87
# ╠═36cc0492-6246-11eb-38dd-4f42fb7066dc
# ╠═83c6d25c-6246-11eb-1a24-57e20f5e7262
# ╠═a1b2a4f8-6246-11eb-00ea-8f6042c72f4e
# ╠═b907e8fc-6246-11eb-0beb-bb44930d033c
# ╠═d08ab6d0-6246-11eb-08a8-152f9802cdfc
# ╠═dfc779ee-6246-11eb-240b-4dc7a7d95641
# ╠═e30d10d2-6246-11eb-1d59-332b5916712e
# ╠═e7e90744-6246-11eb-157c-cf67e8619d6e
# ╠═1aec9fc2-6247-11eb-2942-edc370918f9e
# ╠═16d0ea9c-6247-11eb-12c6-1709f6d0ac99
# ╠═287a7506-6247-11eb-2bad-0778802c00d5
# ╠═221e09a2-6247-11eb-12a8-a13c0a2f96e7
# ╠═dc124df4-6248-11eb-199a-dd4627122715
# ╠═0381fbba-6248-11eb-3e80-b37137438531
# ╠═150f1dae-6248-11eb-276f-9bbf7eba58fd
# ╠═165b9192-6248-11eb-3c29-c7a8c166f731
# ╠═653af7c6-6248-11eb-2a7b-fbf7550ef92b
# ╠═6aa3519a-6248-11eb-193d-a3537f7d3bd0
# ╠═91273cd2-6248-11eb-245c-abb6269f916b
# ╠═e9a82498-6248-11eb-0f36-bbbdc5580c8d
# ╠═ab9775d2-6248-11eb-360a-8b1e048d5717
# ╠═e565d548-6247-11eb-2824-7521d4fa6b2b
# ╠═f4873fce-6249-11eb-0140-871354ca5430
# ╠═f97bf1c0-6247-11eb-1acc-e30068a277d0
# ╠═8d73b66c-624e-11eb-0a52-2309ef897b1c
