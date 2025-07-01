#=
Created on 20/01/2021 16:45:00
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Illustration of the composite and parametric types:
- composite types
    - mutable/immuatble
- unions
- Parametric types
=#

#=
Composite types, sometimes call records, structs or object, can store several values in its *fields*.

When defining a new composite type, we can choose them to be mutable or immuatble:
- mutable types are defined using `mutable struct ... end`, they allow the fields to be changed after the object is created;
- immuatble types are defined similarly using `mutable struct ... end`, after creating the object its fields cannot be changed.
Mutable types are a bit more flexible, though might be a somewhat less safe and are more difficult to work with. As the compiler
knows everything in advance, it might better optimize for immutable types. Which one you choose depends on your application, though
generally immuatable types are the better choice!

As an example, let us define an agent type for an ecological individual-based model (IBM). We create the abstract type `Agent` for which we
can then specify several children types.
=#

abstract type Agent end

#=
The concrete types in such an IBM might represent an animal type you want to model, for example preys and predators. Making a concrete type of 
a prey animal, we want each to have an unique identifier (represented by an integer) and a position. As we expect the agent to move, hence changing
its position when our simulation runs, we choose a mutable type.
=#

mutable struct Prey <: Agent
    id::Int
    pos::NTuple{2, Float64}
end
# notice the type annotation for `id`, which we choose to always reprsenent by an integer.
# the position might be represented by (x,y) coordinates, or as a location ID, or a position on a grid. We don't know, so we leave it untyped.

# defining a composite type immediately a constructor available.
deer = Prey(1, (0.5, 1.9))

# you can always check which field names are available
fieldnames(Prey)

# the fields can be accessed simply
deer.id, deer.pos

# FYI: This is just syntactic sugar for `getfield`, e.g. `getfield(deer, :id)`

# Similarly, a predator type can be defined. In addition to an id and position, which each agent has, they also have a size, determining its mobility.

mutable struct Predator <: Agent
    id::Int
    pos::NTuple{2, Float64}
    size::Float64
end

wolf = Predator(2, (0.0, 0.0), 40.0)  # 40 kg wolf

#=
Using the `.` syntax for accessing the fields is not very tidy! We should define custom getter functions
for the user to access the relevant fields. We could define `id` and `position` methods to get the respective
fields for the two agents. However, since these fields should be defined for every `Agent` type, we can just create
these for the Agent type!
=#

id(agent::Agent) = agent.id
position(agent::Agent) = agent.pos

# Here, we could theoretically have ommited the type annotation in the function. Then the function would accept
# objects of the non-agent type and likely yield an error because they don't have the `id` or `pos` field. Now,
# these functions will return a `MethodError` when given a non-`Agent` input.

# A slightly more interesting example is by extending `size`.

Base.size(agent::Predator) = agent.size

# Here, we had to import `size` because we are extending a function from the `Base` library to work with a new type (doing something vastly different
# than its original function).

# similarly, we can program behaviour between the agents

interact(agent1::Agent, agent2::Agent) = nothing
interact(agent1::Predator, agent2::Prey) = "eat"
interact(agent1::Prey, agent2::Predator) = "run"

# We have chosen the default behaviour that two Agents of unspecified types do not interact at al,
# this will now be the case when a prey meets other prey, a predator an other predator or a new third type comes into the equation.

# FYI: Since in these simple examples, the `interact` methods do not use their arguments, merely perform type checking, we could have written this as `interact(::Agent,::Agent) = ...` etc.

# PARAMETRIC TYPES

#=
Sometimes we want more flexiblility in defining types. Think of designing a new type of matrix. Here you would like to work them for all
numeric datatypes, Int, Int8, Float6, Rational, in addition to new datatypes that might not even be defined yet! To this end, we use
*parametric types*, types that depend on another type.

For example, consider a 2-dimensional coordinate:
=#

struct Point{T}
    x::T
    y::T
end

# Here, each coordinate of the type `Point` has two attributes, `x` and `y`, of the same type. The specific type of Point can vary.

p = Point(1.0, 2.0)

Point(1, 2)

# note that

p isa Point

# But what will happen if you evaluate `Point(1, 2.0)`?

Point(1, 2.0)

# Parametric types can be used in dispatch. For example, if we want to compute the norm of a Point, this would only make sense if Point is a number.

norm(p::Point{T} where {T<:Number}) = sqrt(p.x^2 + p.y^2)

norm(p)

# Constructors

## Outer constructors

# Constructors are functions that create new objects. We have already seen that when creating a new `struc`, this immediately initiates the constructor (e.g., `Point(1.0, 2.0)`). These can also be made explicitly:

Point(x::T, y::T) where {T<:Real} = Point{T}(x,y)

# Constructors, however, allow us to have custom behavior when initializing types. For example, we have seen that `Point(1, 2.0)` won't work, because the two inputs are of the same type.
# In this case, we can make the rule that one of the inputs has to be promoted to a more general type.


Point(x::Real, y::Real) = Point(promote(x, y)...)


Point(1, 2.0)


# We can write other constructors just like functions. For example, support that when we provide a single `x`, we want to create a point (x, y):

Point(x) = Point(x, x);

Point(1)

## Inner constructors

#The above examples show *outer constructors*. These are defined outside the structure. We can also use *inner constructors*, which are declared within the definition of the type. These make use of the keyword `new`. For example, let us define an ordered pair.

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

OrderedPair(18, 23)

OrderedPair(8, 2)

# FYI: for parametric types, the `new` keyword should be type annotated. So, for in the `Point` example one would use `new{T}(x,y)`.