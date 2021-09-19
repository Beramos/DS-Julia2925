### A Pluto.jl notebook ###
# v0.16.0

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

# ╔═╡ cf4e10a8-4862-11eb-05fd-c1a09cbb1bcd
using PlutoUI, Plots

# ╔═╡ c962de82-3c9e-11eb-13df-d5dec37bb2c0
using CSV, DataFrames, Dates

# ╔═╡ c41426f8-5a8e-11eb-1d49-11c52375a7a0
using Images

# ╔═╡ 786b3780-58ec-11eb-0dfd-41f5af6f6a39
# edit the code below to set your name and UGent username

student = (name = "Jan Janssen", email = "Jan.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 981758aa-58e9-11eb-282c-89131d9317b4
begin 
	using Pkg; Pkg.activate("../..")
	using DSJulia;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ 2411c6ca-2bdd-11eb-050c-0399b3b0d7af
md"""
# Project 1: images and cellular automata

We wrap up day 1 by exploring convolutions and similar operations on 1-D and 2-D (or even n-D!) matrices. Departing from some basic building blocks we will cover signal processing, image processing and cellular automata!

**Learning goals:**
- code reuse;
- efficient use of collections and unitRanges;
- control flow in julia;

"""

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

# ╔═╡ f272855c-3c9e-11eb-1919-6b7301b15699
function mean(x)
	return missing
end

# ╔═╡ 66a20628-4834-11eb-01a2-27cc2b1ec7be
x = [2.1, 3.2, 5.4, 4.9, 6.1]

# ╔═╡ 432c3892-482c-11eb-1467-a3b9c1592597
mean(x)

# ╔═╡ 88c10640-4835-11eb-14b0-abba18da058f
weighted_mean(x, w) = missing

# ╔═╡ c7cd636e-5db2-11eb-2895-cd474cc85d18
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

# ╔═╡ a657c556-4835-11eb-12c3-398890e70105
md"We compute the mean again, now using the information that the numbers were collected subsequently and that we give a weight linearly proportional to the position (points further away have a lower contribution to the mean),

$$w_i = \cfrac{i}{\sum_j^n j} \, .$$

For example,

$$[w_1, w_2, w_3] = [1/3, 2/3, 3/3]\, .$$

"

# ╔═╡ 181c4246-4836-11eb-0368-61b2998f5424
wx = collect((1:5) / sum(1:5))

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

# ╔═╡ a1f75f4c-2bde-11eb-37e7-2dc342c7032a
function convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	@assert length(w) < length(x) "length of `w` should be smaller than `x`"
	n = missing
	m = missing
	y = missing # initialize the output

	# ... complete
	return y
end

# ╔═╡ b0dd68f2-58ee-11eb-3c67-f1c4edf8f7c3
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

# ╔═╡ 7945ed1c-598c-11eb-17da-af9a36c6a68c
md"""
Let's try this out on an example, consider a noisy signal,
"""

# ╔═╡ 546beebe-598d-11eb-1717-c9687801e647
noisy_signal(tᵢ; σ=10) = 5tᵢ + 5sin(tᵢ) +  σ * rand();

# ╔═╡ f39d88f6-5994-11eb-041c-012af6d3bae6
md"We use the convolution function we defined to construct a moving_average function,"

# ╔═╡ f94e2e6c-598e-11eb-041a-0b6a068e464c
moving_average(f::Function, t, w) = convolve_1d(f.(t), ones(w).*1/w);

# ╔═╡ 4e45e43e-598f-11eb-0a0a-2fa636748f7c
@bind wₑ Slider(1:2:43, default=3)

# ╔═╡ 0563fba2-5994-11eb-2d81-f70d10092ad7
md"Number of weights (w) : $wₑ"

# ╔═╡ 8e53f108-598d-11eb-127f-ddd5be0ec899
begin 
	t = 0:0.01:10
	plot(t, noisy_signal.(t), label="Noisy", ylabel="Signal (-)", xlabel="time(s)")
	plot!(t, moving_average(noisy_signal, t, wₑ), label="Filtered", lw = 2)
end

# ╔═╡ c6e0a656-5dbb-11eb-0ce7-598f4fb85bee


# ╔═╡ 99a7e070-5995-11eb-0c53-51fc82db2e93


# ╔═╡ 22261bf2-5995-11eb-2d52-932589333c47
QuestionBlock(;
	title=md"**Task:**",
	description = md"""
	Explore this filtering technique by changing the number of weights. Try to understand how the `moving_average` function behaves.
	"""
)

# ╔═╡ b31400fc-5db4-11eb-2430-fd1ea1008280


# ╔═╡ 7c12bcf6-4863-11eb-0994-fb7d763c0d47
function uniform_weights(m)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ 294140a4-2bf0-11eb-22f5-858969a4640d
function triangle_weights(m)
	w = zeros(2m+1)
	# complete and replace [0.0]
	return [0.0]
end	

# ╔═╡ d8c7baac-49be-11eb-3afc-0fedae12f74f
function gaussian_weights(m; σ=4)
	# complete and replace [0.0]
	return [0.0]
end

# ╔═╡ 64bf7f3a-58f0-11eb-1782-0d33a2b615e0
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

# ╔═╡ 2b07134c-598c-11eb-155a-6b28a98e76ca
md"### Application 1: pandemic processing"

# ╔═╡ ff3241be-4861-11eb-0c1c-2bd093e3cbe9
md"""
As an example, let us try to process the number of COVID cases that were reported in Belgium since the beginning of the measurements. These can easily be downloaded from [Sciensano](https://epistat.sciensano.be/Data/)."""

# ╔═╡ 31e39938-3c9f-11eb-0341-53670c2e93e1
begin
	download("https://epistat.sciensano.be/Data/COVID19BE_CASES_AGESEX.csv", "COVID19BE_CASES_AGESEX.csv")
	covid_data = CSV.read("COVID19BE_CASES_AGESEX.csv", DataFrame)
	covid_data = combine(groupby(covid_data, :DATE), :CASES=>sum)
end

# ╔═╡ caef0432-3c9f-11eb-2006-8ff54211b2b3
covid_cases = covid_data[1:end-1,2]

# ╔═╡ b3ec8362-482d-11eb-2df4-2343ee17444a
covid_dates = [Date(d, "yyyy-mm-dd") for d in covid_data[1:end-1,1]]

# ╔═╡ 8a996336-2bde-11eb-10a3-cb0046ed5de9
plot(covid_dates, covid_cases, label="measured COVID cases in Belgium")

# ╔═╡ cb9945f6-5995-11eb-3b10-937cde05fa31
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

# ╔═╡ d2321a9c-5996-11eb-0380-47aa8ec777af


# ╔═╡ 36f73086-5dbc-11eb-250a-775130b479ae


# ╔═╡ b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
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

# ╔═╡ c23ff59c-3ca1-11eb-1a31-2dd522b9d239
function protein_sliding_window(sequence, m, zscales)
	return missing
end

# ╔═╡ 19a98dd4-599e-11eb-2b1c-172e00137e6c
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

# ╔═╡ 134edde4-5a8f-11eb-117f-455e04acc27d
begin
	q101 = Question(
			description=md"""
			Complete the function `decimate(image, ratio=5)`		
			""", 
			validators = @safe[])
	
	qb10 = QuestionBlock(
		title=md"**Question: decimate image**",
		description = md"""
		To proceed with the course we would like smaller images. Since images are just matrices it should not be too challenging to write a function that takes an `image` and resamples the number of pixels so that it is a `ratio` smaller.
		""",
		questions = [q101],
		hints= [
			hint(md"`1:n:end` takes every `n`-th index in a matrix")
			]
	)
	validate(qb10, tracker)
end

# ╔═╡ 13807912-5a8f-11eb-3ca2-09030ee978ab
decimate(image, ratio=5) = missing

# ╔═╡ aba77250-5a8e-11eb-0db1-9f2d8fc726e9
smallbird = decimate(bird_original, 6)

# ╔═╡ d3027d8a-7e80-4a22-bd7b-3f689e3232a4
md"🐦 Compare your image with the answer below."

# ╔═╡ 6d5de3b8-5dbc-11eb-1fc4-8df16c6c04b7
bird = Solutions.decimate(bird_original, 6)

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

# ╔═╡ d1851bbe-5a91-11eb-3ae4-fddeff381c1b
function convolve_2d(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	#...
	return missing
end

# ╔═╡ f5574a90-5a90-11eb-3100-dd98e3375390
function gaussian_kernel(m; σ=4)
	return missing
end

# ╔═╡ ca0748ee-5e2e-11eb-0199-45a98c0645f2
function convolve_image(M::Matrix{<:AbstractRGB}, K::Matrix)
	return missing
end

# ╔═╡ 4d434b48-5a91-11eb-2df8-9d2ea289878e
begin 	
	M_rand = rand(20, 20)
	K_rand = rand(5, 5)
	
	test_kernel = [0 -1 0;
					-1 5 -1;
					0 -1 0]
	
	q111 = Question(
			description=md"""
			**Exercise:**
		
			Complete the function `convolve_2d(M::Matrix, K::Matrix)` that performs a 2D-convolution of an input matrix `M` with a kernel matrix `K`. You can use the same boundary conditions as we used for the 1D convolution.
			""",
			validators = @safe[
				convolve_2d(M_rand, K_rand) ≈ Solutions.convolve_2d(M_rand, K_rand)
			]
		)
	
	q112 = Question(
			description=md"""
**Exercise:**
		
Remember the 1-D Gaussian kernel? Its 2-D analogue is given by

$$K_{i,j} = \exp\left(-\frac{(i-m - 1)^2 +(j-m-1)^2}{2\sigma^2}\right)\,.$$

Using this kernel results in a smoothing operation, often refered to as a Gaussian blur. This kernel is frequently used to remove noise, but it will also remove some edges of the image. Gaussian kernel convolution gives a blurring effect making the image appearing to be viewed through a translucent screen, giving a slight [otherworldly effect](https://tvtropes.org/pmwiki/pmwiki.php/Main/GaussianGirl).


Let us implement the Gaussian kernel by completing the function below.
			""",
			validators = @safe[
				gaussian_kernel(10; σ=4) ≈ Solutions.gaussian_kernel(10; σ=4) 
			]
		)
			
	
	q113 = Question(
			description=md"""
			**Optional exercise (Easy):**
		
			Explore the Gaussian kernel by plotting a `heatmap` of this kernel for a given number of weights and σ.

			"""
		)
	
	q114 = Question(
			description=md"""
**Exercise:**
		
The 2D-convolution can not be directly used on images since images are matrixes of triplets of values. Write a function `convolve_image(M, K)` that performs a convolution on an images and use the previously implemented `convolve_2d(M::Matrix, K::Matrix)` function. Previously, it was demonstrated how to extract the idividual colour channels from an images. A convolution of an image is nothing more than a convolution performed on these channels, separately. To avoid inaccuracies you should convert each channel (Red, Green, Blue) to a `Float32` before convolutions.
			""",
			validators = @safe[
				convolve_image(bird, test_kernel) == 
					Solutions.convolve_image(bird, test_kernel) 
			]
		)
		
		
	q115 = Question(
			description=md"""
Test this new function by applying the Gaussian kernel to our favourite bird image.
			"""
		)
			
	qb11 = QuestionBlock(;
		title=md"**Question: Two-dimensional convolution on images**",
		description = md"""
Just like we did in 1D, we can define a convolution on matrices and images:

$$Y_{i,j} = \sum_{k=-m}^{m} \, \sum_{l=-m}^{m} X_{i + k,\, j+l}\, K_{m+(k+1),\, m+(l+1)}\,.$$

This looks more complex but still amounts to the same thing as the 1D case. We have an $2m+1 \times 2m+1$ kernel matrix $K$, which we use to compute a weighted local sum.
		""",
		questions = @safe[q111, q112, q113, q114, q115],
		hints = [
			hint(md"Did you take into account the boundary conditions? The function `clamp` can help you with that."),
			hint(md""" 
				You can easily convert an argument of a function by piping it into a type:  
				```julia
					function(some_array_var .|> Float32, ...)
				```
				""")	
			
		]
	)
	
	validate(qb11)
end

# ╔═╡ f55f8e6c-5a90-11eb-14fa-1168810ec819
#K_gaussian = gaussian_kernel(3, σ=2)

# ╔═╡ f589c15a-5a90-11eb-2a69-fba0819a4993
#heatmap(K_gaussian)

# ╔═╡ 1e97c530-5a8f-11eb-14b0-47e7e944cba1
#bird

# ╔═╡ f58d5af4-5a90-11eb-3d93-5712bfd9920a
#convolve_image(bird, K_gaussian)

# ╔═╡ a588a356-5a95-11eb-27e8-cb8d394b6ff6
begin 	
	q121 = Question(
		description=md"""
		Kernels emphasise certain features in images and often they have a directionality. `K_x` and `K_y` are known as [Sobol filters](https://en.wikipedia.org/wiki/Sobel_operator) and form the basis of edge detection. Which is just a combination of `K₂` (x-direction) and `K₃` (y-direction),
		
		$$G = \sqrt{G_x^2 + G_y^2}\, ,$$
		
		which is the square-root of the sum of the squared convolution with the `K_x` kernel and the `K_y` kernel. Implement edge detection and test it on the our bird. 
		"""
		)
				
	qb12 = QuestionBlock(;
		title=md"**Optional question: testing some cool kernels**",
		description = md"""
Different kernels can do really cool things. Test and implement the following kernels,

```julia
K₁ = [0 -1 0;   # test on blurry bird and original bird
	  -1 5 -1;
	   0 -1 0]
		
K_x = [1 0 -1;  # on a grayscale image
	   2 0 -2;
	   1 0 -1]
		
K_y = [1 2 1;  # on a grayscale image
       0 0 0;
	   -1 -2 -1]
		
K₄ = [-2 -1 0;  
       -1 1 1;
	   0 1 2]
```

What do you think these kernels do?
		""",
		questions = @safe[q121],

	)
	
	validate(qb12)
end

# ╔═╡ f80ab6ba-5e2f-11eb-276c-31bbd5b0fee9
K_gaussian2 = Solutions.gaussian_kernel(3, σ=2)

# ╔═╡ e5042bac-5e2f-11eb-28bb-dbf653abca17
blurry_bird = Solutions.convolve_image(bird, K_gaussian2)

# ╔═╡ 516b1e7c-5e35-11eb-2ef5-4fa72c35878e


# ╔═╡ 520771bc-5e35-11eb-0252-bfc7d76872f1


# ╔═╡ 52a87820-5e35-11eb-0392-85957277f21a
function edge_detection(M)
	return missing
end

# ╔═╡ 4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
md"""
### Elementary cellular automata

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
@terminal println(rule)

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


# ╔═╡ b43157fa-482e-11eb-3169-cf4989528800
getbinarydigit(rule, i) = missing

# ╔═╡ 2d4e9afe-59cc-11eb-3033-05d9b684b399
begin 	
	qb5 = QuestionBlock(
		title=md"**Optional question (hard)**",
		description = md"""
		Can you think of a way to get the transitioned state given a rule  and a position of a bit in the bitstring? Complete the function `getbinarydigit(rule, i)`.
		For confident programmers, it is possible to do this in a single line. 
		""",
		questions = [
			Question(;description=md"", 
				validators = @safe[
					getbinarydigit(UInt8(110), 5) == 
						Solutions.getbinarydigit(UInt8(110), 5)
					])
		],
		hints = [

			hint(md"The solution is hidden in the next hint."), 
			hint(md""" 
				```julia
				getbinarydigit(rule, i) = isodd(rule >> i)
				```"""),
			hint(md"Don't worry if you don't get fully understand the oneliner, it is bitstring manipulation and is not usually part of a scientific programming curriculum."),
			hint(md"A more naive and less efficient solution would be to convert the rule integer to a string (not a bitstring), which supports indexing. ")
		]
	)
	validate(qb5)
end

# ╔═╡ 781d38a8-59d4-11eb-28f9-9358f132782c
[getbinarydigit(rule, i) for i in 7:-1:0]  # counting all positions

# ╔═╡ 8b6b45c6-64e2-11eb-3662-7de5e25e6faf


# ╔═╡ 00f6e42c-59d4-11eb-31c7-d5aa0105e7cf
getbinarydigit(rule, 4true+2true+1true+1)

# ╔═╡ d2e5787c-59d2-11eb-1bbd-d79672ab8f1b
begin
	function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
		return missing
	end
	
	nextstate(l::Bool, s::Bool, r::Bool, rule::Int) = missing
end

# ╔═╡ 1301a3f4-59d0-11eb-2fc5-35e9c1f0841a
begin 	
	q61 = Question(
			description=md" Complete `nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)`", 
			validators = @safe[
				nextstate(true, false, false, UInt8(110)) == 
					Solutions.nextstate(true, false, false, UInt8(110))
			])
	
	q62 = QuestionOptional{Intermediate}(
			description=md"Using multiple dispatch, write a second function `nextstate(l::Bool, s::Bool, r::Bool, rule::Int)`  so that the rule can be provided as any Integer.", 
			validators = @safe[
				nextstate(true, false, false, 110) == 
					Solutions.nextstate(true, false, false, 110)
			])
	
	qb6 = QuestionBlock(
		title=md"**Question: transitioning the individual states**",
		description = md"""
		Now for the next step, given a state `s` and the states of its left (`l`) and right (`r`) neighbours, can you determine the next state under a `rule` (UInt8)?

		""",
		questions = [q61, q62],
		hints = [
			hint(md"Do not forget you have just implemented `getbinarydigit(rule, i)`."),
			hint(md"In the example of the rules displayed above, all 8 possible combinations of (`l`, `s`, `r`) always refer to the same position in the bitstring."),
			
			hint(md"`8-(4l+2s+1r)`"),
		]
	)
	validate(qb6, tracker)
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

# ╔═╡ 924461c0-2bf3-11eb-2390-71bad2541463
function update1dca!(xnew, x, rule::Integer)
	return missing
end

# ╔═╡ 21440956-2bf5-11eb-0860-11127d727282
update1dca(x, rule::Integer) = missing

# ╔═╡ e46a3f52-5a5a-11eb-1d41-d7d031131d7e
begin 	
	x0_quest = rand(Bool, 100)
	rule_quest = UInt8(110)
	
	
	q71 = Question(
			description=md"""
		Complete `update1dca!(xnew, x, rule::Integer)` that performs a single iteration of the cellular automata given an initial state array `x`, and overwrites the new state array `xnew`, given a certain rule integer. For the boundaries you can assume that the vector loops around so that the first element is the neighbour of the last element.
		$(fyi(md"`!` is often used as suffix to a julia function to denote an inplace operation. The function itself changes the input arguments directly. `!` is a naming convention and does not fulfill an actual functionality"))
		
			""", 
			validators = @safe[
				update1dca!(similar(x0_quest), x0_quest, rule_quest) == 
					Solutions.update1dca!(similar(x0_quest), x0_quest, rule_quest)
			])
	
		q72 = QuestionOptional{Easy}(
			description=md"""
		Complete `xnew = update1dca(x, rule::Integer)` function that performs the same action as `update1dca!` but with an explicit return of the new state array. It is possible to do this in a single line.
			""",
			validators = @safe[
				update1dca(x0_quest, rule_quest) == 
					Solutions.update1dca(x0_quest, rule_quest)
			]
	)
	
	qb7 = QuestionBlock(
		title=md"**Question: evolving the array**",
		description = md"""
		Now that we are able the transition the individual states, it is time to overcome the final challenge, evolving the entire array! Usually in cellular automata all the initial states transition simultaneously from the initial state to the next state.
		""",
		questions = [q71, q72],
		hints= [
			hint(md"""`similar(x)` is a useful function to initialise a new matrix of the same type and dimensions of the array `x`	""")	
		]
	)
	validate(qb7, tracker)
end

# ╔═╡ 405a1036-2bf5-11eb-11f9-a1a714dbf7e1
x0_ca = rand(Bool, 100)

# ╔═╡ 6405f574-2bf5-11eb-3656-d7b9c94f145a
update1dca(x0_ca, rule)

# ╔═╡ e8ddcd80-5f1c-11eb-00bb-6badc5a9ffaa


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

# ╔═╡ 2faf6176-5a5e-11eb-241d-4383971500e3
begin 	
	q81 = Question(
			description=md"""
		Complete `simulate(x0, rule::UInt8; nsteps=100)` that performs a `nsteps` of simulation  given an initial state array `x0` and a rule 
		
			""", 
			validators = @safe[
				simulate(x0_quest, rule_quest; nsteps=10) ==
					Solutions.simulate(x0_quest, rule_quest; nsteps=10)
			])
	
	q82 = Question(
		description=md"""
	Plot the evolution of state array at each iteration as an image.

		""")

	qb8 = QuestionBlock(
		title=md"**Question: simulating the cellular automata**",
		description = md"""
		Now that we are able to transition the individual states, it is time to overcome the final challenge, evolving the entire array! Usually in cellular automata all the initial states transition simultaneously from the initial state to the next state.
		""",
		questions = [q81, q82],
		hints= [
			hint(md"""`similar(x)` is a useful function to initialise a new matrix of the same type and dimensions of the array `x`	"""),
			hint(md"""`Gray(x)` returns the gray component of a color. Try,  `Gray(0)`, `Gray(1)`""")	
		]
	)
	validate(qb8, tracker)
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

# ╔═╡ caefe5ac-5f4d-11eb-2591-67b5515e1bd4
product_code_milk = missing

# ╔═╡ 36786d6e-5a65-11eb-0fa2-81b69989c39e
begin
	rule_ex9 = 171
	initInt_ex9 = 3680689260
	initBs_exp9 = bitstring(initInt_ex9)
	bitArr_ex9 = Solutions.simulate([el == '0' for el in reverse(initBs_exp9)[1:32]], UInt8(rule_ex9); nsteps=50)[end,:]
	
	pl_ex9 = show_barcode(bitArr_ex9)
	
	

	rule2_ex9 = 42
	init_Int2_ex9 = 3681110060
	milk_barcode = bitstring(init_Int2_ex9)
	
	bitArr = Solutions.simulate([el == '0' for el in reverse(milk_barcode)[1:32]], UInt8(rule2_ex9); nsteps=50)[end,:]
	
	pl2_ex9 = show_barcode(bitArr)

	
	q91 = Question(
			description=md""" After generating tons of new barcodes, the employees stumble upon a problem. While it is easy to generate the barcodes given the product codes, it it not trivial to convert a barcode to a product number. Luckily, the employees used the same initial bitstring for all products (*3681110060*).
		
		Can you find the product code for this box of milk **XXX** *3128863161*?
		
		$(pl2_ex9)
		
		The binary form of the barcode is provided below.
			""", 
			validators = @safe[product_code_milk == parse(Int, "$rule2_ex9$init_Int2_ex9")])
	
	qb9 = QuestionBlock(
		title=md"**Optional question: Barcode bonanza**",
		description = md"""
		A simple barcode is data represented by varying the widths and spacings of parallel lines. However this is just an array of binary values that correspondent to an integer number.
		
		![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/UPC-A-036000291452.svg/220px-UPC-A-036000291452.svg.png)
		
		The laser scanner reads the barcode and converts the binary number to an integer which is the product code, a pretty simple and robust system.
		
		A local supermarket completely misread the protocol and accidentally use a cellular automata to convert the binary number into an integer. Their protocol is a little convoluted,		
			
		The number corresponding to a barcode is the **rule number** followed by the *initial 32-bit array encoded as an integer* (initial condition). The barcode is generated by taking the rule number and evolving the initial condition for 50 iterations.
		
		As an example this barcode corresponds to the number: 
		**$(rule_ex9)** *3128863161*
		
		$(pl_ex9)
		
		
		Which is *3128863161* converted to a bitstring as initial array iterated for 50 iterations using rule: $(rule_ex9)
		""",
		questions = [q91],
	)
	validate(qb9)
end

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
		return sqrt.(Solutions.convolve_2d(M, Gx).^2 + Solutions.convolve_2d(M, Gy).^2) .|> Gray
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

# ╔═╡ Cell order:
# ╟─981758aa-58e9-11eb-282c-89131d9317b4
# ╠═786b3780-58ec-11eb-0dfd-41f5af6f6a39
# ╟─2411c6ca-2bdd-11eb-050c-0399b3b0d7af
# ╠═cf4e10a8-4862-11eb-05fd-c1a09cbb1bcd
# ╟─e1147d4e-2bee-11eb-0150-d7af1f51f842
# ╟─c7cd636e-5db2-11eb-2895-cd474cc85d18
# ╠═f272855c-3c9e-11eb-1919-6b7301b15699
# ╠═66a20628-4834-11eb-01a2-27cc2b1ec7be
# ╠═432c3892-482c-11eb-1467-a3b9c1592597
# ╠═88c10640-4835-11eb-14b0-abba18da058f
# ╟─9fa895b2-b327-4789-8aab-6259ca85c7cd
# ╟─a657c556-4835-11eb-12c3-398890e70105
# ╠═181c4246-4836-11eb-0368-61b2998f5424
# ╠═94a950fe-4835-11eb-029c-b70de72c20e6
# ╟─52706c6a-4836-11eb-09a8-53549f16f5c2
# ╠═4dc28cdc-4836-11eb-316f-43c04639da2a
# ╟─8b4c6880-4837-11eb-0ff7-573dd18a9664
# ╟─b0dd68f2-58ee-11eb-3c67-f1c4edf8f7c3
# ╠═a1f75f4c-2bde-11eb-37e7-2dc342c7032a
# ╟─99272f4e-b873-4f70-88e6-10bdbca069fe
# ╟─7945ed1c-598c-11eb-17da-af9a36c6a68c
# ╠═546beebe-598d-11eb-1717-c9687801e647
# ╟─f39d88f6-5994-11eb-041c-012af6d3bae6
# ╠═f94e2e6c-598e-11eb-041a-0b6a068e464c
# ╟─0563fba2-5994-11eb-2d81-f70d10092ad7
# ╟─4e45e43e-598f-11eb-0a0a-2fa636748f7c
# ╠═8e53f108-598d-11eb-127f-ddd5be0ec899
# ╠═c6e0a656-5dbb-11eb-0ce7-598f4fb85bee
# ╟─99a7e070-5995-11eb-0c53-51fc82db2e93
# ╟─22261bf2-5995-11eb-2d52-932589333c47
# ╟─b31400fc-5db4-11eb-2430-fd1ea1008280
# ╟─64bf7f3a-58f0-11eb-1782-0d33a2b615e0
# ╠═7c12bcf6-4863-11eb-0994-fb7d763c0d47
# ╠═294140a4-2bf0-11eb-22f5-858969a4640d
# ╠═d8c7baac-49be-11eb-3afc-0fedae12f74f
# ╟─b2d992ab-66da-4f8f-a313-6a828b62b70d
# ╟─2b07134c-598c-11eb-155a-6b28a98e76ca
# ╟─ff3241be-4861-11eb-0c1c-2bd093e3cbe9
# ╠═c962de82-3c9e-11eb-13df-d5dec37bb2c0
# ╠═31e39938-3c9f-11eb-0341-53670c2e93e1
# ╠═caef0432-3c9f-11eb-2006-8ff54211b2b3
# ╠═b3ec8362-482d-11eb-2df4-2343ee17444a
# ╠═8a996336-2bde-11eb-10a3-cb0046ed5de9
# ╟─cb9945f6-5995-11eb-3b10-937cde05fa31
# ╠═d2321a9c-5996-11eb-0380-47aa8ec777af
# ╟─36f73086-5dbc-11eb-250a-775130b479ae
# ╟─b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
# ╠═87610484-3ca1-11eb-0e74-8574e946dd9f
# ╠═9c82d5ea-3ca1-11eb-3575-f1893df8f129
# ╠═a4ccb496-3ca1-11eb-0e7a-87620596eec1
# ╟─9f62891c-49c2-11eb-3bc8-47f5d2e008cc
# ╟─328385ca-49c3-11eb-0977-c79b31a6caaf
# ╠═c924a5f6-2bf1-11eb-3d37-bb63635624e9
# ╠═7e96f0d6-5999-11eb-3673-43f7f1fa0113
# ╟─19a98dd4-599e-11eb-2b1c-172e00137e6c
# ╠═c23ff59c-3ca1-11eb-1a31-2dd522b9d239
# ╟─085a24fb-f71d-4edb-ba8c-a3f1047c60c2
# ╠═17e7750e-49c4-11eb-2106-65d47b16308c
# ╟─236f1ee8-64e2-11eb-1e60-234754d2c10e
# ╟─0b847e26-4aa8-11eb-0038-d7698df1c41c
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
# ╟─134edde4-5a8f-11eb-117f-455e04acc27d
# ╠═13807912-5a8f-11eb-3ca2-09030ee978ab
# ╟─37d3969f-a3e6-4d59-8ead-177d149bbbf7
# ╠═aba77250-5a8e-11eb-0db1-9f2d8fc726e9
# ╟─d3027d8a-7e80-4a22-bd7b-3f689e3232a4
# ╠═6d5de3b8-5dbc-11eb-1fc4-8df16c6c04b7
# ╠═1dfc943e-5a8f-11eb-336b-15b40b9fe412
# ╟─1e0383ac-5a8f-11eb-1b6d-234b6ad6e9fa
# ╠═1e2ac624-5a8f-11eb-1372-05ca0cbe828d
# ╟─1e2ebef0-5a8f-11eb-2a6c-2bc3dffc6c73
# ╟─1e5db70a-5a8f-11eb-0984-6ff8e3030923
# ╟─4d434b48-5a91-11eb-2df8-9d2ea289878e
# ╠═d1851bbe-5a91-11eb-3ae4-fddeff381c1b
# ╠═f5574a90-5a90-11eb-3100-dd98e3375390
# ╠═ca0748ee-5e2e-11eb-0199-45a98c0645f2
# ╠═f55f8e6c-5a90-11eb-14fa-1168810ec819
# ╠═f589c15a-5a90-11eb-2a69-fba0819a4993
# ╠═1e97c530-5a8f-11eb-14b0-47e7e944cba1
# ╠═f58d5af4-5a90-11eb-3d93-5712bfd9920a
# ╟─e090373d-1e9e-45f6-bd26-bdcd9ddf4a3a
# ╟─a588a356-5a95-11eb-27e8-cb8d394b6ff6
# ╠═f80ab6ba-5e2f-11eb-276c-31bbd5b0fee9
# ╠═e5042bac-5e2f-11eb-28bb-dbf653abca17
# ╠═516b1e7c-5e35-11eb-2ef5-4fa72c35878e
# ╠═520771bc-5e35-11eb-0252-bfc7d76872f1
# ╠═52a87820-5e35-11eb-0392-85957277f21a
# ╟─99cf56dc-aeb3-4f8e-ae52-5b9f639f800e
# ╟─4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
# ╟─b0bd61f0-49f9-11eb-0e6b-69539bc34be8
# ╠═b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
# ╠═fabce6b2-59cc-11eb-2181-43fe08fcbab9
# ╠═05973498-59cd-11eb-2d56-7dd28db4b8e5
# ╟─c61755a6-49f9-11eb-05a0-01d914d305f3
# ╠═a6e7441a-482e-11eb-1edb-6bd1daa00390
# ╟─bec6e3d2-59c8-11eb-0ddb-79795043942d
# ╟─6e184088-59c9-11eb-22db-a5858eab786d
# ╟─1f6262b6-59cc-11eb-1306-0d1ca9f3f8e6
# ╟─2d4e9afe-59cc-11eb-3033-05d9b684b399
# ╠═b43157fa-482e-11eb-3169-cf4989528800
# ╟─5e84dd4a-fabe-452c-a274-663b1ba94f5a
# ╠═781d38a8-59d4-11eb-28f9-9358f132782c
# ╟─8b6b45c6-64e2-11eb-3662-7de5e25e6faf
# ╟─1301a3f4-59d0-11eb-2fc5-35e9c1f0841a
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
# ╟─e46a3f52-5a5a-11eb-1d41-d7d031131d7e
# ╠═924461c0-2bf3-11eb-2390-71bad2541463
# ╠═21440956-2bf5-11eb-0860-11127d727282
# ╟─c9fac3a6-e3ad-4f0e-bc71-a36a593094f7
# ╠═405a1036-2bf5-11eb-11f9-a1a714dbf7e1
# ╠═6405f574-2bf5-11eb-3656-d7b9c94f145a
# ╟─e8ddcd80-5f1c-11eb-00bb-6badc5a9ffaa
# ╟─2faf6176-5a5e-11eb-241d-4383971500e3
# ╠═756ef0e0-2bf5-11eb-107c-8d1c65eacc45
# ╟─bde632e9-3aa4-4a9e-a736-f41ad057b231
# ╠═e1dd7abc-2bf5-11eb-1f5a-0f46c7405dd5
# ╠═9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
# ╠═fb9a97d2-2bf5-11eb-1b92-ab884f0014a8
# ╠═95dbe546-5f18-11eb-34d3-0fb6e14302e0
# ╟─333d2a1a-5f4c-11eb-188a-bb221700e8a0
# ╟─36786d6e-5a65-11eb-0fa2-81b69989c39e
# ╠═caefe5ac-5f4d-11eb-2591-67b5515e1bd4
# ╠═46449848-64e3-11eb-0bf4-c9211b41c68d
# ╟─670d4db7-924b-4c44-9729-8677a9b757c8
