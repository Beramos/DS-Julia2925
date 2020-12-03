### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ d056c964-3597-11eb-01ad-ab46ca2c1864
let
	using Pkg;
	Pkg.activate(".");
	Pkg.add(PackageSpec(url="https://github.com/Beramos/DS-Julia2925", rev="update_admonition"))
end

# ╔═╡ 6c54a3c6-358a-11eb-3529-05cec9ffa342
begin
	include("../../src/DS-Julia2925.jl")
	
end

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

# ╔═╡ 31a8fbf8-e6ce-11ea-2c66-4b4d02b41995


# ╔═╡ 79728490-3582-11eb-1c73-eb6c3d13fd7c
md"### Types of admonition"

# ╔═╡ 78c3aede-3582-11eb-1de3-27b420b17f46
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text])); 

# ╔═╡ d84b371e-3582-11eb-3176-7faf85f87aea
hint(md"This is a hint admonition")

# ╔═╡ 44664a2e-3583-11eb-0f41-970201b67453
correct(text=md"Well done!") = 
	Markdown.MD(Markdown.Admonition("correct", "Correct", [text]));

# ╔═╡ 80fc23f0-3583-11eb-3dae-a5263b2005f7
correct()

# ╔═╡ 0f7275d0-3584-11eb-26c0-3f8dceb6c21a
incorrect(text=md"Keep working on it !") = Markdown.MD(Markdown.Admonition("warning", "Incorrect", [text]));

# ╔═╡ 65a85438-3584-11eb-296b-e3de9deb42d3
incorrect()

# ╔═╡ 72dd1b16-3584-11eb-02bc-21c80993aca7
incorrect(md"did not return a number. Did you forget to write `return`?")

# ╔═╡ bf879432-3584-11eb-3a03-e1c39f717173
fyi(text) = Markdown.MD(
	Markdown.Admonition("info",
		"Additional info",
		[html"""
			<style> pluto-output div.admonition.info .admonition-title {
						background: rgb(161, 161, 161);
					} 

					pluto-output div.admonition.info {
						background: rgba(161, 161, 161, 0.2);
						border: 5px solid rgb(161, 161, 161);
					}
			</style>
		""",
			text
		]
	)
)

# ╔═╡ 2c5bd532-3585-11eb-0e9a-2bf939c940c3
fyi(md"""
	Blue is a color 
	<div> </div>
	
	""")

# ╔═╡ 571c8d48-3585-11eb-10da-d732c9561878
fyi(md"These function can be loaded by using `using ....`")

# ╔═╡ cd897e6e-3587-11eb-19d0-3fff277a2d79
wtf(text) = Markdown.MD(
	Markdown.Admonition("wtf",
		"Self destruct warning",
		[html"""
			<style> pluto-output div.admonition.wtf .admonition-title {
						background: rgb(226, 157, 148);
						animation:blinkingBox 1.5s infinite;
					} 

					pluto-output div.admonition.wtf {
						background: rgba(226, 157, 148, 0.2);
						border: 5px solid rgb(226, 157, 148);
						animation:blinkingBox 1.5s infinite;
					}

			@keyframes blinkingBox{
				0%{     visibility: hidden;    }
				30%{    visibility: hidden; }
				31%{    visibility: visible; }
				99%{    visibility: visible;  }
				100%{   visibility: hidden;     }
			}
			</style>
		""",
			text
		]
	)
)

# ╔═╡ e9e4ad0e-3587-11eb-1d86-b9054c8f634d
wtf(md"I could not resist, sorry!")

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
	return sqrt(x) # this is wrong, write your code here!
end

# ╔═╡ 7a01a508-e78a-11ea-11da-999d38785348
newton_sqrt(2)

# ╔═╡ 713b0250-3582-11eb-21c0-cdc001fc35ee


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
# ╠═d056c964-3597-11eb-01ad-ab46ca2c1864
# ╟─cdff6730-e785-11ea-2546-4969521b33a7
# ╠═7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╠═a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╟─31a8fbf8-e6ce-11ea-2c66-4b4d02b41995
# ╠═79728490-3582-11eb-1c73-eb6c3d13fd7c
# ╠═6c54a3c6-358a-11eb-3529-05cec9ffa342
# ╠═78c3aede-3582-11eb-1de3-27b420b17f46
# ╠═d84b371e-3582-11eb-3176-7faf85f87aea
# ╠═44664a2e-3583-11eb-0f41-970201b67453
# ╠═80fc23f0-3583-11eb-3dae-a5263b2005f7
# ╠═0f7275d0-3584-11eb-26c0-3f8dceb6c21a
# ╠═65a85438-3584-11eb-296b-e3de9deb42d3
# ╠═72dd1b16-3584-11eb-02bc-21c80993aca7
# ╠═bf879432-3584-11eb-3a03-e1c39f717173
# ╠═2c5bd532-3585-11eb-0e9a-2bf939c940c3
# ╠═571c8d48-3585-11eb-10da-d732c9561878
# ╠═cd897e6e-3587-11eb-19d0-3fff277a2d79
# ╠═e9e4ad0e-3587-11eb-1d86-b9054c8f634d
# ╟─56866718-e6ce-11ea-0804-d108af4e5653
# ╠═bccf0e88-e754-11ea-3ab8-0170c2d44628
# ╟─e7abd366-e7a6-11ea-30d7-1b6194614d0a
# ╟─d62f223c-e754-11ea-2470-e72a605a9d7e
# ╠═4896bf0c-e754-11ea-19dc-1380bb356ab6
# ╠═7a01a508-e78a-11ea-11da-999d38785348
# ╠═713b0250-3582-11eb-21c0-cdc001fc35ee
# ╠═682db9f8-e7b1-11ea-3949-6b683ca8b47b
# ╠═088cc652-e7a8-11ea-0ca7-f744f6f3afdd
# ╟─c18dce7a-e7a7-11ea-0a1a-f944d46754e5
