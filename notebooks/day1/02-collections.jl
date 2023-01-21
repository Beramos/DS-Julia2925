### A Pluto.jl notebook ###
# v0.19.2

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

# ╔═╡ cdff6730-e785-11ea-2546-4969521b33a7
using PlutoUI; TableOfContents()

# ╔═╡ fbde6364-4f30-11eb-1ece-712293996c04
using Colors: RGB

# ╔═╡ 486457d8-4f37-11eb-306c-57d650508136
using Images

# ╔═╡ 7308bc54-e6cd-11ea-0eab-83f7535edf25
# edit the code below to set your name and UGent username

student = (name = "Jimmy Janssen", email = "Jimmy.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
md"""
# Notebook 2: Collections
"""

# ╔═╡ 2222fe0c-4c1d-11eb-1e63-f1dbc90a813c
md"""In programming, a collection is a class used to represent a set of similar data type items as a single unit. These unit classes are used for grouping and managing related objects. A collection has an underlying data structure that is used for efficient data manipulation and storage. 
	
	[Techopedia.com](https://www.techopedia.com/definition/25317/collection)"""

# ╔═╡ 44542690-4c1d-11eb-2eea-49f28ed7fd90
md"""
## 1. Arrays

Let us start with `Array`'s. It is very similar to lists in Python, though it can have more than one dimension. An `Array` is defined as follows,


"""

# ╔═╡ 8f8c7b44-4c1d-11eb-0cd8-3bb82c75c086
A = []            # empty array

# ╔═╡ b0420f36-5a71-11eb-01f1-f16b115f5895
md"Note that the element type is `Any`, since the compiler has no idea what we would store in `A`!"

# ╔═╡ a0c22de6-4c1d-11eb-34a2-aff57cfd22a1
X = [1, 3, -5, 7] # array of integers

# ╔═╡ a81d1f22-4c1d-11eb-1b76-2929f30565bf
md"### Indexing and slicing"

# ╔═╡ bb79bf28-4c1d-11eb-35bf-379ac0cd16b6
md"Let's start by eating the frog. Julia uses [1-based indexing](https://docs.google.com/document/d/11ZKaR0a6hvc6xmYLfmslAAPnkVRSZFGz5GZYRNmxmsQ/edit)..."

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
names[end-1:end] = ["Slartibartfast", "The Whale and the Bowl of Petunias"]

# ╔═╡ 4fb1a53e-4c1e-11eb-381b-1f86a5ed97a1
names

# ╔═╡ 619fd3bc-5a72-11eb-22f7-49ff5486e0fa
md"What the first index again? And how to access the last element? If you forgot, just use `first` and `last`:"

# ╔═╡ 7e460c3e-5a72-11eb-0c52-cf9583c70759
first(names), last(names)

# ╔═╡ 354fa70c-5a74-11eb-31fc-ad21a845d3b0
md"Pluto might not execute the lines of code in order. As you are changing `names` later on, the results might be a bit unexpected."

# ╔═╡ 56f5f21e-4c1e-11eb-004e-f19aa9029b01
md"### Types and arrays"

# ╔═╡ 79e0f212-4c1e-11eb-0d64-87308d762180
md"Julia arrays can be of mixed type."

# ╔═╡ 86dcfb26-4c1e-11eb-347f-ffbd8b396f09
Y = [42, "Universe", []]

# ╔═╡ 8a0e3e36-4c1e-11eb-0ec0-d19fdc3c89d8
md"The type of the array changes depending on the elements that make up the array. With `Any` being the most general type. Working with such general objects is not efficient though. In practice, your code will become as slow as Python."

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
Arrays can be initialised in all the classic, very Pythonesque ways.


"""

# ╔═╡ c3462b35-8b27-4b1e-9084-d7f11cb828e1
md"""
> **Assignment: array initialisation**

Test the following statements.

```julia
C = []  # empty

zeros(5)      # row vector of 5 zeroes

ones(3,3)     # 3×3 matrix of 1's, will be discussed later on

fill(0.5, 10) # in case you want to fill a matrix with a specific value
	
rand(2)       # row vector of 2 random floats [0,1]
	
randn(2)      # same but normally-distributed random numbers
	
rand(Bool, 10)  # specify the type, many packages overload rand for other stuff
	
```
"""

# ╔═╡ 4b3317da-4c1f-11eb-19d5-03570c4d65df


# ╔═╡ 503c9da0-4c1f-11eb-292a-db7b8ce9f458


# ╔═╡ 503d455c-4c1f-11eb-3af2-8f200db1fd30


# ╔═╡ 504d8aca-4c1f-11eb-3600-d77038b0f2bc


# ╔═╡ 505874a8-4c1f-11eb-1132-3bbba81ae1db


# ╔═╡ 5071c430-4c1f-11eb-226b-634abae6082f


# ╔═╡ c2ccb916-5a72-11eb-16d9-15283727d6cf


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
dZ = [Z[i-1] - 2Z[i] + Z[i+1] for i=2:length(Z)-1] # central difference

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

# ╔═╡ 10267fee-5a73-11eb-2947-279f6be1a3fe
md"We can also use logic to specify which elements to include."

# ╔═╡ 27051614-5a73-11eb-1d22-35ec8ebc1fd8
[i^2 for i in 1:20 if isodd(i)]  # squares of the odd integers below 20

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

# ╔═╡ 028be3bc-661f-11eb-251e-73abd3abb9fe
size(P)

# ╔═╡ 08e5589e-661f-11eb-262a-dd917f77f56b
size(P, 1)  # size first dimention

# ╔═╡ 0b9bad58-4c24-11eb-26a8-1d04d7b2be61
P[3,2]  # indexing

# ╔═╡ 0b9d0bf8-4c24-11eb-2beb-0763c66e6a20
P[1,:]  # slicing

# ╔═╡ b9a9a730-5a73-11eb-0d17-7bf1aa935697
md"You  will likely not be surprised that most functions just work for two (or more) dimensions:"

# ╔═╡ d4405d8c-5a73-11eb-21f7-37c4d7ac537b
ones(4, 5)

# ╔═╡ da5edf54-5a73-11eb-26ff-2f6af8adceed
fill(0.5, 8, 2)

# ╔═╡ def334c0-5a73-11eb-3006-e7437155cdef
rand(Bool, 3, 3)

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
end

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
md"Sometimes, `vcat` and `hcat` are better used to make the code unambiguous..."

# ╔═╡ cad05c2a-4c4a-11eb-0c89-13cddd2aa35f
md"By default, the `*` operator is used for matrix multiplication"

# ╔═╡ d43ae2ee-4c4a-11eb-281a-b353dc1de640
E = [2 4 3; 3 1 5]

# ╔═╡ d5f77750-4c4a-11eb-0624-11ca5cc2a84e
R = [ 3 10; 4 1 ;7 1]

# ╔═╡ d5fa6276-4c4a-11eb-068e-b114e33e5d8f
E * R

# ╔═╡ 45e86286-4c4b-11eb-1516-0140dc69ab58
md"### Element-wise operations"

# ╔═╡ ee779c1a-4c4a-11eb-1894-d743aeff7f44
md"""This is the Julian way since functions act on the objects, and element-wise operations are done with "dot" operations. For every function or binary operation like `^` there is a "dot" operation `.^` to perform element-by-element exponentiation on arrays."""

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

# ╔═╡ be557eda-64a3-11eb-1562-35ad48531ebd


# ╔═╡ eed4faca-4c1f-11eb-3e6c-b342b48080eb
md""" ### Intermezzo: Colors.jl and Images.jl

As has been mentioned before, everything has a type. We also know that functions can behave differently for each type. With this in mind, let us look at two interesting packages. *Colors.jl* and *Images.jl*
"""

# ╔═╡ 42254aa6-4f37-11eb-001b-f78d5383e36f
RGB(0.5, 0.2, 0.1)

# ╔═╡ 0977a54e-4f31-11eb-148c-1d44be4f6853
md"*Colors.jl* provides a wide array of functions for dealing with color. This includes conversion between colorspaces, measuring distance between colors, simulating color blindness, parsing colors, and generating color scales for graphics."

# ╔═╡ 4c21ed0e-4f37-11eb-0a90-3120e1ee7936
url = "https://i.imgur.com/BJWoNPg.jpg"

# ╔═╡ 5686c59e-4f37-11eb-21d5-47bdbcf75805
download(url, "bluebird.jpg")  # download to a local file

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
md"""
☼ 
$(@bind brightness html"<input type=range min=0.0 max=300.0>")
☾
"""

# ╔═╡ ac62d6e0-5a74-11eb-1538-09d157738257
brightness

# ╔═╡ d73eba40-4f3a-11eb-0aa8-617fc22d5ca3
img[1:1500, 201:1700] ./ (brightness/100)

# ╔═╡ 21db9766-64a4-11eb-3ec1-4956431e7a09
sort(img, dims=2, by=c->hue(HSV(c)))  # we can sort the colors!

# ╔═╡ 5064c592-4c4b-11eb-0dee-5186caf2b1f6
md"### Higher dimensional arrays"

# ╔═╡ 598980b8-4c4b-11eb-0c5b-b7064b189e97
md"Matrices can be generalized to multiple dimensions."

# ╔═╡ 5fcfb5dc-4c4b-11eb-0be6-e7f66ea1839e
H = rand(3, 3, 3)

# ╔═╡ bf6b9fc4-5a74-11eb-2676-bda580c65877
md"That is all there is to see about matrices, feel free to create arrays of any dimension."

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
md"Similar to the `range` function in Python, the object that is created is not an array, but an iterator. This is actually the term used in Python. Julia has many different types and structs, which behave a particular way. Types of `UnitRange` only store the beginning and end value (and stepsize in the case of `StepRange`). But functions are overloaded such that it acts as an array. This can really improve the execution speed since the conversion from `Range` to explicit array is only performed where it is necessary and avoids copying large matrices from function to function."

# ╔═╡ 9fd1be0a-4c4b-11eb-299b-f7f0d8797f71
let
	for i in ur
	  println(i)
	end
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
md"Such implicit objects can be processed much smarter than naive structures. Compare! (You might need to run the lines of code again as not to measure compile time."

# ╔═╡ c4575438-4c4b-11eb-1da2-97acca3f3e99
@elapsed sum([i for i in 1:100_000_000])

# ╔═╡ c64e66c8-4c4b-11eb-1686-8fa64d8b2505
@elapsed sum(1:100_000_000)   

# ╔═╡ 3a6c466a-5a75-11eb-07e2-ffbf9ec3ffe4
sum(1:100_000_000) == sum((i for i in 1:100_000_000))

# ╔═╡ 03d82c7a-4c58-11eb-0071-bb9ea16bfbb3
md"`StepRange` and `UnitRange` also work with floats."

# ╔═╡ 0bec2d28-4c58-11eb-0a51-95bf50bbfd79
0:0.1:10

# ╔═╡ 6aa73154-661f-11eb-2b88-578eb2dd2ec2
(0:1:100) / 10  # equivalent

# ╔═╡ ae6064e6-64a4-11eb-24b5-0b0b848aa2d6


# ╔═╡ 0fd08728-4c58-11eb-1b71-c9710d398fab
md"## 3. Other collections"

# ╔═╡ 2c6097f4-4c58-11eb-0807-d5d8cbfbd62c
md"Some of the other collections include tuples, dictionaries, and others."

# ╔═╡ 9505a4d4-4c58-11eb-1e2e-0d080437fa23
md"### Tuples"

# ╔═╡ 23dac6cc-4c58-11eb-2c66-f1f79db08536
tupleware = ("tuple", "ware") # tuples

# ╔═╡ 4f80f0a8-4c58-11eb-3679-c186c61c5a14
md"A tuple is an array with a fixed size. It is not possible to perform operations that change the size of a tuple."

# ╔═╡ 6d496b44-4c58-11eb-33b6-5b4d6315b6ea
pop!(tupleware)

# ╔═╡ 56e8f6b4-5a75-11eb-3eeb-ffec491be69c
md"In contrast to arrays however, the types at positions should not be the same, since the compiler will create a new type for every combination!"

# ╔═╡ 8245e46e-5a75-11eb-2d0a-27ef6a1f2492
mixedtuple = (9, "nine")

# ╔═╡ 942b88b4-5a75-11eb-3e7b-4534bf4a7b12
typeof(mixedtuple)

# ╔═╡ 7bc7bdf4-4c58-11eb-1fd8-376ac6da5ab2
md"Indexing and slicing is the same as arrays,"

# ╔═╡ 74d97654-4c58-11eb-344b-8d6df24323d5
tupleware[end]

# ╔═╡ 9bb1e83a-5a75-11eb-0fcc-59f6cc50bf6a
md"One can also define named tuples where the fields have names."

# ╔═╡ bcd5696a-5a75-11eb-0ec1-f116216aa682
namedtuple = (trainer="Ash", pokemon="Pikachu")

# ╔═╡ d74ff724-5a75-11eb-39a1-a963cd64948b
namedtuple[:trainer]

# ╔═╡ dd8978a4-5a75-11eb-287e-03e4272b6f2c
namedtuple[1]  # but indexing still works

# ╔═╡ 9cecd9a6-4c58-11eb-22dc-33cd2559d815
md"### Dictionaries"

# ╔═╡ c6d236da-4c58-11eb-2714-3f5c43583a3d
md"A dictionary is a collection that stores a set of values with their corresponding keys internally for faster data retrieval. The operation of finding the value associated with a key is called lookup or indexing. [Techopedia.com](https://www.techopedia.com/definition/10263/dictionary-c)"

# ╔═╡ 3253ab74-4c58-11eb-178e-83ea8aba9c8f
scores = Dict("humans" => 2, "vogons" => 1) # dictionaries

# ╔═╡ 32593936-4c58-11eb-174c-0bb20d93dde5
scores["humans"]

# ╔═╡ fcfb511c-5a75-11eb-2181-33d147ab1806
scores["mice"] = 3  # adding a key

# ╔═╡ 1882840a-5a76-11eb-3392-81c2915487f5
scores

# ╔═╡ 3fc787d6-5a76-11eb-06e9-5378d27ce011
delete!(scores, "humans")  # removing a key, earth was destroyed

# ╔═╡ ebb09172-4c58-11eb-1cc9-91193c57677d
md"## 4. Exercises"

# ╔═╡ f441018e-5212-4e7a-b67e-6e28f92be4a2
md"""
> **Question 1: do you still remember how to integrate?**

Integrating for dummies. Compute the Riemann sum **without** making use of a for-loop.

Riemann approximates the integration of a function in the interval [a, b],
		
$$\int_a^b f(x)\, dx \approx \sum_{i=1}^n f(x_i) \,\Delta x$$

which is the sum of the function $f(x)$ evaluated over an array of x-values in the interval [a,b] multiplied by the $\Delta x$ which is,
		
$$\Delta x = \cfrac{(b-a)}{n}$$

Complete the function `riemannsum(f, a, b; n=100)` where the arguments are the function to integrate (f) the boundaries of the interval a, b and the number of bins with a default value of 100, n.
"""

# ╔═╡ ee9069e2-63a7-11eb-12b9-97ae270506f4
md"Remember, `.` is not only used for decimals..."

# ╔═╡ 3de1f1aa-58bd-11eb-2ffc-0de292b13840
function riemannsum(f, a, b; n=100)
  return missing
end

# ╔═╡ 5f47cdf0-58be-11eb-1bca-a3d0941b9bea
begin 
	integral1 = missing #...
	integral2 = missing #...
end;

# ╔═╡ c1e377c4-64a4-11eb-3e7f-b163cb465057
md"""
> **Question 2: determinining the determinant**

1. Write a function `mydet` to compute the determinant of a 2x2 square matrix. Remember, for a $2 \times 2$ matrix, the determinant is computed as

${\displaystyle|A|={\begin{vmatrix}a&b\\c&d\end{vmatrix}}=ad-bc.}$

2. For larger matrices, there is a recursive way of computing the determinant based on the minors, i.e. the determinants of the submatrices. See [http://mathworld.wolfram.com/Determinant.html](http://mathworld.wolfram.com/Determinant.html). Update `mydet` to compute the determinant of a general square matrix.
"""

# ╔═╡ 5619fd6c-4cfe-11eb-1512-e1800b6c7df9
function mydet(A)
	size(A,1) != size(A,2) && throw(DimensionMismatch)
	return missing
end

# ╔═╡ e5293248-64a4-11eb-0d30-53a15bec0d01
md"""
> **Question 3: it is pi 'o clock**

Estimate pi through Monte Carlo sampling. Do this by simulating throwing `n` pebbles in the [-1, 1] x [-1, 1] square and track the fraction that land in the unit circle. Complete the function `estimatepi` below.

Hints:

- [Check this image](http://www.pythonlikeyoumeanit.com/_images/circle_square_small.png)
- Because each throw falls randomly within the square, you realize that the probability of a dart landing within the circle is given by the ratio of the circle’s area to the square’s area: $$P_{circle} = \frac{Area_{circle}}{Area_{square}} = \frac{\pi r^2}{(2r)^2}\,.$$ Furthermore, we can interpret Pcircle as being approximated by the fraction of darts thrown that land in the circle. Thus, we find: $$\frac{N_{circle}}{N_{total}} \approx \frac{\pi r^2}{(2r)^2} = \frac{\pi}{4}$$where $N_{total}$ is the total number of darts thrown, and $N_{circle}$ is the number of darts that land within the circle. Thus simply by keeping a tally of where the darts land, you can begin to estimate the value of π! [source:](http://www.pythonlikeyoumeanit.com/Module3_IntroducingNumpy/Problems/Approximating_pi.html)  pythonlikeyoumeanit.com
"""

# ╔═╡ cb20fffe-58cf-11eb-1b65-49699f2d3699
function estimatepi(n)
	missing
end

# ╔═╡ cee388d2-58cf-11eb-3b88-971b4b85e957
function estimatepi2(n)
	missing
end

# ╔═╡ 41b19e20-4d0f-11eb-1c3c-572cc5243d99


# ╔═╡ 04aff640-58bb-11eb-1bb6-69ad9fc32314
md"## 5. Extra exercises"

# ╔═╡ 5c8f024f-87a3-444f-8f09-5d179a04a1cb
md"""
> **Question 4: Markdown tables**

Markdown is a lightweight markup language that you can use to add formatting elements to plaintext text documents. It is also the markup language used in this notebook. Markdown is really easy to learn (see the example below). The problem with markdown is that table generation is a tedious process... Write a small Julia package (read function) that generates a markdown table that takes an array of strings for the header and an n-by-m array of table values. Complete `markdowntable()` below. The function should both return a string of the markdown table and should automatically copies this to the clipboard using the `clipboard()` function. Just for completion, you should end your table with a newline (\n).

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
```

Hints:
- The `join` and `repeat`-functions might come in handy;
- The `@assert` macro should get you close to solving the second part.
"""

# ╔═╡ 75d14674-58ba-11eb-3868-172fc00a0eb8
function markdowntable(table, header)
	missing
end

# ╔═╡ 8c5da051-f397-4613-97aa-2d673e03ea7b
md"""
> **Question 5: Ridge Regression**

Ridge regression can be seen as an extension of ordinary least squares regression,

$\beta X =b\, ,$

where a matrix $\beta$ is sought that minimizes the sum of squared residuals between the model and the observations,

$SSE(\beta) = (y - \beta X)^T (y - \beta X)$

In some cases, it is advisable to add a regularisation term to this objective function,

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

> "For instance, on the planet Earth, man had always assumed that he was more intelligent than dolphins because he had achieved so much - the wheel, New York, wars and so on - whilst all the dolphins had ever  done was muck about in the water having a good time. But conversely, the dolphins had always believed that they were far more intelligent than man - for precisely the same reasons."
>
> ~ *Hitchhikers guide to the galaxy* ~

Plot the trend of human vs dolphin intelligence by implementing the analytical solution for ridge regression. For this, you need the uniform scaling operator `I`, found in the `LinearAlgebra` package. Use a lambda of 0.01.
		
"""

# ╔═╡ 9f1a2834-4d0f-11eb-3c3e-b7ff55f65dd3
begin
	t = collect(0:10:3040)
	ϵ₁ = randn(length(t))*15     # noise on Dolphin IQ
	ϵ₂ = randn(length(t))*20     # noise on Human IQ

	Y₁ = dolphinsIQ = t/12 + ϵ₁
	Y₂ = humanIQ = t/20 + ϵ₂
end;

# ╔═╡ 85fb018e-4c1d-11eb-2519-a5abe100748e
begin 
	β₁ = missing    # replace with the correct way to compute β
	β₂ = missing    # replace with the correct way to compute β

	Yₚ₁ = β₁.*t      # Dolphin IQ
	Yₚ₂ = β₂.*t      # Human IQ
end;

# ╔═╡ a0026d1c-bcdb-4a2e-b1a1-11c5235a4956
md"""## Answers
If you would like to take a look at the answers, you can do so by checking the boxo the question you would like to see. The function will be shown just below the question you want to look at.

| Question | Show solution |
|-----|:---------:|
| Question 1 | $(@bind answ_q1 CheckBox()) |
| Question 2 | $(@bind answ_q2 CheckBox()) |
| Question 3 | $(@bind answ_q3 CheckBox()) |
| Question 4 | $(@bind answ_q4 CheckBox()) |
| Question 5 | $(@bind answ_q5 CheckBox()) |
"""

# ╔═╡ 6d43af49-f127-4ffe-ba97-0f04fb792efb
if answ_q1 == true
	md"""
	```Julia
	function riemannsum(f, a, b; n=100)
	  dx = (b - a) / n
	  return sum(f.(a:dx:b)) * dx
	end
	```
	"""
end

# ╔═╡ eae5611f-913c-48e4-bc1b-86d33908ac46
if answ_q2 == true
	md"""
	```Julia
	function mydet(A)
		size(A,1) != size(A,2) && throw(DimensionMismatch)
		return A[1,1]*A[2,2]-[1,2]*A[2,1]
	end
	```
	"""
end

# ╔═╡ be4c9bbe-0ec1-4477-b422-dcf308cd6f5b
if answ_q3 == true
	md"""
	```Julia
	function estimatepi(n)
	  hits = 0
	  for i in 1:n
		  x = rand()
		  y = rand()
		  if x^2 + y^2 ≤ 1.0
			  hits += 1
		  end
	  end
	  return 4hits/n
	end

	estimatepi2(n) = 4count(x-> x ≤ 1.0, sum(rand(n, 2).^2, dims=2)) / n
	```
	"""
end

# ╔═╡ cf2b6aa4-b0e8-471a-95fc-646bbddb989a
if answ_q4 == true
	md"""
	```Julia
	function markdowntable(table, header)
	  n, m = size(table)
	  table_string = ""
	  # add header
	  table_string *= "| " * join(header, " | ") * " |\n"
	  # horizontal lines for separating the columns
	  table_string *= "| " * repeat(":--|", m) * "\n"
	  for i in 1:n
		  table_string *= "| " * join(table[i,:], " | ") * " |\n"
	  end
	  #clipboard(table_string)
	  return table_string
	end
	```
	"""
end

# ╔═╡ 65a45d44-7942-4808-bed0-0369077c5edb
if answ_q5 == true
	md"""
	```Julia
	β₁ = inv(transpose(t)*t + UniformScaling(0.01)) * transpose(t)* Y₁
	β₂ = inv(transpose(t)*t + UniformScaling(0.01)) * transpose(t)* Y₂

	Yₚ₁ = β₁.*t      # Dolphin IQ
	Yₚ₂ = β₂.*t      # Human IQ
	```
	"""
end

# ╔═╡ 2e7973b6-4d0f-11eb-107c-cdaf349428c0
md""" ## 5. References

- [Julia Documentation](https://juliadocs.github.io/Julia-Cheat-Sheet/)
- [Introduction to Julia UCI data science initiative](http://ucidatascienceinitiative.github.io/IntroToJulia/)
- [Month of Julia](https://github.com/DataWookie/MonthOfJulia)
- [Why I love Julia, Next Journal](https://nextjournal.com/kolia/why-i-love-julia)

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Colors = "~0.12.10"
Images = "~0.25.2"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "0310e08cb19f5da31d08341c6120c047598f5b9c"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.5.0"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "1dd4d9f5beebac0c03446918741b1a03dc5e5788"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.6"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "64df3da1d2a26f4de23871cd1b6482bb68092bd5"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.3"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "90630efff0894f8142308e334473eba54c433549"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.5.0"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "7be5f99f7d15578798f338f5433b6c432ea8037b"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78e2c69783c9753a91cdae88a8d432be85a2ab5e"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+0"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "ba2d094a88b6b287bd25cfa86f301e7693ffae2f"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.7.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "b1798a4a6b9aafb530f8f0c4a7b2eb5501e2f2a3"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.16"

[[ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SnoopPrecompile", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "f265e53558fbbf23e0d54e4fab7106c0f2a9e576"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.3"

[[ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "124626988534986113cfd876e3093e4a03890f58"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+3"

[[ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "e7c68ab3df4a75511ba33fc5d8d9098007b579a8"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.2"

[[ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "5985d467623f106523ed8351f255642b5141e7be"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.4"

[[ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "36832067ea220818d105d718527d6ed02385bf22"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.7.0"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "8717482f4a2108c9358e5c3ca903d3a6113badc9"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.5"

[[Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "03d1301b7ec885b266c0f816f338368c6c0b81bd"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.2"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[Inflate]]
git-tree-sha1 = "5cd07aab533df5170988219191dfad0519391428"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.3"

[[IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[IntervalSets]]
deps = ["Dates", "Random", "Statistics"]
git-tree-sha1 = "16c0cc91853084cb5f58a78bd209513900206ce6"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.4"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "ec8a9c9f0ecb1c687e34c1fda2699de4d054672a"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.29"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "946607f84feb96220f480e0422d3484c49c00239"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.19"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "5ae7ca23e13855b3aba94550f26146c01d259267"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.0"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "f71d8950b724e9ff6110fc948dff5a329f901d64"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.8"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "f809158b27eba0c18c269cf2a2be6ed751d3e81d"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.17"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "8175fc2b118a3755113c8e68084dc1a9e63c61ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f6cf8e7944e50901594838951729a1861e668cb8"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.2"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "da095158bdc8eaccb7890f9884048555ab771019"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.4"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "9480500060044fd25a1c341da53f34df7443c2f2"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.4"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

[[Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "6954a456979f23d05085727adb17c4551c19ecd1"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.12"

[[StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "7e6b0e3e571be0b4dd4d2a9a3a83b65c04351ccc"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.3"

[[TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─cdff6730-e785-11ea-2546-4969521b33a7
# ╠═7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╟─a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╟─2222fe0c-4c1d-11eb-1e63-f1dbc90a813c
# ╟─44542690-4c1d-11eb-2eea-49f28ed7fd90
# ╠═8f8c7b44-4c1d-11eb-0cd8-3bb82c75c086
# ╟─b0420f36-5a71-11eb-01f1-f16b115f5895
# ╠═a0c22de6-4c1d-11eb-34a2-aff57cfd22a1
# ╟─a81d1f22-4c1d-11eb-1b76-2929f30565bf
# ╟─bb79bf28-4c1d-11eb-35bf-379ac0cd16b6
# ╠═eaf59a7e-4c1d-11eb-2db3-fd7f995db3e4
# ╠═efa60284-4c1d-11eb-1c08-09993363e4a8
# ╠═efa6f180-4c1d-11eb-1ab0-3d1ca0b4bc57
# ╠═efb6718c-4c1d-11eb-0dff-e55e6a676e39
# ╠═efb69e46-4c1d-11eb-1ce7-ed428db8ff44
# ╟─0a02b730-4c1e-11eb-1e8a-872dcfc8ab81
# ╠═15035dee-4c1e-11eb-123f-a961fdd48445
# ╟─1960de28-4c1e-11eb-1c84-ffe0cbaac940
# ╠═4db9d648-4c1e-11eb-1063-e78c78ef5c4b
# ╠═4fb1a53e-4c1e-11eb-381b-1f86a5ed97a1
# ╟─619fd3bc-5a72-11eb-22f7-49ff5486e0fa
# ╠═7e460c3e-5a72-11eb-0c52-cf9583c70759
# ╟─354fa70c-5a74-11eb-31fc-ad21a845d3b0
# ╟─56f5f21e-4c1e-11eb-004e-f19aa9029b01
# ╟─79e0f212-4c1e-11eb-0d64-87308d762180
# ╠═86dcfb26-4c1e-11eb-347f-ffbd8b396f09
# ╟─8a0e3e36-4c1e-11eb-0ec0-d19fdc3c89d8
# ╠═90d3dc80-4c1e-11eb-2a11-3fe581f0b5f7
# ╠═996ba666-4c1e-11eb-3c5c-4bf8673de6bc
# ╠═90d369a8-4c1e-11eb-3c16-c5fb02bdf3bb
# ╟─f247382c-4c1e-11eb-229c-efe48b7a4d7f
# ╠═fd06f130-4c1e-11eb-37cf-03af9372ae45
# ╠═00237b9a-4c1f-11eb-3b19-73c0b8e4cbed
# ╠═0425e980-4c1f-11eb-2477-e35a924b8018
# ╟─069cccc4-4c1f-11eb-39b3-b94136c1b468
# ╟─0fd48034-4c1f-11eb-06a9-0d7353b2a0d6
# ╠═2262e4fc-4c1f-11eb-07b8-0b9732b93d86
# ╟─3d0107c4-4c1f-11eb-1b5b-ed954348d0aa
# ╟─c3462b35-8b27-4b1e-9084-d7f11cb828e1
# ╠═4b3317da-4c1f-11eb-19d5-03570c4d65df
# ╠═503c9da0-4c1f-11eb-292a-db7b8ce9f458
# ╠═503d455c-4c1f-11eb-3af2-8f200db1fd30
# ╠═504d8aca-4c1f-11eb-3600-d77038b0f2bc
# ╠═505874a8-4c1f-11eb-1132-3bbba81ae1db
# ╠═5071c430-4c1f-11eb-226b-634abae6082f
# ╠═c2ccb916-5a72-11eb-16d9-15283727d6cf
# ╟─52a8a6ec-4c1f-11eb-386c-a99ef05b41b0
# ╠═507254b0-4c1f-11eb-2b2c-8bc88e58e0b3
# ╟─27b18866-4c22-11eb-22da-656ca8a4c01d
# ╟─387c3e70-4c22-11eb-37e4-bb6c36600074
# ╠═3da23eb8-4c22-11eb-1ec4-c350d615322f
# ╠═3f5436d2-4c22-11eb-342a-35b7a29ef146
# ╟─63fea2f6-4c22-11eb-0802-37fd7653cdb5
# ╟─10267fee-5a73-11eb-2947-279f6be1a3fe
# ╠═27051614-5a73-11eb-1d22-35ec8ebc1fd8
# ╟─a5f17ccc-4c22-11eb-2cb8-7b130e1e811f
# ╠═f1b481f4-4c22-11eb-39b7-39ffdd5bbccc
# ╠═f61fc4b0-4c22-11eb-30b3-154ed1aa43bd
# ╟─fcbeda22-4c22-11eb-2d35-a356b98bbc46
# ╟─3516a722-4c23-11eb-3ee7-fb8d582c8ce0
# ╠═08bb725e-4c23-11eb-3338-03370f49dd11
# ╠═0cfc84ca-4c23-11eb-124b-5397430fd203
# ╠═4fbecdfe-4c23-11eb-0da7-5945a49c3a2a
# ╠═562b751e-4c23-11eb-2b8f-73f710bf3520
# ╟─5ed7284a-4c23-11eb-1451-0ff763f52bc7
# ╟─0186eab2-4c24-11eb-0ff6-d7f8af343647
# ╠═097e96e8-4c24-11eb-24c4-31f4d23d3238
# ╠═028be3bc-661f-11eb-251e-73abd3abb9fe
# ╠═08e5589e-661f-11eb-262a-dd917f77f56b
# ╠═0b9bad58-4c24-11eb-26a8-1d04d7b2be61
# ╠═0b9d0bf8-4c24-11eb-2beb-0763c66e6a20
# ╟─b9a9a730-5a73-11eb-0d17-7bf1aa935697
# ╠═d4405d8c-5a73-11eb-21f7-37c4d7ac537b
# ╠═da5edf54-5a73-11eb-26ff-2f6af8adceed
# ╠═def334c0-5a73-11eb-3006-e7437155cdef
# ╟─25d53e6c-4c24-11eb-02a2-a71d4b2a7974
# ╠═6191c72e-4c24-11eb-21bb-a59e880a3573
# ╟─07220d0a-4c4a-11eb-0ae3-298cf03a0bf6
# ╟─26f6f852-4c4a-11eb-3a5c-e7d788713ab8
# ╠═54b81ed8-4c4a-11eb-1d47-99d5823f2ab1
# ╠═56fd77e2-4c4a-11eb-1ab1-4793cd9b220c
# ╠═56ff198a-4c4a-11eb-1604-8f08c9cf868c
# ╠═57226e44-4c4a-11eb-26fd-fbd6f993bb72
# ╠═57327ab4-4c4a-11eb-219f-f70dd02f170c
# ╟─969bc7a0-4c4a-11eb-3db6-892f68020468
# ╠═a8eba678-4c4a-11eb-2866-1135e65bc4df
# ╟─afd0b9a6-4c4a-11eb-270b-133ddc3e753b
# ╠═b4de01c4-4c4a-11eb-3b0b-275ec9ddf5bf
# ╠═b76b87e0-4c4a-11eb-3b21-f1365960fdd0
# ╟─be174110-4c4a-11eb-05cf-17e2527dfad8
# ╟─cad05c2a-4c4a-11eb-0c89-13cddd2aa35f
# ╠═d43ae2ee-4c4a-11eb-281a-b353dc1de640
# ╠═d5f77750-4c4a-11eb-0624-11ca5cc2a84e
# ╠═d5fa6276-4c4a-11eb-068e-b114e33e5d8f
# ╟─45e86286-4c4b-11eb-1516-0140dc69ab58
# ╟─ee779c1a-4c4a-11eb-1894-d743aeff7f44
# ╠═0697987c-4c4b-11eb-3052-df54b72dec52
# ╠═14bceb32-4c4b-11eb-06b2-5190f7ebb9c2
# ╟─1ace7720-4c4b-11eb-0338-37e7a7227a68
# ╠═2146ac4c-4c4b-11eb-288f-edb3eacff0eb
# ╟─28f5c018-4c4b-11eb-3530-8b592f2abeda
# ╠═32351fb8-4c4b-11eb-058b-5bb348e8dfb7
# ╟─be557eda-64a3-11eb-1562-35ad48531ebd
# ╟─eed4faca-4c1f-11eb-3e6c-b342b48080eb
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
# ╟─dd781738-4f37-11eb-09fb-b7f3390a49b2
# ╠═ab395348-4f39-11eb-0a3c-1d8af3b6442e
# ╟─7acaf008-4f3a-11eb-17c2-dfaa1e9f2ce7
# ╟─8ce0ab98-4f3a-11eb-37b2-dd7dda63ad5f
# ╠═ac62d6e0-5a74-11eb-1538-09d157738257
# ╠═d73eba40-4f3a-11eb-0aa8-617fc22d5ca3
# ╠═21db9766-64a4-11eb-3ec1-4956431e7a09
# ╟─5064c592-4c4b-11eb-0dee-5186caf2b1f6
# ╟─598980b8-4c4b-11eb-0c5b-b7064b189e97
# ╠═5fcfb5dc-4c4b-11eb-0be6-e7f66ea1839e
# ╟─bf6b9fc4-5a74-11eb-2676-bda580c65877
# ╟─6e7d5a94-4c4b-11eb-3e2d-353177d6bca5
# ╟─79129c92-4c4b-11eb-28f6-633aedabd990
# ╠═7f693b34-4c4b-11eb-134d-af855593f45e
# ╟─83939d80-4c4b-11eb-3dc8-1b559c61a43b
# ╠═884b0d4a-4c4b-11eb-1d39-5f67ba9e92fe
# ╟─9483861e-4c4b-11eb-156b-2501ef2c54d0
# ╠═9fd1be0a-4c4b-11eb-299b-f7f0d8797f71
# ╠═a2104d08-4c4b-11eb-0ccc-b588e99a2057
# ╠═a214405c-4c4b-11eb-118b-b7ec852f9257
# ╟─a806a9dc-4c4b-11eb-1101-6f75be7a610c
# ╠═af514422-4c4b-11eb-1cfe-cba6029ec52f
# ╟─b3035158-4c4b-11eb-1b8d-1fc4070fa132
# ╠═c4575438-4c4b-11eb-1da2-97acca3f3e99
# ╠═c64e66c8-4c4b-11eb-1686-8fa64d8b2505
# ╠═3a6c466a-5a75-11eb-07e2-ffbf9ec3ffe4
# ╟─03d82c7a-4c58-11eb-0071-bb9ea16bfbb3
# ╠═0bec2d28-4c58-11eb-0a51-95bf50bbfd79
# ╠═6aa73154-661f-11eb-2b88-578eb2dd2ec2
# ╟─ae6064e6-64a4-11eb-24b5-0b0b848aa2d6
# ╟─0fd08728-4c58-11eb-1b71-c9710d398fab
# ╟─2c6097f4-4c58-11eb-0807-d5d8cbfbd62c
# ╟─9505a4d4-4c58-11eb-1e2e-0d080437fa23
# ╠═23dac6cc-4c58-11eb-2c66-f1f79db08536
# ╟─4f80f0a8-4c58-11eb-3679-c186c61c5a14
# ╠═6d496b44-4c58-11eb-33b6-5b4d6315b6ea
# ╟─56e8f6b4-5a75-11eb-3eeb-ffec491be69c
# ╠═8245e46e-5a75-11eb-2d0a-27ef6a1f2492
# ╠═942b88b4-5a75-11eb-3e7b-4534bf4a7b12
# ╟─7bc7bdf4-4c58-11eb-1fd8-376ac6da5ab2
# ╠═74d97654-4c58-11eb-344b-8d6df24323d5
# ╟─9bb1e83a-5a75-11eb-0fcc-59f6cc50bf6a
# ╠═bcd5696a-5a75-11eb-0ec1-f116216aa682
# ╠═d74ff724-5a75-11eb-39a1-a963cd64948b
# ╠═dd8978a4-5a75-11eb-287e-03e4272b6f2c
# ╟─9cecd9a6-4c58-11eb-22dc-33cd2559d815
# ╟─c6d236da-4c58-11eb-2714-3f5c43583a3d
# ╠═3253ab74-4c58-11eb-178e-83ea8aba9c8f
# ╠═32593936-4c58-11eb-174c-0bb20d93dde5
# ╠═fcfb511c-5a75-11eb-2181-33d147ab1806
# ╠═1882840a-5a76-11eb-3392-81c2915487f5
# ╠═3fc787d6-5a76-11eb-06e9-5378d27ce011
# ╟─ebb09172-4c58-11eb-1cc9-91193c57677d
# ╟─f441018e-5212-4e7a-b67e-6e28f92be4a2
# ╟─ee9069e2-63a7-11eb-12b9-97ae270506f4
# ╠═3de1f1aa-58bd-11eb-2ffc-0de292b13840
# ╠═5f47cdf0-58be-11eb-1bca-a3d0941b9bea
# ╟─6d43af49-f127-4ffe-ba97-0f04fb792efb
# ╟─c1e377c4-64a4-11eb-3e7f-b163cb465057
# ╠═5619fd6c-4cfe-11eb-1512-e1800b6c7df9
# ╟─eae5611f-913c-48e4-bc1b-86d33908ac46
# ╟─e5293248-64a4-11eb-0d30-53a15bec0d01
# ╠═cb20fffe-58cf-11eb-1b65-49699f2d3699
# ╠═cee388d2-58cf-11eb-3b88-971b4b85e957
# ╟─be4c9bbe-0ec1-4477-b422-dcf308cd6f5b
# ╟─41b19e20-4d0f-11eb-1c3c-572cc5243d99
# ╟─04aff640-58bb-11eb-1bb6-69ad9fc32314
# ╟─5c8f024f-87a3-444f-8f09-5d179a04a1cb
# ╠═75d14674-58ba-11eb-3868-172fc00a0eb8
# ╟─cf2b6aa4-b0e8-471a-95fc-646bbddb989a
# ╟─8c5da051-f397-4613-97aa-2d673e03ea7b
# ╠═9f1a2834-4d0f-11eb-3c3e-b7ff55f65dd3
# ╠═85fb018e-4c1d-11eb-2519-a5abe100748e
# ╟─65a45d44-7942-4808-bed0-0369077c5edb
# ╟─a0026d1c-bcdb-4a2e-b1a1-11c5235a4956
# ╟─2e7973b6-4d0f-11eb-107c-cdaf349428c0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
