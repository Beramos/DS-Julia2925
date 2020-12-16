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
md"------"

# ╔═╡ 2f51df02-3fda-11eb-0f9c-9b5bea842137
md"## Example exercise"

# ╔═╡ 854891dc-2dab-11eb-2b4b-e129081aacca
md"""Complete the function `myclamp(x)` that clamps a number `x` between 0 and 1.

Open assignments always return `missing`.
"""

# ╔═╡ e27e6aa0-2dab-11eb-3ccc-43c68f37114b
myclamp(x) = missing

# ╔═╡ 87e6c2a8-2dac-11eb-33d3-77a35fc13d71
myclamp(1.1)

# ╔═╡ e05ee714-3fde-11eb-0209-e30f44655997
md"The answer checking happens in the second argument of `check_answer()` and by passing the tracker-instance in the first argument the state of the question (correct/incorrec) is tracked"

# ╔═╡ 4d059920-2dac-11eb-2177-574ca39f3399
# hand in one or serveral examples that should all evaluate to `true`.
check_answer(tracker, myclamp(-1)==0, myclamp(0.3)==0.3, myclamp(1.1)==1.0) 

# ╔═╡ 221b27f8-3fdf-11eb-06c1-f97060a68bca
md"**Hints:**"

# ╔═╡ 542d5fa6-2da9-11eb-1037-3b35a5b22bd5
hint(md"Did you think of this?")

# ╔═╡ 2e7109a0-3fdf-11eb-28af-0d99a01c5066
md"**FYI's:**"

# ╔═╡ 3cd3e814-3fdf-11eb-1918-75993ba2e121
fyi(md"Did you know that scientists recently discovered pink UV-fluorescent squirrels?")

# ╔═╡ Cell order:
# ╟─d00b3712-3fd6-11eb-354e-3182c3cb8eb1
# ╠═cfea9340-3fd6-11eb-26cc-57e76c7353cd
# ╟─4e4c000e-3fda-11eb-3b32-8fad55386401
# ╠═eb3259ee-3fdb-11eb-39d1-6d8b2f5a29ed
# ╠═28e74fe2-3fdc-11eb-28b5-1fc8d35e65cf
# ╠═1a6a2844-3fdd-11eb-2931-dd7fca88e484
# ╟─4707f4ae-3fdc-11eb-3ebd-2b483041d459
# ╟─2f51df02-3fda-11eb-0f9c-9b5bea842137
# ╟─854891dc-2dab-11eb-2b4b-e129081aacca
# ╠═e27e6aa0-2dab-11eb-3ccc-43c68f37114b
# ╠═87e6c2a8-2dac-11eb-33d3-77a35fc13d71
# ╟─e05ee714-3fde-11eb-0209-e30f44655997
# ╠═4d059920-2dac-11eb-2177-574ca39f3399
# ╟─221b27f8-3fdf-11eb-06c1-f97060a68bca
# ╠═542d5fa6-2da9-11eb-1037-3b35a5b22bd5
# ╟─2e7109a0-3fdf-11eb-28af-0d99a01c5066
# ╠═3cd3e814-3fdf-11eb-1918-75993ba2e121
