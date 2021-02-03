### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 24b76a7c-63dd-11eb-1b78-d5a20557e5cd
# edit the code below to set your name and UGent username

student = (name = "Jim Janssen", email = "Jim.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 446c3e4e-63dd-11eb-3300-fb006008ff1f
begin 
	using DSJulia;
	using PlutoUI;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

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

# ╔═╡ c34af248-63e3-11eb-2bfd-898ef2cfbea5
md"## Questions"

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

# ╔═╡ 424c1470-63e0-11eb-323f-454ac8ad273e
begin
	q1 = Question(validators = @safe[n_trees == Solutions.n_trees], 
			description=md"""
			Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
			""")
	
   qb1 = QuestionBlock(;
	title=md"**Question 1: counting trees**",
	questions = [q1],
	hints=[hint(md"This question can be answered without defining your own datatypes and using all that is available from the `Julia.Base` module. This can also be completed without knowing a lot about collections. Since this is only explained in the next part of the course. "),
			hint(md"An alterative solution showcasing the power of Julia will be shown below, it includes some teasers of what is yet to come in this course")
			],
	)
	validate(qb1, tracker)
end

# ╔═╡ dcac803a-648d-11eb-21f2-d72e56528e92


# ╔═╡ fb39928c-63e2-11eb-2b85-15044c04fbe6
product_all_trees = missing

# ╔═╡ c1206434-63e2-11eb-16c1-d7fafb48bbbe
begin
	q2 = Question(validators = @safe[product_all_trees == Solutions.product_all_trees], 
			description=md"""
Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

    Right 1, down 1.
    Right 3, down 1. (This is the slope you already checked.)
    Right 5, down 1.
    Right 7, down 1.
    Right 1, down 2.

In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?""")
	
   qb2 = QuestionBlock(;
	title=md"**Question 2: counting trees**",
	questions = [q2],
	)
	validate(qb2, tracker)
end

# ╔═╡ ede6342c-648d-11eb-0712-836637408e53


# ╔═╡ b9e97832-63e3-11eb-0e39-b5c9129eabbe
md"## Overly engineered solution to these questions showcasing the 💪️ of Julia"

# ╔═╡ 9c015578-648e-11eb-0768-d1e5edb4f65f
md"This is already some advanced use of Julia, so do not worry if this is not yet fully clear. You will learn about this later in this course."

# ╔═╡ f0f0da0a-63e3-11eb-2065-838c77fc57a6
begin
	qalt = Question(;
			description=md"""
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
		Using our knowledge from the simple example above, let us define a function which takes an index and the length of the array and returns the correct index using circular bounds. We will also create a function that takes an array of indices and returns an array of correct indices. Take a moment to think about how you would do this, and afterwards check a possible implementation in hint 1.
		
		So now we know how the compute the **normal** indices from the circular ones. 
		We now need to define some things for our new datatype `CircularArray`. 
		1. We need the `size` of `CircularArray` and 
		2. we need to define how `A[1]` works on our datatype (this is the `getindex` function in julia).
		For the first problem, note that the size of a `CircularArray` is actually the size of the underlying array! So how do you think the function `Base.size(A::CircularArray) = ...` looks like? 
		For the second problem we need a definition of `Base.getindex(A::CircularArray, i::Int)`. How can we define this using the `circindex` function? 
		If you have given this some thought, check out hint no 2 for the answer!.
				""")
	
   QuestionBlock(;
	title=md"**Alternative answer: defining a new data type**",
	questions = [qalt],
	hints=[hint(md"
```julia
circindex(i::Int, N::Int) = 1 + mod(i-1,N)
circindex(I, N::Int) = [circindex(i,N)::Int for i in I]
```"),
			hint(md"
Note that I use `length`. This is because I already know that `data` will be a `string`, as you will see below.
```julia
Base.size(A::CircularArray) = length(A.data)

Base.getindex(A::CircularArray, i::Int) = getindex(A.data, circindex(i, size(A)))
Base.getindex(A::CircularArray, I) = getindex(A.data, circindex(I, size(A)))
```")
			],
	)
end

# ╔═╡ ec0aa2c6-63ea-11eb-062a-cdd3e81a743a
md"""
Let us defined what we talked about before:
"""

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

# ╔═╡ Cell order:
# ╠═24b76a7c-63dd-11eb-1b78-d5a20557e5cd
# ╟─446c3e4e-63dd-11eb-3300-fb006008ff1f
# ╟─5368424c-63dd-11eb-3a1b-05a61e266d2b
# ╟─6c0f2d10-63dd-11eb-2c17-fddf9cd51bfe
# ╟─e1259736-63df-11eb-0010-3f2fc5719596
# ╠═36e51b02-63df-11eb-34a5-39e6e0650541
# ╠═e677ca7e-63df-11eb-186b-8d20826ec916
# ╟─c34af248-63e3-11eb-2bfd-898ef2cfbea5
# ╟─424c1470-63e0-11eb-323f-454ac8ad273e
# ╠═4b4bbeb8-63e2-11eb-0ea2-6de494f61dc1
# ╟─dcac803a-648d-11eb-21f2-d72e56528e92
# ╟─c1206434-63e2-11eb-16c1-d7fafb48bbbe
# ╠═fb39928c-63e2-11eb-2b85-15044c04fbe6
# ╟─ede6342c-648d-11eb-0712-836637408e53
# ╟─b9e97832-63e3-11eb-0e39-b5c9129eabbe
# ╟─9c015578-648e-11eb-0768-d1e5edb4f65f
# ╟─f0f0da0a-63e3-11eb-2065-838c77fc57a6
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
