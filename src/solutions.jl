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
  else
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

### Molecular mass spectrometry
f1(s) = replace(s, "-CH3"=> "-COOH") |> s -> replace(s, "CH3-"=> "COOH-")
f2(s) = replace(s, "-CO-COOH"=> "") |> s -> replace(s, "COOH-CO-"=> "")
	
function f3(molecule)
  if length(molecule) < 4
    molecule = "CH4"
    return molecule
  end
  
  if molecule[1:4] == "CH2-"
    molecule = "CH3-" * molecule[5:end]
  end
  if molecule[end-3:end] == "-CH2"
    molecule = molecule[1:end-4] * "-CH3"
  end
  return molecule
end

f4(s) = replace(s, "-CH2-CH2-"=> "-CO-")
	
function f5(molecule)
  if molecule[1:3] == "CO-"
    molecule = "COOH-" * molecule[4:end]
  end
  
  if molecule[end-2:end] == "-CO" 
    molecule = molecule[1:end-3] * "-COOH"
  end
  return molecule
end 
	
f6(s) = replace(s, "CO-CO-CO" => "CO-CH2-CO")
	
function cycle(molecule)
  molecule |> f1 |> f2 |> f3 |> f4 |> f5 |> f6
end
	
function degrade(molecule)
  mol_prev = ""
  while mol_prev !== molecule
    mol_prev = molecule
    molecule = cycle(molecule)
  end
  return molecule
end

function molecular_weight(molecule)
	return count("CH3", molecule)* 15.0 +
			count("CH4", molecule) * 16.0 +
			count("CH2", molecule) * 14.0 +
			count("CO", molecule) * 28.0 +
			count("OH", molecule) * 17
end

function simulate_path(space, offset, down=1)
  x, y = 1, 1
  n, m = size(space)
  n_trees = 0
  for y in 1:down:n
    n_trees += space[y,x]
    x += offset
    while x > m
      x -= m
    end
  end
  return n_trees
end

# n_trees = simulate_path(map, 3)
n_trees = 254
# product_all_trees = simulate_path(space, 1) * simulate_path(space, 3) * simulate_path(space, 5) * simulate_path(space, 7) * simulate_path(space, 1, 2)
product_all_trees = 1666768320
# answers to advanced solution:
#goingdowntheslope(3, 1, slope)
#slopestyles = (
#    (1, 1), 
#    (3, 1), 
#    (5, 1), 
#    (7, 1), 
#    (1, 2), 
#)
#prod([goingdowntheslope(direction..., slope) for direction in slopestyles])

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


#= Notebook 3: project 1 =#
### Mean
mean(x) = sum(x)/length(x)

weighted_mean(x, w) = sum(w.*x)

### 1D convolution
function convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	@assert length(w) < length(x) "length of `w` should be smaller than `x`"
	n = length(x)
	m = length(w) ÷ 2
	y = zeros(n)

	fill!(y, 0.0)
	for (i, xj) in enumerate(x)
		for (j, wj) in enumerate(w)
			k = clamp(i + j - m, 1, n)
			y[i] += w[j] * x[k]
		end
	end
	return y
end

### Weight vectors
function uniform_weights(m)
	return ones(2m+1) / (2m+1)
end

function triangle_weights(m)
	w = zeros(2m+1)
	for i in 1:(m+1)
		w[i] = i
		w[end-i+1] = i
	end
	w ./= sum(w)
	return w
end	

function gaussian_weights(m; σ=4)
	w = exp.(-(-m:m).^2 / 2σ^2)
	return w ./ sum(w)
end

### Protein sliding window
function protein_sliding_window(sequence, m, zscales)
	n = length(sequence)
	y = zeros(n)
	for i in (m+1):(n-m)
		for k in -m:m
			y[i] += zscales[sequence[i+k]]
		end
	end
	return y / (2m + 1)
end

### Decimate
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

### 2D convolution
function convolve_2d(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	fill!(out, 0.0)
	m = div(size(K, 1), 2) 
	for i in 1:n_rows
		for j in 1:n_cols
			for k in -m:m
				for l in -m:m
					out[i,j] += M[clamp(i+k, 1, n_rows), clamp(j+l, 1, n_cols)] * K[k+m+1,l+m+1]
				end
			end
		end
	end
	return out
end

function gaussian_kernel(m; σ=4)
  K = [exp(-(x^2 + y^2) / 2σ^2) for x in -m:m, y in -m:m]
  K ./= sum(K)
  return K
end

function convolve_image(M::Matrix{<:AbstractRGB}, K::Matrix)
	Mred = convolve_2d(red.(M) .|> Float32, K)
	Mgreen = convolve_2d(green.(M) .|> Float32, K)
	Mblue = convolve_2d(blue.(M) .|> Float32, K)
	return RGB.(Mred, Mgreen, Mblue)
end

### Edge detection
Gx = [1 0 -1; 2 0 -2; 1 0 -1]
Gy = [1 2 1; 0 0 0; -1 -2 -1]
function edge_detection(M)
	M = M .|> Gray .|> Float64
	return sqrt.(Solutions.convolve_2d(M, Gx).^2 + Solutions.convolve_2d(M, Gy).^2) .|> Gray
end

### Get index of bitstring
getbinarydigit(rule, i) = isodd(rule >> i)

### Next state
nextstate(l::Bool, s::Bool, r::Bool, rule::Int) = nextstate(l, s, r, UInt8(rule))
		
function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
  return getbinarydigit(rule, 4l+2s+1r)
end

### Update 1 step of CA
function update1dca!(xnew, x, rule::Integer)
	n = length(x)
	xnew[1] = nextstate(x[end], x[1], x[2], rule)
	xnew[end] = nextstate(x[end-1], x[end], x[1], rule)
	for i in 2:n-1
		xnew[i] = nextstate(x[i-1], x[i], x[i+1], rule)
	end
	return xnew
end

update1dca(x, rule::Integer) = update1dca!(similar(x), x, rule)


### simulating the CA
"""
    simulate(x0, rule; nsteps=100)

Simulate `nsteps` time steps according to `rule` with `X0` as the initial condition.
Returns a matrix X, where the rows are the state vectors at different time steps.
"""
function simulate(x0, rule::UInt8; nsteps=100)
	n = length(x0)
    X = zeros(Bool, nsteps+1, n)
	X[1,:] = x0
	for t in 1:nsteps
		x = @view X[t,:]
		xnew = @view X[t+1,:]
		update1dca!(xnew, x, rule)
	end
    return X
end

### plotting CA
#plot(ca_image(X), size=(1000, 1000))


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
