### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 4ec271b0-4e73-11eb-2660-6b8bd637d7ee
md"""
# Abstract and primitive types

All Julia objects, both those already defined as well as those you might make yourself, have a type. The type system is the secret sauce, allowing Julia to be fast because code can be specialized for a particular combination of types. It is also supremely useful in conjunction with *multiple dispatch*, in which functions work differently depending on which types you feed into them. This notebook will show the basics of the type system. We will only consider abstract and primitive types here, leaving composite types for the next notebook.
"""

# ╔═╡ a1f2d06e-4e73-11eb-3afd-1353def71700
md"""
## Checking the type

The type of objects can be assessed using the function `typeof`. For collections, `eltype` gives the types of individual elements. Try the following examples. Note that types are always capitalized!
"""

# ╔═╡ c0bfdf9e-4e73-11eb-3962-0b3c5d5424d7
a = 42; s = "mice"; n = 0.9; A = [1 2; 3 4];

# ╔═╡ b844d568-4e73-11eb-3de9-4158b0bdca12
typeof(a)

# ╔═╡ c662744a-4e73-11eb-1bfc-6daaf7282285
typeof(s)

# ╔═╡ cae803e2-4e73-11eb-13e0-23abccf86bac
typeof(n)

# ╔═╡ cc606026-4e73-11eb-3576-5d301a771a5a
typeof(A)

# ╔═╡ d3803112-4e73-11eb-2018-f72ffb7f6ec6
md"These are all *concrete types*. Julia types are part of a hierarchical type system, forming a single, fully connected type graph. The concrete types are the leaves of this tree, whereas the inner nodes are *abstract types*. As hinted by the name, these are abstract and cannot be instantiated. They, however, help with conceptually ordering the type system."

# ╔═╡ e8fe2832-4e78-11eb-3fd6-a3f1f0c0892a
md"What is the type of `pi`?"

# ╔═╡ f533012c-4e78-11eb-0f45-3b47f088c9c6
typeofpi = typeof(pi)

# ╔═╡ f69d89ba-4e73-11eb-3ab9-9179ea7e3217
md"Concrete types (should) have a well-defined memory layout, for example `Float64` is  encoded using 64 bits while `Float32` is encoded using 32 bits and hence some computations can be executed quicker but less precise by the former. Abstract types on the other hand mainly encode a semantic meaning, any `Real` should behave as a real number (e.g., addition, division are defined)."

# ╔═╡ de3de7fc-4e73-11eb-2ff6-1560481f7ee5
md"We can find the supertype of a concrete or abstract type using the function `supertype`."

# ╔═╡ e1c8cf4a-4e73-11eb-27be-d702064a0182
supertype(Int8)

# ╔═╡ e56a46c6-4e73-11eb-1748-1b6fe5ab0376
supertype(Float64)

# ╔═╡ e89adcaa-4e73-11eb-1ed8-e9c89ca633f6
supertype(AbstractFloat)

# ╔═╡ ec2ab2be-4e73-11eb-1a22-010439761432
supertype(Real)

# ╔═╡ efa205b4-4e73-11eb-1647-e9dcab5f7b7a
supertype(Number)

# ╔═╡ f3b5a778-4e73-11eb-1d3c-11ae19713eca
supertype(Any)

# ╔═╡ a0cecb24-4e74-11eb-3634-cd8dd628e9ec
md"See how all the numbers are hierarchically represented? Note that any type is always a subtype of `Any`. We can check if an object is (sub)type using the function `isa`."

# ╔═╡ b31fe65a-4e74-11eb-0414-35f2be687c7f
Float64 <: AbstractFloat

# ╔═╡ c2ac0c48-4e74-11eb-10b0-91ad620fefcd
Float16 <: AbstractFloat

# ╔═╡ c5208cce-4e74-11eb-0615-135b510a9e8d
AbstractFloat <: Number

# ╔═╡ c817296a-4e74-11eb-0994-972871114f02
Int <: Number

# ╔═╡ cb066442-4e74-11eb-35e7-ed38d4bd8bbf
Int <: AbstractFloat

# ╔═╡ ce3d5380-4e74-11eb-3d9d-5f34cbbae118
Integer <: Int

# ╔═╡ 34ca6158-4e75-11eb-3d51-330952c9b3dd
md"We can check the entire subtree of a type using the function `subtypetree`"

# ╔═╡ 8fae9e4a-4e75-11eb-0346-377e9f09ecce
function subtypetree(roottype, level=1, indent=4)
	level == 1 && println(roottype)
	for s in subtypes(roottype)
		println(join(fill(" ", level * indent)) * string(s))
		subtypetree(s, level + 1, indent)
	end
end

# ╔═╡ dc511e7e-4e75-11eb-1fcc-c5c98e8613a1
subtypetree(Real)  # check the terminal!

# ╔═╡ 4a01487c-4e78-11eb-1302-d9c6ec4ed6ab
md"""

## Converting types

Changing a variable `x` into a different type `T` can be done using the function `convert(T, x)`.
"""

# ╔═╡ 66292626-4e78-11eb-331b-0563b2110605
convert(Float64, 42)

# ╔═╡ 704b2ebe-4e78-11eb-1583-d10e0aeb2b8d
Float64(42)  # works usually as well

# ╔═╡ c3c40df2-4e78-11eb-3d4a-5fdfdf173da3
Int8(42)

# ╔═╡ cd32e96c-4e78-11eb-0b48-5767421c7875
Float32(π)

# ╔═╡ dc1c8294-4e78-11eb-1400-afa8e5ac8939
md"When designing new types, one often also implements custom `convert` methods."

# ╔═╡ 40a761c2-5b24-11eb-09a8-a5cd0bc4ab95
md"We have seen that you can add any type of float with any type of integer (ditto for vectors and arrays with different types. How does this work? Julia uses *promotion* to cast two inputs in the more general type. For example, compare adding a `Float64` with an `Int`."

# ╔═╡ 99228eee-5b24-11eb-385e-7507ca20ae0e
promote(7.9, 79)

# ╔═╡ ba39991a-5b24-11eb-260b-439bcde4c153
md"You see that `Float64` is the more general type, so both inputs are cast as floats and further processed by the function. That is why the their sum is a float: `7.9 + 79 = 86.9`. 

Of course, this also works with more complex composite types, such as matrices:
"

# ╔═╡ 35e53434-5b25-11eb-10b7-e993e9477c8c
[1 2; 3 4] + [0.0 1.0; 2.0 3.0]

# ╔═╡ 71111ea6-5b25-11eb-2553-4d15ff3271d6


# ╔═╡ 92dc7a4e-5b25-11eb-1518-8182216f24ec
[0, 1.0, 2, 3]  # cast into a vector of floats

# ╔═╡ aa26b46c-4e78-11eb-24d8-7fdce7c94fff
md"""
When designing new types, one often also implements custom `convert` methods.

When reading files, it is often useful to interpret parts of the strings as differnt data types such as numbers. This can be done using the function `parse` that works similarly to `convert`.
"""

# ╔═╡ 815b0436-4e78-11eb-13d4-0dc6531e34f2
parse(Int, "42")

# ╔═╡ 570c85bc-4e79-11eb-0249-891cf205d623
parse(Float64, "0.999")

# ╔═╡ 9193f988-4e79-11eb-05bc-058e9edb8e35
md"Below is a bunch of numbers as a text string. Can you compute their sum?"

# ╔═╡ 6756d6ac-4e79-11eb-21ab-4776195c9d3b
bunchofnumbers = "1.728002758512114, 0.45540258865644284, 1.4067738604851092, 1.6549474922755167, -0.5281073122489854, 2.219250973007533, 0.8195027302254512, 1.8833469318073521, 0.7429034224663096, -0.8127686064960085, -0.14337850083375886, -1.477193046160141, 0.024525761924498457, 0.16097115910472956, -0.39278880092280993, 1.3988081686729814, -1.3316370350161346, 0.2791510437718087, 1.9834455917052212, -0.8616791621501649
"

# ╔═╡ e6f31ad8-4e79-11eb-11f4-2936cb039f8d
parse.(Float64, split(rstrip(bunchofnumbers), ", ")) |> sum

# ╔═╡ 03766a5c-4e75-11eb-12ad-cb2e9468e0d2
md"""
## Methods and dispatch

When a function is run for the first time with a particular combination of type inputs, it gets compiled by the LLVM compiler. Such a specific function is referred to as a `method`. Every time a function is run with a new combination of types of arguments, a suitable method is compiled. This is noticeable when measuring the running time.

Run the following examples in the terminal using `@time`.
"""

# ╔═╡ 2dff8c88-4e75-11eb-050b-7152e82ac10d
mynewfun(x) = x^2 + x

# ╔═╡ 7c2b6dc0-4e76-11eb-1d78-553df82d9100
@time mynewfun(1)  # returns an integer

# ╔═╡ d2a4a32c-5b02-11eb-3839-8108c4965931
@time mynewfun(1.0)  # returns a Float64

# ╔═╡ 32d64b6e-4e75-11eb-0a2a-27214f217f70
@time mynewfun(A)

# ╔═╡ 861ba4c6-4e76-11eb-3d2b-bfabbd143df2
md"The known methods can be found using the function `methods`. For example, look how many methods are defined for sum:"

# ╔═╡ 8d5f7d8e-4e76-11eb-28ba-bdec03a3e150
methods(sum)

# ╔═╡ 99af0924-4e76-11eb-0331-87685125bcd9
md"check how many methods there are associated with the humble multiplication operator `*`."

# ╔═╡ b18d0532-4e76-11eb-2e8a-2bee580533cc
# how many methods for *?

# ╔═╡ cd2eaafc-4e76-11eb-245a-e9898d3d57a4
md"The arguments a function can take can be restricted using the `::`-operator. Here, if we limit a function as `f(x::T)`, this means that `x` can be any type `<: T`. Can you explain the reasoning behind the following code? How does it process numbers? What does it do with strings?"

# ╔═╡ db1bb4c8-4e76-11eb-2756-3f6ce778acc0
begin
	twice(x::Number) = 2x;
	twice(x::AbstractString) = x * x;
end

# ╔═╡ ff755bf8-4e76-11eb-205f-d52529ae50ed
methods(twice)

# ╔═╡ 03932e5e-4e77-11eb-3769-635cc33c3c4d
twice(10) # Int

# ╔═╡ 0b4f99ea-4e77-11eb-29fc-632788d179a3
twice(10.0)  # Float64, also a Number but not an Int

# ╔═╡ 2a0b220a-4e77-11eb-1da7-2978422c11f4
twice("A griffin! ")  # strings mean something else

# ╔═╡ bf91e40a-4e77-11eb-14f1-754b1ce5130e
md"> Julia will always select the method with the most specific type signature.
So, if we would define a function `twice(x::Float64)`, it would be chosen to process `Float64` inputs, even though these are also `Number`s."

# ╔═╡ e1a88a70-4e76-11eb-2486-e1d2f4211792
begin
	f(x, y) = "No life forms present";
	f(x::T, y::T) where {T} = x * y;  # short for {T <: Any}
	f(x::Integer, y::Real) = 2x + y;
	f(x::Int, y::Int) = 2x + 2y;
	f(x::Integer, y::Float64) = x + 2y;
	f(x::Float64, y::Real) = x - y;
	f(x::Float64, y::Float64) = 2x - y;
end

# ╔═╡ 76fe9fc4-4e77-11eb-3bc7-2dfbdff8dfc8
f(1, 2.0)

# ╔═╡ 7aa14c94-4e77-11eb-25c7-fb0103267b06
f(1.0, 2)

# ╔═╡ 7f3a5336-4e77-11eb-2ad6-3d889dc75ac0
f(Int8(1), Int8(2))

# ╔═╡ 822c01d4-4e77-11eb-1409-fbaf83c950b6
f(1.0, 2.0)

# ╔═╡ 85f186a6-4e77-11eb-19ca-5db29615ba97
f("one", 2)

# ╔═╡ 891c820e-4e77-11eb-1ebf-b3065e0d4211
f("one", "two")

# ╔═╡ 8d0d39c4-4e77-11eb-034d-07dc33ab6e9a
f(1, Float32(2.0))

# ╔═╡ 901efaee-4e77-11eb-02d9-b5fe1f0931d5
f(1, 2)

# ╔═╡ 938d8b1e-4e77-11eb-03d3-9b88c7cab3c1
f([1 1; 1 1], [2.0 2.0; 2.0 2.0])

# ╔═╡ 96f6fef2-4e77-11eb-2ec4-399472d86a60
f([1 1; 1 1], [2 2; 2 2])

# ╔═╡ 812cfe48-4e7a-11eb-32e6-c918bbe3e602
md"""

## Extending the type system

Being aware of the type system is a first step, the fun is in extending it and creating your own types.

### Abstract types

Abstract types are defined using the following simple syntax:

```
abstract type «name» end
abstract type «name» <: «supertype» end
```

### Primitive types

*Primitive types* exist of simple bits. Examples are `Float64` and `Int16`. You can declare your own types, though this is likely not something many often do in practice. For example, there is a specific binary encoding possible for nucleotides to make bioinformatics [computations more efficient](https://medium.com/analytics-vidhya/bioinformatics-2-bit-encoding-for-dna-sequences-9b93636e90e2).

### Composite types
*Composite types* (records, structs, or objects) are more exciting. They are often containers for several objects set to behave in a certain way. We will study them in depth in the next notebook.
"""

# ╔═╡ 4df6c0c0-4e7c-11eb-1d43-0d9bbf4896a7
md"""
## Case study 1: Mohs scale


![](http://www.911metallurgist.com/blog/wp-content/uploads/2015/08/Mohs-Hardness-Test-Kit-and-Scale.jpg)
"""

# ╔═╡ b487a776-4e7e-11eb-291b-e900e6e1a2f6
begin
	abstract type Mohs end
	
	
	abstract type Diamond <: Mohs end
	abstract type Corundum <: Mohs end
	abstract type Topaz <: Mohs end
	abstract type Quartz <: Mohs end
	abstract type Orthoclase <: Mohs end
	abstract type Apatite <: Mohs end
	abstract type Fluorite <: Mohs end
	abstract type Calcite <: Mohs end
	abstract type Gypsum <: Mohs end
	abstract type Talc <: Mohs end
end

# ╔═╡ 1aea83a8-4e7f-11eb-2d06-c3e550c4e1b9
begin
	mohs_scale(::Type{Diamond}) = 10
	mohs_scale(::Type{Corundum}) = 9
	mohs_scale(::Type{Topaz}) = 8
	mohs_scale(::Type{Quartz}) = 7
	mohs_scale(::Type{Orthoclase}) = 6
	mohs_scale(::Type{Apatite}) = 5
	mohs_scale(::Type{Fluorite}) = 4
	mohs_scale(::Type{Calcite}) = 3
	mohs_scale(::Type{Gypsum}) = 2
	mohs_scale(::Type{Talc}) = 1
end

# ╔═╡ 6e429164-4e7f-11eb-1829-0582f1417815
Base.isless(m1::Type{<:Mohs}, m2::Type{<:Mohs}) = mohs_scale(m1) < mohs_scale(m2)

# ╔═╡ ad6e9d8e-4e7f-11eb-1e33-efcee699f2a0
isless(Diamond, Corundum)

# ╔═╡ 9d1c94ba-4e7f-11eb-060e-d1bc9683af92
Calcite < Fluorite < Corundum

# ╔═╡ ee370b50-4e7f-11eb-1ce0-d1bdb3e41ae2
rocks = [Gypsum, Orthoclase, Quartz, Corundum, Fluorite, Gypsum, Talc]

# ╔═╡ 1117c600-4e80-11eb-3231-4383d700f760
md"`sort` and `sort!` work using the `isless` function, so these just work:"

# ╔═╡ 07a19574-4e80-11eb-38fa-8d3463dfd700
sort(rocks)

# ╔═╡ 84a0f49c-4e7c-11eb-14f2-452e57f2e414
md"""
## Case study 2: rock-paper-scissors

![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Rock-paper-scissors.svg/1200px-Rock-paper-scissors.svg.png)

We can easily implement the rock-paper-scissors rules using types.
"""

# ╔═╡ 99c4f3c8-4e7c-11eb-3d4a-33ba8d495eb2
begin
	abstract type Hand end
	
	
	abstract type Rock <: Hand end
	abstract type Paper <: Hand end
	abstract type Scissors <: Hand end
end

# ╔═╡ cba6d4cc-5b03-11eb-265d-3f08117b0e8d
md"Now we implement a function to play one hand against an opponent's hand."

# ╔═╡ d913cd92-4e7c-11eb-11e1-3d7539af7fed
begin
	play(h1::Type{Paper}, h2::Type{Rock}) = 1
	play(h1::Type{Rock}, h2::Type{Scissors}) = 1
	play(h1::Type{Scissors}, h2::Type{Paper}) = 1
	
	# this captures both when same inputs are given and
	# when the first person looses
	play(h1::Type{<:Hand}, h2::Type{<:Hand}) = h1 == h2 ? 0 : -1
end

# ╔═╡ 4f107d88-4e7d-11eb-3e49-f54ecf5163da
play(Rock, Rock)

# ╔═╡ 8331c8b0-4e7d-11eb-0690-8bbae3ed086a
play(Rock, Scissors)

# ╔═╡ 88a95ec0-4e7d-11eb-0a33-77ef82874f45
play(Scissors, Rock)

# ╔═╡ 925e2f40-4e7d-11eb-0bd2-f91913c5a23e
play(Scissors, Paper)

# ╔═╡ 5117a6b8-5b04-11eb-2910-dd7412ef69de
md"Can you extend this so that it works with lizard an Spock?
![](https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwordpress.morningside.edu%2Fcdl001%2Ffiles%2F2010%2F09%2FRockPaperScissorsLizardSpock.jpg&f=1&nofb=1)"

# ╔═╡ 5a65f7c8-4e80-11eb-1235-4d2992b69efa
md"""
### Case study: Pokémon types

![](https://www.boxmash.com/wp-content/uploads/2014/03/POKEMON-ARTICLE-TYPES-EFFECTIVE.jpg)

I think this might be removed?
"""

# ╔═╡ f092f656-5b05-11eb-392d-f7118e9bbca3
# type-based dispatchtype

# ╔═╡ Cell order:
# ╠═4ec271b0-4e73-11eb-2660-6b8bd637d7ee
# ╠═a1f2d06e-4e73-11eb-3afd-1353def71700
# ╠═c0bfdf9e-4e73-11eb-3962-0b3c5d5424d7
# ╠═b844d568-4e73-11eb-3de9-4158b0bdca12
# ╠═c662744a-4e73-11eb-1bfc-6daaf7282285
# ╠═cae803e2-4e73-11eb-13e0-23abccf86bac
# ╠═cc606026-4e73-11eb-3576-5d301a771a5a
# ╠═d3803112-4e73-11eb-2018-f72ffb7f6ec6
# ╠═e8fe2832-4e78-11eb-3fd6-a3f1f0c0892a
# ╠═f533012c-4e78-11eb-0f45-3b47f088c9c6
# ╠═f69d89ba-4e73-11eb-3ab9-9179ea7e3217
# ╠═de3de7fc-4e73-11eb-2ff6-1560481f7ee5
# ╠═e1c8cf4a-4e73-11eb-27be-d702064a0182
# ╠═e56a46c6-4e73-11eb-1748-1b6fe5ab0376
# ╠═e89adcaa-4e73-11eb-1ed8-e9c89ca633f6
# ╠═ec2ab2be-4e73-11eb-1a22-010439761432
# ╠═efa205b4-4e73-11eb-1647-e9dcab5f7b7a
# ╠═f3b5a778-4e73-11eb-1d3c-11ae19713eca
# ╠═a0cecb24-4e74-11eb-3634-cd8dd628e9ec
# ╠═b31fe65a-4e74-11eb-0414-35f2be687c7f
# ╠═c2ac0c48-4e74-11eb-10b0-91ad620fefcd
# ╠═c5208cce-4e74-11eb-0615-135b510a9e8d
# ╠═c817296a-4e74-11eb-0994-972871114f02
# ╠═cb066442-4e74-11eb-35e7-ed38d4bd8bbf
# ╠═ce3d5380-4e74-11eb-3d9d-5f34cbbae118
# ╠═34ca6158-4e75-11eb-3d51-330952c9b3dd
# ╠═8fae9e4a-4e75-11eb-0346-377e9f09ecce
# ╠═dc511e7e-4e75-11eb-1fcc-c5c98e8613a1
# ╠═4a01487c-4e78-11eb-1302-d9c6ec4ed6ab
# ╠═66292626-4e78-11eb-331b-0563b2110605
# ╠═704b2ebe-4e78-11eb-1583-d10e0aeb2b8d
# ╠═c3c40df2-4e78-11eb-3d4a-5fdfdf173da3
# ╠═cd32e96c-4e78-11eb-0b48-5767421c7875
# ╠═dc1c8294-4e78-11eb-1400-afa8e5ac8939
# ╠═40a761c2-5b24-11eb-09a8-a5cd0bc4ab95
# ╠═99228eee-5b24-11eb-385e-7507ca20ae0e
# ╠═ba39991a-5b24-11eb-260b-439bcde4c153
# ╠═35e53434-5b25-11eb-10b7-e993e9477c8c
# ╠═71111ea6-5b25-11eb-2553-4d15ff3271d6
# ╠═92dc7a4e-5b25-11eb-1518-8182216f24ec
# ╠═aa26b46c-4e78-11eb-24d8-7fdce7c94fff
# ╠═815b0436-4e78-11eb-13d4-0dc6531e34f2
# ╠═570c85bc-4e79-11eb-0249-891cf205d623
# ╠═9193f988-4e79-11eb-05bc-058e9edb8e35
# ╠═6756d6ac-4e79-11eb-21ab-4776195c9d3b
# ╠═e6f31ad8-4e79-11eb-11f4-2936cb039f8d
# ╠═03766a5c-4e75-11eb-12ad-cb2e9468e0d2
# ╠═2dff8c88-4e75-11eb-050b-7152e82ac10d
# ╠═7c2b6dc0-4e76-11eb-1d78-553df82d9100
# ╠═d2a4a32c-5b02-11eb-3839-8108c4965931
# ╠═32d64b6e-4e75-11eb-0a2a-27214f217f70
# ╠═861ba4c6-4e76-11eb-3d2b-bfabbd143df2
# ╠═8d5f7d8e-4e76-11eb-28ba-bdec03a3e150
# ╠═99af0924-4e76-11eb-0331-87685125bcd9
# ╠═b18d0532-4e76-11eb-2e8a-2bee580533cc
# ╠═cd2eaafc-4e76-11eb-245a-e9898d3d57a4
# ╠═db1bb4c8-4e76-11eb-2756-3f6ce778acc0
# ╠═ff755bf8-4e76-11eb-205f-d52529ae50ed
# ╠═03932e5e-4e77-11eb-3769-635cc33c3c4d
# ╠═0b4f99ea-4e77-11eb-29fc-632788d179a3
# ╠═2a0b220a-4e77-11eb-1da7-2978422c11f4
# ╠═bf91e40a-4e77-11eb-14f1-754b1ce5130e
# ╠═e1a88a70-4e76-11eb-2486-e1d2f4211792
# ╠═76fe9fc4-4e77-11eb-3bc7-2dfbdff8dfc8
# ╠═7aa14c94-4e77-11eb-25c7-fb0103267b06
# ╠═7f3a5336-4e77-11eb-2ad6-3d889dc75ac0
# ╠═822c01d4-4e77-11eb-1409-fbaf83c950b6
# ╠═85f186a6-4e77-11eb-19ca-5db29615ba97
# ╠═891c820e-4e77-11eb-1ebf-b3065e0d4211
# ╠═8d0d39c4-4e77-11eb-034d-07dc33ab6e9a
# ╠═901efaee-4e77-11eb-02d9-b5fe1f0931d5
# ╠═938d8b1e-4e77-11eb-03d3-9b88c7cab3c1
# ╠═96f6fef2-4e77-11eb-2ec4-399472d86a60
# ╠═812cfe48-4e7a-11eb-32e6-c918bbe3e602
# ╠═4df6c0c0-4e7c-11eb-1d43-0d9bbf4896a7
# ╠═b487a776-4e7e-11eb-291b-e900e6e1a2f6
# ╠═1aea83a8-4e7f-11eb-2d06-c3e550c4e1b9
# ╠═6e429164-4e7f-11eb-1829-0582f1417815
# ╠═ad6e9d8e-4e7f-11eb-1e33-efcee699f2a0
# ╠═9d1c94ba-4e7f-11eb-060e-d1bc9683af92
# ╠═ee370b50-4e7f-11eb-1ce0-d1bdb3e41ae2
# ╠═1117c600-4e80-11eb-3231-4383d700f760
# ╠═07a19574-4e80-11eb-38fa-8d3463dfd700
# ╠═84a0f49c-4e7c-11eb-14f2-452e57f2e414
# ╠═99c4f3c8-4e7c-11eb-3d4a-33ba8d495eb2
# ╠═cba6d4cc-5b03-11eb-265d-3f08117b0e8d
# ╠═d913cd92-4e7c-11eb-11e1-3d7539af7fed
# ╠═4f107d88-4e7d-11eb-3e49-f54ecf5163da
# ╠═8331c8b0-4e7d-11eb-0690-8bbae3ed086a
# ╠═88a95ec0-4e7d-11eb-0a33-77ef82874f45
# ╠═925e2f40-4e7d-11eb-0bd2-f91913c5a23e
# ╠═5117a6b8-5b04-11eb-2910-dd7412ef69de
# ╠═5a65f7c8-4e80-11eb-1235-4d2992b69efa
# ╠═f092f656-5b05-11eb-392d-f7118e9bbca3
