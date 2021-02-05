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

# ╔═╡ 96e67e12-67a7-11eb-2537-516f526b8fe8
using Plots

# ╔═╡ 3c7ca21c-67a7-11eb-07ce-a3d815c835ab
using Colors

# ╔═╡ 7b0a195c-67a6-11eb-03e9-c3fe33953a38
# edit the code below to set your name and UGent username

student = (name = "Juan Janssen", email = "Juan.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 7afa0530-67a6-11eb-111e-53c84fec2322
begin 
	using DSJulia;
	using PlutoUI;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ a0178360-67a6-11eb-2919-d72be7bd2388
md"""
# Exercises: convolution, images and cellular automata (part 3)

**Learning goals:**
- code reuse;
- efficient use of collections and unitRanges;
- control flow in julia;

"""


# ╔═╡ 90ae2f32-67a6-11eb-3ca6-e9d4db5f7a3b
md"""
### Elementary cellular automata

*This is an optional but highly interesting application for the fast workers.*

To conclude our adventures, let us consider **elementary cellular automata**. These are more or less the simplest dynamical systems one can study. Cellular automata are discrete spatio temporal systems: both the space time and states are discrete. The state of an elementary cellular automaton is determined by an $n$-dimensional binary vector, meaning that there are only two states 0 or 1 (`true` or `false`). The state transistion of a cell is determined by:
- its own state `s`;
- the states of its two neighbors, left `l` and right `r`.

As you can see in the figure below, each rule corresponds to the 8 possible situations given the states of the two neighbouring cells and it's own state. Logically, one can show that there are only $2^8=256$ possible rules one can apply. Some of them are depicted below.

![](https://mathworld.wolfram.com/images/eps-gif/ElementaryCARules_900.gif)

So each of these rules can be represented by an 8-bit integer. Let us try to explore them all.
"""

# ╔═╡ 90d206a0-67a6-11eb-3e8f-c568406e620a
md"The rules can be represented as a unsigned integer `UInt8` which takes a value between 0 and 255."

# ╔═╡ 90d23cd0-67a6-11eb-3178-75cfff44b494
rule = UInt8(110)

# ╔═╡ 90df4e48-67a6-11eb-0e15-4767ad5797e7
@terminal println(rule)

# ╔═╡ b7ddce78-67a6-11eb-31d3-b78738aa3d28
md"Getting the bitstring is easy"

# ╔═╡ b7fc8b56-67a6-11eb-0de2-ed7a0f292036
bitstring(rule)

# ╔═╡ b7fcc678-67a6-11eb-0a55-1de794e05d82
md"This bitstring represents the transitions of the middle cell to the 8 possible situations of `l`, `r` and `s`. You can verify this by checking the state transitions for rule 110 in de figure above."

# ╔═╡ b8065d16-67a6-11eb-2d33-31dd9a8026a1
md"The challenge with bitstrings is that the separate bits cannot be efficiently accessed so getting the $i$-th digit is a bit more tricky."

# ╔═╡ ce57c888-67a7-11eb-38f2-b1d933ca7c3b


# ╔═╡ 0451bf44-67a7-11eb-1dc8-ddded8d8aa98
getbinarydigit(rule, i) = missing

# ╔═╡ b813a700-67a6-11eb-0805-a3020eefa7a5
begin 	
	qb5 = QuestionBlock(
		title=md"**Optional question (hard)**",
		description = md"""
		Can you think of a way to get the transitioned state given a rule  and a position of a bit in the bitstring? Complete the function `getbinarydigit(rule, i)`.
		For confident programmers, it is possible to do this in a single line. 
		""",
		questions = [
			Question(;description=md"", 
				validators = @safe[
					getbinarydigit(UInt8(110), 5) == 
						Solutions.getbinarydigit(UInt8(110), 5)
					])
		],
		hints = [

			hint(md"The solution is hidden in the next hint."), 
			hint(md""" 
				```julia
				getbinarydigit(rule, i) = isodd(rule >> i)
				```"""),
			hint(md"Don't worry if you don't get fully understand the oneliner, it is bitstring manipulation and is not usually part of a scientific programming curriculum."),
			hint(md"A more naive and less efficient solution would be to convert the rule integer to a string (not a bitstring), which supports indexing. ")
		]
	)
	validate(qb5)
end

# ╔═╡ 046da34e-67a7-11eb-39ef-098968405c01
[getbinarydigit(rule, i) for i in 7:-1:0]  # counting all positions

# ╔═╡ 084c0af8-67a7-11eb-2a6a-8f74c7ab1d10


# ╔═╡ 1b4b2a2a-67a7-11eb-2e87-959df87e5b36
getbinarydigit(rule, 4true+2true+1true+1)

# ╔═╡ 1b7e60a0-67a7-11eb-2b87-bdbef3c1a333
begin
	function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
		return missing
	end
	
	nextstate(l::Bool, s::Bool, r::Bool, rule::Int) = missing
end

# ╔═╡ 046dfc0c-67a7-11eb-192d-57632a8bf698
begin 	
	q61 = Question(
			description=md" Complete `nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)`", 
			validators = @safe[
				nextstate(true, false, false, UInt8(110)) == 
					Solutions.nextstate(true, false, false, UInt8(110))
			])
	
	q62 = QuestionOptional{Intermediate}(
			description=md"Using multiple dispatch, write a second function `nextstate(l::Bool, s::Bool, r::Bool, rule::Int)`  so that the rule can be provided as any Integer.", 
			validators = @safe[
				nextstate(true, false, false, 110) == 
					Solutions.nextstate(true, false, false, 110)
			])
	
	qb6 = QuestionBlock(
		title=md"**Question: transitioning the individual states**",
		description = md"""
		Now for the next step, given a state `s` and the states of its left (`l`) and right (`r`) neighbours, can you determine the next state under a `rule` (UInt8)?

		""",
		questions = [q61, q62],
		hints = [
			hint(md"Do not forget you have just implemented `getbinarydigit(rule, i)`."),
			hint(md"In the example of the rules displayed above, all 8 possible combinations of (`l`, `s`, `r`) always refer to the same position in the bitstring."),
			
			hint(md"`8-(4l+2s+1r)`"),
		]
	)
	validate(qb6, tracker)
end

# ╔═╡ 1b7ebed8-67a7-11eb-1241-8b9e4504a9db
nextstate(true, true, true, rule)

# ╔═╡ 1b96c6c2-67a7-11eb-1b7b-cd3e3a48bfdc
md"Now that we have this working it is easy to generate and visualise the transitions for each rule. This is not an easy line of code try to really understand these comprehensions before moving on.

> Hint: expand the output for a prettier overview of the rules."

# ╔═╡ 1bb21328-67a7-11eb-15a8-ddbc290d6e67
@bind rule_number Slider(0:255, default=110)

# ╔═╡ 1b97eba6-67a7-11eb-367b-795e6a833ec1
md"Rule: $rule_number"

# ╔═╡ 1bb3ea54-67a7-11eb-0bb7-25c1539cb341
md"Click on the small triangle to view the transitions."

# ╔═╡ 1bc084e6-67a7-11eb-385d-81fb3c4f4164
Dict(
	(l=l, s=s, r=r) => nextstate(l, s, r, rule)
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
)

# ╔═╡ 2ec8a65e-67a7-11eb-3826-999430e054f8
cm(b) = b ? Gray(0.05) : Gray(0.95)

# ╔═╡ 1bd59dac-67a7-11eb-3a6f-cdcce5c366a1
Dict(
	cm.([l, s, r]) => [cm(Solutions.nextstate(l, s, r, rule_number))]
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
				)

# ╔═╡ 4b44a362-67a7-11eb-2d67-0d66184f1f16


# ╔═╡ 6522cfb6-67a7-11eb-3525-9b4e56b2607c
function update1dca!(xnew, x, rule::Integer)
	return missing
end

# ╔═╡ 6534f074-67a7-11eb-15ac-5591393c275c
update1dca(x, rule::Integer) = missing

# ╔═╡ 2eeccd02-67a7-11eb-286e-7faad656fc2f
begin 	
	x0_quest = rand(Bool, 100)
	rule_quest = UInt8(110)
	
	
	q71 = Question(
			description=md"""
		Complete `update1dca!(xnew, x, rule::Integer)` that performs a single iteration of the cellular automata given an initial state array `x`, and overwrites the new state array `xnew`, given a certain rule integer.
		$(fyi(md"`!` is often used as suffix to a julia function to denote an inplace operation. The function itself changes the input arguments directly. `!` is a naming convention and does not fulfill an actual functionality"))
		
			""", 
			validators = @safe[
				update1dca!(similar(x0_quest), x0_quest, rule_quest) == 
					Solutions.update1dca!(similar(x0_quest), x0_quest, rule_quest)
			])
	
		q72 = QuestionOptional{Easy}(
			description=md"""
		Complete `xnew = update1dca(x, rule::Integer)` function that performs the same action as `update1dca!` but with an explicit return of the new state array. It is possible to do this in a single line.
			""",
			validators = @safe[
				update1dca(x0_quest, rule_quest) == 
					Solutions.update1dca(x0_quest, rule_quest)
			]
	)
	
	qb7 = QuestionBlock(
		title=md"**Question: evolving the array**",
		description = md"""
		Now that we are able the transition the individual states, it is time to overcome the final challenge, evolving the entire array! Usually in cellular automata all the initial states transition simultaneously from the initial state to the next state.
		""",
		questions = [q71, q72],
		hints= [
			hint(md"""`similar(x)` is a useful function to initialise a new matrix of the same type and dimensions of the array `x`	""")	
		]
	)
	validate(qb7, tracker)
end

# ╔═╡ 653530de-67a7-11eb-379e-0b7b2c2e10c2
x0_ca = rand(Bool, 100)

# ╔═╡ 6545f090-67a7-11eb-38d5-5b45c69e4330
update1dca(x0_ca, rule)

# ╔═╡ ea3b8436-67a7-11eb-22b2-b37ee47b4e68


# ╔═╡ eaf42e6c-67a7-11eb-020d-8bc2355875c0


# ╔═╡ 71764aae-67a7-11eb-261a-f7f430d6e1e0
"""
    simulate(x0, rule; nsteps=100)

Simulate `nsteps` time steps according to `rule` with `X0` as the initial condition.
Returns a matrix X, where the rows are the state vectors at different time steps.
"""
function simulate(x0, rule::UInt8; nsteps=100)
	n = length(x0)
    X = zeros(Bool, nsteps+1, n)
    return missing
end

# ╔═╡ 654f6dc0-67a7-11eb-3d68-e9ab492a3c5b
begin 	
	q81 = Question(
			description=md"""
		Complete `simulate(x0, rule::UInt8; nsteps=100)` that performs a `nsteps` of simulation  given an initial state array `x0` and a rule 
		
			""", 
			validators = @safe[
				simulate(x0_quest, rule_quest; nsteps=10) ==
					Solutions.simulate(x0_quest, rule_quest; nsteps=10)
			])
	
	q82 = Question(
		description=md"""
	Plot the evolution of state array at each iteration as an image.

		""")

	qb8 = QuestionBlock(
		title=md"**Question: simulating the cellular automata**",
		description = md"""
		Now that we are able the transition the individual states, it is time to overcome the final challenge, evolving the entire array! Usually in cellular automata all the initial states transition simultaneously from the initial state to the next state.
		""",
		questions = [q81, q82],
		hints= [
			hint(md"""`similar(x)` is a useful function to initialise a new matrix of the same type and dimensions of the array `x`	"""),
			hint(md"""`Gray(x)` returns the gray component of a color. Try,  `Gray(0)`, `Gray(1)`""")	
		]
	)
	validate(qb8, tracker)
end

# ╔═╡ 71918506-67a7-11eb-32c0-35de007f1f84
X = simulate(x0_ca, UInt8(rule_number); nsteps=100)

# ╔═╡ 71921126-67a7-11eb-0142-1de5c2eb4f66
ca_image(X) = cm.(X)

# ╔═╡ 37a2fa58-67b5-11eb-0650-656207ef57f6


# ╔═╡ 3726e31e-67b5-11eb-22ee-a951ca2f7599


# ╔═╡ bd679f6c-67a7-11eb-3362-b3631b1bfc34


# ╔═╡ 719dbc6a-67a7-11eb-2596-056b57139b44
function show_barcode(bitArr) 
	bar(bitArr, color=:Black, ylims=(0.1,0.5), label="", axis = nothing, border=:none,  bar_width=1,  size=(400,300))
end

# ╔═╡ 785d48a4-67a7-11eb-1509-4901cda96709
product_code_milk = missing

# ╔═╡ 71a84b88-67a7-11eb-25a8-9159f4809a42
begin
	rule_ex9 = 171
	initInt_ex9 = 3680689260
	initBs_exp9 = bitstring(initInt_ex9)
	bitArr_ex9 = Solutions.simulate([el == '0' for el in reverse(initBs_exp9)[1:32]], UInt8(rule_ex9); nsteps=50)[end,:]
	
	pl_ex9 = show_barcode(bitArr_ex9)
	
	

	rule2_ex9 = 42
	init_Int2_ex9 = 3681110060
	milk_barcode = bitstring(init_Int2_ex9)
	
	bitArr = Solutions.simulate([el == '0' for el in reverse(milk_barcode)[1:32]], UInt8(rule2_ex9); nsteps=50)[end,:]
	
	pl2_ex9 = show_barcode(bitArr)

	
	q91 = Question(
			description=md""" After generating tons of new barcodes, the employees stumble upon a problem. While it is easy to generate the barcodes given the product codes, it it not trivial to convert a barcode to a product number. Luckily, the employees used the same initial bitstring for all products (*3681110060*).
		
		Can you find the product code for this box of milk **XXX** *3128863161*?
		
		$(pl2_ex9)
		
		The binary form of the barcode is provided below.
			""", 
			validators = @safe[product_code_milk == parse(Int, "$rule2_ex9$init_Int2_ex9")])
	
	qb9 = QuestionBlock(
		title=md"**Optional question: Barcode bonanza**",
		description = md"""
		A simple barcode is data represented by varying the widths and spacings of parallel lines. However this is just an array of binary values that correspondent to an integer number.
		
		![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/UPC-A-036000291452.svg/220px-UPC-A-036000291452.svg.png)
		
		The laser scanner reads the barcode and converts the binary number to an integer which is the product code, a pretty simple and robust system.
		
		A local supermarket completely misread the protocol and accidentally use a cellular automata to convert the binary number into an integer. Their protocol is a little convoluted,		
			
		The number corresponding to a barcode is the **rule number** followed by the *initial 32-bit array encoded as an integer* (initial condition). The barcode is generated by taking the rule number and evolving the initial condition for 50 iterations.
		
		As an example this barcode corresponds to the number: 
		**$(rule_ex9)** *3128863161*
		
		$(pl_ex9)
		
		
		Which is *3128863161* converted to a bitstring as initial array iterated for 50 iterations using rule: $(rule_ex9)
		""",
		questions = [q91],
	)
	validate(qb9)
end

# ╔═╡ 816c43b4-67a7-11eb-3e76-87d5d48cc34e
barcode_milk =  Bool[1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0];

# ╔═╡ 8423b326-67a7-11eb-1fdf-7bc373064643


# ╔═╡ Cell order:
# ╟─7afa0530-67a6-11eb-111e-53c84fec2322
# ╠═7b0a195c-67a6-11eb-03e9-c3fe33953a38
# ╟─a0178360-67a6-11eb-2919-d72be7bd2388
# ╠═96e67e12-67a7-11eb-2537-516f526b8fe8
# ╟─90ae2f32-67a6-11eb-3ca6-e9d4db5f7a3b
# ╟─90d206a0-67a6-11eb-3e8f-c568406e620a
# ╠═90d23cd0-67a6-11eb-3178-75cfff44b494
# ╠═90df4e48-67a6-11eb-0e15-4767ad5797e7
# ╟─b7ddce78-67a6-11eb-31d3-b78738aa3d28
# ╠═b7fc8b56-67a6-11eb-0de2-ed7a0f292036
# ╟─b7fcc678-67a6-11eb-0a55-1de794e05d82
# ╟─b8065d16-67a6-11eb-2d33-31dd9a8026a1
# ╟─ce57c888-67a7-11eb-38f2-b1d933ca7c3b
# ╟─b813a700-67a6-11eb-0805-a3020eefa7a5
# ╠═0451bf44-67a7-11eb-1dc8-ddded8d8aa98
# ╠═046da34e-67a7-11eb-39ef-098968405c01
# ╟─084c0af8-67a7-11eb-2a6a-8f74c7ab1d10
# ╟─046dfc0c-67a7-11eb-192d-57632a8bf698
# ╠═1b4b2a2a-67a7-11eb-2e87-959df87e5b36
# ╠═1b7e60a0-67a7-11eb-2b87-bdbef3c1a333
# ╠═1b7ebed8-67a7-11eb-1241-8b9e4504a9db
# ╟─1b96c6c2-67a7-11eb-1b7b-cd3e3a48bfdc
# ╟─1b97eba6-67a7-11eb-367b-795e6a833ec1
# ╠═1bb21328-67a7-11eb-15a8-ddbc290d6e67
# ╟─1bb3ea54-67a7-11eb-0bb7-25c1539cb341
# ╠═1bc084e6-67a7-11eb-385d-81fb3c4f4164
# ╠═3c7ca21c-67a7-11eb-07ce-a3d815c835ab
# ╠═2ec8a65e-67a7-11eb-3826-999430e054f8
# ╠═1bd59dac-67a7-11eb-3a6f-cdcce5c366a1
# ╟─4b44a362-67a7-11eb-2d67-0d66184f1f16
# ╟─2eeccd02-67a7-11eb-286e-7faad656fc2f
# ╠═6522cfb6-67a7-11eb-3525-9b4e56b2607c
# ╠═6534f074-67a7-11eb-15ac-5591393c275c
# ╠═653530de-67a7-11eb-379e-0b7b2c2e10c2
# ╠═6545f090-67a7-11eb-38d5-5b45c69e4330
# ╠═ea3b8436-67a7-11eb-22b2-b37ee47b4e68
# ╟─eaf42e6c-67a7-11eb-020d-8bc2355875c0
# ╟─654f6dc0-67a7-11eb-3d68-e9ab492a3c5b
# ╠═71764aae-67a7-11eb-261a-f7f430d6e1e0
# ╠═71918506-67a7-11eb-32c0-35de007f1f84
# ╠═71921126-67a7-11eb-0142-1de5c2eb4f66
# ╠═37a2fa58-67b5-11eb-0650-656207ef57f6
# ╠═3726e31e-67b5-11eb-22ee-a951ca2f7599
# ╟─bd679f6c-67a7-11eb-3362-b3631b1bfc34
# ╟─71a84b88-67a7-11eb-25a8-9159f4809a42
# ╠═719dbc6a-67a7-11eb-2596-056b57139b44
# ╠═785d48a4-67a7-11eb-1509-4901cda96709
# ╠═816c43b4-67a7-11eb-3e76-87d5d48cc34e
# ╠═8423b326-67a7-11eb-1fdf-7bc373064643
