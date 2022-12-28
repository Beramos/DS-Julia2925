### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

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
	using Pkg; Pkg.activate("../..")
	using DSJulia;
	using PlutoUI;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ b1d21552-6242-11eb-2665-c9232be7026e
md"""
# Flatland

![](https://i.imgur.com/ex7JS3Z.png)

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

# ╔═╡ f2485038-30dc-4137-88bb-f9394962ec9e
fyi(md"If you get stuck at any moment in this notebook, you can find a completed version of it [right here](https://github.com/Beramos/DS-Julia2925/blob/master/src/flatland.jl).")

# ╔═╡ 7189b1ee-62ef-11eb-121a-8d7bb3df52c3
md"""
## Assignments
"""

# ╔═╡ f8b080fe-6309-11eb-17aa-fb098fc00b11
md"""

| shape  | difficulty   |
|---|---|
| `Rectangle`  |  ⭐️   |
| `Square`  |  ⭐️   |
|  `Circle` | ⭐️ ⭐️   |
|`RegularPolygon` | ⭐️ ⭐️ ⭐️ |
|`Triangle` | ⭐️ ⭐️ ⭐️ ⭐️ |
|`Quadrilateral` | ⭐️ ⭐️ ⭐️ ⭐️ ⭐️ |

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
 `AbstractRectangle` is for simple rectangles and squares, for which the sides are always aligned with the axes.
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
			return missing # replace this with the correct statement
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

# ╔═╡ 4d4285e8-6334-11eb-0d76-136cc5f645cd


# ╔═╡ 12ddaece-6243-11eb-1e9d-2be312d2e22d
md"Squares are a special case of rectangle."

# ╔═╡ 16666cac-6243-11eb-0e0f-dd0d0ec53926
mutable struct Square <: AbstractRectangle
    x::Float64
    y::Float64
    l::Float64
    function Square((x, y); l=1.0)
        return missing # replace this with the correct statement
    end
end

# ╔═╡ 501f9828-6334-11eb-0f2a-ebaa1d5b0f46


# ╔═╡ 23ea0a46-6243-11eb-145a-b38e34969cfd
md"This small function to get `l` and `w` will allow you to treat `Square` and `Rectangle` the same!"

# ╔═╡ 1b129bf4-6243-11eb-1fa2-d7bd5563a1b4
begin
	lw(shape::Rectangle) = shape.l, shape.w
	lw(shape::Square) = shape.l, shape.l
end

# ╔═╡ 94ec5382-6335-11eb-100c-15d70f27e703


# ╔═╡ 3d67d61a-6243-11eb-1f83-49032ad146da
mutable struct Circle <: Shape
    x::Float64
    y::Float64
    R::Float64
    function Circle((x, y); R=1.0)
        return missing # replace this with the correct statement
    end
end

# ╔═╡ 4ce7abea-6335-11eb-1657-a3ee8986d55e


# ╔═╡ 33757f2c-6243-11eb-11c2-ab5bbd90aa6b
mutable struct RegularPolygon{N} <: Shape 
    x::Float64
    y::Float64
    R::Float64
    θ::Float64  # angle
    function RegularPolygon((x, y), n::Int; R=1.0, θ=0.0)
        @assert n ≥ 3 "polygons need a minimum of three corners"
        return missing # replace this with the correct statement
    end
end

# ╔═╡ bbbe4c9a-6335-11eb-1dc7-55ddf17887f4


# ╔═╡ 4234b198-6243-11eb-2cfa-6102bfd9b896
md"Triangles will be described by their three points. Its center will be computed when needed."

# ╔═╡ 473d9b5c-6243-11eb-363d-23108e81eb93
abstract type AbstractTriangle <: Shape end

# ╔═╡ ce3393a8-6335-11eb-06e9-af93a3794902
md"This one is for free:"

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

# ╔═╡ dad14258-6309-11eb-0a9a-37c0386c8cb4
md"Define some examples."

# ╔═╡ 55de4f76-6243-11eb-1445-a54d01242f64
rect = Rectangle((1, 2), l=1, w=2)

# ╔═╡ 5b6b9854-6243-11eb-2d5b-f3e41ecf2914
square = Square((0, 1))

# ╔═╡ 5f120f1a-6243-11eb-1448-cb12a75680b0
triangle = Triangle((-0.1, 0.5), (1, 2), (1, -0.5))

# ╔═╡ 64fcb6a0-6243-11eb-1b35-437e8e0bfac8
pent = RegularPolygon((0, 0), 5)

# ╔═╡ 668f568a-6243-11eb-3f01-adf1b603e0e4
hex = RegularPolygon((1.2, 3), 6)

# ╔═╡ 7b785b7a-6243-11eb-31c2-9d9deea78842
circle = Circle((10, 10))

# ╔═╡ 5a61e0da-6338-11eb-2a58-ad06aae62940
md"""**Select one of the shapes you have developed.** 

My shape type: $(@bind myshapeType Select(["Square", "Rectangle", "Circle", "RegularPolygon{N}", "Triangle"]))

"""

# ╔═╡ b6a4c98a-6300-11eb-0542-ab324d8e4d7e
begin 
	if myshapeType == "Square"
		myshape = square
	elseif myshapeType == "Rectangle"
		myshape = rect
	elseif myshapeType == "Circle"
		myshape = circle
	elseif myshapeType == "RegularPolygon{N}"
		myshape = pent  # needs to be more general WIP
	elseif myshapeType == "Triangle"
		myshape = triangle  # needs to be more general WIP
	else 
		myshape = missing
	end
		tester = ismissing(myshape) ? md"❌ **$myshapeType is not properly defined!** First complete the inner constructors for $myshapeType or change to a type that do have defined." : md""
end;

# ╔═╡ ca5302b2-6337-11eb-2e98-efb764a792a4
tester

# ╔═╡ 7c80d608-6243-11eb-38ba-f97f7476b245
md"""
## Corners and center

"""

# ╔═╡ 58eb84be-63c3-11eb-09f5-6d16973c7aa7
md"![](https://i.imgur.com/6cKB1xr.png)"

# ╔═╡ 57dee25a-63c3-11eb-0c7a-bfb1ac79bc7b
md"""
Some very basic functions to get or generate the corners and centers of your shapes. The corners are returned as a list of tuples, e.g. `[(x1, y1), (x2, y2), ...]`.
"""

# ╔═╡ 62e7e05e-62fe-11eb-1611-61274c5498cc
begin 	
	q_cc1 = Question(
			description = md"""
			**The number of corners**
			
			```julia
			ncorners(shape::myShape)
			```
			that returns the number of corners.
		

			"""
		)
	
	q_cc2 = Question(
		description = md"""
		**The corners**

		```julia
		corners(shape::myShape)
		```
		that returns the coordinates of the corners.

		"""
	)
	
	q_cc3 = Question(
		description = md"""
		**The center**

		```julia
		center(shape::myShape)
		```
		that returns the center.

		"""
	)
	
	q_cc4 = Question(
		description = md"""
		**The outline**

		```julia
		xycoords(shape::Shape)
		```
		xycoords returns two vectors of the outline: xcoords and ycoords, for `Circle`, you can specify the number of points to take (50 by default). For a lot of shapes this is just another representation of the corners.

		"""
	)
	
	qb_cc = QuestionBlock(;
		title=md"**Assignment: corners and center**",
		description = md"""

	Complete the following functions for your shape ($myshapeType)

		""",
		questions = [q_cc1, q_cc2, q_cc3, q_cc4]
	)
	
	#validate(qb_cc, tracker)
end

# ╔═╡ a005992e-6243-11eb-3e29-61c19c6e5c7c
begin
	ncorners(::Circle) = 0  # this one is for free!
	ncorners(shape::Shape) = missing # leave this default 
	#...add your own ncorners
	
end

# ╔═╡ ac423fa8-6243-11eb-1385-a395d208c42d
begin
	function corners(shape::Shape)
		return missing
	end
end

# ╔═╡ ddf0ac38-6243-11eb-3a1d-cd39d70b2ee0
#=begin
	center(shape::Shape) = (missing, missing)
end=#

# ╔═╡ ecc9a53e-6243-11eb-2784-ed46ccbcadd2
begin
	#xycoords(shape::Shape) = missing, missing
	xycoords(s::Shape) = [first(p) for p in corners(s)], [last(p) for p in corners(s)]


	function xycoords(shape::Circle; n=50)
		# compute `n` points of the circle
		return missing, missing
	end
end

# ╔═╡ c16c36f6-6339-11eb-20d4-27ef9f74b747


# ╔═╡ 5de0c912-6244-11eb-13fd-bfd8328191a6
md"""
## x,y-bounding
"""

# ╔═╡ fe48d2f0-63c2-11eb-12f7-d5a8d6d0ce27
md"![](https://i.imgur.com/G7worze.png)"

# ╔═╡ aa186788-63c3-11eb-1bd1-d138d586e8b6
begin
   q_bound = Question(;
			description=md"""
The fuctions below is supposed to yield the outer limits of the x and y axes of your shape. Can you complete the methods with a oneliner?
""")
	
   qb_bound = QuestionBlock(;
	title=md"**Assignment: bounding box ⭐️⭐️**",
	questions = [q_bound],
	hints=[hint(md"The function `extrema` could be useful here...")]
	)
end

# ╔═╡ a89bdba6-6244-11eb-0b83-c1c64e4de17d
begin
	xlim(shape::Shape) = missing
end

# ╔═╡ b1372784-6244-11eb-0279-27fd755cda6a
begin
	ylim(shape::Shape) = missing
end

# ╔═╡ bd706964-6244-11eb-1d9d-2b60e53cdce1
md"This should return the bounding box, as the smallest rectangle that can completely contain your shape."

# ╔═╡ b91e1e62-6244-11eb-1045-0770fa92e040
boundingbox(shape::Shape) = missing

# ╔═╡ d60f8ca4-6244-11eb-2055-4551e4c10906
md"""
## Area
"""

# ╔═╡ ebf4a45a-6244-11eb-0965-197f536f8e87
begin
	area(shape::Shape) = missing
end

# ╔═╡ 230dd290-6303-11eb-0f55-311ef2b9541e


# ╔═╡ 36cc0492-6246-11eb-38dd-4f42fb7066dc
md"""
## Moving, rotating and scaling
"""

# ╔═╡ ed4bfad2-63c6-11eb-0292-73c34e4d34a6
md"![](https://i.imgur.com/nUlpTDA.png)"

# ╔═╡ 285930b8-63c7-11eb-372b-edc4a4ed0d0a
begin
   q_mrs = Question(;
			description=md"""

Next, let us define some translation, rotation and scaling operations on the shapes.
		
Important: the functions work *in-place*, meaning that the modify your object (that is why use use `mutable` structures).

For `Circle` and `AbstractRectangle` types, `rotate!` leaves them unchanged.

**Note**: rotations are in radials, so between $0$ and $2\pi$.
			""")
	
   qb_mrs = QuestionBlock(;
	title=md"**Assignment: I like to move it ⭐️⭐️⭐️**",
	questions = [q_mrs])
end

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

# ╔═╡ 2d7a63cc-64db-11eb-0a4c-bb7771af8b14


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

# ╔═╡ 8bdc61b0-6330-11eb-3e9a-15412fecf8af
myshape

# ╔═╡ 16d0ea9c-6247-11eb-12c6-1709f6d0ac99
plot(myshape)

# ╔═╡ 6bae2128-6303-11eb-34f2-1dfa96e46ae6
md"This is how it should look like,"

# ╔═╡ 287a7506-6247-11eb-2bad-0778802c00d5
plot(myshape, color="pink")

# ╔═╡ 01d899e6-6305-11eb-017b-27bb2c104ef5


# ╔═╡ 221e09a2-6247-11eb-12a8-a13c0a2f96e7
md"""
## In and intersection

Here, we want to perform some geometric checks. 

```julia
(x, y) in shape
```
should return a Boolean whether the point is in the shape.
"""

# ╔═╡ 6851ebb2-6339-11eb-2ab7-39e07c4e3154
begin
   q_in = Question(;
			description=md"""
			Complete the function `in(q, shape::Shape)` that checks whether a points falls inside a shape. The function `same_side((a, b), p, q)` is provided to check whether two points are on the same side of a line. This should prove very useful to complete this task.""")
	
   qb_in = QuestionBlock(;
	title=md"**Is point in shape? ⭐️⭐️⭐️**",
	questions = [q_in],
	hints=[
		hint(md"It has something to do with the center..."),
		hint(md"... but also with the edges"),
		hint(md"Given that a point is outside a shape, it is always **outside** all edges.")
	]
	)
end

# ╔═╡ e565d548-6247-11eb-2824-7521d4fa6b2b
begin
	function Base.in((x, y), s::Shape)
		# compute something
		return missing
	end
end

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

# ╔═╡ b8ed26f2-633b-11eb-380e-9379b0f4697f
md"Too prove that this function works:" 

# ╔═╡ f4873fce-6249-11eb-0140-871354ca5430
let
	# verfication
	points_all = [1randn(2) for i in 1:1_000]
	points =filter(p->p ∈ myshape, points_all)
	scatter(first.(points_all), last.(points_all), opacity=0.1, color=:lightgrey, label="all")
	scatter!(first.(points), last.(points), label="out")
	plot!(myshape, alpha=0.2)
end

# ╔═╡ 22f63a5e-633a-11eb-27c7-27fcabc7bc6f


# ╔═╡ f3ea648e-633b-11eb-3444-317a4eb5b8ea
begin
   q_circle = Question(;
			description=md"""

**Two circles intersecting ⭐️**
```julia
	Base.intersect(shape1::Circle, shape2::Circle)
```

""")
	
   q_recrec = Question(;
		description=md"""

**Rectangle intersecting another rectangle ⭐️**
```julia
	Base.intersect(shape1::AbstractRectangle, shape2::AbstractRectangle)
```

""")
	
   q_triatria = Question(;
		description=md"""

**Two triangles intersecting (efficient) ⭐️⭐️⭐️⭐️⭐️**
```julia
	Base.intersect(shape1::Triangle, shape2::Triangle)
```

""")
	
   q_general = Question(;
		description=md"""

**Any two shapes intersecting (naive) ⭐️⭐️⭐️**
```julia
	Base.intersect(shape1::T, shape2::T) where {T<:Shape}
```

""")
	
	
	
   qb_inter = QuestionBlock(;
	title=md"**Intersection between shapes?**",
	description=md"""
Similarly, we want to check whether two shapes overlap (partially):

```julia
intersect(shape1, shape2)
```

Complete the function `intersect(shape1, shape2)` that checks whether there is a partial overlap (intersection) between two shapes

The efficiency and the process of checking intersection is very different for each shape and each combination of two shapes. Complete **at least one** of the following combinations.""",
	questions = [q_circle, q_recrec, q_triatria, q_general],
	hints=[
		hint(md"Checking overlapping bounding boxes is very efficient"),
		hint(md"For most shapes: overlapping bounding boxes is a required, but not a sufficient condition for overlap"),
		hint(md"[Very good hint](https://i.imgur.com/TpIStMK.png)")
		
		]
	)
end

# ╔═╡ 5368c46e-633e-11eb-0d98-b1ccb37cc7f8
begin
	function Base.intersect(shape1::AbstractRectangle, shape2::AbstractRectangle)
		return missing
	end
	
	function Base.intersect(shape1::Circle, shape2::Circle)
		return missing
	end

	function Base.intersect(shape1::Triangle, shape2::Triangle)
		return missing
	end
    

	function Base.intersect(shape1::T, shape2::T) where {T<:Shape}
		return missing
	end
	
end

# ╔═╡ e6efb632-6338-11eb-2e22-eb0b1ff577c4
md"We have defined some functions you might find useful:"

# ╔═╡ 0381fbba-6248-11eb-3e80-b37137438531
crossprod((x1, y1), (x2, y2)) = x1 * y2 - x2 * y1

# ╔═╡ 91273cd2-6248-11eb-245c-abb6269f916b
md"Note, Julia will parse composite arguments:"

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

# ╔═╡ 51bca412-6340-11eb-3f38-8bfc8377715b


# ╔═╡ e21b0f1c-633b-11eb-3609-9b9dae71c915
md"""
By completing these functions, the following mathematical syntax should also work:

```julia
(x, y) ∈ shape  # \in<TAB>
shape1 ∩ shape2  # \cap<TAB>
```
"""

# ╔═╡ f97bf1c0-6247-11eb-1acc-e30068a277d0
md"""
## Random placement

Finally, `randplace!` takes a shape, rotates it randomly and moves it randomly within the bounds of the limits `(xmin, xmax)` and `(ymin, ymax)`. Note that the **whole** shape should be within these bounds, not only the center!
"""

# ╔═╡ 97c8cd32-6340-11eb-1d6d-b7d364c0c987
begin
   q_rand = Question(;
			description=md"""
			Complete the function `randplace!(shape::Shape, (xmin, xmax), (ymin, ymax); rotate=true)` that places a shape at a random location withing a given bounding box. Can you define it in such a way that it also gives a random rotation to the shape?""")
	
   qb_rand = QuestionBlock(;
	title=md"**Assignment: random placement⭐️⭐️⭐️**",
	questions = [q_rand],
	hints=[

	]
	)
end

# ╔═╡ 8d73b66c-624e-11eb-0a52-2309ef897b1c
function randplace!(shape::Shape, (xmin, xmax), (ymin, ymax); rotate=true)
    # random rotation
    
    # random translation within bound
    
    return shape
end

# ╔═╡ 3e0a2e20-6341-11eb-3c23-a38b04c89b37
md"Testing if the function works:"

# ╔═╡ 0ee778d2-6341-11eb-10b0-7146fbbc71ff
begin
	# verification
	my_shapes = [randplace!(deepcopy(myshape), (-10,10),(-10,10)) for i in 1:100] 
	plotshapes(my_shapes, alpha=0.2)
end

# ╔═╡ 2338ef6a-630b-11eb-1837-431b567ad619
md"""
## Simulating a system of shapes

Suppose we want to use our shape(s) to study a system of non-interacting particles.
Here, we assume that the shapes are rigid and cannot overlap.
There are no forces that attract or repel particles.
Such studies might be of interest in nanoscience, molecular dynamics or self-organization of complex systems.

One approach to study systems of particles is to model every particle's dynamics, keep track of all collisions, etc.
We will do something more ingenious: we will use ideas from statistical physics.
Namely, every valid state (i.e., no shapes overlap and all shapes are within the box) is equally likely.
So instead of simulating the system, we will take samples from it!
These samples are equivalent to random 'snapshots' of a more complex simulation.
Pretty cool, right?

To generate the samples, we will use [rejection sampling](https://en.wikipedia.org/wiki/Rejection_sampling).
Here, we will randomly place shapes within the box until we are lucky and found one that does not overlap.
More concretely, we follow the following steps:
1. generate all the shapes you want to place;
2. randomly place the shapes into the box (using `randplace!`);
3. from the moment a single shape overlaps with another shape, you have to start entirely anew to step 2.

The last point is crucial! If you place a shape that overlaps an earlier shape,
it is insufficient to redistribute that shape. **You have to start over completely.** Only then will you generate correct samples.

The inputs of our function implementing the above algorithm are:
- `shapes`: a list of your shapes (same type, but not necessarily with the same dimensions);
- `xlims`, `ylims`: tuples outlining the box;
The function works inplace, and returns the number of trials needed to generate a valid sample.
This quantity is relevant by itself (it is related to the partition function of the Boltzmann distribution), but we will only use it for diagnostic purposes.

As you might imagine, this algorithm is still very computationally expensive.
Try with about 20 shapes, and work yourself up to more extensive examples.
Try a mixture of small and large shapes. You should see some self-organization going on!

"""

# ╔═╡ 965b578e-63a5-11eb-2cf4-690ec58e939d
xlims = (0, 100)

# ╔═╡ 961ea26c-63a5-11eb-1227-4bcaf4778d82
ylims = (0, 80)

# ╔═╡ a30ded16-63a5-11eb-35f2-2b1ff724eb54
function rejection_sampling!(shapes::Vector{<:Shape}, xlims, ylims)
    # place all the shapes one-by-one, such that they don't overlap
	# the moment you find a single conflict, you have to start over again
	
	return shapes, trials
    
end

# ╔═╡ 3a961b6e-62f1-11eb-250b-13a3f6f17eaa
begin 
	checkbox(test::Bool)= test ? "✅" : "◯"
	checkbox2(test::Bool)= test ? "✅" : ""
	test1 = @safe !ismissing(myshape)
	test2 = @safe !ismissing(myshape |> corners) && !ismissing(myshape|> ncorners)
	test3 = @safe !ismissing(myshape |> center)
	test4 = @safe !ismissing(myshape |> xycoords)
	test5 = @safe !ismissing(myshape |> xlim) && !ismissing(myshape |> ylim) &&
		!ismissing(myshape |> boundingbox)
	test6 = @safe !ismissing(myshape |> area)
	test7 = @safe !ismissing(move!(myshape |> deepcopy,(1.0,1.0))) &&
				!ismissing(rotate!(myshape |> deepcopy,(1.0))) &&
				!ismissing(scale!(myshape |> deepcopy,(1.0)))
	test8 = @safe !ismissing(in((0.5, 0), myshape))
	test9 = @safe !ismissing(intersect(myshape, myshape))
	test10 = @safe !ismissing(randplace!(myshape, (0.0, 1.0), (0.0, 1.0)))
	test11 = @safe rejection_sampling!([deepcopy(myshape) for i in 1:2], (0, 100), (0, 100)) |> !ismissing
 
end;

# ╔═╡ 7545c788-62f0-11eb-3f6e-01deeaf990e0
md"""
 $(checkbox(test1)) add the correct *inner* constructor to your type (see below);


 $(checkbox(test2)) complete `corners` and `ncorners`, which return the corners and the number of corners, respecitively;


 $(checkbox(test3)) complete `center` to return the center of mass of the shape;
 
 $(checkbox(test4)) complete `xycoords`, which give two vectors with the x- and y-coordinates of the shape, used for plotting;
 
 $(checkbox(test5)) complete `xlim` and `ylim` to give the range on the x- and y-axes of your shape, in addition to `boundingbox` to generate a bounding box of your shape;
 
 $(checkbox(test6)) complete `area`, this computes the area of your shape;
 
 $(checkbox(test7)) complete `move!`, `rotate!` and `scale!` to transform your shape **in place** (note: `AbstractRectangle`s cannot be rotated, they are always aligned to the axes);
 
 $(checkbox(test8)) complete the function `in`, to check whether a point is in your shape;
 
 $(checkbox(test9)) complete `intersect`, to check whether two shapes overlap;
 
 $(checkbox(test10)) complete `randplace!`, which randomly moves and rotates a shape within a box;
 
 $(checkbox(test11)) complete the rejection sampling algorithm and experiment with your shape(s).
 
**Note:** You will need to create specific methods for different types. It's your job to split the template for the functions in several methods and use dispatch.
"""

# ╔═╡ 30c89806-6331-11eb-0610-d3545e7aeba4
begin
   test_rect = @safe Rectangle((1.0, 1.0)) !== missing

	
	
   q_rect_con = Question(;
			description=md"""
			So we have defined a composite Rectangle type with a few fields but the inner constructor is missing. This inner constructor should to instantiate a Rectangle with center (`x`,`y`) and a default length and width of 1.0.   
		
			Multiple dispatch allows us to define multiple constructors for different scenario's. So we have defined an additional constructor where the extremum coordinates are provided (`xmin`, `xmin`), (`ymin`, `ymax`), assuming that the rectangle is always aligned with the axes.
			""")
	
   q_rect_con = QuestionBlock(;
	title=md"**Rectangle ⭐️** $(checkbox2(test_rect)) ",
	questions = [q_rect_con],
	hints=[
		hint(md"Remember, `new()`?")
	]
	)
end

# ╔═╡ abc99468-6333-11eb-1a9d-e50f8e56e468
begin
   test_sq = @safe Square((1.0, 1.0)) !== missing

   q_sq_con = Question(;
			description=md"""
			Can you complete the inner constructor for the square type?
			""")
	
   qb_sq_con = QuestionBlock(;
	title=md"**Square ⭐️** $(checkbox2(test_sq)) ",
	questions = [q_sq_con]
	)
end

# ╔═╡ 5dcdba4e-6335-11eb-19d2-2d10ae81fa39
begin
   test_circle = @safe Circle((1.0, 1.0)) !== missing

   q_circle_con = Question(;
			description=md"""
`Circle`'s are pretty straightforward, having a center and a radius.
			""")
	
   qb_circle_con = QuestionBlock(;
	title=md"**Circles ⭐️⭐️** $(checkbox2(test_circle)) ",
	questions = [q_circle_con]
	)
end

# ╔═╡ 6d06ddfc-6334-11eb-2995-81333ac5e1cd
begin
   test_poly = @safe RegularPolygon((1.0, 1.0), 5) !== missing

   q_poly_con = Question(;
			description=md"""
Regular polygons have a center (`x`, `y`), a radius `R` (distance center to one of the corners) and an angle `θ` how it is tilted.
The order of the polygon is part of its parametric type, so we give the compiler some hints on how it will behave.

Can you complete the inner constructor for the polygon type? This is a little more challenging since it is a **parametric composite type** where `N` is the number of corners.
			""")
	
   qb_poly_con = QuestionBlock(;
	title=md"**Regular polygons ⭐️⭐️⭐️** $(checkbox2(test_poly)) ",
	questions = [q_poly_con],
	hints=[hint(md"`new{n}(...)`")]
	)
end

# ╔═╡ 94cbef4e-6348-11eb-030f-d7a9debdd305
begin
   q_area = Question(;
			description=md"""

Next, let us compute the area of our shapes.
			""")
	
   qb_area = QuestionBlock(;
	title=md"**Assignment: Area ⭐️** $(checkbox2(test_circle)) ",
	questions = [q_area],
	hints= [
		hint(md"The area of a triangle can be computed as $${\frac {1}{2}}{\big |}(x_{A}-x_{C})(y_{B}-y_{A})-(x_{A}-x_{B})(y_{C}-y_{A}){\big |}$$."),
		hint(md"A regular polygon consists of a couple of isosceles triangles.")	
		]
	)
end

# ╔═╡ e5a7eee2-63a5-11eb-0267-499409488b19
md"Function to place `n` copies of a given `shape`:"

# ╔═╡ de6124d2-63a5-11eb-1145-5b11f5f1c0f4
function rejection_sampling(shape, n, xlims, ylims)
    shapes = [deepcopy(shape) for i in 1:n]
    trials = rejection_sampling!(shapes, xlims, ylims)
    return shapes, trials
end


# ╔═╡ Cell order:
# ╠═23bcbb02-62ef-11eb-27f9-13ed327ac098
# ╟─1657b9b2-62ef-11eb-062e-4758f9ea1075
# ╠═63f5861e-6244-11eb-268b-a16bc3f8265c
# ╟─b1d21552-6242-11eb-2665-c9232be7026e
# ╟─f2485038-30dc-4137-88bb-f9394962ec9e
# ╟─7189b1ee-62ef-11eb-121a-8d7bb3df52c3
# ╟─7545c788-62f0-11eb-3f6e-01deeaf990e0
# ╟─f8b080fe-6309-11eb-17aa-fb098fc00b11
# ╟─3a961b6e-62f1-11eb-250b-13a3f6f17eaa
# ╟─d65b61ba-6242-11eb-030d-b18a7518731b
# ╠═e3f846c8-6242-11eb-0d12-ed9f7e534db8
# ╟─e7e43620-6242-11eb-1e2e-65874fe8e293
# ╠═f4b05730-6242-11eb-0e24-51d4c60dc451
# ╠═fe413efe-6242-11eb-3c38-13b9d996bc90
# ╟─30c89806-6331-11eb-0610-d3545e7aeba4
# ╟─4d4285e8-6334-11eb-0d76-136cc5f645cd
# ╟─12ddaece-6243-11eb-1e9d-2be312d2e22d
# ╠═16666cac-6243-11eb-0e0f-dd0d0ec53926
# ╟─abc99468-6333-11eb-1a9d-e50f8e56e468
# ╟─501f9828-6334-11eb-0f2a-ebaa1d5b0f46
# ╟─23ea0a46-6243-11eb-145a-b38e34969cfd
# ╠═1b129bf4-6243-11eb-1fa2-d7bd5563a1b4
# ╟─94ec5382-6335-11eb-100c-15d70f27e703
# ╟─5dcdba4e-6335-11eb-19d2-2d10ae81fa39
# ╠═3d67d61a-6243-11eb-1f83-49032ad146da
# ╟─4ce7abea-6335-11eb-1657-a3ee8986d55e
# ╟─6d06ddfc-6334-11eb-2995-81333ac5e1cd
# ╠═33757f2c-6243-11eb-11c2-ab5bbd90aa6b
# ╟─bbbe4c9a-6335-11eb-1dc7-55ddf17887f4
# ╟─4234b198-6243-11eb-2cfa-6102bfd9b896
# ╠═473d9b5c-6243-11eb-363d-23108e81eb93
# ╟─ce3393a8-6335-11eb-06e9-af93a3794902
# ╠═50e45ac6-6243-11eb-27f9-d5e7d0e1dc01
# ╟─dad14258-6309-11eb-0a9a-37c0386c8cb4
# ╠═55de4f76-6243-11eb-1445-a54d01242f64
# ╠═5b6b9854-6243-11eb-2d5b-f3e41ecf2914
# ╠═5f120f1a-6243-11eb-1448-cb12a75680b0
# ╠═64fcb6a0-6243-11eb-1b35-437e8e0bfac8
# ╠═668f568a-6243-11eb-3f01-adf1b603e0e4
# ╠═7b785b7a-6243-11eb-31c2-9d9deea78842
# ╟─b6a4c98a-6300-11eb-0542-ab324d8e4d7e
# ╟─5a61e0da-6338-11eb-2a58-ad06aae62940
# ╟─ca5302b2-6337-11eb-2e98-efb764a792a4
# ╟─7c80d608-6243-11eb-38ba-f97f7476b245
# ╟─58eb84be-63c3-11eb-09f5-6d16973c7aa7
# ╟─57dee25a-63c3-11eb-0c7a-bfb1ac79bc7b
# ╟─62e7e05e-62fe-11eb-1611-61274c5498cc
# ╠═a005992e-6243-11eb-3e29-61c19c6e5c7c
# ╠═ac423fa8-6243-11eb-1385-a395d208c42d
# ╠═ddf0ac38-6243-11eb-3a1d-cd39d70b2ee0
# ╠═ecc9a53e-6243-11eb-2784-ed46ccbcadd2
# ╟─c16c36f6-6339-11eb-20d4-27ef9f74b747
# ╟─5de0c912-6244-11eb-13fd-bfd8328191a6
# ╟─fe48d2f0-63c2-11eb-12f7-d5a8d6d0ce27
# ╟─aa186788-63c3-11eb-1bd1-d138d586e8b6
# ╠═a89bdba6-6244-11eb-0b83-c1c64e4de17d
# ╠═b1372784-6244-11eb-0279-27fd755cda6a
# ╟─bd706964-6244-11eb-1d9d-2b60e53cdce1
# ╠═b91e1e62-6244-11eb-1045-0770fa92e040
# ╟─d60f8ca4-6244-11eb-2055-4551e4c10906
# ╟─94cbef4e-6348-11eb-030f-d7a9debdd305
# ╠═ebf4a45a-6244-11eb-0965-197f536f8e87
# ╟─230dd290-6303-11eb-0f55-311ef2b9541e
# ╟─36cc0492-6246-11eb-38dd-4f42fb7066dc
# ╟─ed4bfad2-63c6-11eb-0292-73c34e4d34a6
# ╟─285930b8-63c7-11eb-372b-edc4a4ed0d0a
# ╠═83c6d25c-6246-11eb-1a24-57e20f5e7262
# ╠═a1b2a4f8-6246-11eb-00ea-8f6042c72f4e
# ╠═b907e8fc-6246-11eb-0beb-bb44930d033c
# ╟─2d7a63cc-64db-11eb-0a4c-bb7771af8b14
# ╟─d08ab6d0-6246-11eb-08a8-152f9802cdfc
# ╠═dfc779ee-6246-11eb-240b-4dc7a7d95641
# ╠═e30d10d2-6246-11eb-1d59-332b5916712e
# ╠═e7e90744-6246-11eb-157c-cf67e8619d6e
# ╟─1aec9fc2-6247-11eb-2942-edc370918f9e
# ╠═8bdc61b0-6330-11eb-3e9a-15412fecf8af
# ╠═16d0ea9c-6247-11eb-12c6-1709f6d0ac99
# ╟─6bae2128-6303-11eb-34f2-1dfa96e46ae6
# ╠═287a7506-6247-11eb-2bad-0778802c00d5
# ╟─01d899e6-6305-11eb-017b-27bb2c104ef5
# ╟─221e09a2-6247-11eb-12a8-a13c0a2f96e7
# ╟─6851ebb2-6339-11eb-2ab7-39e07c4e3154
# ╠═e565d548-6247-11eb-2824-7521d4fa6b2b
# ╠═150f1dae-6248-11eb-276f-9bbf7eba58fd
# ╟─b8ed26f2-633b-11eb-380e-9379b0f4697f
# ╠═f4873fce-6249-11eb-0140-871354ca5430
# ╟─22f63a5e-633a-11eb-27c7-27fcabc7bc6f
# ╟─f3ea648e-633b-11eb-3444-317a4eb5b8ea
# ╠═5368c46e-633e-11eb-0d98-b1ccb37cc7f8
# ╟─e6efb632-6338-11eb-2e22-eb0b1ff577c4
# ╠═0381fbba-6248-11eb-3e80-b37137438531
# ╟─91273cd2-6248-11eb-245c-abb6269f916b
# ╠═653af7c6-6248-11eb-2a7b-fbf7550ef92b
# ╠═6aa3519a-6248-11eb-193d-a3537f7d3bd0
# ╟─51bca412-6340-11eb-3f38-8bfc8377715b
# ╟─e21b0f1c-633b-11eb-3609-9b9dae71c915
# ╟─f97bf1c0-6247-11eb-1acc-e30068a277d0
# ╟─97c8cd32-6340-11eb-1d6d-b7d364c0c987
# ╠═8d73b66c-624e-11eb-0a52-2309ef897b1c
# ╟─3e0a2e20-6341-11eb-3c23-a38b04c89b37
# ╠═0ee778d2-6341-11eb-10b0-7146fbbc71ff
# ╟─2338ef6a-630b-11eb-1837-431b567ad619
# ╠═965b578e-63a5-11eb-2cf4-690ec58e939d
# ╠═961ea26c-63a5-11eb-1227-4bcaf4778d82
# ╠═a30ded16-63a5-11eb-35f2-2b1ff724eb54
# ╟─e5a7eee2-63a5-11eb-0267-499409488b19
# ╠═de6124d2-63a5-11eb-1145-5b11f5f1c0f4
