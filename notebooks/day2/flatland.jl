### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 1982066a-52aa-11eb-03f7-573ec8cfc235
using Plots, Colors, Random

# ╔═╡ 382ccf46-52aa-11eb-00f5-796a8f0db617
using RecipesBase

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
		l::Float64
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
		l, w = shape.l, shape.w
		return [(x+w/2, y+l/2), (x-w/2, y+l/2), (x-w/2, y-l/2), (x+w/2, y-l/2)]
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

# ╔═╡ b04c089c-5350-11eb-135b-7109553ad714
begin
	Base.in((x, y), s::Circle) = (s.x-x)^2 + (s.y-y)^2 ≤ s.R^2
	
	function Base.in((x, y), s::Rectangle)
		xc, yc = center(s)
		return (xc - 0.5s.w ≤ x ≤ xc + 0.5s.w) && (yc - 0.5s.h ≤ y ≤ yc + 0.5s.h)
	end
	
	#TODO: Polygon and Triangle
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

# ╔═╡ 75b0241c-52aa-11eb-19fc-416ae8a455a8
bill = Triangle((0, 0), (1, 0), (0.5, √(1-0.5)))

# ╔═╡ 04db4e86-534c-11eb-1151-41ba6938fd34
plot(bill)

# ╔═╡ 8685df70-52aa-11eb-3aa6-07856cd2d3b6
plot(Polygon((1, 1), 4, 3))

# ╔═╡ 873cebde-52aa-11eb-1eb4-5f2a08a7096d
corners(bill)

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
# ╠═b04c089c-5350-11eb-135b-7109553ad714
# ╠═7a757ca8-534e-11eb-0440-1d4929378e2b
# ╠═75b0241c-52aa-11eb-19fc-416ae8a455a8
# ╠═04db4e86-534c-11eb-1151-41ba6938fd34
# ╠═8685df70-52aa-11eb-3aa6-07856cd2d3b6
# ╠═873cebde-52aa-11eb-1eb4-5f2a08a7096d
# ╠═8ace273a-534b-11eb-2248-9d5d7195a7e7
# ╠═75ad5b7c-534c-11eb-04cd-07a8cbf1531b
# ╠═7160bec2-534e-11eb-01fe-bb03bffd1968
