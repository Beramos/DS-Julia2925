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

# ╔═╡ 8cfb8f40-6794-11eb-0b33-8d658fe6725b
using Plots

# ╔═╡ 72e5ce1c-679a-11eb-251f-ab932941bcb4
using CSV, DataFrames, Dates

# ╔═╡ 58efc084-678f-11eb-2cff-9728ba22cc17
# edit the code below to set your name and UGent username

student = (name = "Jan Janssen", email = "Jan.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 245b6c12-678f-11eb-2765-cfee142b1d26
begin 
	using DSJulia;
	using PlutoUI;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ 5af8cfda-678f-11eb-0977-85d419805ccb
md"""
# Exercises: convolution, images and cellular automata (part 1)

We wrap up day 1 by exploring convolutions and similar operations on 1-D and 2-D (or even n-D!) matrices. Departing from some basic building blocks we will cover signal processing, image processing and cellular automata!

**Learning goals:**
- code reuse;
- efficient use of collections and unitRanges;
- control flow in julia;

"""

# ╔═╡ 874cda5e-678f-11eb-034e-e5079fff5fc5
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

# ╔═╡ 406cef16-67a8-11eb-2aba-23415f96813f


# ╔═╡ 2e95127c-6790-11eb-1dfb-efac567fa1cf
function mean(x)
	return missing
end

# ╔═╡ 2ec6baca-6790-11eb-3b53-9959545905fe
x = [2.1, 3.2, 5.4, 4.9, 6.1]

# ╔═╡ 2ec73a2c-6790-11eb-1b3f-9f499c17b0f6
mean(x)

# ╔═╡ 2eefe15c-6790-11eb-1362-0752b63e05cf
weighted_mean(x, w) = missing

# ╔═╡ 973c3dba-678f-11eb-3d41-0babfffcc82e
begin
	arr_mean_int = rand(20)
	arr_mean_float = rand(Int, 20)
	arr_weights = collect(1:20)/sum(1:20)
	
	q_mean = Question(
			validators = @safe[
				mean(arr_mean_int) == Solutions.mean(arr_mean_int),
				mean(arr_mean_float) == Solutions.mean(arr_mean_float)
			],
			description = md"""
			Implement the mean function.
			"""
		)
	
	q_wmean = Question(
			validators = @safe[
				weighted_mean(arr_mean_int, arr_weights) == 
					Solutions.weighted_mean(arr_mean_int, arr_weights),
				weighted_mean(arr_mean_float, arr_weights) == 
					Solutions.weighted_mean(arr_mean_float, arr_weights)		
			],
			description = md"""
		So, for this regular mean, we give an equal weight to every element: every $x_i$ is equally important in determining the mean. In some cases, however, we know that some positions are more important than others in determining the mean. For example, we might know the measurement error for each point. In this case, it is sensible to give a weigth inversely proportional to the measurement error. 
		
		In general, the weighted mean is computed as:
		
		$$\sum_{i=1}^n w_ix_i\,,$$

		were, $w_i$ are the weights of data point $x_i$. In order for the weighted mean to make sense, we assume that all these weights are non-zero and that they add up to 1.

		Implement the weighted mean. Do it in a one-liner.
		"""
		)
			

	qb_mean = QuestionBlock(;
		title=md"**Assignment: the mean and weighted mean**",
		description = md"""


		""",
		questions = @safe[q_mean, q_wmean]
	)
	
	validate(qb_mean, tracker)
end

# ╔═╡ 2ef01cc6-6790-11eb-2de5-67e250558cdb
md"We compute the mean again, now using the information that the numbers were collected subsequently and that we give a weight linearly proportional to the position (points further away have a lower contribution to the mean),

$$w_i = \cfrac{i}{\sum_j^n j} \, .$$

For example,

$$[w_1, w_2, w_3] = [1/3, 2/3, 3/3]\, .$$

"

# ╔═╡ 2f01e06e-6790-11eb-2ce6-852221110ff2
wx = collect((1:5) / sum(1:5))

# ╔═╡ 2f02266e-6790-11eb-19cf-8336c103c097
weighted_mean(x, wx)

# ╔═╡ 2f2cf2d6-6790-11eb-067d-456e8b2f804f
md"Note that:"

# ╔═╡ 2f2d4628-6790-11eb-0fd0-f93ed0057dfe
sum(wx)

# ╔═╡ d621de66-6791-11eb-2833-af7559e4a913


# ╔═╡ c79cc3e2-6791-11eb-1ec2-6fc6a3a4876c
md"""
Now back to our one-dimensional convolution,

$$y_i = \sum_{k=-m}^{m} x_{i + k} w_{m+k+1}\,,$$

a vector $\mathbf{x}$ of length $n$ is transformed in a convolved vector $\mathbf{y}$ (also length $n$). The convolution is determined by a **kernel** or **filter** $\mathbf{w}$ of length $2m+1$ (chosen such that it has an odd length). You can see element $y_i$ as a weighted mean of the elements $x_{i-m}, x_{i-m+1},\ldots, x_{i+m-1}, x_{i+m}$.

When computing convolutions (or in numerical computing in general) one has to be careful with the **boundary conditions**. We cannot compute the sum at the ends since the sum would exceed the vector $\mathbf{x}$. There are many sensible ways to resolve this, we will choose the simplest solution of using fixed boundaries by setting $y_i = x_i$ when $i< m$ or $i>n-m$.
"""

# ╔═╡ 8533fd10-67a8-11eb-0489-a575230c1580


# ╔═╡ cfb49686-6791-11eb-14a2-b34d6bae95b2
function convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	@assert length(w) < length(x) "length of `w` should be smaller than `x`"
	n = missing
	m = missing
	y = missing # initialize the output

	# ... complete
	return y
end

# ╔═╡ cc3a2fc0-6791-11eb-03f1-3d628e3ea86a
begin 	
	q_1d = Question(
			validators = @safe[	
				convolve_1d(collect(1:10), [0.5, 0.5, 0.5]) ≈ 
					Solutions.convolve_1d(collect(1:10), [0.5, 0.5, 0.5])
			]
		)
			

	qb_1d = QuestionBlock(;
		title=md"**Assignment: one-dimensional convolution**",
		description = md"""

		Implement the one-dimensional convolution,
		
		$$y_i = \sum_{k=-m}^{m} x_{i + k} w_{m+k+1}\,,$$
		
		by completing the function `convolve_1d(x::Vector, w::Vector).`
		
		This function should be able to take any vector x and compute the convolution with any weight vector that matches the specification of a weight vector (see previously). 

		""",
		questions = @safe[q_1d],
		hints = [
			hint(md"Did you take into account the boundary conditions? The function `clamp` can help you with that.")	
		]
	)
	
	validate(qb_1d, tracker)
end

# ╔═╡ e06a78d6-6791-11eb-2cbd-85812bc978cc
md"""
Let's try this out on an example, consider a noisy signal,
"""

# ╔═╡ e086d5c0-6791-11eb-2f3e-cd6f7235b114
noisy_signal(tᵢ; σ=10) = 5tᵢ + 5sin(tᵢ) +  σ * rand();

# ╔═╡ e08784f0-6791-11eb-3afa-39eedd974535
md"We use the convolution function we defined to construct a moving_average function,"

# ╔═╡ e096aba6-6791-11eb-3b0b-2105e2783060
moving_average(f::Function, t, w) = convolve_1d(f.(t), ones(w).*1/w);

# ╔═╡ ee8c34a6-6791-11eb-24b5-a99125b2440c
@bind wₑ Slider(1:2:43, default=3)

# ╔═╡ e096d8a6-6791-11eb-2734-b384bf77dcd7
md"Number of weights (w) : $wₑ"

# ╔═╡ 91a0ff62-6794-11eb-3e7f-8f9c8cabc91d
begin 
	t = 0:0.01:10
	plot(t, noisy_signal.(t), label="Noisy", ylabel="Signal (-)", xlabel="time(s)")
	plot!(t, moving_average(noisy_signal, t, wₑ), label="Filtered", lw = 2)
end

# ╔═╡ d75e338c-6794-11eb-10b0-dd5ef94b6b61


# ╔═╡ 9d77127c-6794-11eb-1ba9-5f5256b6be85
QuestionBlock(;
	title=md"**Task:**",
	description = md"""
	Explore this filtering technique by changing the number of weights. Try to understand how the `moving_average` function behaves.
	"""
)

# ╔═╡ dc599bc2-6794-11eb-0d1f-4f9723baf62f


# ╔═╡ 4565323c-6797-11eb-033c-6fbfe296e97f
function uniform_weights(m)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ 4cce030a-6797-11eb-2ee8-9186d0df651d
function triangle_weights(m)
	w = zeros(2m+1)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ 4cce3410-6797-11eb-2c51-abae53886909
function gaussian_weights(m; σ=4)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ ebe4c592-6796-11eb-28e4-b30b3aabc4f9
begin 
	m₁ = 3
	try
		global Wu = uniform_weights(m₁)
		global Wt = triangle_weights(m₁)
		global Wg = gaussian_weights(m₁)
	catch e 
	end
	
	fs = (600, 280)
	
	pl31 = scatter(@safe 1:length(Wu), Wu; label="", ylims=[0, 1.5maximum(Wu)], xlabel="weights", size=fs,
	background_color="#F8F8F8", ms = 6)
	title!("Your result:")
	
	pl32 = scatter(@safe 1:length(Wt), Wt; label="", xlabel="weights", size=fs,
	background_color="#F8F8F8", ms = 6)
	title!("Your result:")
	
	pl33 = scatter(@safe 1:length(Wg), Wg; label="", xlabel="weights", size=fs,
	background_color="#F8F8F8", ms = 6)
	title!("Your result:")
	
	q31 = Question(
			description = md"""
		- **uniform**: all values of $\mathbf{w}$ are the same;
		
		$(pl31)
		""",
		validators = @safe[
			uniform_weights(7) ≈ Solutions.uniform_weights(7)
		]
		)
	
	q32 = Question(
		description = md"""
		- **[triangle](https://en.wikipedia.org/wiki/Triangular_function)**: linearly increasing from index $i=1$ till index $i=m+1$ and linearly decreasing from $i=m+1$ to $2m+1$;
		
		$(pl32)
		""",
		validators = @safe[
			triangle_weights(7) ≈ Solutions.triangle_weights(7)
		]
		
	)
	
	q33 = Question(
		description = md"""
		- **Gaussian**: proportional to $\exp(-\frac{(i-m - 1)^2}{2\sigma^2})$ with $i\in 1,\ldots,2m+1$. The *bandwidth* is given by $\sigma$, let us set it to 4. 

		$(pl33)
		""",
		validators = @safe[
			gaussian_weights(7) ≈ Solutions.gaussian_weights(7)
		]
	)

	qb3 = QuestionBlock(;
		title=md"**Question: common weight vectors**",
		description = 
		md"""

		Let us test some different weight vectors, several options seem reasonable:

		For this purpose, make sure that they are all normalized, either by design or by divididing the vector by the total sum at the end.

		""",
		questions = @safe[q31, q32, q33],
		hints = [
			hint(md"Don't forget the meaning of `m`!")	
		]
	)
	
	validate(qb3, tracker)
end

# ╔═╡ be3996da-67a8-11eb-1041-afb0b6d92458


# ╔═╡ ac7ae05a-67a8-11eb-1d3d-6da1cc61f2a9
md"### Application 1: pandemic processing"

# ╔═╡ 72b37606-679a-11eb-2244-e1bdda26f16b
md"""
As an example, let us try to process the number of COVID cases that were reported in Belgium since the beginning of the measurements. These can easily be downloaded from [Sciensano](https://epistat.sciensano.be/Data/)."""

# ╔═╡ 72e681c2-679a-11eb-37c2-c1ddd02a0cfc
begin
	download("https://epistat.sciensano.be/Data/COVID19BE_CASES_AGESEX.csv", "COVID19BE_CASES_AGESEX.csv")
	covid_data = CSV.read("COVID19BE_CASES_AGESEX.csv", DataFrame)
	covid_data = combine(groupby(covid_data, :DATE), :CASES=>sum)
end

# ╔═╡ 72f1465c-679a-11eb-0544-b94495a5f7ea
covid_cases = covid_data[1:end-1,2]

# ╔═╡ 730a74f6-679a-11eb-2cdf-19fe21dcf5c2
covid_dates = [Date(d, "yyyy-mm-dd") for d in covid_data[1:end-1,1]]

# ╔═╡ 730b2658-679a-11eb-23a8-7d84c146c1f1
plot(covid_dates, covid_cases, label="measured COVID cases in Belgium")

# ╔═╡ 731805ee-679a-11eb-2bec-49e59680f7b7
begin 	
	qb4 = QuestionBlock(
		title=md"**Question: processing COVID data**",
		description = md"""
		You can see that the plot is very noisy use convolution to smooth things out!
		
		Explore both the triangle and Gaussian kernels,
		
		1. What is the effect of the number of weights?
		2. What is the effect of σ of in the Gaussian kernel?
		3. Is there a problem with a high number of weights?
		""",
		questions = [Question(;description=md"", validators = Bool[], status=md"")],
		hints = [
			hint(md" Subquestion 3 refers to the weekend effect.")	
		]
	)

end

# ╔═╡ dbfcabb4-679a-11eb-3eef-8f1bc1542688


# ╔═╡ d1b4c97a-679a-11eb-3733-fb4c93a73bae
md"""
### Application 2: protein analysis


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

# ╔═╡ d1ff8c26-679a-11eb-3e49-493e9845dbf5
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

# ╔═╡ d200d54a-679a-11eb-2456-9f6316aa57f4
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

# ╔═╡ d2174afc-679a-11eb-24a0-cf47e97968df
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

# ╔═╡ d218a1ac-679a-11eb-2bab-af40bf39b2c0
md"""
So, we will compute a sliding window of length $2m+1$ on a protein sequence $s$:

$$y_i = \frac{1}{2m+1} \sum_{k=-m}^m z_{s_{i-k}}\,,$$

where $z_{s_{i}}$ is the amino acid property ascociated with amino acid $s_i$.
"""

# ╔═╡ d2277e02-679a-11eb-27e8-6bbc46fd5ae1
md"To be topical, let us try it on the tail spike protein of the SARS-CoV-2 virus. (a baby step towards a new vaccin!)"

# ╔═╡ d227d7a8-679a-11eb-0901-7301975405d7
spike_sars2 = "MFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKVFRSSVLHSTQDLFLPFFSNVTWFHAIHVSGTNGTKRFDNPVLPFNDGVYFASTEKSNIIRGWIFGTTLDSKTQSLLIVNNATNVVIKVCEFQFCNDPFLGVYYHKNNKSWMESEFRVYSSANNCTFEYVSQPFLMDLEGKQGNFKNLREFVFKNIDGYFKIYSKHTPINLVRDLPQGFSALEPLVDLPIGINITRFQTLLALHRSYLTPGDSSSGWTAGAAAYYVGYLQPRTFLLKYNENGTITDAVDCALDPLSETKCTLKSFTVEKGIYQTSNFRVQPTESIVRFPNITNLCPFGEVFNATRFASVYAWNRKRISNCVADYSVLYNSASFSTFKCYGVSPTKLNDLCFTNVYADSFVIRGDEVRQIAPGQTGKIADYNYKLPDDFTGCVIAWNSNNLDSKVGGNYNYLYRLFRKSNLKPFERDISTEIYQAGSTPCNGVEGFNCYFPLQSYGFQPTNGVGYQPYRVVVLSFELLHAPATVCGPKKSTNLVKNKCVNFNFNGLTGTGVLTESNKKFLPFQQFGRDIADTTDAVRDPQTLEILDITPCSFGGVSVITPGTNTSNQVAVLYQDVNCTEVPVAIHADQLTPTWRVYSTGSNVFQTRAGCLIGAEHVNNSYECDIPIGAGICASYQTQTNSPRRARSVASQSIIAYTMSLGAENSVAYSNNSIAIPTNFTISVTTEILPVSMTKTSVDCTMYICGDSTECSNLLLQYGSFCTQLNRALTGIAVEQDKNTQEVFAQVKQIYKTPPIKDFGGFNFSQILPDPSKPSKRSFIEDLLFNKVTLADAGFIKQYGDCLGDIAARDLICAQKFNGLTVLPPLLTDEMIAQYTSALLAGTITSGWTFGAGAALQIPFAMQMAYRFNGIGVTQNVLYENQKLIANQFNSAIGKIQDSLSSTASALGKLQDVVNQNAQALNTLVKQLSSNFGAISSVLNDILSRLDKVEAEVQIDRLITGRLQSLQTYVTQQLIRAAEIRASANLAATKMSECVLGQSKRVDFCGKGYHLMSFPQSAPHGVVFLHVTYVPAQEKNFTTAPAICHDGKAHFPREGVFVSNGTHWFVTQRNFYEPQIITTDNTFVSGNCDVVIGIVNNTVYDPLQPELDSFKEELDKYFKNHTSPDVDLGDISGINASVVNIQKEIDRLNEVAKNLNESLIDLQELGKYEQYIKWPWYIWLGFIAGLIAIVMVTIMLCCMTSCCSCLKGCCSCGSCCKFDEDDSEPVLKGVKLHYT"

# ╔═╡ db647c82-67a8-11eb-379d-b1a395f0d94f
m = 5

# ╔═╡ d87b113e-67a8-11eb-2c53-630788d2bacf
function protein_sliding_window(sequence, m, zscales)
	return missing
end

# ╔═╡ d86372d6-67a8-11eb-0d8e-d94f87b60803
begin 	
	q_ps = QuestionBlock(
		title=md"**Question: complete protein sliding window**",
		description = md"""
		Complete the function `protein_sliding_window` and play around with the parameters. Can you discover a strongly non-polar region in the protein?
		
		Plot the 3rd zscale versus the index of the amino acids in the tail-spike.
		""",
		questions = [
			Question(
				validators = @safe[
					protein_sliding_window(spike_sars2, 5, zscales1) ≈
						Solutions.protein_sliding_window(spike_sars2, 5, zscales1),
					protein_sliding_window(spike_sars2, 25, zscales2) ≈
						Solutions.protein_sliding_window(spike_sars2, 25, zscales2),
					protein_sliding_window(spike_sars2, 5, zscales3) ≈
						Solutions.protein_sliding_window(spike_sars2, 5, zscales3),
				]
				)],
		hints = [
			hint(md"Try to increase the window size for clearer results.")
		]
	)
	validate(q_ps, tracker)
end

# ╔═╡ d87b7174-67a8-11eb-31ad-1fb0ac41184f
proteinsw = protein_sliding_window(spike_sars2, m, zscales3)

# ╔═╡ Cell order:
# ╟─245b6c12-678f-11eb-2765-cfee142b1d26
# ╠═58efc084-678f-11eb-2cff-9728ba22cc17
# ╟─5af8cfda-678f-11eb-0977-85d419805ccb
# ╟─874cda5e-678f-11eb-034e-e5079fff5fc5
# ╟─406cef16-67a8-11eb-2aba-23415f96813f
# ╟─973c3dba-678f-11eb-3d41-0babfffcc82e
# ╠═2e95127c-6790-11eb-1dfb-efac567fa1cf
# ╠═2ec6baca-6790-11eb-3b53-9959545905fe
# ╠═2ec73a2c-6790-11eb-1b3f-9f499c17b0f6
# ╠═2eefe15c-6790-11eb-1362-0752b63e05cf
# ╟─2ef01cc6-6790-11eb-2de5-67e250558cdb
# ╠═2f01e06e-6790-11eb-2ce6-852221110ff2
# ╠═2f02266e-6790-11eb-19cf-8336c103c097
# ╟─2f2cf2d6-6790-11eb-067d-456e8b2f804f
# ╠═2f2d4628-6790-11eb-0fd0-f93ed0057dfe
# ╟─d621de66-6791-11eb-2833-af7559e4a913
# ╟─c79cc3e2-6791-11eb-1ec2-6fc6a3a4876c
# ╟─8533fd10-67a8-11eb-0489-a575230c1580
# ╟─cc3a2fc0-6791-11eb-03f1-3d628e3ea86a
# ╠═cfb49686-6791-11eb-14a2-b34d6bae95b2
# ╟─e06a78d6-6791-11eb-2cbd-85812bc978cc
# ╠═8cfb8f40-6794-11eb-0b33-8d658fe6725b
# ╠═e086d5c0-6791-11eb-2f3e-cd6f7235b114
# ╟─e08784f0-6791-11eb-3afa-39eedd974535
# ╠═e096aba6-6791-11eb-3b0b-2105e2783060
# ╟─e096d8a6-6791-11eb-2734-b384bf77dcd7
# ╠═ee8c34a6-6791-11eb-24b5-a99125b2440c
# ╠═91a0ff62-6794-11eb-3e7f-8f9c8cabc91d
# ╟─d75e338c-6794-11eb-10b0-dd5ef94b6b61
# ╟─9d77127c-6794-11eb-1ba9-5f5256b6be85
# ╠═dc599bc2-6794-11eb-0d1f-4f9723baf62f
# ╟─ebe4c592-6796-11eb-28e4-b30b3aabc4f9
# ╠═4565323c-6797-11eb-033c-6fbfe296e97f
# ╠═4cce030a-6797-11eb-2ee8-9186d0df651d
# ╠═4cce3410-6797-11eb-2c51-abae53886909
# ╟─be3996da-67a8-11eb-1041-afb0b6d92458
# ╟─ac7ae05a-67a8-11eb-1d3d-6da1cc61f2a9
# ╟─72b37606-679a-11eb-2244-e1bdda26f16b
# ╠═72e5ce1c-679a-11eb-251f-ab932941bcb4
# ╠═72e681c2-679a-11eb-37c2-c1ddd02a0cfc
# ╠═72f1465c-679a-11eb-0544-b94495a5f7ea
# ╠═730a74f6-679a-11eb-2cdf-19fe21dcf5c2
# ╠═730b2658-679a-11eb-23a8-7d84c146c1f1
# ╟─731805ee-679a-11eb-2bec-49e59680f7b7
# ╟─dbfcabb4-679a-11eb-3eef-8f1bc1542688
# ╟─d1b4c97a-679a-11eb-3733-fb4c93a73bae
# ╠═d1ff8c26-679a-11eb-3e49-493e9845dbf5
# ╠═d200d54a-679a-11eb-2456-9f6316aa57f4
# ╠═d2174afc-679a-11eb-24a0-cf47e97968df
# ╟─d218a1ac-679a-11eb-2bab-af40bf39b2c0
# ╟─d2277e02-679a-11eb-27e8-6bbc46fd5ae1
# ╠═d227d7a8-679a-11eb-0901-7301975405d7
# ╠═db647c82-67a8-11eb-379d-b1a395f0d94f
# ╟─d86372d6-67a8-11eb-0d8e-d94f87b60803
# ╠═d87b113e-67a8-11eb-2c53-630788d2bacf
# ╠═d87b7174-67a8-11eb-31ad-1fb0ac41184f
