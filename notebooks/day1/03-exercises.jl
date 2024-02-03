### A Pluto.jl notebook ###
# v0.19.37

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ cf4e10a8-4862-11eb-05fd-c1a09cbb1bcd
using PlutoUI, Plots; TableOfContents()

# ╔═╡ ba2c4c6b-d1bc-47cc-a13e-db2e5bab414d
using Colors

# ╔═╡ c41426f8-5a8e-11eb-1d49-11c52375a7a0
using Images

# ╔═╡ 786b3780-58ec-11eb-0dfd-41f5af6f6a39
# edit the code below to set your name and UGent username

student = (name = "Jan Janssen", email = "Jan.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ dd3bc556-8f41-4de1-8350-54fd99c1d83e
md"""
Submission by: **_$(student.name)_**
"""

# ╔═╡ d46c00c9-f65c-4cf4-a6b7-e9eb1c000460
begin
	hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));
	fyi(text) = Markdown.MD(
		Markdown.Admonition("info",
			"Additional info",
			[fyi_css,
				text
			]
		)
	)
	md"""
	# Project 1: images and cellular automata
	
	We wrap up day 1 by exploring convolutions and similar operations on 1-D and 2-D (or even n-D!) matrices. Departing from some basic building blocks we will cover signal processing, image processing and cellular automata!
	
	**Learning goals:**
	- code reuse;
	- efficient use of collections and unitRanges;
	- control flow in julia;
	
	"""
end

# ╔═╡ e1147d4e-2bee-11eb-0150-d7af1f51f842
md"""
## 1-D convolutions

We will start with local operations in 1-D, i.e., processing a vector to obtain a new vector. Such operations are important in signal processing if we want to smoothen a noisy signal for example but the operations are also used in bioinformatics and complex systems. 

A one-dimensional convolution is defined as follows,

$$y_i = \sum_{k=-m}^{m} x_{i + k} w_{m+k+1}$$

and can be seen as a *local weighted average* of a vector:
- local means that, for each element of the output, we only consider a small subregion of our input vector;
- weighted average means that within this region, we might not give every element an equal importance.

Let us first consider the regular mean:

$$\frac{1}{n}\sum_{i=1}^n x_i\,.$$

The function `mean` is not in the `Base` of Julia but can easily be imported from `StatsBase`. Let's implement it ourselves instead!
"""

# ╔═╡ b8a69910-8c8a-423c-aa13-1d1fab2fe10b
md"""
>**Assignment:** Compute the mean.
"""

# ╔═╡ f272855c-3c9e-11eb-1919-6b7301b15699
function mean(x)
	return missing
end

# ╔═╡ 66a20628-4834-11eb-01a2-27cc2b1ec7be
x = [2.1, 3.2, 5.4, 4.9, 6.1]

# ╔═╡ 432c3892-482c-11eb-1467-a3b9c1592597
mean(x)

# ╔═╡ 788b7f25-a2b6-4b97-99d5-3ecf01473c3d
md"""
		So, for this regular mean, we give an equal weight to every element: every $x_i$ is equally important in determining the mean. In some cases, however, we know that some positions are more important than others in determining the mean. For example, we might know the measurement error for each point. In this case, it is sensible to give a weigth inversely proportional to the measurement error. 
		
		In general, the weighted mean is computed as:
		
		$$\sum_{i=1}^n w_ix_i\,,$$

		were, $w_i$ are the weights of data point $x_i$. In order for the weighted mean to make sense, we assume that all these weights are non-zero and that they add up to 1.

		Implement the weighted mean. Do it in a one-liner.
		"""

# ╔═╡ 9f54a75d-adb6-486b-8e11-775813ecaa1c
md"""
>**Assignment:** Compute the weighted mean.
"""

# ╔═╡ a657c556-4835-11eb-12c3-398890e70105
md"We compute the mean again, now using the information that the numbers were collected subsequently and that we give a weight linearly proportional to the position (points further away have a lower contribution to the mean),

$$w_i = \cfrac{i}{\sum_j^n j} \, .$$

For example,

$$[w_1, w_2, w_3] = [1/6, 2/6, 3/6]\, .$$

"

# ╔═╡ 88c10640-4835-11eb-14b0-abba18da058f
weighted_mean(x, w) = missing

# ╔═╡ 181c4246-4836-11eb-0368-61b2998f5424
wx = collect((1:3) / sum(1:3))

# ╔═╡ 94a950fe-4835-11eb-029c-b70de72c20e6
weighted_mean(x, wx)

# ╔═╡ 52706c6a-4836-11eb-09a8-53549f16f5c2
md"Note that:"

# ╔═╡ 4dc28cdc-4836-11eb-316f-43c04639da2a
sum(wx)

# ╔═╡ 8b4c6880-4837-11eb-0ff7-573dd18a9664
md"""
Now back to our one-dimensional convolution,

$$y_i = \sum_{k=-m}^{m} x_{i + k} w_{m+k+1}\,,$$

a vector $\mathbf{x}$ of length $n$ is transformed in a convolved vector $\mathbf{y}$ (also length $n$). The convolution is determined by a **kernel** or **filter** $\mathbf{w}$ of length $2m+1$ (chosen such that it has an odd length). You can see element $y_i$ as a weighted mean of the elements $x_{i-m}, x_{i-m+1},\ldots, x_{i+m-1}, x_{i+m}$.

When computing convolutions (or in numerical computing in general) one has to be careful with the **boundary conditions**. We cannot compute the sum at the ends since the sum would exceed the vector $\mathbf{x}$. There are many sensible ways to resolve this, we will choose the simplest solution of repeating the boundaries by setting $x_i = x_1$ when $i< 1$ and $x_i = x_n$ when $i>n$.
"""

# ╔═╡ 9407fda7-9442-4a1a-a8f2-e2c3fd69ae60
md"""
> **Assignment:** one-dimensional convolution.
>
> Implement the one-dimensional convolution,
>
> $$y_i = \sum_{k=-m}^{m} x_{i + k} w_{m+k+1}\,,$$
>
>by completing the function `convolve_1d(x::Vector, w::Vector).`
>
> This function should be able to take any vector x and compute the convolution with any weight vector that matches the specification of a weight vector (see previously). 
"""

# ╔═╡ bc67a0a6-d5f1-4404-9406-acb05857361d
hint(
	md"""
	Did you take into account the boundary conditions? The function `clamp` can help you with that.
	"""
)

# ╔═╡ a1f75f4c-2bde-11eb-37e7-2dc342c7032a
function convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	@assert length(w) < length(x) "length of `w` should be smaller than `x`"
	n = missing
	m = missing
	y = zeros(size(x)) # initialize the output

	# ... complete
	return y
end

# ╔═╡ 7945ed1c-598c-11eb-17da-af9a36c6a68c
md"""
Let's try this out on an example, consider a noisy signal,
"""

# ╔═╡ 546beebe-598d-11eb-1717-c9687801e647
noisy_signal(tᵢ; σ=10) = 5tᵢ + 5sin(tᵢ) +  σ * rand();

# ╔═╡ f39d88f6-5994-11eb-041c-012af6d3bae6
md"We use the convolution function we defined to construct a moving_average function,"

# ╔═╡ f94e2e6c-598e-11eb-041a-0b6a068e464c
moving_average(y, w) = convolve_1d(y, ones(w).*1/w);

# ╔═╡ 4e45e43e-598f-11eb-0a0a-2fa636748f7c
@bind wₑ Slider(1:2:43, default=3)

# ╔═╡ 0563fba2-5994-11eb-2d81-f70d10092ad7
md"Number of weights (w) : $wₑ"

# ╔═╡ 8e53f108-598d-11eb-127f-ddd5be0ec899
begin 
	t = 0:0.01:10
	signal = noisy_signal.(t) 
	plot(t, signal, label="Noisy", ylabel="Signal (-)", xlabel="time(s)")
	plot!(t, moving_average(signal, wₑ), label="Filtered", lw = 2)
end

# ╔═╡ eec85f98-ae75-451e-b8bf-89271c8f4950
md"""
	> Explore this filtering technique by changing the number of weights. Try to understand how the `moving_average` function behaves.
	"""

# ╔═╡ 99a7e070-5995-11eb-0c53-51fc82db2e93


# ╔═╡ 6d0288d9-84a1-4380-bf37-feb9dad866e5
md"""
> **Assignment**: common weight vectors
>
> Let us test some different weight vectors, several options seem reasonable:
> For this purpose, make sure that they are all normalized, either by design or by divididing the vector by the total sum at the end.

"""

# ╔═╡ 2b6303b0-cbc6-4ab2-abc5-c55793548b0e
md"""
> **uniform weight vector**: all values of $\mathbf{w}$ are the same;
"""

# ╔═╡ c98a6330-c133-4309-a374-e897051d7bf6
m₁ = 3

# ╔═╡ 7c12bcf6-4863-11eb-0994-fb7d763c0d47
function uniform_weights(m)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ 64bf7f3a-58f0-11eb-1782-0d33a2b615e0
begin 
	Wu = uniform_weights(m₁)
	fs = (600, 280)
	
	pl31 = scatter(1:length(Wu), Wu; label="", xlabel="weights", size=fs,
	background_color="#F8F8F8", ms = 6)
	title!("Your result:")
end

# ╔═╡ e0188352-3771-4249-9bf1-f9c7f39ee3c8


# ╔═╡ 6f4e6870-8d82-4b39-b2fd-9d340150a414
md"""
> **[triangle](https://en.wikipedia.org/wiki/Triangular_function) weight function**: linearly increasing from index $i=1$ till index $i=m+1$ and linearly decreasing from $i=m+1$ to $2m+1$;
"""

# ╔═╡ 294140a4-2bf0-11eb-22f5-858969a4640d
function triangle_weights(m)
	w = zeros(2m+1)
	# complete and replace [0.0]
	return [0.0]
end	

# ╔═╡ 91c7e17b-28a5-44ed-8c92-ee8a36d71a69
begin
	try
		global Wt = triangle_weights(m₁)
	catch e 	
	end
	pl33 = scatter(1:length(Wt), Wt; label="", ylims=[0, 1.5maximum(Wt)], xlabel="weights", size=fs,
	background_color="#F8F8F8", ms = 6)
	title!("Your result:")
end


# ╔═╡ 6d725252-b1de-4439-aab5-d2b4361947b5
md"""
> **Gaussian weight function**: proportional to $\exp(-\frac{(i-m - 1)^2}{2\sigma^2})$ with $i\in 1,\ldots,2m+1$. The *bandwidth* is given by $\sigma$, let us set it to 4. """

# ╔═╡ d8c7baac-49be-11eb-3afc-0fedae12f74f
function gaussian_weights(m; σ=4)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ 2b8cbdc9-4c6d-44c9-8dae-47487a01f577
begin
	try
		global Wg = gaussian_weights(m₁)
		pl34 = scatter(1:length(Wg), Wg; label="", xlabel="weights", size=fs,
		background_color="#F8F8F8", ms = 6)
		title!("Your result:")
	catch e 
	end
end


# ╔═╡ 1f5fca26-af78-4a20-9017-83366a5118f4


# ╔═╡ b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
md"""
### Application: protein analysis


A protein (polypeptide chain) is a sequence of amino acids, small molecules with unique physicochemical properties that largely determine the protein structure and function. 

![source: technology networks.com](https://cdn.technologynetworks.com/tn/images/thumbs/webp/640_360/essential-amino-acids-chart-abbreviations-and-structure-324357.webp?v=10459598)

In bioinformatics, the 20 common amino acids are denoted by 20 capital letters, `A` for alanine, `C` for cysteine, etc. Many interesting local properties can be computed by looking at local properties of amino acids. For example, the (now largely outdated) **Chou-Fasman method** for the prediction the local three-dimensional shape of a protein ($\alpha$-helix or $\beta$-sheet) uses a sliding window to check if regions are enriched for amino acids associated with $\alpha$-helices or $\beta$-sheets.

We will study a protein using a sliding window analysis by making use of the **amino acid z-scales**. These are three physicochemical properties of an amino acid. 

In order, they quantify:
1. *lipophilicity*: the degree in which the amino acid chain is lipidloving (and hence hydrophopic);
2. *steric properties*: how large and flexible the side chains are;
3. *electric properties*, polarity, such as positive and negative charges present. Negative values for apolar, positive values for polar.

The three z-scales for each of the amino acids is given in dictionaries below.
"""

# ╔═╡ 87610484-3ca1-11eb-0e74-8574e946dd9f
# quantifies lipophilicity
zscales1 = Dict(
  'E' => 3.11,
  'C' => 0.84,
  'D' => 3.98,
  'A' => 0.24,
  'R' => 3.52,
  'G' => 2.05,
  'N' => 3.05,
  'F' => -4.22,
  'M' => -2.85,
  'K' => 2.29,
  'P' => -1.66,
  'Q' => 1.75,
  'I' => -3.89,
  'H' => 2.47,
  'W' => -4.36,
  'S' => 2.39,
  'T' => 0.75,
  'L' => -4.28,
  'Y' => -2.54,
  'V' => -2.59,)

# ╔═╡ 9c82d5ea-3ca1-11eb-3575-f1893df8f129
# quantifies steric properties (Steric bulk/Polarizability)
zscales2 = Dict(
	'E' => 0.26,
  'C' => -1.67,
  'D' => 0.93,
  'A' => -2.32,
  'R' => 2.5,
  'G' => -4.06,
  'N' => 1.62,
  'F' => 1.94,
  'M' => -0.22,
  'K' => 0.89,
  'P' => 0.27,
  'Q' => 0.5,
  'I' => -1.73,
  'H' => 1.95,
  'W' => 3.94,
  'S' => -1.07,
  'T' => -2.18,
  'L' => -1.3,
  'Y' => 2.44,
  'V' => -2.64,)

# ╔═╡ a4ccb496-3ca1-11eb-0e7a-87620596eec1
# quantifies electronic properties such as polarity and charge
zscales3 = Dict(
	'E' => -0.11,
  'C' => 3.71,
  'D' => 1.93,
  'A' => 0.6,
  'R' => -3.5,
  'G' => 0.36,
  'N' => 1.04,
  'F' => 1.06,
  'M' => 0.47,
  'K' => -2.49,
  'P' => 1.84,
  'Q' => -1.44,
  'I' => -1.71,
  'H' => 0.26,
  'W' => 0.59,
  'S' => 1.15,
  'T' => -1.12,
  'L' => -1.49,
  'Y' => 0.43,
  'V' => -1.54,)

# ╔═╡ 9f62891c-49c2-11eb-3bc8-47f5d2e008cc
md"""
So, we will compute a sliding window of length $2m+1$ on a protein sequence $s$:

$$y_i = \frac{1}{2m+1} \sum_{k=-m}^m z_{s_{i-k}}\,,$$

where $z_{s_{i}}$ is the amino acid property ascociated with amino acid $s_i$.
"""

# ╔═╡ 328385ca-49c3-11eb-0977-c79b31a6caaf
md"To be topical, let us try it on the tail spike protein of the SARS-CoV-2 virus. (a baby step towards a new vaccin!)"

# ╔═╡ c924a5f6-2bf1-11eb-3d37-bb63635624e9
spike_sars2 = "MFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKVFRSSVLHSTQDLFLPFFSNVTWFHAIHVSGTNGTKRFDNPVLPFNDGVYFASTEKSNIIRGWIFGTTLDSKTQSLLIVNNATNVVIKVCEFQFCNDPFLGVYYHKNNKSWMESEFRVYSSANNCTFEYVSQPFLMDLEGKQGNFKNLREFVFKNIDGYFKIYSKHTPINLVRDLPQGFSALEPLVDLPIGINITRFQTLLALHRSYLTPGDSSSGWTAGAAAYYVGYLQPRTFLLKYNENGTITDAVDCALDPLSETKCTLKSFTVEKGIYQTSNFRVQPTESIVRFPNITNLCPFGEVFNATRFASVYAWNRKRISNCVADYSVLYNSASFSTFKCYGVSPTKLNDLCFTNVYADSFVIRGDEVRQIAPGQTGKIADYNYKLPDDFTGCVIAWNSNNLDSKVGGNYNYLYRLFRKSNLKPFERDISTEIYQAGSTPCNGVEGFNCYFPLQSYGFQPTNGVGYQPYRVVVLSFELLHAPATVCGPKKSTNLVKNKCVNFNFNGLTGTGVLTESNKKFLPFQQFGRDIADTTDAVRDPQTLEILDITPCSFGGVSVITPGTNTSNQVAVLYQDVNCTEVPVAIHADQLTPTWRVYSTGSNVFQTRAGCLIGAEHVNNSYECDIPIGAGICASYQTQTNSPRRARSVASQSIIAYTMSLGAENSVAYSNNSIAIPTNFTISVTTEILPVSMTKTSVDCTMYICGDSTECSNLLLQYGSFCTQLNRALTGIAVEQDKNTQEVFAQVKQIYKTPPIKDFGGFNFSQILPDPSKPSKRSFIEDLLFNKVTLADAGFIKQYGDCLGDIAARDLICAQKFNGLTVLPPLLTDEMIAQYTSALLAGTITSGWTFGAGAALQIPFAMQMAYRFNGIGVTQNVLYENQKLIANQFNSAIGKIQDSLSSTASALGKLQDVVNQNAQALNTLVKQLSSNFGAISSVLNDILSRLDKVEAEVQIDRLITGRLQSLQTYVTQQLIRAAEIRASANLAATKMSECVLGQSKRVDFCGKGYHLMSFPQSAPHGVVFLHVTYVPAQEKNFTTAPAICHDGKAHFPREGVFVSNGTHWFVTQRNFYEPQIITTDNTFVSGNCDVVIGIVNNTVYDPLQPELDSFKEELDKYFKNHTSPDVDLGDISGINASVVNIQKEIDRLNEVAKNLNESLIDLQELGKYEQYIKWPWYIWLGFIAGLIAIVMVTIMLCCMTSCCSCLKGCCSCGSCCKFDEDDSEPVLKGVKLHYT"

# ╔═╡ 7e96f0d6-5999-11eb-3673-43f7f1fa0113
m = 5

# ╔═╡ 3e40ce8d-612d-4ead-be99-7cbb0f7e242d
md"""
> **Question: complete protein sliding window**
>
> Complete the function `protein_sliding_window` and play around with the parameters. Can you discover a strongly non-polar region in the protein?
>
> Plot the 3rd zscale versus the index of the amino acids in the tail-spike.
"""

# ╔═╡ 2d4e1bf0-1b99-4307-909b-53b43586509b
hint(md"Try to increase the window size for clearer results.")

# ╔═╡ c23ff59c-3ca1-11eb-1a31-2dd522b9d239
function protein_sliding_window(sequence, m, zscales)
	return missing
end

# ╔═╡ 17e7750e-49c4-11eb-2106-65d47b16308c
proteinsw = protein_sliding_window(spike_sars2, m, zscales3)

# ╔═╡ 236f1ee8-64e2-11eb-1e60-234754d2c10e


# ╔═╡ 0b847e26-4aa8-11eb-0038-d7698df1c41c
md"""
### Intermezzo: What is an image?

An image is generally just a matrix of pixels. What is a pixel? Usually this corresponds to just a particular color (or grayscale). So let us play around with colors first.

There are many ways to encode colors. For our purposes, we can just work with the good old RGB scheme, where each color is described by three values, respectively the red, green and blue fraction.
"""

# ╔═╡ e3f4c82a-5a8d-11eb-3d7d-fd30c0e4a134
daanbeardred = RGB(100/255, 11/255, 13/255)

# ╔═╡ c3a51344-5a8e-11eb-015f-bd9aa28aa6eb
md"We can extract the red, green, and blue components using the obvious functions."

# ╔═╡ c3ac56e0-5a8e-11eb-3520-279c4ba47034
red(daanbeardred), green(daanbeardred), blue(daanbeardred)

# ╔═╡ c3dc3798-5a8e-11eb-178d-fb98d87768bf
md"Converting a color to grayscale is also easy."

# ╔═╡ c3e02c4a-5a8e-11eb-2c2e-b5117c5310a3
Gray(daanbeardred)

# ╔═╡ c41f1cb6-5a8e-11eb-326c-db30e518a702
md"An image is a matrix of colors, nothing more!"

# ╔═╡ c44eb368-5a8e-11eb-26cd-d9ba694ac760
mini_image = [RGB(0.8, 0.6, 0.1) RGB(0.2, 0.8, 0.9) RGB(0.8, 0.6, 0.1);
				RGB(0.2, 0.8, 0.9) RGB(0.8, 0.2, 0.2) RGB(0.2, 0.8, 0.9);
				RGB(0.8, 0.6, 0.1) RGB(0.2, 0.8, 0.9) RGB(0.8, 0.6, 0.1)]

# ╔═╡ c4541a1a-5a8e-11eb-3b09-c3adb3794723
mini_image[2, 2]

# ╔═╡ c48a7a24-5a8e-11eb-2151-f5b99da0039b
size(mini_image)

# ╔═╡ c4901d26-5a8e-11eb-1786-571c99fa50e2
red.(mini_image), green.(mini_image), blue.(mini_image)

# ╔═╡ c4c2df5e-5a8e-11eb-169b-256c7737156a
Gray.(mini_image)

# ╔═╡ c4dc60a0-5a8e-11eb-3070-3705948c7c93
function redimage(image)
	return RGB.(red.(image), 0, 0)
end

# ╔═╡ c4e02064-5a8e-11eb-29eb-1d9cc2769121
function greenimage(image)
	return RGB.(0, green.(image), 0)
end

# ╔═╡ c512c06e-5a8e-11eb-0f57-250b65d242c3
function blueimage(image)
	return RGB.(0, 0, blue.(image))
end

# ╔═╡ c52bc23a-5a8e-11eb-0e9a-0554ed5c632e
redimage(mini_image), greenimage(mini_image), blueimage(mini_image)

# ╔═╡ e5ff8880-5a8d-11eb-0c7f-490c48170654
url = "https://i.imgur.com/BJWoNPg.jpg"

# ╔═╡ 12c363d6-5a8f-11eb-0142-b7a2bee0dad2
download(url, "aprettybird.jpg") # download to a local file

# ╔═╡ 12c9c136-5a8f-11eb-3d91-5d121b8999d5
bird_original = load("aprettybird.jpg")

# ╔═╡ 12fd8282-5a8f-11eb-136c-6df77b026bd4
typeof(bird_original)

# ╔═╡ 13185c4c-5a8f-11eb-1164-cf745ddb0111
eltype(bird_original)

# ╔═╡ 131c000e-5a8f-11eb-0ab1-d55894321001
md"So an image is basically a two-dimensional array of Colors. Which means it can be processed just like any other array. and because of the type system, a lot of interesting features work out of the box."

# ╔═╡ 134b2bec-5a8f-11eb-15f5-ff8a1efb68a9
md"Lets the define a function to reduce the size of the image"

# ╔═╡ a8ebd04e-adfc-45a4-a08e-79d6b050c567
md"""
> **Question: decimate image**
>
> To proceed with the course we would like smaller images. Since images are just matrices it should not be too challenging to write a function that takes an `image` and resamples the number of pixels so that it is a `ratio` smaller.
"""

# ╔═╡ fa05f2a1-623f-43a6-b44e-2525a770f382
hint(md"`1:n:end` takes every `n`-th index in a matrix")

# ╔═╡ 13807912-5a8f-11eb-3ca2-09030ee978ab
decimate(image, ratio=5) = missing

# ╔═╡ 6d5de3b8-5dbc-11eb-1fc4-8df16c6c04b7
bird = decimate(bird_original, 6)

# ╔═╡ dd2d6fde-0e64-4032-9c81-16aa368ce084
typeof(bird_original)

# ╔═╡ 8e95e4c7-4d81-437f-961d-3720e599e01d
md"""
Jippie we have a smaller bird to work with. Because images are matrices we can do all kinds of cooll stuff
"""

# ╔═╡ 1e0383ac-5a8f-11eb-1b6d-234b6ad6e9fa
md"""
☼
$(@bind brightness Slider(0:0.01:4, default=1.5))
☾
"""

# ╔═╡ 1dfc943e-5a8f-11eb-336b-15b40b9fe412
brightness

# ╔═╡ 1e2ac624-5a8f-11eb-1372-05ca0cbe828d
bird ./ brightness

# ╔═╡ 1e2ebef0-5a8f-11eb-2a6c-2bc3dffc6c73
md"This is just a simple element-wise division of a matrix."

# ╔═╡ 1e5db70a-5a8f-11eb-0984-6ff8e3030923
md"""

## 2-D operations

After this colourful break, Let us move from 1-D operations to 2-D operations. This will be a nice opportunity to learn something about image processing.
"""

# ╔═╡ 4f2fbae3-1aa6-42ad-9a97-0971e63b199f
md"""
> **Exercise:**
> 
> Complete the function `convolve_2d(M::Matrix, K::Matrix)` that performs a 2D-convolution of an input matrix `M` with a kernel matrix `K`. You can use the same boundary conditions as we used for the 1D convolution.
"""

# ╔═╡ d1851bbe-5a91-11eb-3ae4-fddeff381c1b
function convolve_2d(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	#...
	return missing
end

# ╔═╡ 7d4c40d6-2aa3-4246-8554-bef080109f19
md"""
> **Exercise:**
>	
> Remember the 1-D Gaussian kernel? Its 2-D analogue is given by
>
> $$K_{i,j} = \exp\left(-\frac{(i-m - 1)^2 +(j-m-1)^2}{2\sigma^2}\right)\,.$$
>
> Using this kernel results in a smoothing operation, often refered to as a Gaussian blur. This kernel is frequently used to remove noise, but it will also remove some edges of the image. Gaussian kernel convolution gives a blurring effect making the image appearing to be viewed through a translucent screen, giving a slight [otherworldly effect](https://tvtropes.org/pmwiki/pmwiki.php/Main/GaussianGirl).
>
>
> Let us implement the Gaussian kernel by completing the function below.
"""

# ╔═╡ f5574a90-5a90-11eb-3100-dd98e3375390
function gaussian_kernel(m; σ=4)
	return missing
end

# ╔═╡ 2286d0a6-1413-4b30-8436-712e0ddf6767
md"""
> **Optional exercise (Easy):**
>
> Explore the Gaussian kernel by plotting a `heatmap` of this kernel for a given number of weights and σ.
"""

# ╔═╡ 414c791d-b0e3-4a54-b1cc-634553b355be
hint(md"""
```julia
 K_gaussian = gaussian_kernel(3, σ=2)
```
""")

# ╔═╡ bfb54354-c9fc-48da-b329-960c7138e137
hint(md"""
```julia
 heatmap(K_gaussian)
```
""")

# ╔═╡ 6d95b718-358c-459a-8aa7-eb687fc9fad7


# ╔═╡ e51c129f-9e04-4bd5-8693-09030d41d02c
md"""
> **Exercise:**
>	
> The 2D-convolution can not be directly used on images since images are matrixes of triplets of values. Write a function `convolve_image(M, K)` that performs a convolution on an images and use the previously implemented `convolve_2d(M::Matrix, K::Matrix)` function. Previously, it was demonstrated how to extract the idividual colour channels from an images. A convolution of an image is nothing more than a convolution performed on these channels, separately. To avoid inaccuracies you should convert each channel (Red, Green, Blue) to a `Float32` before convolutions.
>
> Just like we did in 1D, we can define a convolution on matrices and images:
>
> $$Y_{i,j} = \sum_{k=-m}^{m} \, \sum_{l=-m}^{m} X_{i + k,\, j+l}\, K_{m+(k+1),\, m+(l+1)}\,.$$
>
> This looks more complex but still amounts to the same thing as the 1D case. We have an $2m+1 \times 2m+1$ kernel matrix $K$, which we use to compute a weighted local sum.
>
> *Test* this new function by applying the Gaussian kernel to our favourite bird image.
"""

# ╔═╡ 26060e40-2ff0-40c9-bf1c-0b4cedddc139
hint(md"Did you take into account the boundary conditions? The function `clamp` can help you with that.")

# ╔═╡ 948052a6-89fb-4d3e-81eb-0d7bb167b8dc
hint(md""" 
You can easily convert an argument of a function by piping it into a type:  
```julia
	function(some_array_var .|> Float32, ...)
```
""")

# ╔═╡ ca0748ee-5e2e-11eb-0199-45a98c0645f2
function convolve_image(M::Matrix{<:AbstractRGB}, K::Matrix)
	return missing
end

# ╔═╡ 1e97c530-5a8f-11eb-14b0-47e7e944cba1
#bird

# ╔═╡ f58d5af4-5a90-11eb-3d93-5712bfd9920a
#convolve_image(bird, K_gaussian)

# ╔═╡ 9879be7d-0c14-4922-a33f-53afb7f239b8


# ╔═╡ 62916ec1-0784-4c69-b41f-918db1037703
begin
	function gaussian_kernel_sol(m; σ=4)
  		K = [exp(-(x^2 + y^2) / 2σ^2) for x in -m:m, y in -m:m]
		  K ./= sum(K)
		  return K
	end
	
	function convolve_2d_sol(M::Matrix, K::Matrix)
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

	function convolve_image_sol(M::Matrix{<:AbstractRGB}, K::Matrix)
		Mred = convolve_2d_sol(red.(M) .|> Float32, K)
		Mgreen = convolve_2d_sol(green.(M) .|> Float32, K)
		Mblue = convolve_2d_sol(blue.(M) .|> Float32, K)
		return RGB.(Mred, Mgreen, Mblue)
	end

	decimate_sol(image, ratio=5) = image[1:ratio:end, 1:ratio:end]
	
md"""
> **Optional question: testing some cool kernels**
>
> Kernels emphasise certain features in images and often they have a directionality. `K_x` and `K_y` are known as [Sobol filters](https://en.wikipedia.org/wiki/Sobel_operator) and form the basis of edge detection. Which is just a combination of `K₂` (x-direction) and `K₃` (y-direction),
> 
> $$G = \sqrt{G_x^2 + G_y^2}\, ,$$
> 
> which is the square-root of the sum of the squared convolution with the `K_x` kernel and the `K_y` kernel. Implement edge detection and test it on the our bird. >
>
> Different kernels can do different things. Test and implement the following kernels,
> What do you think the following kernels do?
>
> ```julia
> K₁ = [0 -1 0;   # test on blurry bird and original bird
> 	  -1 5 -1;
> 	   0 -1 0]
>	
> K_x = [1 0 -1;  # on a grayscale image
> 	   2 0 -2;
> 	   1 0 -1]
> 		
> K_y = [1 2 1;  # on a grayscale image
>        0 0 0;
> 	   -1 -2 -1]
> 		
> K₄ = [-2 -1 0;  
>        -1 1 1;
> 	   0 1 2]
> ```
"""
end

# ╔═╡ 52a87820-5e35-11eb-0392-85957277f21a
function edge_detection(M)
	return missing
end

# ╔═╡ 51c4d953-1892-4654-975b-9fc6f3e3114b


# ╔═╡ f80ab6ba-5e2f-11eb-276c-31bbd5b0fee9
K_gaussian2 = gaussian_kernel_sol(3, σ=2)

# ╔═╡ e5042bac-5e2f-11eb-28bb-dbf653abca17
blurry_bird = convolve_image_sol(decimate_sol(bird_original), K_gaussian2)

# ╔═╡ f12c025c-94a0-45a5-9feb-26131a24e79a


# ╔═╡ 4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
md"""
### Optional: Elementary cellular automata

*This is an optional but highly interesting application for the fast workers.*

To conclude our adventures, let us consider **elementary cellular automata**. These are more or less the simplest dynamical systems one can study. Cellular automata are discrete spatio temporal systems: both the space time and states are discrete. The state of an elementary cellular automaton is determined by an $n$-dimensional binary vector, meaning that there are only two states 0 or 1 (`true` or `false`). The state transistion of a cell is determined by:
- its own state `s`;
- the states of its two neighbors, left `l` and right `r`.

As you can see in the figure below, each rule corresponds to the 8 possible situations given the states of the two neighbouring cells and it's own state. Logically, one can show that there are only $2^8=256$ possible rules one can apply. Some of them are depicted below.

![](https://mathworld.wolfram.com/images/eps-gif/ElementaryCARules_900.gif)

So each of these rules can be represented by an 8-bit integer. Let us try to explore them all.
"""

# ╔═╡ b0bd61f0-49f9-11eb-0e6b-69539bc34be8
md"The rules can be represented as a unsigned integer `UInt8` which takes a value between 0 and 255."

# ╔═╡ b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
rule = UInt8(110)

# ╔═╡ fabce6b2-59cc-11eb-2181-43fe08fcbab9
println(rule)

# ╔═╡ 05973498-59cd-11eb-2d56-7dd28db4b8e5


# ╔═╡ c61755a6-49f9-11eb-05a0-01d914d305f3
md"Getting the bitstring is easy"

# ╔═╡ a6e7441a-482e-11eb-1edb-6bd1daa00390
bitstring(rule)

# ╔═╡ bec6e3d2-59c8-11eb-0ddb-79795043942d
md"This bitstring represents the transitions of the middle cell to the 8 possible situations of `l`, `r` and `s`. You can verify this by checking the state transitions for rule 110 in de figure above."

# ╔═╡ 6e184088-59c9-11eb-22db-a5858eab786d
md"The challenge with bitstrings is that the separate bits cannot be efficiently accessed so getting the $i$-th digit is a bit more tricky."

# ╔═╡ 1f6262b6-59cc-11eb-1306-0d1ca9f3f8e6


# ╔═╡ b31f6e4e-b796-4b6a-9248-8f0c465b7cb5
 md"""
> **Optional question (hard)**
>
> Can you think of a way to get the transitioned state given a rule  and a position of a bit in the bitstring? Complete the function `getbinarydigit(rule, i)`.
> For confident programmers, it is possible to do this in a single line. 
"""

# ╔═╡ b235c6c8-8773-41da-960d-09da33620e2b
hint(md"The solution is hidden in the next hint.")

# ╔═╡ ef80843e-20c7-4908-9d51-ce031da39aa4
hint(md""" 
	```julia
	getbinarydigit(rule, i) = isodd(rule >> i)
	```""")

# ╔═╡ 55309481-589d-4c77-9b14-ef6aebe2670a
hint(md"Don't worry if you don't get fully understand the oneliner, it is bitstring manipulation and is not usually part of a scientific programming curriculum.")

# ╔═╡ 3c8ed609-a813-4568-af5c-96b194111197
hint(md"A more naive and less efficient solution would be to convert the rule integer to a string (not a bitstring), which supports indexing. ")

# ╔═╡ b43157fa-482e-11eb-3169-cf4989528800
getbinarydigit(rule, i) = missing

# ╔═╡ 781d38a8-59d4-11eb-28f9-9358f132782c
[getbinarydigit(rule, i) for i in 7:-1:0]  # counting all positions

# ╔═╡ 8b6b45c6-64e2-11eb-3662-7de5e25e6faf


# ╔═╡ 2eef0c7f-2fbc-4b59-8374-fffd9d84f7d9
md"""
> **Question:** transitioning the individual states
>
> Now for the next step, given a state `s` and the states of its left (`l`) and right (`r`) neighbours, can you determine the next state under a `rule` (UInt8)?
>
> **Substask 1:** Complete `nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)`
>
> **Substask 2:** Using multiple dispatch, write a second function `nextstate(l::Bool, s::Bool, r::Bool, rule::Int)`  so that the rule can be provided as any Integer."
"""

# ╔═╡ 816bd608-3332-4a07-9f09-c7a432b0279f
hint(md"Do not forget you have just implemented `getbinarydigit(rule, i)`.")

# ╔═╡ 892be4c0-408d-4542-9c55-331cd7582a6e
hint(md"In the example of the rules displayed above, all 8 possible combinations of (`l`, `s`, `r`) always refer to the same position in the bitstring.")

# ╔═╡ 939b842e-30c8-4c9b-8988-6c470234ebb6
hint(md"`8-(4l+2s+1r)`")

# ╔═╡ 00f6e42c-59d4-11eb-31c7-d5aa0105e7cf
getbinarydigit(rule, 4true+2true+1true+1)

# ╔═╡ d2e5787c-59d2-11eb-1bbd-d79672ab8f1b
begin
	function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
		return missing
	end
	
	nextstate(l::Bool, s::Bool, r::Bool, rule::Int) = missing
end

# ╔═╡ 38e6a67c-49fa-11eb-287f-91a836f5752c
nextstate(true, true, true, rule)

# ╔═╡ 511661de-59d5-11eb-16f5-4dbdf4e93ab2
md"Now that we have this working it is easy to generate and visualise the transitions for each rule. This is not an easy line of code try to really understand these comprehensions before moving on.

> Hint: expand the output for a prettier overview of the rules."

# ╔═╡ be013232-59d4-11eb-360e-e97b6c388991
@bind rule_number Slider(0:255, default=110)

# ╔═╡ 428af062-59d5-11eb-3cf7-99533810e83c
md"Rule: $rule_number"

# ╔═╡ a808b2d0-5aff-11eb-036f-fd32a1dc92fc
md"Click on the small triangle to view the transitions."

# ╔═╡ 4776ccca-482f-11eb-1194-398046ab944a
Dict(
	(l=l, s=s, r=r) => nextstate(l, s, r, rule)
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
)					

# ╔═╡ 1afb9a16-5d8a-11eb-1ed5-875084953542
md"We made use of a simple function `cm` to map the states to a gray scale. Feel free to modify this function so that two colors are used for `true`/`false`."

# ╔═╡ 90f543e4-5d89-11eb-27c0-8572a859c1b5
cm(b) = b ? Gray(0.05) : Gray(0.95)

# ╔═╡ 95ce684a-64e2-11eb-211b-e198b0016152
cm(b::Missing) = missing;  # safe version when not complete!

# ╔═╡ 5f97da58-2bf4-11eb-26de-8fc5f19f02d2
Dict(
	cm.([l, s, r]) => [cm(nextstate(l, s, r, rule_number))]
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
				)									

# ╔═╡ c4f3732c-b646-4f97-b095-1c400955be86
md"""
> **Question:** evolving the array
>
> Now that we are able the transition the individual states, it is time to overcome the final challenge, evolving the entire array! Usually in cellular automata all the initial states transition simultaneously from the initial state to the next state.
>
> **Complete** `update1dca!(xnew, x, rule::Integer)` that performs a single iteration of the cellular automata given an initial state array `x`, and overwrites the new state array `xnew`, given a certain rule integer. For the boundaries you can assume that the vector loops around so that the first element is the neighbour of the last element.
>
> **FYI:** `!` is often used as suffix to a julia function to denote an inplace operation. The function itself changes the input arguments directly. `!` is a naming convention and does not fulfill an actual functionality"
>
> **Complete** `xnew = update1dca(x, rule::Integer)` function that performs the same action as `update1dca!` but with an explicit return of the new state array. It is possible to do this in a single line.
"""

# ╔═╡ 43222f49-766a-48ba-b55e-0409082243bb
hint(md"""`similar(x)` is a useful function to initialise a new matrix of the same type and dimensions of the array `x`	""")	

# ╔═╡ 924461c0-2bf3-11eb-2390-71bad2541463
function update1dca!(xnew, x, rule::Integer)
	return missing
end

# ╔═╡ 21440956-2bf5-11eb-0860-11127d727282
update1dca(x, rule::Integer) = missing

# ╔═╡ 405a1036-2bf5-11eb-11f9-a1a714dbf7e1
x0_ca = rand(Bool, 100)

# ╔═╡ 6405f574-2bf5-11eb-3656-d7b9c94f145a
update1dca(x0_ca, rule)

# ╔═╡ e8ddcd80-5f1c-11eb-00bb-6badc5a9ffaa


# ╔═╡ f637425d-e7f7-44d7-a8c2-4f795badc5af
md"""
> **Question:** simulating the cellular automata
>
> Now that we are able to transition the individual states, it is time to overcome the final challenge, evolving the entire array! Usually in cellular automata all the initial states transition simultaneously from the initial state to the next state.
>
> **Complete** `simulate(x0, rule::UInt8; nsteps=100)` that performs a `nsteps` of simulation  given an initial state array `x0` and a rule.
>
> **Plot** the evolution of state array at each iteration as an image.
"""

# ╔═╡ dc013365-7620-4493-9137-739bd6f4b3e2
hint(md"""`similar(x)` is a useful function to initialise a new matrix of the same type and dimensions of the array `x`	""")

# ╔═╡ 416a1d78-4582-4511-9879-5302fc7c1171
hint(md"""`Gray(x)` returns the gray component of a color. Try,  `Gray(0)`, `Gray(1)`""")	

# ╔═╡ 756ef0e0-2bf5-11eb-107c-8d1c65eacc45
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

# ╔═╡ e1dd7abc-2bf5-11eb-1f5a-0f46c7405dd5
X = simulate(x0_ca, UInt8(rule_number); nsteps=100)

# ╔═╡ 9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
ca_image(X) = cm.(X)

# ╔═╡ fb9a97d2-2bf5-11eb-1b92-ab884f0014a8


# ╔═╡ 95dbe546-5f18-11eb-34d3-0fb6e14302e0


# ╔═╡ 333d2a1a-5f4c-11eb-188a-bb221700e8a0
function show_barcode(bitArr) 
	bar(bitArr, color=:Black, ylims=(0.1,0.5), label="", axis = nothing, border=:none,  bar_width=1,  size=(400,300))
end

# ╔═╡ da058da2-e762-4909-8857-169a012890b5
begin 
	### Get index of bitstring
	getbinarydigit_sol(rule, i) = isodd(rule >> i)
	
	### Next state
	nextstate_sol(l::Bool, s::Bool, r::Bool, rule::Int) = nextstate_sol(l, s, r, UInt8(rule))
			
	function nextstate_sol(l::Bool, s::Bool, r::Bool, rule::UInt8)
	  return getbinarydigit_sol(rule, 4l+2s+1r)
	end
	
	### Update 1 step of CA
	function update1dca_sol!(xnew, x, rule::Integer)
		n = length(x)
		xnew[1] = nextstate_sol(x[end], x[1], x[2], rule)
		xnew[end] = nextstate_sol(x[end-1], x[end], x[1], rule)
		for i in 2:n-1
			xnew[i] = nextstate_sol(x[i-1], x[i], x[i+1], rule)
		end
		return xnew
	end
	
	update1dca_sol(x, rule::Integer) = update1dca_sol!(similar(x), x, rule)
	
	
	### simulating the CA
	"""
	    simulate(x0, rule; nsteps=100)
	
	Simulate `nsteps` time steps according to `rule` with `X0` as the initial condition.
	Returns a matrix X, where the rows are the state vectors at different time steps.
	"""
	function simulate_sol(x0, rule::UInt8; nsteps=100)
		n = length(x0)
	    X = zeros(Bool, nsteps+1, n)
		X[1,:] = x0
		for t in 1:nsteps
			x = @view X[t,:]
			xnew = @view X[t+1,:]
			update1dca_sol!(xnew, x, rule)
		end
	    return X
	end

	
	rule_ex9 = 171
	initInt_ex9 = 3680689260
	initBs_exp9 = bitstring(initInt_ex9)
	bitArr_ex9 = simulate_sol([el == '0' for el in reverse(initBs_exp9)[1:32]], UInt8(rule_ex9); nsteps=50)[end,:]
	
	pl_ex9 = show_barcode(bitArr_ex9)
	
	

	rule2_ex9 = 42
	init_Int2_ex9 = 3681110060
	milk_barcode = bitstring(init_Int2_ex9)
	
	bitArr = simulate_sol([el == '0' for el in reverse(milk_barcode)[1:32]], UInt8(rule2_ex9); nsteps=50)[end,:]
	
	pl2_ex9 = show_barcode(bitArr)

	
	md"""
	**Optional question:** Barcode bonanza
	
	A simple barcode is data represented by varying the widths and spacings of parallel lines. However this is just an array of binary values that correspondent to an integer number.
	
	![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/UPC-A-036000291452.svg/220px-UPC-A-036000291452.svg.png)
	
	The laser scanner reads the barcode and converts the binary number to an integer which is the product code, a pretty simple and robust system.
	
	A local supermarket completely misread the protocol and accidentally use a cellular automata to convert the binary number into an integer. Their protocol is a little convoluted,		
		
	The number corresponding to a barcode is the **rule number** followed by the *initial 32-bit array encoded as an integer* (initial condition). The barcode is generated by taking the rule number and evolving the initial condition for 50 iterations.
	
	As an example this barcode corresponds to the number: 
	**$(rule_ex9)** *3128863161*
	
	$(pl_ex9)
	
	
	Which is *3128863161* converted to a bitstring as initial array iterated for 50 iterations using rule: $(rule_ex9)

	After generating tons of new barcodes, the employees stumble upon a problem. While it is easy to generate the barcodes given the product codes, it it not trivial to convert a barcode to a product number. Luckily, the employees used the same initial bitstring for all products (*3681110060*).
		
	Can you find the product code for this box of milk **XXX** *3128863161*?
	
	$(pl2_ex9)
	
	The binary form of the barcode is provided below.
	"""
end

# ╔═╡ caefe5ac-5f4d-11eb-2591-67b5515e1bd4
product_code_milk = missing

# ╔═╡ 46449848-64e3-11eb-0bf4-c9211b41c68d
barcode_milk =  Bool[1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0];

# ╔═╡ 670d4db7-924b-4c44-9729-8677a9b757c8
md"""## Answers:
If you would like to take a look at the answers, you can do so by checking the box of the question you would like to see. The function will be shown just below the question you want to look at.

| Question | Show solution |
|-----|:---------:|
| Question Means | $(@bind answ_q1 CheckBox()) |
| Question 1-Dimensional covolutional | $(@bind answ_q2 CheckBox()) |
| Question Common weight vectors | $(@bind answ_q3 CheckBox()) |
| Question Protein sliding image | $(@bind answ_q4 CheckBox()) |
| Question Decimate image | $(@bind answ_q5 CheckBox()) |
| Question 2-Dimensional convolutional | $(@bind answ_q6 CheckBox()) |
| Question Edge detection | $(@bind answ_q7 CheckBox()) |
| Question Get binary digit | $(@bind answ_q8 CheckBox()) |
| Question Transitioning individual states | $(@bind answ_q9 CheckBox()) |
| Question Evolving the array | $(@bind answ_q10 CheckBox()) |
| Question Simulate | $(@bind answ_q11 CheckBox()) |
"""

# ╔═╡ 9fa895b2-b327-4789-8aab-6259ca85c7cd
if answ_q1 == true
	md"""
	```julia
		mean(x) = sum(x)/length(x)

		weighted_mean(x, w) = sum(w.*x)
	```
	"""
end

# ╔═╡ 99272f4e-b873-4f70-88e6-10bdbca069fe
if answ_q2 == true
	md"""
	```julia
	function convolve_1d(x::Vector, w::Vector)
		@assert length(w) % 2 == 1 "length of `w` has to be odd!"
		@assert length(w) < length(x) "length of `w` should be smaller than `x`"
		n = length(x)
		m = length(w) ÷ 2
		y = zeros(n)

		fill!(y, 0.0)
		for (i, xj) in enumerate(x)
		for (j, wj) in enumerate(w)
		  k = j - m - 1
		  l = clamp(i - k, 1, n)
				y[i] += w[j] * x[l]
			end
		end
		return y
	end
	```
	"""
end

# ╔═╡ b2d992ab-66da-4f8f-a313-6a828b62b70d
if answ_q3 == true
	md"""
	**Solutions:**
	```julia
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
	```
	"""
end

# ╔═╡ 085a24fb-f71d-4edb-ba8c-a3f1047c60c2
if answ_q4 == true
	md"""
	```julia
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
	```
	"""
end

# ╔═╡ 37d3969f-a3e6-4d59-8ead-177d149bbbf7
if answ_q5 == true
	md"""
	```julia
	decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]
	```
	"""
end

# ╔═╡ e090373d-1e9e-45f6-bd26-bdcd9ddf4a3a
if answ_q6 == true
	md"""
	**Solutions:**
	```julia
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
	```
	"""
end

# ╔═╡ 99cf56dc-aeb3-4f8e-ae52-5b9f639f800e
if answ_q7 == true
	md"""
	```julia
	Gx = [1 0 -1; 2 0 -2; 1 0 -1]
	Gy = [1 2 1; 0 0 0; -1 -2 -1]
	function edge_detection(M)
		M = M .|> Gray .|> Float64
		return sqrt.(convolve_2d(M, Gx).^2 + convolve_2d(M, Gy).^2) .|> Gray
	end
	```
	"""
end

# ╔═╡ 5e84dd4a-fabe-452c-a274-663b1ba94f5a
if answ_q8 == true
	md"""
	```julia
	getbinarydigit(rule, i) = isodd(rule >> i)
	```
	"""
end

# ╔═╡ f9b59b28-c635-4474-bc12-f9ce45a047fd
if answ_q9 == true
	md"""
	```julia
	nextstate(l::Bool, s::Bool, r::Bool, rule::Int) = nextstate(l, s, r, UInt8(rule))
		
	function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
	  return getbinarydigit(rule, 4l+2s+1r)
	end
	```
	"""
end

# ╔═╡ c9fac3a6-e3ad-4f0e-bc71-a36a593094f7
if answ_q10 == true
	md"""
	```julia
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
	```
	"""
end

# ╔═╡ bde632e9-3aa4-4a9e-a736-f41ad057b231
if answ_q11 == true
	md"""
	```julia
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
	```
	"""
end

# ╔═╡ 37cb5545-38cc-49f5-aff7-913eb0d08cbc
md"Colors can also be represented in other ways, such as this hexadecimal format:"

# ╔═╡ 7fb698a3-aaad-4a36-ae73-a05602d790af
hex(daanbeardred)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Colors = "~0.12.10"
Images = "~0.25.2"
Plots = "~1.38.0"
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "d935f7500bb5b326a595b8b53c6a7d03edff1769"

[[deps.AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "d92ad398961a3ed262d8bf04a1a2b8340f915fef"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.5.0"
weakdeps = ["ChainRulesCore", "Test"]

    [deps.AbstractFFTs.extensions]
    AbstractFFTsChainRulesCoreExt = "ChainRulesCore"
    AbstractFFTsTestExt = "Test"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "cde29ddf7e5726c9fb511f340244ea3481267608"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.7.2"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "16351be62963a67ac4083f748fdb3cca58bfd52f"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.7"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "2dc09997850d68179b69dafb58ae806167a32b1b"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.8"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "1287e3872d646eed95198457873249bd9f0caed2"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.20.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "9ebb045901e9bbf58767a9f34ff89831ed711aae"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.15.7"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "75bd5b6fc5089df449b5d35fa501c846c9b6549b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.12.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "8cfa272e8bdedfa88b6aefbbca7c19f1befac519"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.3.0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "f9d7112bfff8a19a3a4ea4e03a8e6a91fe8456bf"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.3"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "ac67408d9ddf207de5cfa9a97e114352430f01ed"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.16"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "66c4c81f259586e8f002eacebc177e1fb06363b0"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.11"
weakdeps = ["ChainRulesCore", "SparseArrays"]

    [deps.Distances.extensions]
    DistancesChainRulesCoreExt = "ChainRulesCore"
    DistancesSparseArraysExt = "SparseArrays"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8e9441ee83492030ace98f9789a654a6d0b1f643"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "4820348781ae578893311153d69049a93d05f39d"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.8.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "c5c28c245101bd59154f649e19b038d15901b5dc"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "ff38ba61beff76b8f4acad8ab0c97ef73bb670cb"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.9+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "8e2d86e06ceb4580110d9e716be26658effc5bfd"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.8"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "da121cbdc95b065da07fbb93638367737969693f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.8+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "e94c92c7bf4819685eb80186d51c43e71d4afa17"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.76.5+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "899050ace26649433ef1af25bc17a815b3db52b7"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.9.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "abbbb9ec3afd783a7cbd82ef01dcd088ea051398"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.1"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "2e4520d67b0cef90865b3ef727594d2a58e0e1f8"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.11"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageBase", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "eb3d4365a10e3f3ecb3b115e9d12db131d28a386"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.12"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "08b0e6354b21ef5dd5e49026028e41831401aca8"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.17"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "PrecompileTools", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "3447781d4c80dbe6d71d239f7cfb1f8049d4c84f"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.6"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "bca20b2f5d00c4fbc192c3212da8fa79f4688009"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.7"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "b0b765ff0b4c3ee20ce6740d843be8dfce48487c"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.3.0"

[[deps.ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "355e2b974f2e3212a75dfb60519de21361ad3cb7"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.9"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "e7c68ab3df4a75511ba33fc5d8d9098007b579a8"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.2"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "LazyModules", "OffsetArrays", "PrecompileTools", "Statistics"]
git-tree-sha1 = "783b70725ed326340adf225be4889906c96b8fd1"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.7"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "44664eea5408828c03e5addb84fa4f916132fc26"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.8.1"

[[deps.ImageShow]]
deps = ["Base64", "ColorSchemes", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "3b5344bcdbdc11ad58f3b1956709b5b9345355de"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.8"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "8717482f4a2108c9358e5c3ca903d3a6113badc9"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.5"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "5fa9f92e1e2918d9d1243b1131abe623cdf98be7"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.3"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3d09a9f60edf77f8a4d99f9e015e8fbf9989605d"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.7+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "ea8031dea4aff6bd41f1df8f2fdfb25b33626381"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.4"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "be8e690c3973443bec584db3346ddc904d4884eb"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "5fdf2fe6724d8caabf43b557b84ce53f3b7e2f6b"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.0.2+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.IntervalSets]]
deps = ["Dates", "Random"]
git-tree-sha1 = "3d8866c029dd6b16e69e0d4a939c4dfcb98fac47"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.7.8"
weakdeps = ["Statistics"]

    [deps.IntervalSets.extensions]
    IntervalSetsStatisticsExt = "Statistics"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.IterTools]]
git-tree-sha1 = "42d5f897009e7ff2cf88db414a389e5ed1bdd023"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.10.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "PrecompileTools", "Printf", "Reexport", "Requires", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "7c0008f0b7622c6c0ee5c65cbc667b69f8a65672"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.45"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "a53ebe394b71470c7f97c2e7e170d51df21b17af"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.7"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "fa6d0bcff8583bac20f1ffa708c3913ca605c611"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.5"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60b1194df0a3298f460063de985eae7b01bc011a"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.1+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "f428ae552340899a935973270b8d98e5a31c49fe"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.1"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "7d6dd4e9212aebaeed356de34ccf262a3cd415aa"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.26"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "72dc3cf284559eb8f53aa593fe62cb33f83ed0c0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.0.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.MappedArrays]]
git-tree-sha1 = "2dab0221fe2b0f2cb6754eaa743cc266339f527e"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.2"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "1130dbe1d5276cb656f6e1094ce97466ed700e5a"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "7b86a5d4d70a9f5cdf2dacb3cbe6d251d1a61dbe"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.4"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded64ff6d4fdd1cb68dfcbb818c69e144a5b2e4c"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.16"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore", "ImageMetadata"]
git-tree-sha1 = "d92b107dbb887293622df7697a2223f9f8176fcd"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.1.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OffsetArrays]]
git-tree-sha1 = "6a731f2b5c03157418a20c12195eb4b74c8f8621"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.13.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "a4ca623df1ae99d09bc9868b008262d0c0ac1e4f"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.4+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "51901a49222b09e3743c65b8847687ae5fc78eb2"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a12e56c72edee3ce6b96667745e6cbbe5498f200"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.23+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "67186a2bc9a90f9f85ff3cc8277868961fb57cbd"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.4.3"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "0fac6313486baae819364c52b4f483450a9d793f"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.12"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "862942baf5663da528f66d24996eb6da85218e76"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "68723afdb616445c6caaef6255067a8339f91325"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.55"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "00099623ffee15972c16111bcf84c58a0051257c"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.9.0"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.Quaternions]]
deps = ["LinearAlgebra", "Random", "RealDot"]
git-tree-sha1 = "9a46862d248ea548e340e30e2894118749dc7f51"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.7.5"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "1342a47bf3260ee108163042310d26f2be5ec90b"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.5"
weakdeps = ["FixedPointNumbers"]

    [deps.Ratios.extensions]
    RatiosFixedPointNumbersExt = "FixedPointNumbers"

[[deps.RealDot]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9f0a1b71baaf7650f4fa8a1d168c7fb6ee41f0c9"
uuid = "c1ae055f-0cd5-4b69-90a6-9a35b1a98df9"
version = "0.1.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays"]
git-tree-sha1 = "792d8fd4ad770b6d517a13ebb8dadfcac79405b8"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.6.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays"]
git-tree-sha1 = "4b33e0e081a825dbfaf314decf58fa47e53d6acb"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.4.0"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "2da10356e31327c7096832eb9cd86307a50b1eb6"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "7b0e9c14c624e435076d19aea1e5cbdec2b9ca37"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.2"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "1d77abd07f617c4868c33d4f5b9e1dbb2643c9cf"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.2"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "34cc045dd0aaa59b8bbe86c644679bc57f1d5bd0"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.8"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TranscodingStreams]]
git-tree-sha1 = "54194d92959d8ebaa8e26227dbe3cdefcdcd594f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.3"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "e2d817cc500e960fdbafcf988ac8436ba3208bfd"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.3"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "7558e29847e99bc3f04d6569e82d0f5c54460703"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+1"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "93f43ab61b16ddfb2fd3bb13b3ce241cafb0e6c9"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.31.0+0"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "5f24e158cf4cee437052371455fe361f526da062"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.6"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "801cbe47eae69adc50f36c3caec4758d2650741b"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.2+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "730eeca102434283c50ccf7d1ecdadf521a765a4"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "330f955bc41bb8f5270a369c473fc4a5a4e4d3cb"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a68c9655fbe6dfcab3d972808f1aafec151ce3f8"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.43.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "93284c28274d9e75218a416c65ec49d0e0fcdf3d"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.40+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "libpng_jll"]
git-tree-sha1 = "d4f63314c8aa1e48cd22aa0c17ed76cd1ae48c3c"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.10.3+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9c304562909ab2bab0262639bd4f444d7bc2be37"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+1"
"""

# ╔═╡ Cell order:
# ╟─dd3bc556-8f41-4de1-8350-54fd99c1d83e
# ╠═cf4e10a8-4862-11eb-05fd-c1a09cbb1bcd
# ╠═786b3780-58ec-11eb-0dfd-41f5af6f6a39
# ╟─d46c00c9-f65c-4cf4-a6b7-e9eb1c000460
# ╟─e1147d4e-2bee-11eb-0150-d7af1f51f842
# ╟─b8a69910-8c8a-423c-aa13-1d1fab2fe10b
# ╠═f272855c-3c9e-11eb-1919-6b7301b15699
# ╠═66a20628-4834-11eb-01a2-27cc2b1ec7be
# ╠═432c3892-482c-11eb-1467-a3b9c1592597
# ╟─788b7f25-a2b6-4b97-99d5-3ecf01473c3d
# ╟─9f54a75d-adb6-486b-8e11-775813ecaa1c
# ╟─a657c556-4835-11eb-12c3-398890e70105
# ╠═88c10640-4835-11eb-14b0-abba18da058f
# ╟─9fa895b2-b327-4789-8aab-6259ca85c7cd
# ╠═181c4246-4836-11eb-0368-61b2998f5424
# ╠═94a950fe-4835-11eb-029c-b70de72c20e6
# ╟─52706c6a-4836-11eb-09a8-53549f16f5c2
# ╠═4dc28cdc-4836-11eb-316f-43c04639da2a
# ╟─8b4c6880-4837-11eb-0ff7-573dd18a9664
# ╟─9407fda7-9442-4a1a-a8f2-e2c3fd69ae60
# ╟─bc67a0a6-d5f1-4404-9406-acb05857361d
# ╠═a1f75f4c-2bde-11eb-37e7-2dc342c7032a
# ╟─99272f4e-b873-4f70-88e6-10bdbca069fe
# ╟─7945ed1c-598c-11eb-17da-af9a36c6a68c
# ╠═546beebe-598d-11eb-1717-c9687801e647
# ╟─f39d88f6-5994-11eb-041c-012af6d3bae6
# ╠═f94e2e6c-598e-11eb-041a-0b6a068e464c
# ╟─0563fba2-5994-11eb-2d81-f70d10092ad7
# ╟─4e45e43e-598f-11eb-0a0a-2fa636748f7c
# ╠═8e53f108-598d-11eb-127f-ddd5be0ec899
# ╟─eec85f98-ae75-451e-b8bf-89271c8f4950
# ╟─99a7e070-5995-11eb-0c53-51fc82db2e93
# ╟─6d0288d9-84a1-4380-bf37-feb9dad866e5
# ╟─2b6303b0-cbc6-4ab2-abc5-c55793548b0e
# ╠═c98a6330-c133-4309-a374-e897051d7bf6
# ╠═7c12bcf6-4863-11eb-0994-fb7d763c0d47
# ╟─64bf7f3a-58f0-11eb-1782-0d33a2b615e0
# ╟─e0188352-3771-4249-9bf1-f9c7f39ee3c8
# ╟─6f4e6870-8d82-4b39-b2fd-9d340150a414
# ╠═294140a4-2bf0-11eb-22f5-858969a4640d
# ╟─91c7e17b-28a5-44ed-8c92-ee8a36d71a69
# ╟─6d725252-b1de-4439-aab5-d2b4361947b5
# ╠═d8c7baac-49be-11eb-3afc-0fedae12f74f
# ╟─2b8cbdc9-4c6d-44c9-8dae-47487a01f577
# ╟─b2d992ab-66da-4f8f-a313-6a828b62b70d
# ╟─1f5fca26-af78-4a20-9017-83366a5118f4
# ╟─b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
# ╠═87610484-3ca1-11eb-0e74-8574e946dd9f
# ╠═9c82d5ea-3ca1-11eb-3575-f1893df8f129
# ╠═a4ccb496-3ca1-11eb-0e7a-87620596eec1
# ╟─9f62891c-49c2-11eb-3bc8-47f5d2e008cc
# ╟─328385ca-49c3-11eb-0977-c79b31a6caaf
# ╠═c924a5f6-2bf1-11eb-3d37-bb63635624e9
# ╠═7e96f0d6-5999-11eb-3673-43f7f1fa0113
# ╟─3e40ce8d-612d-4ead-be99-7cbb0f7e242d
# ╟─2d4e1bf0-1b99-4307-909b-53b43586509b
# ╠═c23ff59c-3ca1-11eb-1a31-2dd522b9d239
# ╟─085a24fb-f71d-4edb-ba8c-a3f1047c60c2
# ╠═17e7750e-49c4-11eb-2106-65d47b16308c
# ╟─236f1ee8-64e2-11eb-1e60-234754d2c10e
# ╟─0b847e26-4aa8-11eb-0038-d7698df1c41c
# ╠═ba2c4c6b-d1bc-47cc-a13e-db2e5bab414d
# ╠═e3f4c82a-5a8d-11eb-3d7d-fd30c0e4a134
# ╟─c3a51344-5a8e-11eb-015f-bd9aa28aa6eb
# ╠═c3ac56e0-5a8e-11eb-3520-279c4ba47034
# ╟─c3dc3798-5a8e-11eb-178d-fb98d87768bf
# ╠═c3e02c4a-5a8e-11eb-2c2e-b5117c5310a3
# ╠═c41426f8-5a8e-11eb-1d49-11c52375a7a0
# ╟─c41f1cb6-5a8e-11eb-326c-db30e518a702
# ╠═c44eb368-5a8e-11eb-26cd-d9ba694ac760
# ╠═c4541a1a-5a8e-11eb-3b09-c3adb3794723
# ╠═c48a7a24-5a8e-11eb-2151-f5b99da0039b
# ╠═c4901d26-5a8e-11eb-1786-571c99fa50e2
# ╠═c4c2df5e-5a8e-11eb-169b-256c7737156a
# ╠═c4dc60a0-5a8e-11eb-3070-3705948c7c93
# ╠═c4e02064-5a8e-11eb-29eb-1d9cc2769121
# ╠═c512c06e-5a8e-11eb-0f57-250b65d242c3
# ╠═c52bc23a-5a8e-11eb-0e9a-0554ed5c632e
# ╠═e5ff8880-5a8d-11eb-0c7f-490c48170654
# ╠═12c363d6-5a8f-11eb-0142-b7a2bee0dad2
# ╠═12c9c136-5a8f-11eb-3d91-5d121b8999d5
# ╠═12fd8282-5a8f-11eb-136c-6df77b026bd4
# ╠═13185c4c-5a8f-11eb-1164-cf745ddb0111
# ╟─131c000e-5a8f-11eb-0ab1-d55894321001
# ╟─134b2bec-5a8f-11eb-15f5-ff8a1efb68a9
# ╟─a8ebd04e-adfc-45a4-a08e-79d6b050c567
# ╟─fa05f2a1-623f-43a6-b44e-2525a770f382
# ╠═13807912-5a8f-11eb-3ca2-09030ee978ab
# ╟─37d3969f-a3e6-4d59-8ead-177d149bbbf7
# ╠═6d5de3b8-5dbc-11eb-1fc4-8df16c6c04b7
# ╠═1dfc943e-5a8f-11eb-336b-15b40b9fe412
# ╠═dd2d6fde-0e64-4032-9c81-16aa368ce084
# ╟─8e95e4c7-4d81-437f-961d-3720e599e01d
# ╟─1e0383ac-5a8f-11eb-1b6d-234b6ad6e9fa
# ╠═1e2ac624-5a8f-11eb-1372-05ca0cbe828d
# ╟─1e2ebef0-5a8f-11eb-2a6c-2bc3dffc6c73
# ╟─1e5db70a-5a8f-11eb-0984-6ff8e3030923
# ╟─4f2fbae3-1aa6-42ad-9a97-0971e63b199f
# ╠═d1851bbe-5a91-11eb-3ae4-fddeff381c1b
# ╟─7d4c40d6-2aa3-4246-8554-bef080109f19
# ╠═f5574a90-5a90-11eb-3100-dd98e3375390
# ╟─2286d0a6-1413-4b30-8436-712e0ddf6767
# ╟─414c791d-b0e3-4a54-b1cc-634553b355be
# ╟─bfb54354-c9fc-48da-b329-960c7138e137
# ╟─6d95b718-358c-459a-8aa7-eb687fc9fad7
# ╟─e51c129f-9e04-4bd5-8693-09030d41d02c
# ╟─26060e40-2ff0-40c9-bf1c-0b4cedddc139
# ╟─948052a6-89fb-4d3e-81eb-0d7bb167b8dc
# ╠═ca0748ee-5e2e-11eb-0199-45a98c0645f2
# ╠═1e97c530-5a8f-11eb-14b0-47e7e944cba1
# ╠═f58d5af4-5a90-11eb-3d93-5712bfd9920a
# ╟─e090373d-1e9e-45f6-bd26-bdcd9ddf4a3a
# ╟─9879be7d-0c14-4922-a33f-53afb7f239b8
# ╟─62916ec1-0784-4c69-b41f-918db1037703
# ╠═52a87820-5e35-11eb-0392-85957277f21a
# ╟─99cf56dc-aeb3-4f8e-ae52-5b9f639f800e
# ╟─51c4d953-1892-4654-975b-9fc6f3e3114b
# ╠═f80ab6ba-5e2f-11eb-276c-31bbd5b0fee9
# ╠═e5042bac-5e2f-11eb-28bb-dbf653abca17
# ╟─f12c025c-94a0-45a5-9feb-26131a24e79a
# ╟─4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
# ╟─b0bd61f0-49f9-11eb-0e6b-69539bc34be8
# ╠═b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
# ╠═fabce6b2-59cc-11eb-2181-43fe08fcbab9
# ╟─05973498-59cd-11eb-2d56-7dd28db4b8e5
# ╟─c61755a6-49f9-11eb-05a0-01d914d305f3
# ╠═a6e7441a-482e-11eb-1edb-6bd1daa00390
# ╟─bec6e3d2-59c8-11eb-0ddb-79795043942d
# ╟─6e184088-59c9-11eb-22db-a5858eab786d
# ╟─1f6262b6-59cc-11eb-1306-0d1ca9f3f8e6
# ╟─b31f6e4e-b796-4b6a-9248-8f0c465b7cb5
# ╟─b235c6c8-8773-41da-960d-09da33620e2b
# ╟─ef80843e-20c7-4908-9d51-ce031da39aa4
# ╟─55309481-589d-4c77-9b14-ef6aebe2670a
# ╟─3c8ed609-a813-4568-af5c-96b194111197
# ╠═b43157fa-482e-11eb-3169-cf4989528800
# ╟─5e84dd4a-fabe-452c-a274-663b1ba94f5a
# ╠═781d38a8-59d4-11eb-28f9-9358f132782c
# ╟─8b6b45c6-64e2-11eb-3662-7de5e25e6faf
# ╟─2eef0c7f-2fbc-4b59-8374-fffd9d84f7d9
# ╟─816bd608-3332-4a07-9f09-c7a432b0279f
# ╟─892be4c0-408d-4542-9c55-331cd7582a6e
# ╟─939b842e-30c8-4c9b-8988-6c470234ebb6
# ╠═00f6e42c-59d4-11eb-31c7-d5aa0105e7cf
# ╠═d2e5787c-59d2-11eb-1bbd-d79672ab8f1b
# ╟─f9b59b28-c635-4474-bc12-f9ce45a047fd
# ╠═38e6a67c-49fa-11eb-287f-91a836f5752c
# ╟─511661de-59d5-11eb-16f5-4dbdf4e93ab2
# ╟─428af062-59d5-11eb-3cf7-99533810e83c
# ╟─be013232-59d4-11eb-360e-e97b6c388991
# ╟─a808b2d0-5aff-11eb-036f-fd32a1dc92fc
# ╟─4776ccca-482f-11eb-1194-398046ab944a
# ╠═5f97da58-2bf4-11eb-26de-8fc5f19f02d2
# ╟─1afb9a16-5d8a-11eb-1ed5-875084953542
# ╠═90f543e4-5d89-11eb-27c0-8572a859c1b5
# ╠═95ce684a-64e2-11eb-211b-e198b0016152
# ╟─c4f3732c-b646-4f97-b095-1c400955be86
# ╟─43222f49-766a-48ba-b55e-0409082243bb
# ╠═924461c0-2bf3-11eb-2390-71bad2541463
# ╠═21440956-2bf5-11eb-0860-11127d727282
# ╟─c9fac3a6-e3ad-4f0e-bc71-a36a593094f7
# ╠═405a1036-2bf5-11eb-11f9-a1a714dbf7e1
# ╠═6405f574-2bf5-11eb-3656-d7b9c94f145a
# ╟─e8ddcd80-5f1c-11eb-00bb-6badc5a9ffaa
# ╟─f637425d-e7f7-44d7-a8c2-4f795badc5af
# ╟─dc013365-7620-4493-9137-739bd6f4b3e2
# ╟─416a1d78-4582-4511-9879-5302fc7c1171
# ╠═756ef0e0-2bf5-11eb-107c-8d1c65eacc45
# ╟─bde632e9-3aa4-4a9e-a736-f41ad057b231
# ╠═e1dd7abc-2bf5-11eb-1f5a-0f46c7405dd5
# ╠═9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
# ╠═fb9a97d2-2bf5-11eb-1b92-ab884f0014a8
# ╠═95dbe546-5f18-11eb-34d3-0fb6e14302e0
# ╟─da058da2-e762-4909-8857-169a012890b5
# ╟─333d2a1a-5f4c-11eb-188a-bb221700e8a0
# ╠═caefe5ac-5f4d-11eb-2591-67b5515e1bd4
# ╠═46449848-64e3-11eb-0bf4-c9211b41c68d
# ╟─670d4db7-924b-4c44-9729-8677a9b757c8
# ╟─37cb5545-38cc-49f5-aff7-913eb0d08cbc
# ╠═7fb698a3-aaad-4a36-ae73-a05602d790af
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
