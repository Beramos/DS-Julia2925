### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ fbde6364-4f30-11eb-1ece-712293996c04
using Colors: RGB

# ╔═╡ 486457d8-4f37-11eb-306c-57d650508136
using Images

# ╔═╡ 69dc67fa-4cff-11eb-331e-25ffdced4323
let 
	using LinearAlgebra
	using Plots
	using DSJulia

	blue = "#8DC0FF"
	red = "#FFAEA6"

	t = collect(0:10:3040)
	ϵ₁ = randn(length(t))*15     # noise on Dolphin IQ
	ϵ₂ = randn(length(t))*20     # noise on Human IQ

	Y₁ = dolphinsIQ = t/12 + ϵ₁
	Y₂ = humanIQ = t/20 + ϵ₂

	sc = scatter(t,Y₁; label="Dolphins", color=blue,
	  ylabel="IQ (-)", xlabel ="Time (year BC)", legend=:topleft)
	sc = scatter!(sc, t,Y₂; label="Humans", color=red)
	
	λₛ = 0.01
	
qb3 = QuestionBlock(;
	title=md"**Question 5: Ridge Regression**",
	description = md"""
Ridge regression can be seen as an extension of ordinary least squares regression,

$\beta X =b\, ,$

where a matrix $\beta$ is sought which minimizes the sum of squared residuals between the model and the observations,

$SSE(\beta) = (y - \beta X)^T (y - \beta X)$

In some cases it is adviceable to add a regularisation term to this objective function,

$SSE(\beta) = (y - \beta X)^T (y - \beta X) + \lambda \left\lVert X \right\rVert^2_2 \, ,$

this is known as ridge regression. The matrix $\beta$ that minimises the objective function can be computed analytically.

$\beta = \left(X^T X + \lambda I \right)^{-1}X^T y$

Let us look at an example. We found some data on the evolution of human and dolphin intelligence.

```julia
using Plots

blue = "#8DC0FF"
red = "#FFAEA6"

t = collect(0:10:3040)
ϵ₁ = randn(length(t))*15     # noise on Dolphin IQ
ϵ₂ = randn(length(t))*20     # noise on Human IQ

Y₁ = dolphinsIQ = t/12 + ϵ₁
Y₂ = humanIQ = t/20 + ϵ₂

sc = scatter(t,Y₁; label="Dolphins", color=blue,
  ylabel="IQ (-)", xlabel ="Time (year BC)", legend=:topleft)
sc = scatter!(sc, t,Y₂; label="Humans", color=red)		
```
		
$(sc)

> "For instance, on the planet Earth, man had always assumed that he was more intelligent than dolphins because he had achieved so much - the wheel, New York, wars and so on - whilst all the dolphins had ever  done was muck about in the water having a good time. But conversely, the dolphins had always believed that they were far more intelligent than man - for precisely the same reasons."
>
> ~ *Hitchhikers guide to the galaxy* ~

Plot the trend of human vs. dolphin intelligence by implementing the analytical solution for ridge regression. For this, you need the uniform scaling operator `I`, found in the `LinearAlgebra` package. Use a lambda of 0.01.
		
""",
	questions = [Question(;description=md"",validators=Bool[], status=md"")]
)
end

# ╔═╡ 9f1a2834-4d0f-11eb-3c3e-b7ff55f65dd3
begin
	using LinearAlgebra
	t = collect(0:10:3040)
	ϵ₁ = randn(length(t))*15     # noise on Dolphin IQ
	ϵ₂ = randn(length(t))*20     # noise on Human IQ

	Y₁ = dolphinsIQ = t/12 + ϵ₁
	Y₂ = humanIQ = t/20 + ϵ₂
end;

# ╔═╡ 7308bc54-e6cd-11ea-0eab-83f7535edf25
# edit the code below to set your name and UGent username

student = (name = "Jimmy Janssen", email = "Jimmy.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ cdff6730-e785-11ea-2546-4969521b33a7
begin 
	using DSJulia;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
md"""
# Notebook 2: Collections
"""

# ╔═╡ 2222fe0c-4c1d-11eb-1e63-f1dbc90a813c
fyi(md"""In programming, a collection is a class used to represent a set of similar data type items as a single unit. These unit classes are used for grouping and managing related objects. A collection has an underlying data structure that is used for efficient data manipulation and storage. 
	
	[Techopedia.com](https://www.techopedia.com/definition/25317/collection)""")

# ╔═╡ 44542690-4c1d-11eb-2eea-49f28ed7fd90
md"""
## 1. Arrays

Let us start with `Array`'s. It is very similar to lists in Python, though it can have more than one dimension. An `Array` is defined as follows,


"""

# ╔═╡ 8f8c7b44-4c1d-11eb-0cd8-3bb82c75c086
A = []            # empty array

# ╔═╡ a0c22de6-4c1d-11eb-34a2-aff57cfd22a1
X = [1, 3, -5, 7] # array of integers

# ╔═╡ a81d1f22-4c1d-11eb-1b76-2929f30565bf
md"### Indexing and slicing"

# ╔═╡ bb79bf28-4c1d-11eb-35bf-379ac0cd16b6
md"Let's start by eating the frog. Julia uses 1-based indexing..."

# ╔═╡ eaf59a7e-4c1d-11eb-2db3-fd7f995db3e4
names = ["Arthur", "Ford", "Zaphod", "Marvin", "Trillian", "Eddie"]

# ╔═╡ efa60284-4c1d-11eb-1c08-09993363e4a8
names[0]        # this does not work, sorry Pythonista's

# ╔═╡ efa6f180-4c1d-11eb-1ab0-3d1ca0b4bc57
names[1]        # hell yeah!

# ╔═╡ efb6718c-4c1d-11eb-0dff-e55e6a676e39
names[end]      # last element

# ╔═╡ efb69e46-4c1d-11eb-1ce7-ed428db8ff44
names[end-1]    # second to last element

# ╔═╡ 0a02b730-4c1e-11eb-1e8a-872dcfc8ab81
md"Slicing arrays is intuitive,"

# ╔═╡ 15035dee-4c1e-11eb-123f-a961fdd48445
names[3:6]

# ╔═╡ 1960de28-4c1e-11eb-1c84-ffe0cbaac940
md"and slicing with assignment too."

# ╔═╡ 4db9d648-4c1e-11eb-1063-e78c78ef5c4b
names[end-1:end] = ["Slartibartfast","The Whale and the Bowl of Petunias"]

# ╔═╡ 4fb1a53e-4c1e-11eb-381b-1f86a5ed97a1
names

# ╔═╡ 56f5f21e-4c1e-11eb-004e-f19aa9029b01
md"### Types and arrays"

# ╔═╡ 79e0f212-4c1e-11eb-0d64-87308d762180
md"Julia arrays can be of mixed type."


# ╔═╡ 86dcfb26-4c1e-11eb-347f-ffbd8b396f09
Y = [42, "Universe", []]

# ╔═╡ 8a0e3e36-4c1e-11eb-0ec0-d19fdc3c89d8
md"The type of the array changes depending on the elements that make up the array. With `Any` being the most general type."

# ╔═╡ 90d3dc80-4c1e-11eb-2a11-3fe581f0b5f7
typeof(Y)

# ╔═╡ 996ba666-4c1e-11eb-3c5c-4bf8673de6bc
X

# ╔═╡ 90d369a8-4c1e-11eb-3c16-c5fb02bdf3bb
typeof(X)

# ╔═╡ f247382c-4c1e-11eb-229c-efe48b7a4d7f
md"When the elements of the arrays are mixed, the type is promoted to the closest common ancestor. For `Y` this is `Any`.  But an array of an integer and a float becomes an..."

# ╔═╡ fd06f130-4c1e-11eb-37cf-03af9372ae45
B = [1.1, 1]

# ╔═╡ 00237b9a-4c1f-11eb-3b19-73c0b8e4cbed
typeof(B)

# ╔═╡ 0425e980-4c1f-11eb-2477-e35a924b8018
eltype(B)   # gives the type of the elements

# ╔═╡ 069cccc4-4c1f-11eb-39b3-b94136c1b468
md"... array of floats." 

# ╔═╡ 0fd48034-4c1f-11eb-06a9-0d7353b2a0d6
md"""
Julia allows the flexibility of having mixed types, though this will hinder performance, as the compiler can no longer optimize for the type. If you process an array of `Any`'s, your code will be as slow as Python.

To create an array of a particular type, just use `Type[]`.

"""

# ╔═╡ 2262e4fc-4c1f-11eb-07b8-0b9732b93d86
Float64[1, 2, 3]

# ╔═╡ 3d0107c4-4c1f-11eb-1b5b-ed954348d0aa
md"""### Initialisation
Arrays can be initialized in all the classic, very Pythonesque ways.


"""

# ╔═╡ 4b3317da-4c1f-11eb-19d5-03570c4d65df
C = []  # empty

# ╔═╡ 503c9da0-4c1f-11eb-292a-db7b8ce9f458
zeros(5)      # row vector of 5 zeroes

# ╔═╡ 503d455c-4c1f-11eb-3af2-8f200db1fd30
ones(3,3)     # 3X3 matrix of 1's, will be discussed later on

# ╔═╡ 504d8aca-4c1f-11eb-3600-d77038b0f2bc
fill(0.5, 10) # in case you want to fill a matrix with a specific value

# ╔═╡ 505874a8-4c1f-11eb-1132-3bbba81ae1db
rand(2)    # row vector of 2 random floats [0,1]

# ╔═╡ 5071c430-4c1f-11eb-226b-634abae6082f
randn(2)   # same but normally-distributed random numbers

# ╔═╡ 52a8a6ec-4c1f-11eb-386c-a99ef05b41b0
md"Often it is better to provide a specific type for initialization. For numeric elements `Float64` is the default."

# ╔═╡ 507254b0-4c1f-11eb-2b2c-8bc88e58e0b3
zeros(Int8, 5)

# ╔═╡ 27b18866-4c22-11eb-22da-656ca8a4c01d
md"### Comprehensions and list-like operations"

# ╔═╡ 387c3e70-4c22-11eb-37e4-bb6c36600074
md"Comprehensions are a concise and powerful way to construct arrays and are very loved by the Python community."

# ╔═╡ 3da23eb8-4c22-11eb-1ec4-c350d615322f
Z = [1, 2, 3, 4, 5, 6, 8, 9, 8, 6, 5, 4, 3, 2, 1]

# ╔═╡ 3f5436d2-4c22-11eb-342a-35b7a29ef146
dZ = [Z[i-1] - 2*Z[i] + Z[i+1] for i=2:length(Z)-1] # central difference

# ╔═╡ 63fea2f6-4c22-11eb-0802-37fd7653cdb5
md"""General $N$-dimensional arrays can be constructed using the following syntax:

```julia
[ F(x,y,...) for x=rx, y=ry, ... ]
```

Note that this is similar to using set notation. For example:

```julia
[i * j for i in 1:4, j in 1:5]
```


"""

# ╔═╡ a5f17ccc-4c22-11eb-2cb8-7b130e1e811f
md"Arrays behave like a stack. So pushing, appending and popping are valid operations. Elements can be added to the back of the array, (*Pushing and appending*)"

# ╔═╡ f1b481f4-4c22-11eb-39b7-39ffdd5bbccc
push!(names, "Eddie") # add a single element

# ╔═╡ f61fc4b0-4c22-11eb-30b3-154ed1aa43bd
append!(names, ["Sam", "Gerard"]) # add an array

# ╔═╡ fcbeda22-4c22-11eb-2d35-a356b98bbc46
md""" "Eddie" was appended as the final element of the Array along with "Sam" and "Gerard". Remember, a "!" is used to indicate an in-place function. `pop()` is used to return and remove the final element of an array"""

# ╔═╡ 3516a722-4c23-11eb-3ee7-fb8d582c8ce0
md"Removing the last element or first element (*popping*)"

# ╔═╡ 08bb725e-4c23-11eb-3338-03370f49dd11
pop!(names)

# ╔═╡ 0cfc84ca-4c23-11eb-124b-5397430fd203
names

# ╔═╡ 4fbecdfe-4c23-11eb-0da7-5945a49c3a2a
popfirst!(names)

# ╔═╡ 562b751e-4c23-11eb-2b8f-73f710bf3520
names

# ╔═╡ 5ed7284a-4c23-11eb-1451-0ff763f52bc7
md"## 2. Matrices"

# ╔═╡ 0186eab2-4c24-11eb-0ff6-d7f8af343647
md"Let's add a dimension and go to 2D Arrays, matrices. It is all quite straightforward,"

# ╔═╡ 097e96e8-4c24-11eb-24c4-31f4d23d3238
P = [0 1 1; 2 3 5; 8 13 21; 34 55 89]

# ╔═╡ 0b9bad58-4c24-11eb-26a8-1d04d7b2be61
P[3,2]  # indexing

# ╔═╡ 0b9d0bf8-4c24-11eb-2beb-0763c66e6a20
P[1,:]  # slicing

# ╔═╡ 25d53e6c-4c24-11eb-02a2-a71d4b2a7974
md"It is important to know that arrays and other collections are copied by reference."

# ╔═╡ 6191c72e-4c24-11eb-21bb-a59e880a3573
let
	println(); println()
    P = [0 1 1; 2 3 5; 8 13 21; 34 55 89]
	@show R = P
	@show P
	@show P[1, 1] = 42
	println()
	@show R
end; # Check the terminal

# ╔═╡ 07220d0a-4c4a-11eb-0ae3-298cf03a0bf6
md"`deepcopy()` can be used to make a fully dereferenced object."

# ╔═╡ 26f6f852-4c4a-11eb-3a5c-e7d788713ab8
md"""### Concatenation
Arrays can be constructed and also concatenated using the following functions,
"""

# ╔═╡ 54b81ed8-4c4a-11eb-1d47-99d5823f2ab1
I = [0 1 1; 2 3 5; 8 13 21; 34 55 89]

# ╔═╡ 56fd77e2-4c4a-11eb-1ab1-4793cd9b220c
W = rand(4,3)

# ╔═╡ 56ff198a-4c4a-11eb-1604-8f08c9cf868c
cat(I, W, dims=2)                # concatenation along a specified dimension

# ╔═╡ 57226e44-4c4a-11eb-26fd-fbd6f993bb72
cat(I, W, dims=1) == vcat(I, W) == [I; W]   # vertical concatenation

# ╔═╡ 57327ab4-4c4a-11eb-219f-f70dd02f170c
cat(I, W, dims=2) == hcat(I, W) == [I W]   # horizontal concatenation

# ╔═╡ 969bc7a0-4c4a-11eb-3db6-892f68020468
md"Note that `;` is an operator to use `vcat`, e.g."

# ╔═╡ a8eba678-4c4a-11eb-2866-1135e65bc4df
[zeros(2, 2) ones(2, 1); ones(1, 3)]

# ╔═╡ afd0b9a6-4c4a-11eb-270b-133ddc3e753b
md"This simplified syntax can lead to strange behaviour. Explain the following difference."

# ╔═╡ b4de01c4-4c4a-11eb-3b0b-275ec9ddf5bf
[1  2-3]

# ╔═╡ b76b87e0-4c4a-11eb-3b21-f1365960fdd0
[1 2 -3]

# ╔═╡ be174110-4c4a-11eb-05cf-17e2527dfad8
md"Sometimes, `vcat` and `hcat` are better used to make the code unambiguous."

# ╔═╡ cad05c2a-4c4a-11eb-0c89-13cddd2aa35f
md"By default, the `*` operator is used for matrix-matrix multiplication"

# ╔═╡ d43ae2ee-4c4a-11eb-281a-b353dc1de640
E = [2 4 3; 3 1 5]

# ╔═╡ d5f77750-4c4a-11eb-0624-11ca5cc2a84e
R = [ 3 10; 4 1 ;7 1]

# ╔═╡ d5fa6276-4c4a-11eb-068e-b114e33e5d8f
E * R

# ╔═╡ 45e86286-4c4b-11eb-1516-0140dc69ab58
md"### Element-wise operations"

# ╔═╡ ee779c1a-4c4a-11eb-1894-d743aeff7f44
md"""This is the Julian way since functions act on the objects, and element-wise operatios are done with "dot" operations. For every function or binary operation like `^` there is a "dot" operation `.^` to perform element-by-element exponentiation on arrays."""

# ╔═╡ 0697987c-4c4b-11eb-3052-df54b72dec52
T = [10 10 10; 20 20 20]

# ╔═╡ 14bceb32-4c4b-11eb-06b2-5190f7ebb9c2
T.^2

# ╔═╡ 1ace7720-4c4b-11eb-0338-37e7a7227a68
md"""Under the hood, Julia is looping over the elements of `Y`. So a sequence of dot-operations is fused into a single loop."""

# ╔═╡ 2146ac4c-4c4b-11eb-288f-edb3eacff0eb
T.^2 .+ cos.(T)

# ╔═╡ 28f5c018-4c4b-11eb-3530-8b592f2abeda
md"""
Did you notice that dot-operations are also applicable to functions, even user-defined functions? As programmers, we are by lazy by definition and all these dots are a lot of work. The `@.` macro does this for us.
"""

# ╔═╡ 32351fb8-4c4b-11eb-058b-5bb348e8dfb7
T.^2 .+ cos.(T) == @. T^2 + cos(T)

# ╔═╡ eed4faca-4c1f-11eb-3e6c-b342b48080eb
md""" ### Intermezzo: Colors.jl and Images.jl

As has been mentioned before, everything has a type. We also know that functions can behave differently for each type. With this in mind, let us look at two interesting packages. *Colors.jl*
"""

# ╔═╡ 42254aa6-4f37-11eb-001b-f78d5383e36f
RGB(0.5,0.2,0.1)

# ╔═╡ 0977a54e-4f31-11eb-148c-1d44be4f6853
fyi(md"*Colors.jl* provides a wide array of functions for dealing with color. This includes conversion between colorspaces, measuring distance between colors, simulating color blindness, parsing colors, and generating color scales for graphics.")

# ╔═╡ 4c21ed0e-4f37-11eb-0a90-3120e1ee7936
url = "https://i.imgur.com/BJWoNPg.jpg"

# ╔═╡ 5686c59e-4f37-11eb-21d5-47bdbcf75805
download(url, "bluebird.jpg") # download to a local file

# ╔═╡ a5dc2904-4f37-11eb-24c1-d7837c8bd487
img = load("bluebird.jpg")

# ╔═╡ cf3ec91e-4f37-11eb-0706-e9f726532654
typeof(img)

# ╔═╡ d7d1b940-4f37-11eb-3f74-9dbe02774e54
eltype(img)

# ╔═╡ f90725be-4f37-11eb-1905-e99a65ad3e07
size(img)

# ╔═╡ dd781738-4f37-11eb-09fb-b7f3390a49b2
md"So an image is basically a two-dimensional array of Colors. Which means it can be processed just like any other array."

# ╔═╡ ab395348-4f39-11eb-0a3c-1d8af3b6442e
sqr_img = img[1:1500, 201:1700]

# ╔═╡ 7acaf008-4f3a-11eb-17c2-dfaa1e9f2ce7
md"Because of this type system, a lot of interesting feature work out of the box."

# ╔═╡ 8ce0ab98-4f3a-11eb-37b2-dd7dda63ad5f
@bind brightness html"<input type=range min=0.0 max=300.0>"

# ╔═╡ d73eba40-4f3a-11eb-0aa8-617fc22d5ca3
img[1:1500, 201:1700]./(brightness/100)

# ╔═╡ 5064c592-4c4b-11eb-0dee-5186caf2b1f6
md"### Higher dimensional arrays"

# ╔═╡ 598980b8-4c4b-11eb-0c5b-b7064b189e97
md"Matrices can be generalized to multiple dimensions."

# ╔═╡ 5fcfb5dc-4c4b-11eb-0be6-e7f66ea1839e
H = rand(3, 3, 3)

# ╔═╡ 6e7d5a94-4c4b-11eb-3e2d-353177d6bca5
md"### Ranges"

# ╔═╡ 79129c92-4c4b-11eb-28f6-633aedabd990
md"The colon operator `:` can be used to construct unit ranges, e.g., from 1 to 20:"

# ╔═╡ 7f693b34-4c4b-11eb-134d-af855593f45e
ur = 1:20

# ╔═╡ 83939d80-4c4b-11eb-3dc8-1b559c61a43b
md"Or by increasing in steps:"

# ╔═╡ 884b0d4a-4c4b-11eb-1d39-5f67ba9e92fe
str = 1:3:20

# ╔═╡ 9483861e-4c4b-11eb-156b-2501ef2c54d0
md"Similar to the `range` function in Python, the object that is created is not an array, but an iterator. This is actually the term used in Python. Julia has many different types and structs, which behave a particular way. Types of `UnitRange` only store the beginning and end value (and stepsize in the case of `StepRange`). But functions are overloaded such that it acts as arrays."

# ╔═╡ 9fd1be0a-4c4b-11eb-299b-f7f0d8797f71
for i in ur
  println(i)
end

# ╔═╡ a2104d08-4c4b-11eb-0ccc-b588e99a2057
str[3]

# ╔═╡ a214405c-4c4b-11eb-118b-b7ec852f9257
length(str)

# ╔═╡ a806a9dc-4c4b-11eb-1101-6f75be7a610c
md"All values can be obtained using `collect`:"

# ╔═╡ af514422-4c4b-11eb-1cfe-cba6029ec52f
collect(str)

# ╔═╡ b3035158-4c4b-11eb-1b8d-1fc4070fa132
md"Such implicit objects can be processed much smarter than naive structures. Compare!"

# ╔═╡ c4575438-4c4b-11eb-1da2-97acca3f3e99
@time sum((i for i in 1:100_000_000))

# ╔═╡ c64e66c8-4c4b-11eb-1686-8fa64d8b2505
@time sum(1:100_000_000)   # the timer output is in the terminal

# ╔═╡ 03d82c7a-4c58-11eb-0071-bb9ea16bfbb3
md"`StepRange` and `UnitRange` also work with floats."

# ╔═╡ 0bec2d28-4c58-11eb-0a51-95bf50bbfd79
0:0.1:10

# ╔═╡ 0fd08728-4c58-11eb-1b71-c9710d398fab
md"## 3. Other collections"

# ╔═╡ 2c6097f4-4c58-11eb-0807-d5d8cbfbd62c
md"Some of the other collections include tuples, dictionaries, and others."

# ╔═╡ 9505a4d4-4c58-11eb-1e2e-0d080437fa23
md"### Tuples"

# ╔═╡ 23dac6cc-4c58-11eb-2c66-f1f79db08536
tupleware = ("tuple", "ware") # tuples

# ╔═╡ 4f80f0a8-4c58-11eb-3679-c186c61c5a14
fyi(md"A tuple is an array with a fixed size. It is not possible to perform operations that change the size of a tuple.")

# ╔═╡ 6d496b44-4c58-11eb-33b6-5b4d6315b6ea
pop!(tupleware)

# ╔═╡ 7bc7bdf4-4c58-11eb-1fd8-376ac6da5ab2
md"Indexing and slicing is the same as arrays,"

# ╔═╡ 74d97654-4c58-11eb-344b-8d6df24323d5
tupleware[end]

# ╔═╡ 9cecd9a6-4c58-11eb-22dc-33cd2559d815
md"### Dictionaries"

# ╔═╡ c6d236da-4c58-11eb-2714-3f5c43583a3d
fyi(md"A dictionary is a collection that stores a set of values with their corresponding keys internally for faster data retrieval. The operation of finding the value associated with a key is called lookup or indexing. [Techopedia.com](https://www.techopedia.com/definition/10263/dictionary-c)")

# ╔═╡ 3253ab74-4c58-11eb-178e-83ea8aba9c8f
scores = Dict("humans" => 2, "vogons" => 1) # dictionaries

# ╔═╡ 32593936-4c58-11eb-174c-0bb20d93dde5
scores["humans"]

# ╔═╡ ebb09172-4c58-11eb-1cc9-91193c57677d
md"## 4. Exercises"

# ╔═╡ 3de1f1aa-58bd-11eb-2ffc-0de292b13840
function riemannsum(f, a, b; n=100)
    missing
end

# ╔═╡ 5f47cdf0-58be-11eb-1bca-a3d0941b9bea
begin 
	integral1 = missing #...
	integral2 = missing #...
end;

# ╔═╡ 3aa37510-58bb-11eb-2ecb-37ce4428269c
begin 
	
	q1 = Question(
			validators = @safe[
				riemannsum(sin, 0, 2pi) == Solutions.riemannsum(sin, 0, 2pi),
			
				riemannsum(x->x*sin(x), 0, 2pi) == 
					Solutions.riemannsum(x->x*sin(x), 0, 2pi),
			
				riemannsum(x->(sqrt(1-x^2)), 0, 1, n=1000) == 
					Solutions.riemannsum(x->(sqrt(1-x^2)), 0, 1, n=1000)
			]
		)
			
	q2 = Question(
			validators = @safe[
				integral1 == Solutions.riemannsum(x->x*sin(x), 0, 2pi)
			], 
			description = md" **Integral 1:**  $ \int_0^{2\pi} x\,sin(x)\,dx$ (n=100)")
			
	q3 = Question(
			validators = @safe[
			integral2 == Solutions.riemannsum(x->(sqrt(1-x^2)), 0, 1, n=1000)
			], 
			description = md" **Integral 2:**  $ \int_0^1 \sqrt{1-x^2}\,dx$ (n=1000)")
	
	
qb1 = QuestionBlock(;
	title=md"**Question 1: do you still remember how to integrate?**",
	description = md"""
Integrating for dummies. Compute the Riemann sum **without** making use of a for-loop.

Riemann approximates the integration of a function in the interval [a, b],
		
$$\int_a^b f(x)\, dx \approx \sum_{i=1}^n f(x_i) \,\Delta x$$

which is the sum of the function $f(x)$ evaluated over an array of x-values in the interval [a,b] multiplied by the $\Delta x$ which is,
		
$$\Delta x = \cfrac{(b-a)}{n}$$

Complete the function `riemannsum(f, a, b,; n=100)` where the arguments are the function to integrate (f) the boundaries of the interval a, b and the number of bins with a default value of 100, n.		

	""",
	questions = [q1, q2, q3]
)
	validate(qb1, tracker)
end

# ╔═╡ 75d14674-58ba-11eb-3868-172fc00a0eb8
function markdowntable(table, header)
	missing
end

# ╔═╡ 0c91ce30-58b9-11eb-3617-4d87682831dd
begin
	
	q71 = Question(
			validators = @safe[
			  markdowntable(ones(8, 4), ["A", "B", "C", "D"])==
			  Solutions.markdowntable(ones(8, 4), ["A", "B", "C", "D"]),
			  markdowntable(ones(20, 2), ["Foo", "Bar"])==
			  Solutions.markdowntable(ones(20, 2), ["Foo", "Bar"]),
			]
		  )
	q72 = QuestionOptional{Easy}(
			description = md"Make sure the user does not put in invalid table specifications by asserting the number of columns in the content equal to the number of elements in the header."
		  )
	
	qb70 = QuestionBlock(;
		title=md"**Question 2: markdown tables**",
		description = md"""
	Markdown is a lightweight markup language that you can use to add formatting elements to plaintext text documents. It is also the markup language used in this notebook. Markdown is really easy to learn (see the example below). The problem with markdown is that tables generation is a tedious process... Write a small julia package (read function) that generates a markdown table that takes a an array of strings for the header and a n-by-m array of table values. Complete `markdowntable()` below. The function should both return a string of the markdown table and should automatically copies this to the clipboard using the `clipboard()` function

		```MD
			# Header 1
			## Header 2
			### Header 3

			**This text is bold** and *this is italic*.

			* This
			* is 
			* a 
			* list.

			| This | is | a | table |
			| :--|:--|:--|:--| 
			| 5 | 10 | 10 | 3 |
			| 9 | 3 | 1 | 5 |
			| 8 | 4 | 7 | 6 |
		```
	# Header 1
	## Header 2
	### Header 3

	**This text is bold** and *this is italic*.

	* This
	* is 
	* a 
	* list.

	| This | is | a | table |
	| :--|:--|:--|:--| 
	| 5 | 10 | 10 | 3 |
	| 9 | 3 | 1 | 5 |
	| 8 | 4 | 7 | 6 |
		
	-----------------
		

		""",
		questions = [q71, q72],
		hints = [
			hint(md""" The `join` and `repeat`-functions might come in handy """),
			hint(md""" The @assert macro should get you close to solving the second part."""),
		]
		
	)
	
	validate(qb70, tracker)
end

# ╔═╡ 7cb0cbfe-4cfb-11eb-3faf-a7bd7b89a874
vandermonde(α, n) = missing

# ╔═╡ 5619fd6c-4cfe-11eb-1512-e1800b6c7df9
function mydet(A)
	size(A,1) != size(A,2) && throw(DimensionMismatch)
	
	return missing
end

# ╔═╡ b1a00da4-4cfe-11eb-0aff-69099e40d28f
let 
	using LinearAlgebra
	M₁ = [1 2; 3 4]
	M₂ = rand(10, 10)

	
q2 = Question(;
	description=md"""
Write a function `mydet` to compute the determinant of a 2x2 square matrix. Remember, for a $2 \times 2$ matrix, the determinant is computed as

${\displaystyle|A|={\begin{vmatrix}a&b\\c&d\end{vmatrix}}=ad-bc.}$
""",
	validators = @safe[det(M₁) == mydet(M₁)]
)
	
q3 = Question(;
	description=md"""For larger matrices, there is a recursive way of computing the determinant based on the minors, i.e. the determinants of the submatrices. See [http://mathworld.wolfram.com/Determinant.html](http://mathworld.wolfram.com/Determinant.html).

Update `mydet` to compute the determinant of a general square matrix.
""",
	validators = @safe[det(M₁) == mydet(M₁), det(M₂) == mydet(M₂)]
)
		
qb2 = QuestionBlock(;
	title=md"**Question 3: determinining the determinant**",
	description = md"""
	""",
	questions = [q2, q3]
)
	validate(qb2, tracker)
end

# ╔═╡ cb20fffe-58cf-11eb-1b65-49699f2d3699
function estimatepi(n)
	missing
end

# ╔═╡ cee388d2-58cf-11eb-3b88-971b4b85e957
function estimatepi2(n)
	missing
end

# ╔═╡ c6e16d7a-58cf-11eb-32a4-3372939066e3
begin 
qb90 = QuestionBlock(;
	title=md"**Question 4: it is pi 'o clock**",
	description = md"""
	Estimate pi through Monte Carlo sampling. Do this by simulating throwing `n` pebbles in the [-1, 1] x [-1, 1] square and track the fraction that land in the unit square. Complete the function `estimatepi` below.
	""",
	questions = [
		Question(
		  validators = @safe[
			abs(estimatepi(100) - π) < 1.0, 
			abs(estimatepi(100000) - π) < 1e-2
		  ], 
		),
			
		QuestionOptional{Easy}(
				validators = @safe[
					abs(estimatepi2(100) - π) < 1.0, 
					abs(estimatepi2(100000) - π) < 1e-2
					], 
				description = md"Did you use a for loop? If so, try to do this without an explicit for-loop")
	]
)
	validate(qb90, tracker)
end

# ╔═╡ 41b19e20-4d0f-11eb-1c3c-572cc5243d99


# ╔═╡ 04aff640-58bb-11eb-1bb6-69ad9fc32314
md"## 5. Extra exercises"

# ╔═╡ 85fb018e-4c1d-11eb-2519-a5abe100748e
begin 
	β₁ = missing    # replace with the correct way to compute β
	β₂ = missing    # replace with the correct way to compute β

	Yₚ₁ = β₁.*t      # Dolphin IQ
	Yₚ₂ = β₂.*t      # Human IQ
end;

# ╔═╡ b56686ec-4cfa-11eb-2b14-a5d49a137cc5
let
	α = 1:20
	n = 5
	
q1 = Question(;
	description=md"""
Write a one-liner function `vandermonde` to generate this matrix. This function takes as a vector `α` and `n`, the number of powers to compute.
""",
	validators = [vandermonde(α, n) == [αᵢ^j for αᵢ in α, j in 0:n-1]]
)
		
qb1 = QuestionBlock(;
	title=md"**Question 6: Vandermonde matrix**",
	description = md"""Write a function to generate an $n \times m$ [Vandermonde matrix](https://en.wikipedia.org/wiki/Vandermonde_matrix) for a given vector $\alpha=[\alpha_1,\alpha_2,\ldots,\alpha_m]^T$. This matrix is defined as follows

${\displaystyle V={\begin{bmatrix}1&\alpha _{1}&\alpha _{1}^{2}&\dots &\alpha _{1}^{n-1}\\1&\alpha _{2}&\alpha _{2}^{2}&\dots &\alpha _{2}^{n-1}\\1&\alpha _{3}&\alpha _{3}^{2}&\dots &\alpha _{3}^{n-1}\\\vdots &\vdots &\vdots &\ddots &\vdots \\1&\alpha _{m}&\alpha _{m}^{2}&\dots &\alpha _{m}^{n-1}\end{bmatrix}},}$

or

$V = [\alpha_i^{j-1}] .$
		
""",
	questions = [q1]
)
	validate(qb1)
end

# ╔═╡ 2e7973b6-4d0f-11eb-107c-cdaf349428c0
md""" ## 5. References

- [Julia Documentation](https://juliadocs.github.io/Julia-Cheat-Sheet/)
- [Introduction to Julia UCI data science initiative](http://ucidatascienceinitiative.github.io/IntroToJulia/)
- [Month of Julia](https://github.com/DataWookie/MonthOfJulia)
- [Why I love Julia, Next Journal](https://nextjournal.com/kolia/why-i-love-julia)

"""

# ╔═╡ Cell order:
# ╠═cdff6730-e785-11ea-2546-4969521b33a7
# ╠═7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╠═a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╠═2222fe0c-4c1d-11eb-1e63-f1dbc90a813c
# ╠═44542690-4c1d-11eb-2eea-49f28ed7fd90
# ╠═8f8c7b44-4c1d-11eb-0cd8-3bb82c75c086
# ╠═a0c22de6-4c1d-11eb-34a2-aff57cfd22a1
# ╠═a81d1f22-4c1d-11eb-1b76-2929f30565bf
# ╠═bb79bf28-4c1d-11eb-35bf-379ac0cd16b6
# ╠═eaf59a7e-4c1d-11eb-2db3-fd7f995db3e4
# ╠═efa60284-4c1d-11eb-1c08-09993363e4a8
# ╠═efa6f180-4c1d-11eb-1ab0-3d1ca0b4bc57
# ╠═efb6718c-4c1d-11eb-0dff-e55e6a676e39
# ╠═efb69e46-4c1d-11eb-1ce7-ed428db8ff44
# ╠═0a02b730-4c1e-11eb-1e8a-872dcfc8ab81
# ╠═15035dee-4c1e-11eb-123f-a961fdd48445
# ╠═1960de28-4c1e-11eb-1c84-ffe0cbaac940
# ╠═4db9d648-4c1e-11eb-1063-e78c78ef5c4b
# ╠═4fb1a53e-4c1e-11eb-381b-1f86a5ed97a1
# ╠═56f5f21e-4c1e-11eb-004e-f19aa9029b01
# ╠═79e0f212-4c1e-11eb-0d64-87308d762180
# ╠═86dcfb26-4c1e-11eb-347f-ffbd8b396f09
# ╠═8a0e3e36-4c1e-11eb-0ec0-d19fdc3c89d8
# ╠═90d3dc80-4c1e-11eb-2a11-3fe581f0b5f7
# ╠═996ba666-4c1e-11eb-3c5c-4bf8673de6bc
# ╠═90d369a8-4c1e-11eb-3c16-c5fb02bdf3bb
# ╠═f247382c-4c1e-11eb-229c-efe48b7a4d7f
# ╠═fd06f130-4c1e-11eb-37cf-03af9372ae45
# ╠═00237b9a-4c1f-11eb-3b19-73c0b8e4cbed
# ╠═0425e980-4c1f-11eb-2477-e35a924b8018
# ╠═069cccc4-4c1f-11eb-39b3-b94136c1b468
# ╠═0fd48034-4c1f-11eb-06a9-0d7353b2a0d6
# ╠═2262e4fc-4c1f-11eb-07b8-0b9732b93d86
# ╠═3d0107c4-4c1f-11eb-1b5b-ed954348d0aa
# ╠═4b3317da-4c1f-11eb-19d5-03570c4d65df
# ╠═503c9da0-4c1f-11eb-292a-db7b8ce9f458
# ╠═503d455c-4c1f-11eb-3af2-8f200db1fd30
# ╠═504d8aca-4c1f-11eb-3600-d77038b0f2bc
# ╠═505874a8-4c1f-11eb-1132-3bbba81ae1db
# ╠═5071c430-4c1f-11eb-226b-634abae6082f
# ╠═52a8a6ec-4c1f-11eb-386c-a99ef05b41b0
# ╠═507254b0-4c1f-11eb-2b2c-8bc88e58e0b3
# ╠═27b18866-4c22-11eb-22da-656ca8a4c01d
# ╠═387c3e70-4c22-11eb-37e4-bb6c36600074
# ╠═3da23eb8-4c22-11eb-1ec4-c350d615322f
# ╠═3f5436d2-4c22-11eb-342a-35b7a29ef146
# ╠═63fea2f6-4c22-11eb-0802-37fd7653cdb5
# ╠═a5f17ccc-4c22-11eb-2cb8-7b130e1e811f
# ╠═f1b481f4-4c22-11eb-39b7-39ffdd5bbccc
# ╠═f61fc4b0-4c22-11eb-30b3-154ed1aa43bd
# ╠═fcbeda22-4c22-11eb-2d35-a356b98bbc46
# ╠═3516a722-4c23-11eb-3ee7-fb8d582c8ce0
# ╠═08bb725e-4c23-11eb-3338-03370f49dd11
# ╠═0cfc84ca-4c23-11eb-124b-5397430fd203
# ╠═4fbecdfe-4c23-11eb-0da7-5945a49c3a2a
# ╠═562b751e-4c23-11eb-2b8f-73f710bf3520
# ╠═5ed7284a-4c23-11eb-1451-0ff763f52bc7
# ╠═0186eab2-4c24-11eb-0ff6-d7f8af343647
# ╠═097e96e8-4c24-11eb-24c4-31f4d23d3238
# ╠═0b9bad58-4c24-11eb-26a8-1d04d7b2be61
# ╠═0b9d0bf8-4c24-11eb-2beb-0763c66e6a20
# ╠═25d53e6c-4c24-11eb-02a2-a71d4b2a7974
# ╠═6191c72e-4c24-11eb-21bb-a59e880a3573
# ╠═07220d0a-4c4a-11eb-0ae3-298cf03a0bf6
# ╠═26f6f852-4c4a-11eb-3a5c-e7d788713ab8
# ╠═54b81ed8-4c4a-11eb-1d47-99d5823f2ab1
# ╠═56fd77e2-4c4a-11eb-1ab1-4793cd9b220c
# ╠═56ff198a-4c4a-11eb-1604-8f08c9cf868c
# ╠═57226e44-4c4a-11eb-26fd-fbd6f993bb72
# ╠═57327ab4-4c4a-11eb-219f-f70dd02f170c
# ╠═969bc7a0-4c4a-11eb-3db6-892f68020468
# ╠═a8eba678-4c4a-11eb-2866-1135e65bc4df
# ╠═afd0b9a6-4c4a-11eb-270b-133ddc3e753b
# ╠═b4de01c4-4c4a-11eb-3b0b-275ec9ddf5bf
# ╠═b76b87e0-4c4a-11eb-3b21-f1365960fdd0
# ╠═be174110-4c4a-11eb-05cf-17e2527dfad8
# ╠═cad05c2a-4c4a-11eb-0c89-13cddd2aa35f
# ╠═d43ae2ee-4c4a-11eb-281a-b353dc1de640
# ╠═d5f77750-4c4a-11eb-0624-11ca5cc2a84e
# ╠═d5fa6276-4c4a-11eb-068e-b114e33e5d8f
# ╠═45e86286-4c4b-11eb-1516-0140dc69ab58
# ╠═ee779c1a-4c4a-11eb-1894-d743aeff7f44
# ╠═0697987c-4c4b-11eb-3052-df54b72dec52
# ╠═14bceb32-4c4b-11eb-06b2-5190f7ebb9c2
# ╠═1ace7720-4c4b-11eb-0338-37e7a7227a68
# ╠═2146ac4c-4c4b-11eb-288f-edb3eacff0eb
# ╠═28f5c018-4c4b-11eb-3530-8b592f2abeda
# ╠═32351fb8-4c4b-11eb-058b-5bb348e8dfb7
# ╠═eed4faca-4c1f-11eb-3e6c-b342b48080eb
# ╠═fbde6364-4f30-11eb-1ece-712293996c04
# ╠═42254aa6-4f37-11eb-001b-f78d5383e36f
# ╟─0977a54e-4f31-11eb-148c-1d44be4f6853
# ╠═486457d8-4f37-11eb-306c-57d650508136
# ╠═4c21ed0e-4f37-11eb-0a90-3120e1ee7936
# ╠═5686c59e-4f37-11eb-21d5-47bdbcf75805
# ╠═a5dc2904-4f37-11eb-24c1-d7837c8bd487
# ╠═cf3ec91e-4f37-11eb-0706-e9f726532654
# ╠═d7d1b940-4f37-11eb-3f74-9dbe02774e54
# ╠═f90725be-4f37-11eb-1905-e99a65ad3e07
# ╠═dd781738-4f37-11eb-09fb-b7f3390a49b2
# ╠═ab395348-4f39-11eb-0a3c-1d8af3b6442e
# ╠═7acaf008-4f3a-11eb-17c2-dfaa1e9f2ce7
# ╠═8ce0ab98-4f3a-11eb-37b2-dd7dda63ad5f
# ╠═d73eba40-4f3a-11eb-0aa8-617fc22d5ca3
# ╠═5064c592-4c4b-11eb-0dee-5186caf2b1f6
# ╠═598980b8-4c4b-11eb-0c5b-b7064b189e97
# ╠═5fcfb5dc-4c4b-11eb-0be6-e7f66ea1839e
# ╠═6e7d5a94-4c4b-11eb-3e2d-353177d6bca5
# ╠═79129c92-4c4b-11eb-28f6-633aedabd990
# ╠═7f693b34-4c4b-11eb-134d-af855593f45e
# ╠═83939d80-4c4b-11eb-3dc8-1b559c61a43b
# ╠═884b0d4a-4c4b-11eb-1d39-5f67ba9e92fe
# ╠═9483861e-4c4b-11eb-156b-2501ef2c54d0
# ╠═9fd1be0a-4c4b-11eb-299b-f7f0d8797f71
# ╠═a2104d08-4c4b-11eb-0ccc-b588e99a2057
# ╠═a214405c-4c4b-11eb-118b-b7ec852f9257
# ╠═a806a9dc-4c4b-11eb-1101-6f75be7a610c
# ╠═af514422-4c4b-11eb-1cfe-cba6029ec52f
# ╠═b3035158-4c4b-11eb-1b8d-1fc4070fa132
# ╠═c4575438-4c4b-11eb-1da2-97acca3f3e99
# ╠═c64e66c8-4c4b-11eb-1686-8fa64d8b2505
# ╠═03d82c7a-4c58-11eb-0071-bb9ea16bfbb3
# ╠═0bec2d28-4c58-11eb-0a51-95bf50bbfd79
# ╠═0fd08728-4c58-11eb-1b71-c9710d398fab
# ╠═2c6097f4-4c58-11eb-0807-d5d8cbfbd62c
# ╠═9505a4d4-4c58-11eb-1e2e-0d080437fa23
# ╠═23dac6cc-4c58-11eb-2c66-f1f79db08536
# ╠═4f80f0a8-4c58-11eb-3679-c186c61c5a14
# ╠═6d496b44-4c58-11eb-33b6-5b4d6315b6ea
# ╠═7bc7bdf4-4c58-11eb-1fd8-376ac6da5ab2
# ╠═74d97654-4c58-11eb-344b-8d6df24323d5
# ╠═9cecd9a6-4c58-11eb-22dc-33cd2559d815
# ╠═c6d236da-4c58-11eb-2714-3f5c43583a3d
# ╠═3253ab74-4c58-11eb-178e-83ea8aba9c8f
# ╠═32593936-4c58-11eb-174c-0bb20d93dde5
# ╠═ebb09172-4c58-11eb-1cc9-91193c57677d
# ╠═3aa37510-58bb-11eb-2ecb-37ce4428269c
# ╠═3de1f1aa-58bd-11eb-2ffc-0de292b13840
# ╠═5f47cdf0-58be-11eb-1bca-a3d0941b9bea
# ╠═0c91ce30-58b9-11eb-3617-4d87682831dd
# ╠═75d14674-58ba-11eb-3868-172fc00a0eb8
# ╠═7cb0cbfe-4cfb-11eb-3faf-a7bd7b89a874
# ╠═b1a00da4-4cfe-11eb-0aff-69099e40d28f
# ╠═5619fd6c-4cfe-11eb-1512-e1800b6c7df9
# ╠═c6e16d7a-58cf-11eb-32a4-3372939066e3
# ╠═cb20fffe-58cf-11eb-1b65-49699f2d3699
# ╠═cee388d2-58cf-11eb-3b88-971b4b85e957
# ╟─41b19e20-4d0f-11eb-1c3c-572cc5243d99
# ╠═04aff640-58bb-11eb-1bb6-69ad9fc32314
# ╠═69dc67fa-4cff-11eb-331e-25ffdced4323
# ╠═9f1a2834-4d0f-11eb-3c3e-b7ff55f65dd3
# ╠═85fb018e-4c1d-11eb-2519-a5abe100748e
# ╠═b56686ec-4cfa-11eb-2b14-a5d49a137cc5
# ╠═2e7973b6-4d0f-11eb-107c-cdaf349428c0
