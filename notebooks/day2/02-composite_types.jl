### A Pluto.jl notebook ###
# v0.20.13

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 8062c45e-1df3-44bc-981d-cc990fbe6bcb
using PlutoUI; TableOfContents()

# ╔═╡ 372d3cf2-6173-11eb-356e-23c959c3fd89
# edit the code below to set your name and UGent username

student = (name = "Sam Janssen", email = "Sam.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ acd7de0c-5d8c-11eb-120a-8b79f2b8eb3b
abstract type Agent end

# ╔═╡ b96a33b8-5d8c-11eb-01de-439f53cdc355
mutable struct Prey <: Agent
	id::Int
	pos::NTuple{2, Float64}
end

# ╔═╡ cd0d8636-5d8c-11eb-19f9-4da4550d306f
deer = Prey(1, (0.5, 1.9))

# ╔═╡ d672cc72-5d8c-11eb-2c06-0341181e3a3d
fieldnames(Prey)

# ╔═╡ 61c43794-6174-11eb-1545-2db114b929e4
deer.pos

# ╔═╡ 01fe6f9a-5d8d-11eb-0519-03aefcd587bb
mutable struct Predator <: Agent
    id::Int
    pos::NTuple{2, Float64}
    size::Float64
end

# ╔═╡ 05ae1a2a-5d8d-11eb-0ed8-496f48194232
wolf = Predator(2, (0.0, 0.0), 40.0)  # 40 kg wolf

# ╔═╡ 1df0419c-5d8d-11eb-3444-d5741bf10d32
id(agent::Agent) = agent.id

# ╔═╡ 234dd2e4-5d8d-11eb-366c-c15474da799f
position(agent::Agent) = agent.pos

# ╔═╡ 375bf8d8-5d8d-11eb-1a49-69905d38effe
Base.size(agent::Predator) = agent.size

# ╔═╡ 50f17586-5d8d-11eb-0eec-579467b787d0
begin
	interact(agent1::Agent, agent2::Agent) = nothing
	interact(agent1::Predator, agent2::Prey) = "eat"
	interact(agent1::Prey, agent2::Predator) = "run"
end

# ╔═╡ 5c141870-654b-11eb-26f3-4b58b0b2e25d
mutable struct Neutral <: Agent end

# ╔═╡ 4d2d4e6c-654b-11eb-02c5-698af6d43b37
fly = Neutral()

# ╔═╡ 6f69292e-654b-11eb-012e-317c7b2f33ea
wolf

# ╔═╡ 78f6ea1c-654b-11eb-217e-6da9345f2fe3
deer

# ╔═╡ 7ea3de2a-654b-11eb-18c2-0fa369696cb9
fauna = [fly, wolf, deer]

# ╔═╡ 3422d2fc-654b-11eb-37c8-93a84229ab21
rand(fauna)

# ╔═╡ 340538c8-654b-11eb-3733-272fb9a8f106
#... interact

# ╔═╡ b1525c16-654b-11eb-0428-43008354b402


# ╔═╡ cf6dea8c-5d8d-11eb-3f54-4d947305f5e5
begin
	struct Point{T}
		x::T
		y::T
	end
	
# PASTE YOUR CONSTRUCTORS HERE!
end

# ╔═╡ d84355d4-5d8d-11eb-2c2c-21daf0364c21
p = Point(1.0, 2.0)

# ╔═╡ db651312-5d8d-11eb-09f1-bb693144d8f7
p_int = Point(1, 2)

# ╔═╡ 8b7688ce-5d8e-11eb-0100-dd2712247ff6
p_string = Point("hello", "goodbye")  # might not make sense but currently allowed!

# ╔═╡ 9c0f7916-5d8e-11eb-15cd-11badf9f9c01
Point([1 2; 3 4], [2 3; 9 4])  # maybe relevant to quantum physics?

# ╔═╡ e799c73e-5d8d-11eb-3df4-13dbef13a342
p isa Point

# ╔═╡ eb563ede-5d8d-11eb-1e91-55bd3b36f4eb
p isa Point{Float64}  # more specific

# ╔═╡ fc2d5c92-5d8d-11eb-08c3-29d0478f1884
p isa Point{Int}  # obviously not true

# ╔═╡ 072f2382-5d8e-11eb-377a-d39d0821559e
p isa Point{Real}  # unexpectedly not true!

# ╔═╡ 393e2f9e-5d8e-11eb-11d7-511c32ce6e48
Point(1, 2.0)  # should error initially, but will be fixed later in the notebook!

# ╔═╡ e246757e-5d8e-11eb-313c-61a63246cf9a
Point(1, 2.0)

# ╔═╡ ecc14f96-5d8f-11eb-2b18-cb23fad26b6e
Point(1.2)

# ╔═╡ a4a1cb18-5d90-11eb-08ee-8570368a056b
struct Squares
    count::Int
end

# ╔═╡ da6cc5b8-5d90-11eb-07ff-db8bdb504054
for i in Squares(7)
    println(i)
end

# ╔═╡ e3759d4c-5d90-11eb-0bea-bb4247623ec2
25 ∈ Squares(10)

# ╔═╡ 07998440-5d91-11eb-1a65-8de428eac89c
sum(Squares(18093))

# ╔═╡ 59fe435a-6bfb-4b3c-9f56-3aeb258aacfc
sum()

# ╔═╡ e11b0b10-6621-11eb-0bdb-f3719cc92a20
@elapsed sum(Squares(18093))

# ╔═╡ 192d9fd4-5d91-11eb-1cb9-c706aad03480
#Base.eltype(::Type{Squares}) = Int

# ╔═╡ 1fa68c72-5d91-11eb-1102-c18460e92ee6
#Base.length(S::Squares) = S.count

# ╔═╡ 2270e790-5d91-11eb-20e5-29905f232734
collect(Squares(4))

# ╔═╡ 49f1d98c-5d91-11eb-1657-f320e9fcdc0e
#Base.sum(S::Squares) = (n = S.count; return n*(n+1)*(2n+1)÷6)

# ╔═╡ 4cb68744-5d91-11eb-2b3e-e7df55888c93
sum(Squares(18093))  # much faster now!


# ╔═╡ e99af5c0-6621-11eb-058b-45c3719930d0
@elapsed sum(Squares(18093))

# ╔═╡ e9a99a00-5d91-11eb-2c50-8be452cab83f
struct Strang <: AbstractMatrix{Int}
    n::Int
end

# ╔═╡ ec62c35c-5d91-11eb-3773-b9385f312f7f
Base.size(S::Strang) = (S.n, S.n)

# ╔═╡ efb0b460-5d91-11eb-2534-496df689dc60
Base.getindex(S::Strang, i, j) = i==j ? 2 : (abs(i - j) == 1 ?  -1 : 0)

# ╔═╡ f3c3114c-5d91-11eb-1d37-6d97ea6d267f
S = Strang(1000)  # holy cow! Looks just like a real matrix!

# ╔═╡ 04dcda58-5d92-11eb-10ba-396947081338
sum(S)  # works, but slow...

# ╔═╡ fbdb2958-6621-11eb-3cb6-a9bdeea3bdb7
@elapsed sum(S)

# ╔═╡ 0f878dea-5d92-11eb-0000-b7484532ee70
#Base.sum(S::Strang) = 2

# ╔═╡ 11630c02-5d92-11eb-1746-4dabf327fbbe
sum(S)

# ╔═╡ 046ce4f8-6622-11eb-3c4f-7b6bf21fb77b
@elapsed sum(S)

# ╔═╡ 1e65cb9c-5d92-11eb-3526-332169917fd9
v = randn(1000)

# ╔═╡ 3ae60e88-5d94-11eb-0c50-1d74ea104758
struct WizCur
	missing # complete me!
end

# ╔═╡ 48301af2-5d94-11eb-0019-7737667c9cea
galleons(money::WizCur) = missing # complete me!

# ╔═╡ 4ea80eda-5d94-11eb-3882-21a41d2d65f8
sickles(money::WizCur) = missing # complete me!

# ╔═╡ 5af60d90-5d94-11eb-2ee4-b7bfc2caf53b
knuts(money::WizCur) = missing # complete me!

# ╔═╡ 5f7c75ac-5d94-11eb-137a-7914cd009821
#=
function Base.show(io::IO, money::WizCur)
    print(io, "I am printed for WIZCUR, make me say something meaningful")
end
=#

# ╔═╡ 678ca64a-5d94-11eb-2b85-0b706526e35b
Base.isless(m1::WizCur, m2::WizCur) = missing # complete me!

# ╔═╡ 27fcaede-5d90-11eb-1cea-91fcc4b6b0fe
struct OrderedPair
  x
  y
  function OrderedPair(x, y)
    if x < y
      new(x, y)
    else
      new(y, x)
    end
  end
end

# ╔═╡ 2a224fde-5d90-11eb-1c46-3fd248350914
OrderedPair(18, 23)

# ╔═╡ 2c937298-5d90-11eb-06e6-ab70b9d3701e
OrderedPair(8, 2)

# ╔═╡ 8afbd434-5d94-11eb-366b-d3d719189ef7
Base.isgreater(m1::WizCur, m2::WizCur) = missing # complete me!

# ╔═╡ 9226b2d8-5d94-11eb-2bea-491eb7dc1da7
Base.isequal(m1::WizCur, m2::WizCur) = missing # complete me!

# ╔═╡ 95146d46-5d94-11eb-22aa-c1a544e0d784
Base.:+(m1::WizCur, m2::WizCur) = missing # complete me!

# ╔═╡ 605779e6-5d8e-11eb-3e08-c7420ef76aba
norm(p::Point{T} where {T<:Number}) = sqrt(p.x^2 + p.y^2)

# ╔═╡ 6646eb5c-5d8e-11eb-1e01-f3011c4230de
norm(p)

# ╔═╡ 6960f8d2-5d8e-11eb-0215-2de7b54e3081
norm(p_int)  # dispatch creates a method for this type

# ╔═╡ 9eab40be-5d94-11eb-0c59-21f5824fb812
money_ron = missing # complete me!

# ╔═╡ a137e0f8-5d94-11eb-2209-73acad549307
money_harry = missing # complete me!

# ╔═╡ a79ba114-5d94-11eb-16ae-9906c6cdf54f
dungbomb_fund = money_ron + money_harry

# ╔═╡ d448a2e0-5d92-11eb-18a6-9ff817992154
begin
	struct Vandermonde{T,VT} <: AbstractMatrix{T}
		α::VT
		m::Int
		Vandermonde(α::AbstractVector{T}, m) where {T} = missing
	end

	# take length of α as a default value of m
	Vandermonde(α::Vector{<:Number}) = missing
end

# ╔═╡ bd91a60e-5d93-11eb-09d4-830ca69439bf
Base.size(V::Vandermonde) = missing

# ╔═╡ 39d6d5c4-5d8d-11eb-0e07-11d891ff87a3
size(wolf)

# ╔═╡ 276e9af4-5d92-11eb-1399-993570859698
function Base.:*(S::Strang, v::Vector)
    n = length(v)
    @assert size(S, 2) == n
    x = similar(v)
    for i in 1:n
        x[i] = v[i]
        i > 1 && (x[i] += v[i-1])
        i < n && (x[i] += v[i+1])
    end
    return x
end

# ╔═╡ a9502b64-5d90-11eb-144c-3d7ce0949e67
Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)

# ╔═╡ 201f59ee-5d92-11eb-33ae-51904d249dd4
S * v  # works, but slow

# ╔═╡ 300a8428-5d92-11eb-188b-05d00df4f6a7
S * v  # fast (linear time in v)

# ╔═╡ c2ecfec8-5d93-11eb-2640-07bc07f3da98
Base.getindex(V::Vandermonde, i, j) = missing

# ╔═╡ e6ce946e-cbbc-40f6-8227-c219fd22bcb3
md"""
Submission by: **_$(student.name)_**
"""

# ╔═╡ eb0428ac-5d8c-11eb-09a3-2b3cfc77f3f4
begin
	
	md"""
	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ 70be3952-5d8c-11eb-1509-b3f7077d57e0
md"""
# Composite and parametric types

The previous notebook showed that it is easy to extend the type system with our own types in the hierarchy. The interesting thing is to have the concrete 'leafs' on this tree contain data that can be used in the functions.

## Composite types

Composite types, sometimes call records, structs (matlab) or objects (python), can store several values in their *fields*.

When defining a new composite type, we can choose them to be mutable or immutable:
- mutable types are defined using `mutable struct ... end`, they allow the fields to be changed after the object is created;
- immutable types are defined similarly using `struct ... end`, after creating the object its fields cannot be changed (immutable by default).
Mutable types are a bit more flexible, though might be less safe and are more difficult to work with. As the compiler
knows everything in advance, it often optimizes better for immutable types. The choice depends on the application, though
generally immutable types are the better choice!

As an example, let us define an agent type for an ecological individual-based model (IBM). We create the abstract type `Agent` for which we
can then specify several children types.
"""

# ╔═╡ af8c6460-5d8c-11eb-3ba8-c16e8855e992
md"The concrete types in such an IBM might represent an animal type you want to model, for example, preys and predators. In making a concrete type of prey animal, we want each to have a unique identifier (represented by an integer) and a position. As we expect the agent to move, hence changing
its position when our simulation runs, we choose a mutable type."

# ╔═╡ bcacf89e-5d8c-11eb-0077-e5761b8855a3
md"Notice the type annotation for `id`, which we choose to always represent by an integer."

# ╔═╡ c7a077ba-5d8c-11eb-08bb-07c343ea8ab1
md"After defining a composite type, a constructor for that type is immediately available. A constructor is a function to instantiate a type."

# ╔═╡ ce25e25c-5d8c-11eb-2e8e-b5b1e7350d70
md"You can always check which field names are available."

# ╔═╡ dac11770-5d8c-11eb-1058-2d043e172931
md"The fields can be accessed easily:"

# ╔═╡ e7b9023a-5d8c-11eb-1387-cfa7c41ab6ca
md"This is just syntactic sugar for `getfield`, e.g. `getfield(deer, :id)`"

# ╔═╡ fb6e62d4-5d8c-11eb-34f3-bf3df7cd4cb3
md"Similarly, a predator type can be defined. In addition to an `id` and `position`, which each agent has, they also have a size, determining its mobility."

# ╔═╡ 18d04a36-5d8d-11eb-1986-693eaad5d5be
md"Using the `.` syntax for accessing the fields is very \"object-oriented\" and not  very juliaesque! We should define custom getter functions
for the user to access the relevant fields. We could define `id` and `position` methods to get the respective
fields for the two agents. However, since these fields should be defined for every `Agent` type, we can just create
these for the Agent type!"

# ╔═╡ 23f7e8c4-5d8d-11eb-04af-b5e268c13a14
md"Here, we could theoretically have omited the type annotation in the function. Then the function would accept objects of the non-agent type and likely yield an error because they don't have the `id` or `pos` field. Now, these functions will return a `MethodError` when given a non-`Agent` input."

# ╔═╡ 330d2090-5d8d-11eb-1003-a52a078514b2
md"A slightly more interesting example is by extending `size`."

# ╔═╡ 3f5740f6-5d8d-11eb-19c3-ddedf6003e53
md"Here, we had to import `size` because we are extending a function from the `Base` library to work with a new type (doing something vastly different than its original function)."

# ╔═╡ 47049bf0-5d8d-11eb-18c2-733287b69420
md"Similarly, we can program the interaction behaviour between the agents."

# ╔═╡ 585995ae-5d8d-11eb-256f-bd8e9eb52063
md"We have chosen the default behaviour that two Agents of unspecified types do not interact at all, this will now be the case when a prey meets other prey, a predator another predator or a new third type comes into the equation."

# ╔═╡ 62e49c94-5d8d-11eb-39ac-f30febf282ff
md"Since in these simple examples, the `interact` methods do not use their arguments, merely perform type checking, we could have written this as `interact(::Agent,::Agent) = ...` etc."

# ╔═╡ e5c61ace-654a-11eb-05be-79153b6222b6
md"**Assignment: the wildlife**


Test a few random wildlife encounters.
"

# ╔═╡ 6e8548b4-5d8d-11eb-3fcc-45cb005e5c5e
md"""
## Parametric types

Sometimes we want more flexibilility in defining types. Think of designing a new type of matrix. Here you would like to work them for all
numeric datatypes, `Int`, `Int8`, `Float64`, `Rational`, in addition to new datatypes that might not even be defined yet! To this end, we use
*parametric types*, types that **depend** on another type.

For example, consider a 2-dimensional coordinate:
(x,y)
"""

# ╔═╡ d305007e-5d8d-11eb-2505-3347d7d1a561
md"Here, each coordinate of the type `Point` has two attributes, `x` and `y`, of the same type. The specific type of `Point` can vary."

# ╔═╡ dd5706ec-5d8d-11eb-29df-75170b547cf8
md"Note that"

# ╔═╡ 17022b06-5d8e-11eb-391b-7194962a2c18
md"The observations above are very important! Even though `Float16 <: Real`, this does not hold for the corresponding parametric types."

# ╔═╡ 4b262a72-5d8e-11eb-02bb-5fb2bd07f280
md"Parametric types can be used in dispatch. For example, if we want to compute the norm of a Point, this would only make sense if Point is a number."

# ╔═╡ 8321136a-5d8e-11eb-0da2-e750b81d7ce9
md"""
## Constructors

Constructors are functions that create new objects.

### Outer constructors

We have already seen that when creating a new `struct`, this immediately initiates the constructor (e.g., `Point(1.0, 2.0)`). These can also be made explicitly:

```julia
Point(x::T, y::T) where {T<:Real} = Point{T}(x,y)
```

In a normal file, we could run this, but Pluto does not allow us to have constructors at different places. Copy-paste it to the cell where we defined the `Point` type.

"""

# ╔═╡ 9d4b9eee-5d8f-11eb-07bb-557415e4ac4a
md"""

The line above yields an error, because there is no constructor method when two inputs are of a different type. The following constructors will resolve such cases satisfactorily.

```julia
Point(x::Real, y::Real) = Point(promote(x, y)...)
```

Add it to the definition and see the change!

We can write other constructors just like functions. For example, we can define a function that tells Julia that when we provide a single `x`, we want to create a point (x, y): where x == y .

```julia
Point(x) = Point(x, x)
```
"""

# ╔═╡ 142666de-5d90-11eb-3231-efe53ddc9b0d
md"""

### Inner constructors

The above examples show *outer constructors*. These are defined outside the structure. We can also use *inner constructors*, which are declared within the definition of the type. These make use of the keyword `new`. For example, let us define an ordered pair.
"""

# ╔═╡ 2efe030e-5d90-11eb-38ae-092222d3a8d4
md"For parametric types, the `new` keyword should be type annotated. So, for in the `Point` example one would use `new{T}(x,y)`."

# ╔═╡ 46df4eb0-5d90-11eb-1fdf-f34a7bcb7191
md"""

## Example: iterators

We can extend Julia by making use of established interfaces, such as for iterators like `1:0.1:10`. For example, suppose we want to iterate over the first $n$ squares of natural numbers.
"""

# ╔═╡ aca1c930-5d90-11eb-29d9-954e097bbe3b
md"To make this an iterator, we just have to extend the `iterate` function of `Base`. This is what is needed for Julia to treat this as an iterator because all functions fall back to this."

# ╔═╡ 984ae6c9-335f-4ed7-a320-12eb67f4060b
md"👇 It is normal that some of the following cells throw an error, that is because the automatic determination of execution order seems to be wrong here. Just rerun with `<shift>` + `<enter>`"

# ╔═╡ 0b8980aa-5d91-11eb-385b-71568ec0e325
md"Let's give the compiler some additional information!"

# ╔═╡ 26a70358-5d91-11eb-0241-699b5dc4783f
md"Now this works:"

# ╔═╡ 2cbe2370-5d91-11eb-130a-5da52d1a62c8
md"I remember there is a fancy formula to compute the sum of squared natural numbers. Uncomment it to activate!"

# ╔═╡ 579e3828-5d91-11eb-1d33-b94628d61fc0
md"""

## Example: custom matrices

Similarly, we can make our very own matrix types. Consider the Strang matrix, a [tridiagonal matrix](https://en.wikipedia.org/wiki/Tridiagonal_matrix) with 2 on the main diagonal, and -1 on the first diagonal below and above the main diagonal. 
"""

# ╔═╡ 066901bc-6622-11eb-23ad-ed869adad36d
md"Uncomment the line below."

# ╔═╡ 310d8966-6176-11eb-1b23-9d942f197fbd
md"Luckily there is a trick to computing the product of a tridiagonal matrix and a vector:"

# ╔═╡ 711a5574-a7c5-43c6-a8a2-4830361f0071
md"As you can see in the above function, next to using `a ? b : c` for condensing control flow there is also another option. When we use `a && b`, b will only be evaluated and returned when a is `true`. So you can put any expression you like after the `&&`!"

# ╔═╡ cf146bf4-6177-11eb-1eaa-c35efde57b3e
md"## Exercises"

# ╔═╡ c98b4ded-9ca0-46b2-ba00-adf8566e41c3
md"""
> **Exercise: wizarding currency**
			
The British Wizarding World uses Galleons, Sickles, and Knuts as currency. There are 17 Sickles in a Galleon, and 29 Knuts in a Sickle, meaning there are 493 Knuts in a Galleon. We will make a structure `WizCur` to represent wizarding currency. This structure has three integer-valued fields: `galleons`, `sickles`, and `knuts`. The constructor should always create tidy representations, meaning that, for example, if the number of knuts is 29 or more, it just adds an appropriate number of sickles such that the number knuts is less than 29 (it's magical money). The same applies to the sickles, which can also never exceed 17.

Overload `Base.show` such that Julia prints your currency as, for example, `7G, 2S, 9K`.

Also, overload the function `+` to add two instances of `WizCur` and the `>` and `<` operators to compare two instances of wizarding currency.

The piggy bank with Ron's life savings contains 19 Sickles and 732 Knuts. Harry has 3 Galleons, 1 Sickle, and 7 Knuts pocket change. Who has the most money? How many do they have together?
"""

# ╔═╡ 6c3ffe46-6112-4a3d-b882-9eb5e0a4bbbf
md"If `isless` is defined, there is no need to define `isgreater` (Think about why this is the case!). Feel free to add this function as an exercise."

# ╔═╡ 392228e2-617d-11eb-09a5-c9e5649356eb
md"""
> **Exercise: Vandermonde matrix**

The [Vandermonde matrix](https://en.wikipedia.org/wiki/Vandermonde_matrix) can be obtained from a vector by taking the powers from 0 till $m-1$.

$${\displaystyle V={\begin{bmatrix}1&\alpha _{1}&\alpha _{1}^{2}&\dots &\alpha _{1}^{n-1}\\1&\alpha _{2}&\alpha _{2}^{2}&\dots &\alpha _{2}^{n-1}\\1&\alpha _{3}&\alpha _{3}^{2}&\dots &\alpha _{3}^{n-1}\\\vdots &\vdots &\vdots &\ddots &\vdots \\1&\alpha _{m}&\alpha _{m}^{2}&\dots &\alpha _{m}^{n-1}\end{bmatrix}},}$$

$$V_{i,j} = \alpha_i^{j-1}$$

Complete the implementation to store and process this matrix.
		"""

# ╔═╡ cb3e91cc-5d93-11eb-020c-d73c10131755
α = [1, 2, 3, 4]

# ╔═╡ d107c75e-5d93-11eb-0e6f-097b1291e460
V = Vandermonde(α, 4)

# ╔═╡ 7f02b0a0-617f-11eb-1263-91423840def3


# ╔═╡ a9ad5b1d-1935-427b-b7f0-dc638b0e861b
md"""
> **Exercise: determinant of a Vandermonde matrix**

The determinant of a Vandermonde matrix is easy to compute:

$${\displaystyle \det(V)=\prod _{1\leq i<j\leq n}(\alpha_{j}-\alpha_{i}).}$$

Overload this for the Vandermonde matrix!

Hint: `prod`
"""

# ╔═╡ d2a076ea-5d93-11eb-216e-f5c37d330b40
import LinearAlgebra

# ╔═╡ dc945902-5d93-11eb-1121-a7ae99c5862e
LinearAlgebra.det(V::Vandermonde) = missing

# ╔═╡ 0267b920-9a1f-472f-9d21-5609fb877325
md"""## Answers:
If you would like to take a look at the answers, you can do so by checking the box of the question you would like to see. The function will be shown just below the question you want to look at.

| Question | Show solution |
|-----|:---------:|
| Question WizCur | $(@bind answ_q1 CheckBox()) |
| Question Vandermonde | $(@bind answ_q2 CheckBox()) |
| Question Vandermonde determinant | $(@bind answ_q3 CheckBox()) |

"""

# ╔═╡ fcf5c7e6-b745-44af-b731-cd3d44f848b9
if answ_q1 == true
	md"""
	```Julia
	struct WizCur
	  galleons::Int
	  sickles::Int
	  knuts::Int
	  function WizCur(galleons::Int, sickles::Int, knuts::Int)
		  sickles += knuts ÷ 29
		  knuts %= 29
		  galleons += sickles ÷ 17
		  sickles %= 17
		  return new(galleons, sickles, knuts)
	  end
	end

	galleons(money::WizCur) = money.galleons
	sickles(money::WizCur) = money.sickles
	knuts(money::WizCur) = money.knuts

	moneyinknuts(money::WizCur) = 29*17galleons(money) + 29sickles(money) + knuts(money)

	function Base.show(io::IO, money::WizCur)
	  print(io, "$(galleons(money))G, $(sickles(money))S, $(knuts(money))K")
	end

	Base.isless(m1::WizCur, m2::WizCur) = moneyinknuts(m1) < moneyinknuts(m2) 
	Base.isgreater(m1::WizCur, m2::WizCur) = moneyinknuts(m1) > moneyinknuts(m2) 
	Base.isequal(m1::WizCur, m2::WizCur) = moneyinknuts(m1) == moneyinknuts(m2)

	Base.:+(m1::WizCur, m2::WizCur) = WizCur(galleons(m1)+galleons(m2),
											  sickles(m1)+sickles(m2),
											  knuts(m1)+knuts(m2))

	money_ron = WizCur(0, 19, 732)
	money_harry = WizCur(3, 1, 7)

	dungbomb_fund = money_ron + money_harry
	```
	"""
end

# ╔═╡ f4fc59ac-e0e2-483a-9e07-6664090cb299
if answ_q2 == true
	md"""
	```Julia
	struct Vandermonde{T,VT} <: AbstractMatrix{T}
	  α::VT
	  m::Int
	  Vandermonde(α::AbstractVector{T}, m) where {T} = new{T,typeof(α)}(α,m)
	end

	Vandermonde(α::Vector{<:Number}) = Vandermonde(α, length(α))

	Base.size(V::Vandermonde) = (length(V.α), V.m)
	Base.getindex(V::Vandermonde, i, j) = V.α[i]^(j-1)
	```
	"""
end

# ╔═╡ 1c373bba-eeb6-4673-8b18-0d68b524e536
if answ_q3 == true
	md"""
	```julia
	determinant(V::Vandermonde) = 
	((xi-xj) for (i,xi) in enumerate(V.α), (j, xj) in enumerate(V.α) if i < j) |> prod
	```
	"""
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "e358466155272fd49d35add62d34b7cfbd35c574"

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
# ╟─e6ce946e-cbbc-40f6-8227-c219fd22bcb3
# ╠═8062c45e-1df3-44bc-981d-cc990fbe6bcb
# ╠═372d3cf2-6173-11eb-356e-23c959c3fd89
# ╟─eb0428ac-5d8c-11eb-09a3-2b3cfc77f3f4
# ╟─70be3952-5d8c-11eb-1509-b3f7077d57e0
# ╠═acd7de0c-5d8c-11eb-120a-8b79f2b8eb3b
# ╟─af8c6460-5d8c-11eb-3ba8-c16e8855e992
# ╠═b96a33b8-5d8c-11eb-01de-439f53cdc355
# ╟─bcacf89e-5d8c-11eb-0077-e5761b8855a3
# ╟─c7a077ba-5d8c-11eb-08bb-07c343ea8ab1
# ╠═cd0d8636-5d8c-11eb-19f9-4da4550d306f
# ╟─ce25e25c-5d8c-11eb-2e8e-b5b1e7350d70
# ╠═d672cc72-5d8c-11eb-2c06-0341181e3a3d
# ╟─dac11770-5d8c-11eb-1058-2d043e172931
# ╠═61c43794-6174-11eb-1545-2db114b929e4
# ╟─e7b9023a-5d8c-11eb-1387-cfa7c41ab6ca
# ╟─fb6e62d4-5d8c-11eb-34f3-bf3df7cd4cb3
# ╠═01fe6f9a-5d8d-11eb-0519-03aefcd587bb
# ╠═05ae1a2a-5d8d-11eb-0ed8-496f48194232
# ╟─18d04a36-5d8d-11eb-1986-693eaad5d5be
# ╠═1df0419c-5d8d-11eb-3444-d5741bf10d32
# ╠═234dd2e4-5d8d-11eb-366c-c15474da799f
# ╟─23f7e8c4-5d8d-11eb-04af-b5e268c13a14
# ╟─330d2090-5d8d-11eb-1003-a52a078514b2
# ╠═375bf8d8-5d8d-11eb-1a49-69905d38effe
# ╠═39d6d5c4-5d8d-11eb-0e07-11d891ff87a3
# ╟─3f5740f6-5d8d-11eb-19c3-ddedf6003e53
# ╟─47049bf0-5d8d-11eb-18c2-733287b69420
# ╠═50f17586-5d8d-11eb-0eec-579467b787d0
# ╟─585995ae-5d8d-11eb-256f-bd8e9eb52063
# ╟─62e49c94-5d8d-11eb-39ac-f30febf282ff
# ╟─e5c61ace-654a-11eb-05be-79153b6222b6
# ╠═5c141870-654b-11eb-26f3-4b58b0b2e25d
# ╠═4d2d4e6c-654b-11eb-02c5-698af6d43b37
# ╠═6f69292e-654b-11eb-012e-317c7b2f33ea
# ╠═78f6ea1c-654b-11eb-217e-6da9345f2fe3
# ╠═7ea3de2a-654b-11eb-18c2-0fa369696cb9
# ╠═3422d2fc-654b-11eb-37c8-93a84229ab21
# ╠═340538c8-654b-11eb-3733-272fb9a8f106
# ╠═b1525c16-654b-11eb-0428-43008354b402
# ╟─6e8548b4-5d8d-11eb-3fcc-45cb005e5c5e
# ╠═cf6dea8c-5d8d-11eb-3f54-4d947305f5e5
# ╟─d305007e-5d8d-11eb-2505-3347d7d1a561
# ╠═d84355d4-5d8d-11eb-2c2c-21daf0364c21
# ╠═db651312-5d8d-11eb-09f1-bb693144d8f7
# ╠═8b7688ce-5d8e-11eb-0100-dd2712247ff6
# ╠═9c0f7916-5d8e-11eb-15cd-11badf9f9c01
# ╟─dd5706ec-5d8d-11eb-29df-75170b547cf8
# ╠═e799c73e-5d8d-11eb-3df4-13dbef13a342
# ╠═eb563ede-5d8d-11eb-1e91-55bd3b36f4eb
# ╠═fc2d5c92-5d8d-11eb-08c3-29d0478f1884
# ╠═072f2382-5d8e-11eb-377a-d39d0821559e
# ╟─17022b06-5d8e-11eb-391b-7194962a2c18
# ╠═393e2f9e-5d8e-11eb-11d7-511c32ce6e48
# ╟─4b262a72-5d8e-11eb-02bb-5fb2bd07f280
# ╠═605779e6-5d8e-11eb-3e08-c7420ef76aba
# ╠═6646eb5c-5d8e-11eb-1e01-f3011c4230de
# ╠═6960f8d2-5d8e-11eb-0215-2de7b54e3081
# ╟─8321136a-5d8e-11eb-0da2-e750b81d7ce9
# ╠═e246757e-5d8e-11eb-313c-61a63246cf9a
# ╟─9d4b9eee-5d8f-11eb-07bb-557415e4ac4a
# ╠═ecc14f96-5d8f-11eb-2b18-cb23fad26b6e
# ╟─142666de-5d90-11eb-3231-efe53ddc9b0d
# ╠═27fcaede-5d90-11eb-1cea-91fcc4b6b0fe
# ╠═2a224fde-5d90-11eb-1c46-3fd248350914
# ╠═2c937298-5d90-11eb-06e6-ab70b9d3701e
# ╟─2efe030e-5d90-11eb-38ae-092222d3a8d4
# ╟─46df4eb0-5d90-11eb-1fdf-f34a7bcb7191
# ╠═a4a1cb18-5d90-11eb-08ee-8570368a056b
# ╟─aca1c930-5d90-11eb-29d9-954e097bbe3b
# ╠═a9502b64-5d90-11eb-144c-3d7ce0949e67
# ╟─984ae6c9-335f-4ed7-a320-12eb67f4060b
# ╠═da6cc5b8-5d90-11eb-07ff-db8bdb504054
# ╠═e3759d4c-5d90-11eb-0bea-bb4247623ec2
# ╠═07998440-5d91-11eb-1a65-8de428eac89c
# ╠═59fe435a-6bfb-4b3c-9f56-3aeb258aacfc
# ╠═e11b0b10-6621-11eb-0bdb-f3719cc92a20
# ╟─0b8980aa-5d91-11eb-385b-71568ec0e325
# ╠═192d9fd4-5d91-11eb-1cb9-c706aad03480
# ╠═1fa68c72-5d91-11eb-1102-c18460e92ee6
# ╟─26a70358-5d91-11eb-0241-699b5dc4783f
# ╠═2270e790-5d91-11eb-20e5-29905f232734
# ╟─2cbe2370-5d91-11eb-130a-5da52d1a62c8
# ╠═49f1d98c-5d91-11eb-1657-f320e9fcdc0e
# ╠═4cb68744-5d91-11eb-2b3e-e7df55888c93
# ╠═e99af5c0-6621-11eb-058b-45c3719930d0
# ╟─579e3828-5d91-11eb-1d33-b94628d61fc0
# ╠═e9a99a00-5d91-11eb-2c50-8be452cab83f
# ╠═ec62c35c-5d91-11eb-3773-b9385f312f7f
# ╠═efb0b460-5d91-11eb-2534-496df689dc60
# ╠═f3c3114c-5d91-11eb-1d37-6d97ea6d267f
# ╠═04dcda58-5d92-11eb-10ba-396947081338
# ╠═fbdb2958-6621-11eb-3cb6-a9bdeea3bdb7
# ╟─066901bc-6622-11eb-23ad-ed869adad36d
# ╠═0f878dea-5d92-11eb-0000-b7484532ee70
# ╠═11630c02-5d92-11eb-1746-4dabf327fbbe
# ╠═046ce4f8-6622-11eb-3c4f-7b6bf21fb77b
# ╠═1e65cb9c-5d92-11eb-3526-332169917fd9
# ╠═201f59ee-5d92-11eb-33ae-51904d249dd4
# ╟─310d8966-6176-11eb-1b23-9d942f197fbd
# ╠═276e9af4-5d92-11eb-1399-993570859698
# ╠═300a8428-5d92-11eb-188b-05d00df4f6a7
# ╟─711a5574-a7c5-43c6-a8a2-4830361f0071
# ╟─cf146bf4-6177-11eb-1eaa-c35efde57b3e
# ╟─c98b4ded-9ca0-46b2-ba00-adf8566e41c3
# ╠═3ae60e88-5d94-11eb-0c50-1d74ea104758
# ╠═48301af2-5d94-11eb-0019-7737667c9cea
# ╠═4ea80eda-5d94-11eb-3882-21a41d2d65f8
# ╠═5af60d90-5d94-11eb-2ee4-b7bfc2caf53b
# ╠═5f7c75ac-5d94-11eb-137a-7914cd009821
# ╠═678ca64a-5d94-11eb-2b85-0b706526e35b
# ╟─6c3ffe46-6112-4a3d-b882-9eb5e0a4bbbf
# ╠═8afbd434-5d94-11eb-366b-d3d719189ef7
# ╠═9226b2d8-5d94-11eb-2bea-491eb7dc1da7
# ╠═95146d46-5d94-11eb-22aa-c1a544e0d784
# ╠═9eab40be-5d94-11eb-0c59-21f5824fb812
# ╠═a137e0f8-5d94-11eb-2209-73acad549307
# ╠═a79ba114-5d94-11eb-16ae-9906c6cdf54f
# ╟─fcf5c7e6-b745-44af-b731-cd3d44f848b9
# ╟─392228e2-617d-11eb-09a5-c9e5649356eb
# ╠═d448a2e0-5d92-11eb-18a6-9ff817992154
# ╠═bd91a60e-5d93-11eb-09d4-830ca69439bf
# ╠═c2ecfec8-5d93-11eb-2640-07bc07f3da98
# ╠═cb3e91cc-5d93-11eb-020c-d73c10131755
# ╠═d107c75e-5d93-11eb-0e6f-097b1291e460
# ╟─f4fc59ac-e0e2-483a-9e07-6664090cb299
# ╟─7f02b0a0-617f-11eb-1263-91423840def3
# ╟─a9ad5b1d-1935-427b-b7f0-dc638b0e861b
# ╠═d2a076ea-5d93-11eb-216e-f5c37d330b40
# ╠═dc945902-5d93-11eb-1121-a7ae99c5862e
# ╟─1c373bba-eeb6-4673-8b18-0d68b524e536
# ╟─0267b920-9a1f-472f-9d21-5609fb877325
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
