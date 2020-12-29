### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 7308bc54-e6cd-11ea-0eab-83f7535edf25
# edit the code below to set your name and UGent username

student = (name = "Jeanette Janssen", email = "Jeanette.Janssen@UGent.be");

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
# Notebook 0: Getting up and running

First of all, **_welcome to the course!_**
"""

# ╔═╡ 31a8fbf8-e6ce-11ea-2c66-4b4d02b41995


# ╔═╡ 56866718-e6ce-11ea-0804-d108af4e5653
md"### Open Question

"

# ╔═╡ bccf0e88-e754-11ea-3ab8-0170c2d44628
ex_1_1 = md"""
your answer here
""" 

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ e7abd366-e7a6-11ea-30d7-1b6194614d0a
if !(@isdefined ex_1_1)
	md"""Do not change the name of the variable - write you answer as `ex_1_1 = "..."`"""
end

# ╔═╡ 4896bf0c-e754-11ea-19dc-1380bb356ab6
function newton_sqrt(x, error_margin=0.01, a=x / 2) # a=x/2 is the default value of `a`
	return missing # this is wrong, write your code here!
end

# ╔═╡ 56996b1a-49bd-11eb-32b5-cffd5c4d0b82
begin
	q₁ = Question(;
		description=md"""
		Complete the function `myclamp(x)` that clamps a number `x` between 0 and 1.

		Open assignments always return `missing`. 
		""",
		validators= @safe[newton_sqrt(4.0)==2.0]
	)
	
   qb = QuestionBlock(;
	title=md"### 1.0 | Question with validation and hints",
	description=md"""
		Write a function newton_sqrt(x) which implements the above algorithm.
		""",
	questions = [q₁],
	hints = [hint(md"""If you're stuck, feel free to cheat, this is homework 0 after all 🙃

    Julia has a function called `sqrt`""")]
	);
	
	validate(qb,tracker)
end

# ╔═╡ Cell order:
# ╟─cdff6730-e785-11ea-2546-4969521b33a7
# ╠═7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╟─a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╟─31a8fbf8-e6ce-11ea-2c66-4b4d02b41995
# ╟─56866718-e6ce-11ea-0804-d108af4e5653
# ╠═bccf0e88-e754-11ea-3ab8-0170c2d44628
# ╟─e7abd366-e7a6-11ea-30d7-1b6194614d0a
# ╟─56996b1a-49bd-11eb-32b5-cffd5c4d0b82
# ╠═4896bf0c-e754-11ea-19dc-1380bb356ab6
