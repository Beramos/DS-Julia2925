### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 4e827046-8787-11ed-1763-99b10d56f7a6
using PlutoUI, Random; TableOfContents()

# ╔═╡ 347583c6-9ed6-42af-b760-733585dbb7a6
# edit the code below to set your name and UGent username

student = (name = "Jimmy Janssen", email = "Jimmy.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ efb5380d-ab9d-4e7e-ad2b-d7beb3e28609
@bind shape_type Select(["circles", "rectangles", "triangles"])

# ╔═╡ b7e28115-8901-4972-b37f-9b5869735b50
md"""
# Crazy fields 
Bram will think of a better title

In this synthesis exercise, you will help a gardener manage their fields. The fields are of peculiar shape: they are all in the shape of $(shape_type)! These little fields are part of a big piece of land that extends from 0 to 100 in both the x and y direction.

> Note, you can choose the flavour of this exercise by picking the shapes of the fields, circles and rectangles are quite easy, while triangles test your geometry skills!

"""

# ╔═╡ 2ff01603-4322-4571-b172-20b9952ff4ff
if shape_type == "circles"
	md"Circles are given as a tuple of type `(x, y, R)` with (`x`, `y`) its centre and `R` the radius."
elseif shape_type == "rectangles"
	md"Rectangles are represented as (x, y, w, h) with (`x`, `y`) its centre and (`w`, `h`) the width and height."
elseif shape_type == "triangles"
	md"Triangles are represented as `(x1, y1, x2, y2, x3 y3)`, the three coordinates of the corners."
end

# ╔═╡ 7470865e-87e2-4e40-8cb5-e27b516ce976
md"This exercise is free-form for you to practice your Julia skills. Making a dedicated type with constructor might make things easier, but is not required."

# ╔═╡ cb0e6002-1e60-4a2d-af54-b52ac8f0d318
md"""
## Assignments

### 1. Areas

> Make a function `area` to compute the area of your shape. Find the sum of all your shapes.

Extra: can you directly use `sort!` to sort your shapes by area?

"""

# ╔═╡ 409d0d25-bae3-45ed-9ba1-477fcf928bce
area(;x,y,R) = R^2 * pi 

# ╔═╡ 3bdf0670-2511-4fd6-be39-8d22c2945d4c
md"""
### 2. Overlap

> Some of the fields might overlap. Can you extend the function `isdisjoint` to check if two of your shapes *don't* overlap? How many of the shapes don't overlap?
"""

# ╔═╡ 5949a413-705d-477b-8091-d517f09095de
Base.isdisjoint((x1,y1,R1),(x2,y2,R2)) = (x1-x2)^2 + (y1-y2)^2 ≥ (R1 + R2)^2

# ╔═╡ 8b19a9e4-5701-4e45-85a6-8e9d3b93563f


# ╔═╡ faf30153-b607-48d1-8db0-1f47e2e1e62e
md"""
### 3. Total area within bound

> As you have seen in the previous question, some fields overlap. Likewise, part of the shapes might be out bound of the $[0,100]\times [0,100]$ larger field. Can you compute or estimate the total available area where you don't count overlapping parts multiple times?

Computing this might be a bit tricky. So the farmer proposes an alternative solution to estimate the area. They suggest randomly throwing a large number (say, 100,000) of seeds in the big field and count which fraction land in one of the shapes. This fraction is proportional to the part of the land covered by a field.

To this end, extend the function `in` such that you can check whether a point lies in a shape, i.e. `(x, y) in shape`. You can use the function `count` to estimate the surface.
"""

# ╔═╡ cbddea11-0694-484e-a3b9-63ff1d565300
#Base.in((x,y), (xc,yc,R)) = (x-xc)^2 + (y-yc)^2 < R^2

# ╔═╡ 341062d6-bc50-47fe-acfd-8401321fec86
#Base.in((xc,yc,R)) = (x-xc)^2 + (y-yc)^2 < R^2

# ╔═╡ 47d9f887-a7e0-42e0-ad27-53b6d5b8adb2
points = [(rand(), rand()) for _ in 1:10_000]

# ╔═╡ e1a4741f-415d-4a61-8ff5-a8454607d437


# ╔═╡ a70e9d92-c098-49e1-bb8f-4adfc55a6c98
#n_points_inshape = count(any(s->p in s, circles) for p in points)

# ╔═╡ 07a91625-2e1c-4f31-ae13-1f1316bb26e8


# ╔═╡ 57f8656f-7c84-47cc-9da1-62c3e74c7769
begin
	Random.seed!(1)

	n = 100
	Rmax = 10

	circles = [(x=100rand(), y=100rand(), R=Rmax * rand()) for _ in 1:n]
	rectangles = [(x=100rand(), y=100rand(), w=5rand()+5, h=5rand()+5) for _ in 1:n]
	triangles = [100rand(2) |> ((x, y),)->(x1=x+4randn(), y1=y+4randn(), x2=x+4randn(), y2=y+4randn(), x3=x+4randn(), y3=y+4randn()) for _ in 1:n]
end;

# ╔═╡ a7fdf0f3-4810-4c9c-8fd5-e144b602d209
sum(c->area(;c...), circles)

# ╔═╡ 4a507508-0532-4659-94b4-7a04bdd91fe0
count(all(isdisjoint(ci, cj) for (j, cj) in enumerate(circles) if i != j)
		for (i, ci) in enumerate(circles))

# ╔═╡ d5c9526d-5dff-4fb2-8a2c-e96c0229f474
shapes = shape_type=="circles" ? circles : (shape_type=="rectangles" ? rectangles : triangles);

# ╔═╡ 9c443e96-d40c-4c9d-a0b3-3390e18911df
shapes

# ╔═╡ de71232a-1498-4db1-8fc3-65a84a93551a
first(shapes)

# ╔═╡ 73503bf0-5dc8-4cc5-a636-e6521ef3089e
md"""
## Hints
"""

# ╔═╡ 93becd08-699a-471e-a92c-dc134229a0ec
sum(sqrt, [1, 3, 4])

# ╔═╡ f320a277-0b23-4a63-834d-a1f8815610fb
count(>(2), [-1, 1, 3, 8, 9])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[compat]
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "80a5d8517e826b2173974b49edb80bdf023b7a81"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═4e827046-8787-11ed-1763-99b10d56f7a6
# ╠═347583c6-9ed6-42af-b760-733585dbb7a6
# ╠═b7e28115-8901-4972-b37f-9b5869735b50
# ╠═efb5380d-ab9d-4e7e-ad2b-d7beb3e28609
# ╠═9c443e96-d40c-4c9d-a0b3-3390e18911df
# ╠═2ff01603-4322-4571-b172-20b9952ff4ff
# ╠═de71232a-1498-4db1-8fc3-65a84a93551a
# ╠═7470865e-87e2-4e40-8cb5-e27b516ce976
# ╠═cb0e6002-1e60-4a2d-af54-b52ac8f0d318
# ╠═409d0d25-bae3-45ed-9ba1-477fcf928bce
# ╠═a7fdf0f3-4810-4c9c-8fd5-e144b602d209
# ╠═3bdf0670-2511-4fd6-be39-8d22c2945d4c
# ╠═5949a413-705d-477b-8091-d517f09095de
# ╠═4a507508-0532-4659-94b4-7a04bdd91fe0
# ╠═8b19a9e4-5701-4e45-85a6-8e9d3b93563f
# ╠═faf30153-b607-48d1-8db0-1f47e2e1e62e
# ╠═cbddea11-0694-484e-a3b9-63ff1d565300
# ╠═341062d6-bc50-47fe-acfd-8401321fec86
# ╠═47d9f887-a7e0-42e0-ad27-53b6d5b8adb2
# ╠═e1a4741f-415d-4a61-8ff5-a8454607d437
# ╠═a70e9d92-c098-49e1-bb8f-4adfc55a6c98
# ╠═07a91625-2e1c-4f31-ae13-1f1316bb26e8
# ╠═57f8656f-7c84-47cc-9da1-62c3e74c7769
# ╠═d5c9526d-5dff-4fb2-8a2c-e96c0229f474
# ╠═73503bf0-5dc8-4cc5-a636-e6521ef3089e
# ╠═93becd08-699a-471e-a92c-dc134229a0ec
# ╠═f320a277-0b23-4a63-834d-a1f8815610fb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
