### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ cfea9340-3fd6-11eb-26cc-57e76c7353cd
using DSJulia

# ╔═╡ 4bfec7fc-2da9-11eb-1f36-2d55a5099098
using Markdown

# ╔═╡ d00b3712-3fd6-11eb-354e-3182c3cb8eb1
md"""## Some examples on how to use DSJulia"""

# ╔═╡ cf59f7a6-3fd6-11eb-1bb5-05fd29396dd8


# ╔═╡ f14d9b62-2da8-11eb-3ae5-776f9a1e53e0
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 854891dc-2dab-11eb-2b4b-e129081aacca
md"""Complete the function `myclamp(x)` that clamps a number `x` between 0 and 1.

Open assignments always return `missing`.
"""

# ╔═╡ e27e6aa0-2dab-11eb-3ccc-43c68f37114b
myclamp(x) = missing

# ╔═╡ 87e6c2a8-2dac-11eb-33d3-77a35fc13d71
myclamp(1.1)

# ╔═╡ 542d5fa6-2da9-11eb-1037-3b35a5b22bd5
hint(md"Did you think of this?")

# ╔═╡ 51df9352-2dab-11eb-2d71-bb09b24a94ef
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 62aaf320-2dab-11eb-38e6-5bbb3c0994b0
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 6e08751c-2dab-11eb-3c25-e9735d364519
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 7346b4b2-2dab-11eb-1bec-8109ff354040
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 75d80ffc-2dab-11eb-3273-67042f7d6647
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ eb8c2358-2dab-11eb-3040-ed30ac2b53d6
function validate(statements...)
	all_valid = all(statements)
	ismissing(all_valid) && return still_missing()
	some_valid = any(statements)
	some_valid && !all_valid && return keep_working(md"You are not quite there, but getting warmer!")
	!all_valid && return keep_working()
	all_valid && return correct()
end

# ╔═╡ 4d059920-2dac-11eb-2177-574ca39f3399
# hand in one or serveral examples that should all evaluate to `true`.
validate(myclamp(-1)==0, myclamp(0.3)==0.3, myclamp(1.1)==1.0) 

# ╔═╡ Cell order:
# ╟─d00b3712-3fd6-11eb-354e-3182c3cb8eb1
# ╠═cfea9340-3fd6-11eb-26cc-57e76c7353cd
# ╠═cf59f7a6-3fd6-11eb-1bb5-05fd29396dd8
# ╠═4bfec7fc-2da9-11eb-1f36-2d55a5099098
# ╠═f14d9b62-2da8-11eb-3ae5-776f9a1e53e0
# ╠═854891dc-2dab-11eb-2b4b-e129081aacca
# ╠═e27e6aa0-2dab-11eb-3ccc-43c68f37114b
# ╠═87e6c2a8-2dac-11eb-33d3-77a35fc13d71
# ╠═4d059920-2dac-11eb-2177-574ca39f3399
# ╟─542d5fa6-2da9-11eb-1037-3b35a5b22bd5
# ╠═51df9352-2dab-11eb-2d71-bb09b24a94ef
# ╠═62aaf320-2dab-11eb-38e6-5bbb3c0994b0
# ╠═6e08751c-2dab-11eb-3c25-e9735d364519
# ╠═7346b4b2-2dab-11eb-1bec-8109ff354040
# ╠═75d80ffc-2dab-11eb-3273-67042f7d6647
# ╠═eb8c2358-2dab-11eb-3040-ed30ac2b53d6
