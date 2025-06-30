### A Pluto.jl notebook ###
# v0.20.10

using Markdown
using InteractiveUtils

# ╔═╡ 4109a39c-00b7-4954-bb73-35407f82a6f7
using PlutoUI; TableOfContents()

# ╔═╡ 24b76a7c-63dd-11eb-1b78-d5a20557e5cd
# edit the code below to set your name and UGent username

student = (name = "Jim Janssen", email = "Jim.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 36e51b02-63df-11eb-34a5-39e6e0650541
begin
	download("https://gist.githubusercontent.com/DaanVanHauwermeiren/2b02f275eef08643acfbf8fa9e9e4097/raw/e4e68d69d9c54a9b33a319d7b56dc8daf83fea5b/data.txt", "map.txt")
	
	function parse_input(input)
		lines = split(input, "\n")
		m = length(first(lines))
		#return [l[j]=='#' for l in lines, j in 1:m]
		return [l[j] for l in lines, j in 1:m]
	end
	
	map = read("map.txt", String) |> rstrip |> parse_input;
end

# ╔═╡ e677ca7e-63df-11eb-186b-8d20826ec916
map

# ╔═╡ fb39928c-63e2-11eb-2b85-15044c04fbe6
product_all_trees = missing

# ╔═╡ ede6342c-648d-11eb-0712-836637408e53


# ╔═╡ de9cf7b0-63ea-11eb-12fb-773d79c2463b
begin 
	struct CircularArray 
		data
	end

	circindex(i::Int,N::Int) = 1 + mod(i-1,N)
	circindex(I,N::Int) = [circindex(i,N)::Int for i in I]

	Base.size(A::CircularArray) = length(A.data)

	Base.getindex(A::CircularArray, i::Int) = getindex(A.data, circindex(i, size(A)))
	Base.getindex(A::CircularArray, I) = getindex(A.data, circindex(I, size(A)))
end

# ╔═╡ 8b75c14d-f706-4cf3-9921-c0c5050aa3a4
md"""
Submission by: **_$(student.name)_**
"""

# ╔═╡ 5368424c-63dd-11eb-3a1b-05a61e266d2b
md"""
# Additional exercises for basics

First of all, welcome to these additional exercises, **$(student[:name])**!

This exercise is based on [the advent of code](https://adventofcode.com/), a yearly programming challenge during the advent period.
"""

# ╔═╡ 6c0f2d10-63dd-11eb-2c17-fddf9cd51bfe
md"""## 1. Trajecting trajectories

Suppose you find yourself on top of a snowy mountain, sparsely covered with trees. You want to reach the bottom of the mountain using your sled, but the situation you find yourself in is certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (this will serve as the input later) of the open squares (.) and trees (#) you can see. For example:

```
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
```

These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times 🤯️:

```
..##.........##.........##.........##.........##.........##.......  --->
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
```

You start on the open square `(.)` in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

Your sled can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

The locations you would check in the above example are marked here with `O` where there was an open square and `X` where there was a tree:

```
..##.........##.........##.........##.........##.........##.......  --->
#..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........X.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...#X....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
```

In this example, traversing the map using this slope would cause you to encounter 7 trees.

"""

# ╔═╡ e1259736-63df-11eb-0010-3f2fc5719596
md"""
Let us first give you a hand with the data input:
"""

# ╔═╡ c34af248-63e3-11eb-2bfd-898ef2cfbea5
md"""## Questions
> **Question 1: counting trees**

Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?

Hints:
- This question can be answered without defining your own datatypes and using all that is available from the `Julia.Base` module. This can also be completed without knowing a lot about collections. Since this is only explained in the next part of the course.
- An alterative solution showcasing the power of Julia will be shown below, it includes some teasers of what is yet to come in this course.
"""

# ╔═╡ 4b4bbeb8-63e2-11eb-0ea2-6de494f61dc1
begin
	# this is where you start
	x, y = 1, 1
	# how big is the mountain?
	n, m = size(map)
	# you start your tree hitting counter at zero of course!
  	n_trees = 0
	
	# go over the mountain and count the trees!
	
	n_trees = missing
end

# ╔═╡ f50a0a99-9f4d-426b-a02e-291975d79d52
md"""
> **Question 2: counting trees**

Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

    Right 1, down 1.
    Right 3, down 1. (This is the slope you already checked.)
    Right 5, down 1.
    Right 7, down 1.
    Right 1, down 2.

In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?
"""

# ╔═╡ b9e97832-63e3-11eb-0e39-b5c9129eabbe
md"## Overly engineered solution to these questions showcasing the 💪️ of Julia"

# ╔═╡ 9c015578-648e-11eb-0768-d1e5edb4f65f
md"""This is already some advanced use of Julia, so do not worry if this is not yet fully clear. You will learn about this later in this course.

The alternative solutions makes use of the fact that the boundaries are circular. As an example, this would be valid:
```julia
A = ['a', 'b', 'c']
A[1] == A[4] == A[7]
```
So we need some datastructure that behaves like a normal array, but with wonky out-of-bounds behaviour!

In julia, a custom datatype can be defined as:

```
struct CircularArray 
	data
end
```
Now we have our data type `CircularArray`, which has a field `data`.
Using our knowledge from the simple example above, let us define a function which takes an index and the length of the array and returns the correct index using circular bounds. We will also create a function that takes an array of indices and returns an array of correct indices. Take a moment to think about how you would do this, and afterwards, check a possible implementation in hint 1.

So now we know how the compute the **standard** indices from the circular ones. 
We now need to define some things for our new datatype `CircularArray`. 
1. We need the `size` of `CircularArray` and 
2. We must define how `A[1]` works on our datatype (this is the `getindex` function in julia).
For the first problem, note that the size of a `CircularArray` is actually the size of the underlying array! So what do you think the function `Base.size(A::CircularArray) = ...` looks like? 
For the second problem, we need a definition of `Base.getindex(A::CircularArray, i::Int)`. How can we define this using the `circindex` function? 
If you have given this some thought, check out hint no 2 for the answer!

**Hints**

```julia
circindex(i::Int, N::Int) = 1 + mod(i-1,N)
circindex(I, N::Int) = [circindex(i,N)::Int for i in I]
```

Note that I use `length`. This is because I already know that `data` will be a `string`, as you will see below.

```julia
Base.size(A::CircularArray) = length(A.data)
```

Base.getindex(A::CircularArray, i::Int) = getindex(A.data, circindex(i, size(A)))
Base.getindex(A::CircularArray, I) = getindex(A.data, circindex(I, size(A)))

"""

# ╔═╡ ec0aa2c6-63ea-11eb-062a-cdd3e81a743a
md"""
Let us defined what we talked about before:
"""

# ╔═╡ f752b934-63ea-11eb-09cc-99172ed4870d
md"""
Now, let us read in the data, but this time each horizontal line is a `CircularArray`! (Try to understand what each line does in the code below)
"""

# ╔═╡ 5c2438ce-63eb-11eb-0892-272fb362a2e8
begin
	# init 1D array of data type CircularArrays with len=number of lines 
	# in the file and leave it undefined for now
	# Note that the number of lines is hardcoded (323).
	# This could be done more elegantly in an other way, but we will leave that
	# exercise for the user.
	slope = Array{CircularArray, 1}(undef, 323)

	import Base.Iterators.enumerate
	
	# open the file
	open("map.txt") do file
		# if you have some programming experience, you can probably guess 
		# what enumerate does.
		# the eachline function speaks for itself: iterate over each line in the file!
		for (idx, ln) in enumerate(eachline(file))
			slope[idx] = CircularArray(ln)
		end
	end
end

# ╔═╡ 9cafdef2-63eb-11eb-326a-5d51766d17d5
md"This is how the data now looks like: (Click to expand and have a nicer view of the circular mountain)"

# ╔═╡ 9371b694-63eb-11eb-30a5-d3542ca8f4e5
slope

# ╔═╡ 18054676-63f0-11eb-1a53-5b65f8477882
slope[1]

# ╔═╡ 73f03a14-63f0-11eb-1a14-17e4e69745af
md"Let us look at one horizontal line of the mountain. Check the output below of data at index 1, 32 and 63. Does this match your intuition?"

# ╔═╡ 2164576e-63f0-11eb-3e57-4fad123c494b
firstline = slope[1]

# ╔═╡ 8eda596a-63f0-11eb-03ba-abd147192428
size(firstline)

# ╔═╡ 62dfc3ae-63f0-11eb-350c-b3040f8a6d9b
firstline[1], firstline[32], firstline[63]

# ╔═╡ 224c26ce-63ec-11eb-0744-e97f5196972a
md"""
If we want to go down the slope using our sled in the configuration of 1 down + 3 right, we can write down the *mountain coordinates* like this:

```julia
(1, 1)
(2, 4)
(3, 7)
(4, 10)
(5, 13)
...
```
We have not talked about collections and ranges, yet so this will be a sneak peak. You can define a range in julia like this: `1:5`. This will give you the values `[1,2,3,4,5]`. On the other hand, `1:2:5` will give you `[1,3,5]`. Do you see the difference? 
change some values in the two cells below to check if you understand the basics on this concept. Then, think about how you would write up the list of x-coordinates and y-coordinates if you go down the slope 1 down, 3 right.
"""

# ╔═╡ 9ec3845e-63ec-11eb-1a81-c141b4ff37d8
collect(1:5)

# ╔═╡ b590457a-63ec-11eb-3b3b-5d5b0de1f98c
collect(1:2:5)

# ╔═╡ a0f50fee-63ed-11eb-0208-0b5f7036a7b1
md"Moving on, let us define our function to go down the slope. Does this match your intuition of before?"

# ╔═╡ ae58f724-63eb-11eb-0541-3584d99d9fc5
function goingdowntheslope(right, down, slope)
    xvals = 1:right:right*323
    yvals = 1:down:323
    thingsyoufind = [slope[yval][xval] for (xval, yval) in zip(xvals, yvals)]
    return sum(thingsyoufind .== '#')
end    

# ╔═╡ 44885292-63ee-11eb-048b-2b7481a83ae8
md"""Now that you possess all this new knowledge, can find the answers to the two slope-questions in this notebook?"""

# ╔═╡ 10e183ca-63ec-11eb-3d4b-57ed0543cda1
goingdowntheslope(3, 1, slope)

# ╔═╡ dd716abc-63ed-11eb-36e9-fdbd1187146e
slopestyles = (
    (1, 1), 
    (3, 1), 
    (5, 1), 
    (7, 1), 
    (1, 2), 
)

# ╔═╡ e0569568-63ed-11eb-33b9-51a8b179292c
prod([goingdowntheslope(direction..., slope) for direction in slopestyles])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "133b40f49190746ef0c25610be61de0fbd0b13e7"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "3876f0ab0390136ae0b5e3f064a109b87fa1e56e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.63"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─8b75c14d-f706-4cf3-9921-c0c5050aa3a4
# ╠═4109a39c-00b7-4954-bb73-35407f82a6f7
# ╠═24b76a7c-63dd-11eb-1b78-d5a20557e5cd
# ╟─5368424c-63dd-11eb-3a1b-05a61e266d2b
# ╟─6c0f2d10-63dd-11eb-2c17-fddf9cd51bfe
# ╟─e1259736-63df-11eb-0010-3f2fc5719596
# ╟─36e51b02-63df-11eb-34a5-39e6e0650541
# ╠═e677ca7e-63df-11eb-186b-8d20826ec916
# ╠═c34af248-63e3-11eb-2bfd-898ef2cfbea5
# ╠═4b4bbeb8-63e2-11eb-0ea2-6de494f61dc1
# ╠═f50a0a99-9f4d-426b-a02e-291975d79d52
# ╠═fb39928c-63e2-11eb-2b85-15044c04fbe6
# ╟─ede6342c-648d-11eb-0712-836637408e53
# ╟─b9e97832-63e3-11eb-0e39-b5c9129eabbe
# ╟─9c015578-648e-11eb-0768-d1e5edb4f65f
# ╟─ec0aa2c6-63ea-11eb-062a-cdd3e81a743a
# ╠═de9cf7b0-63ea-11eb-12fb-773d79c2463b
# ╟─f752b934-63ea-11eb-09cc-99172ed4870d
# ╠═5c2438ce-63eb-11eb-0892-272fb362a2e8
# ╟─9cafdef2-63eb-11eb-326a-5d51766d17d5
# ╠═9371b694-63eb-11eb-30a5-d3542ca8f4e5
# ╠═18054676-63f0-11eb-1a53-5b65f8477882
# ╟─73f03a14-63f0-11eb-1a14-17e4e69745af
# ╠═2164576e-63f0-11eb-3e57-4fad123c494b
# ╠═8eda596a-63f0-11eb-03ba-abd147192428
# ╠═62dfc3ae-63f0-11eb-350c-b3040f8a6d9b
# ╟─224c26ce-63ec-11eb-0744-e97f5196972a
# ╠═9ec3845e-63ec-11eb-1a81-c141b4ff37d8
# ╠═b590457a-63ec-11eb-3b3b-5d5b0de1f98c
# ╟─a0f50fee-63ed-11eb-0208-0b5f7036a7b1
# ╠═ae58f724-63eb-11eb-0541-3584d99d9fc5
# ╟─44885292-63ee-11eb-048b-2b7481a83ae8
# ╠═10e183ca-63ec-11eb-3d4b-57ed0543cda1
# ╠═dd716abc-63ed-11eb-36e9-fdbd1187146e
# ╠═e0569568-63ed-11eb-33b9-51a8b179292c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
