### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 7308bc54-e6cd-11ea-0eab-83f7535edf25
# edit the code below to set your name and UGent username

student = (name = "Jan Janssen", UGent_username = "JaJansse")

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ cdff6730-e785-11ea-2546-4969521b33a7
md"""

Submission by: **_$(student.name)_**
"""

# ╔═╡ a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
md"""
# Notebook 0: Getting up and running

First of all, **_welcome to the course!_**
"""

# ╔═╡ 094e39c8-e6ce-11ea-131b-07c4a1199edf


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

# ╔═╡ d62f223c-e754-11ea-2470-e72a605a9d7e
md"### Question with validation and hints

Write a function newton_sqrt(x) which implements the above algorithm."

# ╔═╡ 4896bf0c-e754-11ea-19dc-1380bb356ab6
function newton_sqrt(x, error_margin=0.01, a=x / 2) # a=x/2 is the default value of `a`
	return missing # this is wrong, write your code here!
end

# ╔═╡ 7a01a508-e78a-11ea-11da-999d38785348
newton_sqrt(2)

# ╔═╡ 682db9f8-e7b1-11ea-3949-6b683ca8b47b
let
	result = newton_sqrt(2, 0.01)
	if !(result isa Number)
		md"""
!!! warning "Not a number"
    `newton_sqrt` did not return a number. Did you forget to write `return`?
		"""
	elseif abs(result - sqrt(2)) < 0.01
		md"""
!!! correct
    Well done!
		"""
	else
		md"""
!!! warning "Incorrect"
    Keep working on it!
		"""
	end
end

# ╔═╡ 088cc652-e7a8-11ea-0ca7-f744f6f3afdd
md"""
!!! hint
    `abs(r - s)` is the distance between `r` and `s`
"""

# ╔═╡ c18dce7a-e7a7-11ea-0a1a-f944d46754e5
md"""
!!! hint
    If you're stuck, feel free to cheat, this is homework 0 after all 🙃

    Julia has a function called `sqrt`
"""

# ╔═╡ Cell order:
# ╟─cdff6730-e785-11ea-2546-4969521b33a7
# ╠═7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╠═a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╟─094e39c8-e6ce-11ea-131b-07c4a1199edf
# ╟─31a8fbf8-e6ce-11ea-2c66-4b4d02b41995
# ╟─56866718-e6ce-11ea-0804-d108af4e5653
# ╠═bccf0e88-e754-11ea-3ab8-0170c2d44628
# ╟─e7abd366-e7a6-11ea-30d7-1b6194614d0a
# ╟─d62f223c-e754-11ea-2470-e72a605a9d7e
# ╠═4896bf0c-e754-11ea-19dc-1380bb356ab6
# ╠═7a01a508-e78a-11ea-11da-999d38785348
# ╠═682db9f8-e7b1-11ea-3949-6b683ca8b47b
# ╠═088cc652-e7a8-11ea-0ca7-f744f6f3afdd
# ╟─c18dce7a-e7a7-11ea-0a1a-f944d46754e5
