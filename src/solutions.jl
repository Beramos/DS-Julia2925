#=
Created on Monday 18th of January 2021
Last update: Tuesday 19th of January 2021

@author: Bram De Jaegher
bram.de.jaegher@gmail.com
=#

#=______________________
|                       |
|         Day 1         |
|_______________________|
=#

#= Notebook 1: basics =#
### Clipping
function clip(x)
  if x ≤ 0 && return 0.
  elseif x ≥ 1 && return 1.
  return x
  end
end

### Stirling
stirling(n) = sqrt(2*π*n)*(n/exp(1))^n

### Time is relative
function since_epoch(t)
  now = t
  seconds = now % 60 # 60 seconds in a minute
  now -= seconds
  # to minutes
  now = div(now, 60) 
  minutes = now % 60 # 60 minutes in an hour
  now -= minutes
  # to hours
  now = div(now, 60)
  hours = now % 24 # 24 hours in a day
  now -= hours
  # to days
  now = div(now, 24)
  days = now % 365 # ± 365 days in a year
  return days, hours, minutes, seconds
end

### Fermat
function checkfermat(a::Int, b::Int, c::Int, n::Int)
  if a^n + b^n == c^n
      println("Holy smokes, Fermat was wrong!")
  else
      println("No, that doesn’t work.")
  end
end


### Justify
rightjustify(s) = println(" "^(70-length(s)) * s)

### Grid print
function printgrid()
  dashed = " -"^4*" "
  plusdash = "+"*dashed*"+"*dashed*"+"
  verticals = ("|"*" "^9)^2*"|"
  s = (plusdash * "\n" * (verticals * "\n")^4)^2*plusdash * "\n"
  println(s)
end

# WIP bigprint

#= Notebook 2: collections =# 
### Riemann sum

function riemannsum(f, a, b; n=100)
  dx = (b - a) / n
  return sum(f.(a:dx:b)) * dx
end

### Markdown table
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

### Determinant
# WIP

### Pi Time
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

### Vandermonde
vandermonde(α, n) = [αᵢ^j for αᵢ in α, j in 0:n-1]

#=______________________
|                       |
|         Day 2         |
|_______________________|
=#

#= Notebook 1: types =#
### String parsing
bunchofnumbers_parser(bunchofnumbers) = parse.(Float64, split(rstrip(bunchofnumbers), ", ")) |> sum


#= Notebook 2: composite types =#
### Wizarding currency
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

moneyinknuts(money::WizCur) = 29*17galleons(money) + 17sickles(money) + knuts(money)

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


### Vandermonde
struct Vandermonde{T,VT} <: AbstractMatrix{T}
  α::VT
  m::Int
  Vandermonde(α::AbstractVector{T}, m) where {T} = new{T,typeof(α)}(α,m)
end

Vandermonde(α::Vector{<:Number}) = Vandermonde(α, length(α))

Base.size(V::Vandermonde) = (length(V.α), V.m)
Base.getindex(V::Vandermonde, i, j) = V.α[i]^(j-1)

α = [1, 2, 3, 4]

V = Vandermonde(α, 4)

determinant(V::Vandermonde) = 
  ((xi-xj) for (i,xi) in enumerate(V.α), (j, xj) in enumerate(V.α) if i < j) |> prod