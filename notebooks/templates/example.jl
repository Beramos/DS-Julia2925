### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ cfea9340-3fd6-11eb-26cc-57e76c7353cd
using DSJulia

# ╔═╡ d00b3712-3fd6-11eb-354e-3182c3cb8eb1
md"""## Some examples on how to use DSJulia"""

# ╔═╡ 4e4c000e-3fda-11eb-3b32-8fad55386401
md"At the start of the notebook we need the name and email of the students"

# ╔═╡ eb3259ee-3fdb-11eb-39d1-6d8b2f5a29ed
student = (name="Bram De Jaegher", email="Bram.DeJaegher@gmail.com")

# ╔═╡ 28e74fe2-3fdc-11eb-28b5-1fc8d35e65cf
md"Next step is to initialise the tracker"

# ╔═╡ 1a6a2844-3fdd-11eb-2931-dd7fca88e484
tracker = ProgressTracker(student.name, student.email);

# ╔═╡ 4707f4ae-3fdc-11eb-3ebd-2b483041d459
md"-----"

# ╔═╡ e27e6aa0-2dab-11eb-3ccc-43c68f37114b
myclamp(x) = max.(0, min.(x,1))

# ╔═╡ 9bbee332-4170-11eb-05a6-4998f14d307e
begin
	q₁ = Question(;
		description=md"""
		Complete the function `myclamp(x)` that clamps a number `x` between 0 and 1.

		Open assignments always return `missing`. 
		""",
		validators= @safe[myclamp(-1)==0, myclamp(0.3)==0.3, myclamp(1.1)==1.0]
	)
	
	q₂ = QuestionOptional{Easy}(;
		description=md"""
		Try to make the clamping also work for arrays.
		""",
		validators= @safe[myclamp([2.0, 0.3])==[1.0, 0.3]]
	)
	
	q₃ = QuestionOptional{Intermediate}(;
		description=md"""
		This is an intermediate question. Surely you can complete this
		""",
		validators= @safe[true]
	)
	
	q₄ = QuestionOptional{Hard}(;
		description=md"""
		I admit, this one is definitely harder
		""",
		validators= @safe[false]
	)
	
	
   qb = QuestionBlock(;
	title=md"### Question 1.0: What a crazy exercise",
	description=md"""
		Some additional general kind off description and all.
		You can even add other admonitions. 
		$(fyi(md"I'm here!"))
		
		Anything markdowny. Just make sure to use the triple accolades `\"\"\"`.
		
		""",
	questions = [q₁, q₂, q₃, q₄],
	hints=[	hint(md"Have you tried this?"),
			hint(md"Have you tried switching it on and off again?")]
	);
	
	validate(qb)
end

# ╔═╡ 87e6c2a8-2dac-11eb-33d3-77a35fc13d71
myclamp(1.1)

# ╔═╡ e05ee714-3fde-11eb-0209-e30f44655997
md"The automatic grading happens in the second argument of `validate()` and by passing the tracker-instance in the first argument the state of the question (correct/incorrect) is tracked"

# ╔═╡ 221b27f8-3fdf-11eb-06c1-f97060a68bca
md"**Hints:**"

# ╔═╡ 542d5fa6-2da9-11eb-1037-3b35a5b22bd5
hint(md"Did you think of this?")

# ╔═╡ 2e7109a0-3fdf-11eb-28af-0d99a01c5066
md"**FYI's:**"

# ╔═╡ 3cd3e814-3fdf-11eb-1918-75993ba2e121
fyi(md"""Did you know that scientists recently discovered pink UV-fluorescent squirrels? $(fyi("a"))""")

# ╔═╡ 1befa358-485a-11eb-1195-f3f53e48020b
bomb("")

# ╔═╡ Cell order:
# ╟─d00b3712-3fd6-11eb-354e-3182c3cb8eb1
# ╠═cfea9340-3fd6-11eb-26cc-57e76c7353cd
# ╟─4e4c000e-3fda-11eb-3b32-8fad55386401
# ╠═eb3259ee-3fdb-11eb-39d1-6d8b2f5a29ed
# ╠═28e74fe2-3fdc-11eb-28b5-1fc8d35e65cf
# ╠═1a6a2844-3fdd-11eb-2931-dd7fca88e484
# ╠═4707f4ae-3fdc-11eb-3ebd-2b483041d459
# ╠═9bbee332-4170-11eb-05a6-4998f14d307e
# ╠═e27e6aa0-2dab-11eb-3ccc-43c68f37114b
# ╠═87e6c2a8-2dac-11eb-33d3-77a35fc13d71
# ╠═e05ee714-3fde-11eb-0209-e30f44655997
# ╟─221b27f8-3fdf-11eb-06c1-f97060a68bca
# ╠═542d5fa6-2da9-11eb-1037-3b35a5b22bd5
# ╟─2e7109a0-3fdf-11eb-28af-0d99a01c5066
# ╠═3cd3e814-3fdf-11eb-1918-75993ba2e121
# ╠═1befa358-485a-11eb-1195-f3f53e48020b
