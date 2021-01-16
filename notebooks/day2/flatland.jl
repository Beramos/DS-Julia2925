### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 1982066a-52aa-11eb-03f7-573ec8cfc235
using Plots, Colors, Random

# ╔═╡ 382ccf46-52aa-11eb-00f5-796a8f0db617
using RecipesBase

# ╔═╡ 571b0ee4-57f6-11eb-265b-d556fc5d9efa
using LinearAlgebra

# ╔═╡ e310fd66-52a9-11eb-3fd6-0fff013ee966
abstract type Shape end

# ╔═╡ 448524fa-52aa-11eb-2c1a-3bec050967fc
randcolor() = RGB(rand(), rand(), rand())

# ╔═╡ 97c58ada-534a-11eb-1f81-ed88a6bf0aad
randcolor()

# ╔═╡ e9970200-534b-11eb-2da3-43226e7a37c0
color(s::Shape) = s.color

# ╔═╡ 01b9278e-52aa-11eb-0264-b9429a9f6040
begin
	mutable struct Rectangle <: Shape
		x::Float64
		y::Float64
		h::Float64
		w::Float64
		color::RGB
	end

	Rectangle((x, y), l, w=l; color=randcolor()) = Rectangle(x, y, l, w, color)
end

# ╔═╡ cc20cdba-534a-11eb-1b17-ad2f90ff8604
Rectangle((0, 0), 1, 1.1)

# ╔═╡ 0957fff6-52aa-11eb-1578-157fa8eedc86
begin
	mutable struct Polygon <: Shape
    	x::Float64
    	y::Float64
    	n::Int
    	R::Float64
		color::RGB
	end
	
	Polygon((x, y), n, R=1; color=randcolor()) = Polygon(x, y, n, R, color)
end

# ╔═╡ 22440b86-52aa-11eb-1ab1-f7ad05be14a0
begin
	mutable struct Triangle <: Shape
    	x1::Float64
    	x2::Float64
    	x3::Float64
    	y1::Float64
    	y2::Float64
    	y3::Float64
		color::RGB
	end


	Triangle((x1, y1), (x2, y2), (x3, y3); color=randcolor()) = Triangle(x1, x2, x3, y1, y2, y3, color)
end

# ╔═╡ bb00bc7a-52aa-11eb-32c6-3d29e6473944
begin
	mutable struct Circle <: Shape
		x::Float64
		y::Float64
		R::Float64
		color::RGB
	end
	
	Circle((x, y), R=1; color=randcolor()) = Circle(x, y, R, color)
end

# ╔═╡ 0cde4058-534b-11eb-37e0-5d3caddc820c
priest = Circle((8,9), 2)

# ╔═╡ d95155c8-5349-11eb-0c73-0fc1cb5292fc
begin
	center(shape::Shape) = shape.x, shape.y
	
	center(t::Triangle) = ((t.x1 + t.x2 + t.x3) / 3, (t.y1 + t.y2 + t.y3) / 3)
end

# ╔═╡ c9ec34a8-52aa-11eb-16c3-cf85388e6827
begin
	ncorners(::Circle) = 0
	ncorners(::Triangle) = 3
	ncorners(::Circle) = 0
end

# ╔═╡ 0f0ebd94-52ab-11eb-0b1c-71b8bfd7b9f1
begin
	
	function corners(shape::Rectangle)
		x, y = center(shape)
		h, w = shape.h, shape.w
		return [(x+w/2, y+h/2), (x-w/2, y+h/2), (x-w/2, y-h/2), (x+w/2, y-h/2)]
	end
	
	function corners(shape::Polygon)
		x, y = center(shape)
		R = shape.R
		n = shape.n
		return [(x+R*cos(θ), y+R*sin(θ)) for θ in range(0, step=2π/n, length=n)]
	end
	
	corners(t::Triangle) = [(t.x1, t.y1), (t.x2, t.y2), (t.x3, t.y3)]
end

# ╔═╡ 8d418288-52aa-11eb-1952-f1eb33e14955
begin
	area(shape::Rectangle) = shape.l * shape.w
	
	function area(shape::Polygon)
    	R = shape.R
    	n = shape.n
    	θ = 2π / n  # angle of a triangle
    	h = R * cos(θ/2)
    	b = R * sin(θ/2)
    	return b * h * n
	end
	
	function area(t::Triangle)
		(x1, y1), (x2, y2), (x3, y3) = corners(t)
		return abs(x1*y2 + x2*y3 + x3*y1 - y1*x2 - y2*x3 - y3*x1) / 2
	end
	
	area(shape::Circle) = shape.R^2 * π
end

# ╔═╡ a3fb2576-534d-11eb-09d2-1d30831e4af4
function Base.show(io::IO, s::Shape)
	println(io, "$(typeof(s)) ($(ncorners(s)) corners, area = $(area(s)))")
	plot(s, xticks=[],yticks=[])
end

# ╔═╡ dae8acb4-52aa-11eb-296d-1b3937f0725d
begin
	function xycoords(shape::Circle; n=50)
    	θs = range(0, 2π, length=n)
    	return shape.x .+ shape.R * cos.(θs), shape.y .+ shape.R * sin.(θs)
	end
	
	xycoords(s::Shape) = [first(p) for p in corners(s)], [last(p) for p in corners(s)]
end

# ╔═╡ 3c4b64e8-52aa-11eb-10e6-2dae86fd9c43
@recipe function f(s::Shape)
    xguide --> "x"
    yguide --> "y"
    label --> ""
    aspect_ratio := :equal
    seriestype := :shape
	color := color(s)
    x, y = xycoords(s)
    return x, y
end

# ╔═╡ 7a757ca8-534e-11eb-0440-1d4929378e2b
begin
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
end

# ╔═╡ 0bc031a4-57f1-11eb-2c93-332ecb81b5dc
function same_side((a, b), p, q)
	n = (a[2] - b[2], b[1] - a[1])
	return sign(n⋅(p.-a)) == sign(n⋅(q.-a))
end

# ╔═╡ b04c089c-5350-11eb-135b-7109553ad714
begin
	Base.in((x, y), s::Circle) = (s.x-x)^2 + (s.y-y)^2 ≤ s.R^2
	
	function Base.in((x, y), s::Rectangle)
		xc, yc = center(s)
		return (xc - 0.5s.w ≤ x ≤ xc + 0.5s.w) && (yc - 0.5s.h ≤ y ≤ yc + 0.5s.h)
	end
	
	function Base.in(q, s::Triangle)
		p1, p2, p3 = corners(s)
		return same_side((p1, p2), p3, q) && 
				same_side((p2, p3), p1, q) &&
				same_side((p3, p1), p2, q)
	end
end

# ╔═╡ 75ad32c6-57f9-11eb-0774-f326297d1f39
bill = Triangle((0, 0), (1, 0), (0.5, √(1-0.5)))

# ╔═╡ f51c609a-5821-11eb-277e-eba6301206c1
p1, p2, p3 = corners(bill)

# ╔═╡ 026e1764-5822-11eb-01e4-1dc6b13e287d
q = (0.5, 0.2)

# ╔═╡ b0dca02a-5821-11eb-2b7c-b11ad04774b4
q ∈ bill

# ╔═╡ 0faae2c4-5822-11eb-2c82-5d7acfc38f4b
same_side((p1, p2), p3, q)

# ╔═╡ 16e60fc8-5822-11eb-207c-13397a2a9842
same_side((p1, p3), p2, q)

# ╔═╡ 24c6a88a-5822-11eb-0480-49653e920137
same_side((p2, p3), p1, q)

# ╔═╡ 28bcd058-5822-11eb-318d-b7bfe2e0372f
v = p3 .- p2

# ╔═╡ 3482cb20-5822-11eb-1338-452d9b51b667
n = (-v[2], v[1])

# ╔═╡ 444eaa88-5822-11eb-311f-5ff6929ad2d7
v ⋅ n

# ╔═╡ 8458f054-57f8-11eb-28fd-6bf66190041e
begin 
	colorin((i,j), s::Shape) = (i, j) in s ? s.color : RGB(1.0, 1.0, 1.0)
	
	function colorin((i,j), shapes::Vector{<:Shape})
		i = findlast(s->(i,j) in s, shapes)
		# if no index is found, the pixel does not fall in a shape
		# return white
		isnothing(i) && return RGB(1.0, 1.0, 1.0)
		return shapes[i].color
	end
end

# ╔═╡ e2980baa-57fa-11eb-1e91-9929062ea491
randpoint(xmax, ymax) = (xmax*rand(), ymax*rand())

# ╔═╡ 33dd73fa-57fa-11eb-3dc6-cdc3e1e9c8ac
begin
	randshapes(::Type{Triangle}, n, (xmax, ymax)) = [Triangle(randpoint(xmax, ymax), randpoint(xmax, ymax), randpoint(xmax, ymax)) for i in 1:n]
	
	randshapes(::Type{Rectangle}, n, (xmax, ymax), zmax) = [Rectangle(randpoint(xmax, ymax), zmax*rand(), zmax*rand()) for i in 1:n]
end

# ╔═╡ 74758296-57fe-11eb-2c9f-5b7fd6bf3a19
triangle = Triangle(randpoint(10, 10), randpoint(10, 10),randpoint(10, 10))

# ╔═╡ 8acdb9e8-57fe-11eb-1ec0-79d736759f04
begin
	p= plot(triangle)
	for i in 1:100
		q = 10rand(2)
		if q in triangle
			scatter!([q[1]], [q[2]], label="", color="red")
		else
			scatter!([q[1]], [q[2]], label="", color="blue")
		end
	end
	p
end
			

# ╔═╡ 004423dc-57fe-11eb-143c-f50c5280f1ff
function plotshapes(shapes)
	p = plot()
	plot!.(shapes)
	return p
end

# ╔═╡ b0f8c998-57fa-11eb-1274-1f07263100f3
triangles = randshapes(Triangle, 10, (100, 200))

# ╔═╡ 212d3988-5823-11eb-1d9d-29770ae308a2
rectangles = randshapes(Rectangle, 10, (100, 200), 50)

# ╔═╡ f0249e3c-57fd-11eb-2da8-b501d5ed6e2f
plotshapes(triangles)

# ╔═╡ 419604e8-5823-11eb-0a0c-af22bcc5b47c
plotshapes(rectangles)

# ╔═╡ 3990bcea-57fe-11eb-0f7d-11cd11b01d92
triangles[1].color

# ╔═╡ 0d87454a-57fb-11eb-0289-459ea5c41e31
[colorin((j, i), rectangles) for i in -100:100, j in -100:200]

# ╔═╡ 8ace273a-534b-11eb-2248-9d5d7195a7e7
mutatecolor(color; σcol=0.2) =  (color.r, color.g, color.b) .|> (x -> x + σcol*randn()) .|> (x-> clamp(x,0.0, 1.0)) |> (c->RGB(c...))

# ╔═╡ 75ad5b7c-534c-11eb-04cd-07a8cbf1531b
begin
	function mutateshape(s::Shape; σmove=1, σcol=0.2, scale=0.3)
		move!(s, σmove * randn(2))
		s.R *= 2scale * rand() + 1
		s.color = mutatecolor(s.color; σcol)
		s
	end
	
	function mutateshape(s::Triangle; σcol=0.2, σscale=1)
		s.x1 += σscale * randn()
		s.x2 += σscale * randn()
		s.x3 += σscale * randn()
		s.y1 += σscale * randn()
		s.y2 += σscale * randn()
		s.y3 += σscale * randn()
		s.color = mutatecolor(s.color; σcol)
		s
	end
	
	function mutateshape(s::Rectangle; σcol=0.2, scale=0.2)
		s.w *= 2scale * rand() + 1
		s.h *= 2scale * rand() + 1
		s.color = mutatecolor(s.color; σcol)
		s
	end
end

# ╔═╡ 7160bec2-534e-11eb-01fe-bb03bffd1968
function evolve_shapes(img, population; k_max=100, n_evals=200)
	for k in 1:k_max
		parents = select(img, population, n_evals)
		population = crossover(population)
		mutateshape!.(population)
	end
	return population
end

# ╔═╡ Cell order:
# ╠═1982066a-52aa-11eb-03f7-573ec8cfc235
# ╠═e310fd66-52a9-11eb-3fd6-0fff013ee966
# ╠═448524fa-52aa-11eb-2c1a-3bec050967fc
# ╠═97c58ada-534a-11eb-1f81-ed88a6bf0aad
# ╠═e9970200-534b-11eb-2da3-43226e7a37c0
# ╠═01b9278e-52aa-11eb-0264-b9429a9f6040
# ╠═cc20cdba-534a-11eb-1b17-ad2f90ff8604
# ╠═0957fff6-52aa-11eb-1578-157fa8eedc86
# ╠═22440b86-52aa-11eb-1ab1-f7ad05be14a0
# ╠═bb00bc7a-52aa-11eb-32c6-3d29e6473944
# ╠═0cde4058-534b-11eb-37e0-5d3caddc820c
# ╠═382ccf46-52aa-11eb-00f5-796a8f0db617
# ╠═3c4b64e8-52aa-11eb-10e6-2dae86fd9c43
# ╠═a3fb2576-534d-11eb-09d2-1d30831e4af4
# ╠═8d418288-52aa-11eb-1952-f1eb33e14955
# ╠═d95155c8-5349-11eb-0c73-0fc1cb5292fc
# ╠═c9ec34a8-52aa-11eb-16c3-cf85388e6827
# ╠═dae8acb4-52aa-11eb-296d-1b3937f0725d
# ╠═0f0ebd94-52ab-11eb-0b1c-71b8bfd7b9f1
# ╠═7a757ca8-534e-11eb-0440-1d4929378e2b
# ╠═571b0ee4-57f6-11eb-265b-d556fc5d9efa
# ╠═0bc031a4-57f1-11eb-2c93-332ecb81b5dc
# ╠═b04c089c-5350-11eb-135b-7109553ad714
# ╠═75ad32c6-57f9-11eb-0774-f326297d1f39
# ╠═f51c609a-5821-11eb-277e-eba6301206c1
# ╠═026e1764-5822-11eb-01e4-1dc6b13e287d
# ╠═b0dca02a-5821-11eb-2b7c-b11ad04774b4
# ╠═0faae2c4-5822-11eb-2c82-5d7acfc38f4b
# ╠═16e60fc8-5822-11eb-207c-13397a2a9842
# ╠═24c6a88a-5822-11eb-0480-49653e920137
# ╠═28bcd058-5822-11eb-318d-b7bfe2e0372f
# ╠═3482cb20-5822-11eb-1338-452d9b51b667
# ╠═444eaa88-5822-11eb-311f-5ff6929ad2d7
# ╠═8458f054-57f8-11eb-28fd-6bf66190041e
# ╠═e2980baa-57fa-11eb-1e91-9929062ea491
# ╠═33dd73fa-57fa-11eb-3dc6-cdc3e1e9c8ac
# ╠═74758296-57fe-11eb-2c9f-5b7fd6bf3a19
# ╠═8acdb9e8-57fe-11eb-1ec0-79d736759f04
# ╠═004423dc-57fe-11eb-143c-f50c5280f1ff
# ╠═b0f8c998-57fa-11eb-1274-1f07263100f3
# ╠═212d3988-5823-11eb-1d9d-29770ae308a2
# ╠═f0249e3c-57fd-11eb-2da8-b501d5ed6e2f
# ╠═419604e8-5823-11eb-0a0c-af22bcc5b47c
# ╠═3990bcea-57fe-11eb-0f7d-11cd11b01d92
# ╠═0d87454a-57fb-11eb-0289-459ea5c41e31
# ╠═8ace273a-534b-11eb-2248-9d5d7195a7e7
# ╠═75ad5b7c-534c-11eb-04cd-07a8cbf1531b
# ╠═7160bec2-534e-11eb-01fe-bb03bffd1968
