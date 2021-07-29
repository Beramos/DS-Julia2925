### A Pluto.jl notebook ###
# v0.15.1

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

# ╔═╡ 7a8e5f68-beb1-41d4-af1f-4b89e5bbf388
begin
	using PlutoUI
	md"🦆 : $(@bind ducksize Slider(20:500, default=200))"
end

# ╔═╡ e703ea17-554a-4932-a20c-5e5975f4372a
begin
using HypertextLiteral
md"""Select your **settings** below:\
*Background color*: $(@bind bg_color html"<input type=color value='#00eeff'>")\
*Font*: $(@bind font_type Select(["cursive","serif","sans-serif","monospace","fantasy"]))\
*Font size*: $(@bind font_size NumberField(10:40, default=20))\
"""
end

# ╔═╡ b5094370-ee11-11eb-3e48-b3a77979f99a
md"""# An Introduction To Pluto
Welcome, dear reader, to this short introduction to Pluto. Knowing how to use Pluto is your first step towards working in an interactive environment with the `Julia` language!

In the rest of this notebook you'll find some handy **tips** and **tricks** to get you up and running in no time. 

Good luck!
"""

# ╔═╡ 2dd30617-8deb-4762-9cc3-55f6ef341505
md"""## The Very Beginning
If you're here that means that you have already done this part!
But just for completion let us repeat what you need to do to start a `Pluto` notebook.
1. Open your `Julia` PERL (the application you downloaded from the Julia site)
2. Type `using Pluto` : This will load the Pluto module for you.
3. Type `Pluto.run()` : This starts your Pluto environment in your standard browser.
4. Select the notebook you want to open by typing the **path** to it or by inserting the **url** to the notebook. 
"""

# ╔═╡ bc216d83-20ba-4efb-b201-bff73a83f5af
md"""## Interacting With Pluto 
In this section we will quickly explain to you how to run notebooks and interact with them.

To begin with when you open a Pluto notebook, every cell is loaded and executed. So you may want to wait a couple of seconds before typing/working in a notebook.
"""

# ╔═╡ 8d9a48e4-382f-49a1-9f51-ab549a5b7039
md"""If you want to load a cell yourself you have two options. The first one is to just click the grey ▶ button in the bottom right corner. The second way is by pressing `Ctrl + Shift`. This will cause your current cell to be executed but it will also cause all the *related* cells to update. This way Pluto always keep your whole notebook up to date. Try to run the cell below. See how the other cell changes its output as well?"""

# ╔═╡ 288f2701-aa8e-4a81-b334-b58bcdc74ae7
duckcount = 2

# ╔═╡ 5bb6c26d-4d0f-47b4-8a47-e7d436be4892
repeat("🦆",duckcount)

# ╔═╡ 75f401fc-03eb-465a-a218-68b6ccc544d1
md"""Want to see the code behind a certain cell? Easy, just click on the 👁 button to the left of this cell. Go on! Try it with this cell."""

# Congrats! See how easy this is?

# ╔═╡ 22a6d095-e48f-4a56-9587-bca63beedf99
md"""If you're feeling ready to start typing yourself then you can create a new cell by clicking on the `+` icon on the upper or lower left corner of this cell.

Lastly we want to mention that if you want to remove a cell or just disable it temporary, you can so so by clicking on the `...` circle on the left side of your cell. Not seeing this button? That's normal! You'll only see this symbol when you are inside a code cell. (remember you can do this with the 👁 button).
"""

# ╔═╡ 1bffea5a-dd8d-4156-88d4-b6b614436881
md"""## Markdown and Pluto 
You may have noticed that there is a bit of markup inside this notebook. The nice thing in Pluto is that it's really easy to do this. You can just use the `Markdown` language inside these notebooks. To start a `Markdown` part, just type `md"your text here"`. Want to type a big chunck of markdown text? Use `md\"""Your big chunk of text\"""` this way you can also use backspaces inside your markdown. 

Not really familiar with the `Markdown` language? Don't worry it is really easy to learn, all the info you'll ever need can be found [here](https://www.markdownguide.org/cheat-sheet/).

Another nice thing to know is that you can use `Latex` and `unicode` symbols in Pluto. `Latex` gives you easy access to symbols like `α` (just type `\alpha<TAB>`). `Unicode` makes it so you can use all the smileys you love in your text and even as variable names! (big 🧠 time). 
Again if you don't know any Latex or Unicode symbols you can just look them up on there respective pages. Just click [here](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols) for **Latex** and [here](https://unicode.org/emoji/charts/full-emoji-list.html) for **Unicode**. 
"""

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

2. To automatically export your notebook to a pdf you first need to install the PlutoPDF package. This can be done with the following code `import Pkg; Pkg.add(url="https://github.com/JuliaPluto/PlutoPDF.jl")`. Next you just need to run the following code in Julia: `import PlutoPDF` followed by `PlutoPDF.pluto_to_pdf("notebook.jl")`. More info about this package can be found [here](https://github.com/JuliaPluto/PlutoPDF.jl).

"""

# ╔═╡ c6363449-3b51-4f25-ab41-c0cde7f0565c
md"""## Making It Interactive
To end the introduction, you will learn how to give your notebook that extra portion of interactivity.

Pluto allows you to use `Javascript` inside your notebook. Most people don't know `Javascript` so that's where `PlutoUI` comes to the rescue! Activate this by typing `using PlutoUI` at the top of your new notebook. By simply typing `@bind varname Slider(5:10)` you can make a nice slider. The value of the variable `varname` will now change depending on where you put the slider. Inside the `Slider` function you put `(minimal value : maximal value)`. Sliders are of course not the only thing you can use, there is a whole range interaction tools. You can learn about all of them inside the sample notebook *Sample Interactivity*. These sample notebooks can be found by clicking on the **Pluto.jl** logo at the top of your notebook and then selecting the *sample notebooks* option at the start menu.

To give you a little example, just play with the slider below and see what happens.
"""

# ╔═╡ 34971682-5962-4e58-aa18-bf155256c49f
Resource("https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Male_mallard_duck_2.jpg/1920px-Male_mallard_duck_2.jpg", :width => ducksize)

# ╔═╡ b3b85049-733d-4d05-b734-051949a61468
md"""# The Advanced Stuff
If you just want to use Pluto as you Julia environment then you know everything you need to know by now 🥳. However if you would like to know how to change the layout of your Pluto notebooks, add extra functionality, make a presentation in Pluto and how to publish it only as an interactive notebook. Then the next parts are for you!
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

# ╔═╡ 6b20de32-f606-45d1-a800-b4cdadc33017
md"""## Javascript, HTML and CSS 
As the title already tells you, it is indeed possible to tailor Pluto notebooks to your own preferences. Because you can actually use `Javascript, HTML and CSS` in Pluto notebooks. To do this you just install the module called `HypertextLiteral` by typing `using HypertextLiteral` at the beginning of your notebook. This allows you to use the `@htl()` macro in which you can start typing your Hypertext code encapsulated by \""".  If you would like some more info about this or a sneakpeak of its applications, then take a look at the sample notebook called *sample JavaScript* that you can find at the sample notebook section. 

Below you will find an example of what you can do by combining these languages in Pluto.
"""

# ╔═╡ d1739e3b-6363-4a77-8d7c-61b6ba8978bd
@htl("""

<article class="learning">
	<p>
		This is a little example of how you can use the automatic update function of Pluto to your advantage. By binding the right variables you can completely let the user choose how their notebook looks! Isn't that great?
	</p>
</article>


<style>

	article.learning {
		background: $(bg_color);
		padding: 1em;
		border-radius: 5px;
		font-size: $(font_size)px;
		font-family: $(font_type);
	}
</style>
""")

# ╔═╡ 3acc7d2e-7c54-423c-aac8-1f8f61963d77
md"""And this is how the above cell looks in `HTML` and `CSS` code:
```htmlmixed
<article class="learning">
	<p>
		This is a little example of how you can use the automatic update function of Pluto to your advantage. By binding the right variables you can completely let the user choose how their notebook looks! Isn't that great?
	</p>
</article>


<style>

	article.learning {
		background: $(bg_color);
		padding: 1em;
		border-radius: 5px;
		font-size: $(font_size)px;
		font-family: $(font_type);
	}
</style>
```

"""

# ╔═╡ 4c1ea155-df57-4b1b-94f7-c638e7f747c2
md"""## Publishing Your Notebook Online 
Lastly we will take a small look at how you could post your interactive notebook online so that other people can also access it without using Julia.

At the moment this still isn't implemented in Pluto. It is however as we mentioned earlier possible to make a static version of your notebook.
But if you really want to have an up and running version of your notebook that everyone can access, then there are two main ways at the moment.

1. The first and easiest option is to use [Binder](https://github.com/fonsp/pluto-on-binder). This gives an easy and free way of running your notebook online. However it can take a long time to load.


2. The second way is a bit more complicated. In short you will run your notebook through `GitHub` and use a (payed) server to take care of the interactive part. If you don't have a server laying around this may not be for you. If you want to find out more about this you can read all about it [here](https://cotangent.dev/how-to-publish-pluto-jl-notebooks-online-interactively/)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─b5094370-ee11-11eb-3e48-b3a77979f99a
# ╟─2dd30617-8deb-4762-9cc3-55f6ef341505
# ╟─bc216d83-20ba-4efb-b201-bff73a83f5af
# ╟─8d9a48e4-382f-49a1-9f51-ab549a5b7039
# ╠═288f2701-aa8e-4a81-b334-b58bcdc74ae7
# ╟─5bb6c26d-4d0f-47b4-8a47-e7d436be4892
# ╟─75f401fc-03eb-465a-a218-68b6ccc544d1
# ╟─22a6d095-e48f-4a56-9587-bca63beedf99
# ╟─1bffea5a-dd8d-4156-88d4-b6b614436881
# ╟─4b0bca9a-426f-4157-935d-cf67cd03f201
# ╟─c6363449-3b51-4f25-ab41-c0cde7f0565c
# ╟─7a8e5f68-beb1-41d4-af1f-4b89e5bbf388
# ╟─34971682-5962-4e58-aa18-bf155256c49f
# ╟─b3b85049-733d-4d05-b734-051949a61468
# ╟─f5630f3c-b0eb-4b60-a428-da21b8a68416
# ╟─ec19c690-5784-4cc4-a63b-5d2485eeafa9
# ╟─2a83d1e3-79c2-4a36-93b2-1bf2f89b27f3
# ╟─5a1f85e6-f9c6-44b7-a2d4-6b70d65aeaef
# ╟─6b20de32-f606-45d1-a800-b4cdadc33017
# ╟─e703ea17-554a-4932-a20c-5e5975f4372a
# ╟─d1739e3b-6363-4a77-8d7c-61b6ba8978bd
# ╟─3acc7d2e-7c54-423c-aac8-1f8f61963d77
# ╟─4c1ea155-df57-4b1b-94f7-c638e7f747c2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
