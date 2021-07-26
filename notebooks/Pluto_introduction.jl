### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ b5094370-ee11-11eb-3e48-b3a77979f99a
md"""# An Introduction To Pluto
Welcome dear reader to this short introduction to Pluto. Knowing how to use Pluto is your first step towards working in an interactive environment with the `Julia` language!

In the rest of this notebook you'll find some handy **tips** and **tricks** to get you up and running in no time. 
Good luck!
"""

# ╔═╡ 2dd30617-8deb-4762-9cc3-55f6ef341505
md"""## The very beginning
If you're here that means that you have already done this part!
But just for completion let us repeat what you need to do to start a `Pluto` notebook.
1. Open your `Julia` PERL (the application you downloaded from the Julia site)
2. Type `using Pluto` : This will load the Pluto module for you.
3. Type `Pluto.run()` : This starts your Pluto environment in your standard browser.
4. Select the notebook you want to open by typing the **path** to it or by inserting the **url** to the notebook. 
"""

# ╔═╡ f5630f3c-b0eb-4b60-a428-da21b8a68416
md"""## Presentation Mode
Yes you are reading this correctly! Next to being very interactive and easy to learn you can also make presentations in Pluto.
This is not yet implemented in a 'nice' way but we can access it through a backdoor.
By typing the following code in an empty cell you'll create a button that allows you to enter presentation mode. `html"<button onclick='present()'>present</button>"`

When in presentation mode, all second order headings or higher will start a new slide. So to start a new slide just type `md"## cool title"` in an empty cell and you are good to go!

To exit presentation mode, just click again on the same button.
"""

# ╔═╡ ec19c690-5784-4cc4-a63b-5d2485eeafa9
html"<button onclick='present()'>present</button>"

# ╔═╡ 2a83d1e3-79c2-4a36-93b2-1bf2f89b27f3
md"## This starts a new slide"

# ╔═╡ 5a1f85e6-f9c6-44b7-a2d4-6b70d65aeaef
md"### This doesn't"

# ╔═╡ 4b0bca9a-426f-4157-935d-cf67cd03f201
md"""## Export Modes
If you want to export your current notebook there are a couple of ways and formats to do this with.

### Formats
There are 3 different formats as which you can export a notebook:
1. A notebook
2. A static HTML file (if you want to make static sites in Pluto)
3. A PDF file

### How to do it?
There are (at the moment) two ways to do this:
1. The most easy way to do this is by just scrolling to the top of your notebook, clicking the export button (looks like a triangle on top of a circle).
2. To automatically export your notebook to a pdf you first need to install the PlutoPDF package. This can be done with the following code `import Pkg; Pkg.add(url="https://github.com/JuliaPluto/PlutoPDF.jl")`. Next you just need to run the following code in Julia: `import PlutoPDF` followed by `PlutoPDF.pluto\_to\_pdf("notebook.jl")`. More info about this package can be found [here](https://github.com/JuliaPluto/PlutoPDF.jl).

"""

# ╔═╡ c0b21f0b-f0a5-46fc-aa65-2067a66deff7
# not te onderzoeken: https://cotangent.dev/how-to-publish-pluto-jl-notebooks-online-interactively/

# ╔═╡ Cell order:
# ╟─b5094370-ee11-11eb-3e48-b3a77979f99a
# ╟─2dd30617-8deb-4762-9cc3-55f6ef341505
# ╟─f5630f3c-b0eb-4b60-a428-da21b8a68416
# ╟─ec19c690-5784-4cc4-a63b-5d2485eeafa9
# ╟─2a83d1e3-79c2-4a36-93b2-1bf2f89b27f3
# ╟─5a1f85e6-f9c6-44b7-a2d4-6b70d65aeaef
# ╟─4b0bca9a-426f-4157-935d-cf67cd03f201
# ╠═c0b21f0b-f0a5-46fc-aa65-2067a66deff7
