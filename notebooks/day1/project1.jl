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

# ╔═╡ cf4e10a8-4862-11eb-05fd-c1a09cbb1bcd
using PlutoUI, Plots

# ╔═╡ c962de82-3c9e-11eb-13df-d5dec37bb2c0
using CSV, DataFrames, Dates

# ╔═╡ 87c5bb72-4aa7-11eb-3897-a523011703c5
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
	using DSJulia;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ 2411c6ca-2bdd-11eb-050c-0399b3b0d7af
md"""
# Project 1: images and cellular automata

We wrap up the day by exploring convolutions and similar operations on 1-D and 2-D (or even n-D!) matrices. Departing from some basic building blocks we will cover signal processing, image processing and cellular automata!

**Learning goals:**
- code reuse;
- speed and performance (including optimizations);
- learning to plot and make animations.
"""

# ╔═╡ 14bb9c3a-34b5-11eb-0f20-75a14b584e0c
matrix = [1 2 3 4; 5 6 7 8; 9 10 11 12]

# ╔═╡ 2712ade2-34b5-11eb-0242-57f37f6607a3
C = CartesianIndices(matrix)

# ╔═╡ 3d9c3fea-2bde-11eb-0f09-cf11dcb07c0d
md"""
## 1-Dimensional operations

We will start with local operations in 1-D, i.e., processing a vector to obtain a new vector. Such operations are important in signal processing if we want to smoothen a noisy signal for example but the operations are also used in bioinformatics and complex systems. 
"""

# ╔═╡ e1147d4e-2bee-11eb-0150-d7af1f51f842
md"""
### Convolution

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
	n = length(x)
	return sum(x) / n
end

# ╔═╡ 66a20628-4834-11eb-01a2-27cc2b1ec7be
x = [2.1, 3.2, 5.4, 4.9, 6.1]

# ╔═╡ 432c3892-482c-11eb-1467-a3b9c1592597
mean(x)

# ╔═╡ 8b220aea-4834-11eb-12bb-3b91414fe30a
md"""
So, for this regular mean, we give an equal weight to every element: every $x_i$ is equally important in determining the mean. In some cases, however, we know that some positions are more important than others in determining the mean. For example, we might know the that a measurement error for each point. In this case, we might want to give a weigth inversely proportional to the measurement error. 
"""

# ╔═╡ 88c10640-4835-11eb-14b0-abba18da058f
weighted_mean(x, w) = missing

# ╔═╡ 62aa3de4-58e0-11eb-01af-1b2d8c1b7d05
begin 	
	q1 = Question(
			validators = [
				weighted_mean(x, collect((1:5) / sum(1:5))) == 4.986666666666666
			], 
			description = md""
		)
			

	qb1 = QuestionBlock(;
		title=md"**Question 1: The weighted mean**",
		description = md"""
		In general, the weighted mean is computed as:
		
		$$\sum_{i=1}^n w_ix_i\,,$$

		were, $w_i$ are the weights of data point $x_i$. In order for the weighted mean to make sense, we assume that all these weights are non-zero and that they sum to 1.

		Implement the weighted mean.

		""",
		questions = @safe[q1]
	)
	
	validate(qb1, tracker)
end

# ╔═╡ a657c556-4835-11eb-12c3-398890e70105
md"We compute the mean again, now using the information that the numbers were collected consequently and that we give a weight linearly proportional to the position,

$$w_i = \cfrac{i}{\sum_j^n j} \, .$$

Example,

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

When computing convolutions (or in numerical computing in general) one has to be careful with the **boundary conditions**. We cannot compute the sum at the ends since the sum would exceed the vector $\mathbf{x}$. There are many sensible ways to resolve this, we will choose the simplest solution of using fixed boundaries by setting $y_i = x_i$ when $i< m$ or $i>n-m$.
"""

# ╔═╡ a1f75f4c-2bde-11eb-37e7-2dc342c7032a
function convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	@assert length(w) < length(x) "length of `w` should be smaller than `x`"
	n = length(x)
	m = length(w) ÷ 2
	out = zeros(n)

	# ... complete
	return missing
end

# ╔═╡ b0dd68f2-58ee-11eb-3c67-f1c4edf8f7c3
begin 	
	q2 = Question(
			validators = [	
				convolve_1d(collect(1:10), [0.5, 0.5, 0.5]) == 
			[3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 13.5, 14.5, 15.0]
			], 
			description = md""
		)
			

	qb2 = QuestionBlock(;
		title=md"**Question 2: one-dimensional convolution**",
		description = md"""

		Implement the one-dimensional convolution,
		
		$$y_i = \sum_{k=-m}^{m} x_{i + k} w_{m+k+1}\,,$$
		
		by completing the function `convolve_1d(x::Vector, w::Vector).`
		
		This function should be able to take any vector x and compute the convolution with any weight vector that matches the specification of a weight vector (see previously). 

		""",
		questions = @safe[q2],
		hints = [
			hint(md"Did you take into account the boundary conditions?")	
		]
	)
	
	validate(qb2, tracker)
end

# ╔═╡ 6e95d126-598d-11eb-22a9-f3b895578acd
function sol_convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	n = length(x)
	m = length(w) ÷ 2
	out = zeros(n)

	fill!(out, 0.0)
	for (i, xj) in enumerate(x)
		for (j, wj) in enumerate(w)
			k = clamp(i + j - m, 1, n)
			out[i] += w[j] * x[k]
		end
	end
	return out
end

# ╔═╡ 7945ed1c-598c-11eb-17da-af9a36c6a68c
md"""
Let's try this out on an example, consider a noisy signal,
"""

# ╔═╡ 546beebe-598d-11eb-1717-c9687801e647
noisy_signal(tᵢ) = 5tᵢ+5sin(tᵢ)+10*rand();

# ╔═╡ f39d88f6-5994-11eb-041c-012af6d3bae6
md"We use the convolution function we defined to construct a moving_average function,"

# ╔═╡ f94e2e6c-598e-11eb-041a-0b6a068e464c
moving_average(f::Function, t, w) = sol_convolve_1d(f.(t), ones(w).*1/w);

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

# ╔═╡ 99a7e070-5995-11eb-0c53-51fc82db2e93


# ╔═╡ 22261bf2-5995-11eb-2d52-932589333c47
QuestionBlock(;
	title=md"**Task:**",
	description = md"""
	Explore this filtering technique by changing the number of weights. Try to understand the how the `moving_average` function works
	""",
	questions = [Question(;description=md"", validators = Bool[], status=md"")]
)

# ╔═╡ 7c12bcf6-4863-11eb-0994-fb7d763c0d47
function uniform_weights(m)
	return ones(2m+1) / (2m+1)
end

# ╔═╡ 294140a4-2bf0-11eb-22f5-858969a4640d
function triangle_weigths(m)
	w = zeros(2m+1)
	for i in 1:(m+1)
		w[i] = i
		w[end-i+1] = i
	end
	w ./= sum(w)
	return w
end	

# ╔═╡ d8c7baac-49be-11eb-3afc-0fedae12f74f
function gaussian_weigths(m; σ=4)
	w = exp.(-(-m:m).^2 / 2σ^2)
	return w ./ sum(w)
end

# ╔═╡ 64bf7f3a-58f0-11eb-1782-0d33a2b615e0
begin 
	m₁ = 3
	try
		global Wu = uniform_weights(m₁)
		global Wt = triangle_weigths(m₁)
		global Wg = gaussian_weigths(m₁)
	catch e 
	end
	
	fs = (600, 280)
	
	pl31 = scatter(@safe 1:length(Wu), Wu; label="", xlabel="weights", size=fs,
	background_color="#F8F8F8")
	title!("Your result:")
	
	pl32 = scatter(@safe 1:length(Wt), Wt; label="", xlabel="weights", size=fs,
	background_color="#F8F8F8")
	title!("Your result:")
	
	pl33 = scatter(@safe 1:length(Wg), Wg; label="", xlabel="weights", size=fs,
	background_color="#F8F8F8")
	title!("Your result:")
	
	q31 = Question(
			validators = [	

			], 
			description = md"""
		- **uniform**: all values of $\mathbf{w}$ are the same;
		
		$(pl31)
		"""
		)
	
	q32 = Question(
		validators = [	

		], 
		description = md"""
		- **[triangle](https://en.wikipedia.org/wiki/Triangular_function)**: linearly increasing from index $i=1$ till index $i=m+1$ and linearly decreasing from $i=m+1$ to $2m+1$;
		
		$(pl32)
		"""
		
	)
	
	q33 = Question(
		validators = [	

		], 
		description = md"""
		- **Gaussian**: proportional to $\exp(-\frac{(i-m - 1)^2}{2\sigma^2})$ with $i\in 1,\ldots,2m+1$. The *bandwidth* is given by $\sigma$, let us set it to 4. 

		$(pl33)
		"""
	)

	qb3 = QuestionBlock(;
		title=md"**Question 2: some common weight vectors**",
		description = 
		md"""

		Let us test some different weight vectors, several options seem reasonable:

		For this purpose, make sure that they are all normalized, either by design or by divididing the vector by the total sum at the end.

		""",
		questions = @safe[q31, q32, q33],
		hints = [

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
		title=md"**Question 4: processing COVID data**",
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

# ╔═╡ 696e252a-4862-11eb-2752-9d7bbd0a4b7d


# ╔═╡ d2321a9c-5996-11eb-0380-47aa8ec777af


# ╔═╡ b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
md"""
### Application 2: protein analysis


A protein (polypeptide chain) is a sequence of amino acids, small molecules with unique physicochemical properties that largely determine the protein structure and function. 

![source: technology networks.com](https://cdn.technologynetworks.com/tn/images/thumbs/webp/640_360/essential-amino-acids-chart-abbreviations-and-structure-324357.webp?v=10459598)

In bioinformatics, the 20 common amino acids are denoted by 20 capital letters, `A` for alanina, `C` for cysteine, etc. Many interesting local properties can be computed by looking at local properties of amino acids. For example, the (now largely outdated) **Chou-Fasman method** for the prediction the local three-dimensional shape of a protein ($\alpha$-helix or $\beta$-sheet) uses a sliding window to check if regions are enriched for amino acids associated with $\alpha$-helices or $\beta$-sheets.

We will study a protein using a sliding window analysis by making use of the **amino acid z-scales**. These are three physicochemical properties of an amino acid. 

In order, they quantify:
1. *lipophilicity*: the degree in which the amino acid chain is lipidloving (and hence hydrophopic);
2. *steric properties*: how large and flexible the side chains are;
3. *electric properties*, such as positive or negative charges.

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
	n = length(sequence)
	y = zeros(n)
	for i in (m+1):(n-m)
		for k in -m:m
			y[i] += zscales[sequence[i+k]]
		end
	end
	return y / (2m + 1)
end

# ╔═╡ 17e7750e-49c4-11eb-2106-65d47b16308c
proteinsw = protein_sliding_window(spike_sars2, m, zscales1)

# ╔═╡ dce6ec82-3ca1-11eb-1d87-1727b0e692df
plot(proteinsw, xlabel="Index of Amino acid in the tail-spike", label="", ylabel="local properties")

# ╔═╡ 19a98dd4-599e-11eb-2b1c-172e00137e6c
keep_working(md"**@Michiel** can you provide an outro here? Not sure what to do with this. This ends rather anti-climactic")

# ╔═╡ 4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
md"""
### Application 3: Elementary cellular automata

To conclude our adventures in 1D, let us consider **elementary cellular automata**. These are more or less the simplest dynamical systems one can study. Cellular automata are discrete spatio temporal systems: both the space time and states are discrete. The state of an elementary cellular automaton is determined by an $n$-dimensional binary vector, meaning that there are only two states 0 or 1 (`true` or `false`). The state transistion of a cell is determined by:
- its own state `s`;
- the states of its two neighbors, left `l` and right `r`.

As you can see in the figure below, each rule corresponds to the 8 possible situations given the states of the two neighbouring cells and it's own state. Logically, one can show that there are only $2^8=256$ possible rules one can apply. Some of them are depicted below.

![](https://mathworld.wolfram.com/images/eps-gif/ElementaryCARules_900.gif)

So each of these rules can be represented by an 8-bit integer. Let us try to explore them all.
"""

# ╔═╡ b0bd61f0-49f9-11eb-0e6b-69539bc34be8
md"The rules can be represented as a unsigned integer `UInt8` which takes a value between 0 and 255."

# ╔═╡ b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
rule = 110 |> UInt8

# ╔═╡ fabce6b2-59cc-11eb-2181-43fe08fcbab9
println(rule) # check command line

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
#getbinarydigit(rule, i) = missing

# ╔═╡ 1266818c-59d3-11eb-0b7d-d7253621762e
getbinarydigit(rule, i) = rule & 2^(i-1) != 0

# ╔═╡ 2d4e9afe-59cc-11eb-3033-05d9b684b399
begin 	
	qb5 = QuestionBlock(
		title=md"**Optional question (hard)**",
		description = md"""
		Can you think of a way to get the transitioned state given a rule  and a position of a bit in the bitstring? Complete the function `getbinarydigit(rule, i)`.
		It is possible to do this in a single line. Don't worry if you don't get this, this is bitstring manipulation and not usually part of a scientific programming curriculum.
		""",
		questions = [
			Question(;description=md"", 
				validators = @safe[
					getbinarydigit(UInt8(110), 5) == (UInt8(110) & 2^4 != 0) 
					])
		],
		hints = [
			hint(md"The solution is hidden in the next hint."), 
			hint(md""" 
				```julia
				getbinarydigit(rule, i) = rule & 2^(i-1) != 0
				```""")	
		]
	)
	validate(qb5)
end

# ╔═╡ 781d38a8-59d4-11eb-28f9-9358f132782c
getbinarydigit(rule, 1) 

# ╔═╡ 1301a3f4-59d0-11eb-2fc5-35e9c1f0841a
begin 	
	q61 = Question(
			description=md" Complete `nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)`", 
			validators = @safe[])
	
	q62 = QuestionOptional{Intermediate}(
			description=md"Using multiple dispatch, write a second function `nextstate(l::Bool, s::Bool, r::Bool, rule::Int)`  so that the rule can be provided as any Integer.", 
			validators = @safe[])
	
	qb6 = QuestionBlock(
		title=md"**Question: transitioning the states**",
		description = md"""
		Now for the next step, given a state `s` and the states of its left (`l`) and right (`r`) neighbours, can you determine the next state under a `rule` (UInt8)?

		""",
		questions = [q61, q62],
		hints = [
			hint(md"Do not forget you have just implemented `getbinarydigit(rule, i)`."),
			hint(md"In the example of the rules displayed above, all 8 possible combinations of (`l`, `s`, `r`) always refer to the same position in the bitstring"),
			
			hint(md"8-(4l+2s+1r)"),
		]
	)
	validate(qb6, tracker)
end

# ╔═╡ 625c4e1e-2bf3-11eb-2c03-193f7d013fbe
#nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8) = missing

# ╔═╡ 00f6e42c-59d4-11eb-31c7-d5aa0105e7cf
getbinarydigit(rule, 4true+2true+1true+1)

# ╔═╡ d2e5787c-59d2-11eb-1bbd-d79672ab8f1b
begin
	nextstate(l::Bool, s::Bool, r::Bool, rule::Int) = nextstate(l, s, r, UInt8(rule))
		
	function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
		return getbinarydigit(rule, 8-(4l+2s+1r))
	end
	
end

# ╔═╡ 38e6a67c-49fa-11eb-287f-91a836f5752c
nextstate(true, true, true, rule)

# ╔═╡ 511661de-59d5-11eb-16f5-4dbdf4e93ab2
md"Now that we have this working it is easy to generate and visualise the transitions for each rule. This is not an easy line of code try to really understand these comprehensions before moving on. hint: expand the output for a prettier overview of the rules."

# ╔═╡ be013232-59d4-11eb-360e-e97b6c388991
@bind rule_number Slider(1:256, default=110)

# ╔═╡ 428af062-59d5-11eb-3cf7-99533810e83c
md"Rule: $rule_number"

# ╔═╡ 4776ccca-482f-11eb-1194-398046ab944a
Dict((l=l, s=s, r=r) => nextstate(l, s, r, rule_number)
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
	)
					

# ╔═╡ 5f97da58-2bf4-11eb-26de-8fc5f19f02d2
Dict(Gray.([l, s, r]) => [Gray(1), Gray(nextstate(l, s, r, rule_number)), Gray(1)]
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
				)									

# ╔═╡ e68101ca-59d5-11eb-18c2-351e9a68421a


# ╔═╡ 924461c0-2bf3-11eb-2390-71bad2541463
function update1dca!(xnew, x, rule::Integer)
	n = length(x)
	xnew[1] = nextstate(x[end], x[1], x[2], rule)
	xnew[end] = nextstate(x[end-1], x[end], x[1], rule)
	for i in 2:n-1
		xnew[i] = nextstate(x[i-1], x[i], x[i+1], rule)
	end
	return xnew
end

# ╔═╡ 21440956-2bf5-11eb-0860-11127d727282
next1dca(x, rule::Integer) = update1dca!(similar(x), x, rule)

# ╔═╡ 405a1036-2bf5-11eb-11f9-a1a714dbf7e1
x0_ca = rand(Bool, 100)

# ╔═╡ 6405f574-2bf5-11eb-3656-d7b9c94f145a
next1dca(x0_ca, rule)

# ╔═╡ 756ef0e0-2bf5-11eb-107c-8d1c65eacc45
"""
    simulate(x0, rule; nsteps=100)

Simulate `nsteps` time steps according to `rule` with `X0` as the initial condition.
Returns a matrix X, where the rows are the state vectors at different time steps.
"""
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

# ╔═╡ e1dd7abc-2bf5-11eb-1f5a-0f46c7405dd5
X = simulate(x0_ca, rule; nsteps=100)

# ╔═╡ 9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
ca_image(X) = Gray.(X)

# ╔═╡ fb9a97d2-2bf5-11eb-1b92-ab884f0014a8
plot(ca_image(X), size=(1000, 1000))

# ╔═╡ 4810a052-2bf6-11eb-2e9f-7f9389116950
all_cas = Dict(rule=>ca_image(simulate(x0_ca, rule; nsteps=500)) for rule in UInt8(0):UInt8(251))

# ╔═╡ 0b847e26-4aa8-11eb-0038-d7698df1c41c
md"""
### Intermezzo: What is an image?

An image is generally just a matrix of pixels. What is a pixel? Usually this corresponds to just a particular color (or grayscale). So let us play around with colors first.

There are many ways to encode colors. For our purposes, we can just work with the good old RGB scheme, where each color is described by three values, respectively the red, green and blue fraction.
"""

# ╔═╡ 90c3c542-4aa8-11eb-03fb-e70579c8e4f3
daanbeardred = RGB(100/255, 11/255, 13/255)

# ╔═╡ 57074882-4aa9-11eb-0ad5-a5ebadc22550
md"We can extract the red, green, and blue components using the obvious functions."

# ╔═╡ 3ee9cbbc-4aa9-11eb-1cb6-c37d007839e8
red(daanbeardred), green(daanbeardred), blue(daanbeardred)

# ╔═╡ 7af6568e-4aa9-11eb-3fd5-97fa8401696a
md"Converting a color to grayscale is also easy."

# ╔═╡ 6e51e25e-4aa9-11eb-116f-09bad1bf0041
Gray(daanbeardred)

# ╔═╡ 8ac8761c-4aa9-11eb-25d2-ed4c0f15bd66
md"An image is a matrix of colors, nothing more!"

# ╔═╡ 95942566-4aa9-11eb-318f-09cada65a5f7
mini_image = [RGB(0.8, 0.6, 0.1) RGB(0.2, 0.8, 0.9) RGB(0.8, 0.6, 0.1);
				RGB(0.2, 0.8, 0.9) RGB(0.8, 0.2, 0.2) RGB(0.2, 0.8, 0.9);
				RGB(0.8, 0.6, 0.1) RGB(0.2, 0.8, 0.9) RGB(0.8, 0.6, 0.1)]

# ╔═╡ fbc9ceee-4aa9-11eb-308e-613f2a5f3646
mini_image[2, 2]

# ╔═╡ c8c58ce4-4aaa-11eb-1558-59028a05aba6
size(mini_image)

# ╔═╡ 0a47f23e-4aaa-11eb-020a-d5a6c4104aa9
red.(mini_image), green.(mini_image), blue.(mini_image)

# ╔═╡ 1c327406-4aaa-11eb-3212-9d6d00c9c35d
Gray.(mini_image)

# ╔═╡ 470ef5c8-4aaa-11eb-0bab-ff6a21471bcc
function redimage(image)
	return RGB.(red.(image), 0, 0)
end

# ╔═╡ 78bd5fa6-4aaa-11eb-11f9-bd6f571fdf8c
function greenimage(image)
	return RGB.(0, green.(image), 0)
end

# ╔═╡ 7aae8510-4aaa-11eb-1622-a113684f9a7d
function blueimage(image)
	return RGB.(0, 0, blue.(image))
end

# ╔═╡ 991bcfe4-4aaa-11eb-22e8-935938437b51
redimage(mini_image), greenimage(mini_image), blueimage(mini_image)

# ╔═╡ a07ab8ba-59a5-11eb-1fa5-39971674843b
url = "https://i.imgur.com/BJWoNPg.jpg"

# ╔═╡ b8eac080-59a5-11eb-30e1-71c29adc8188
download(url, "aprettybird.jpg") # download to a local file

# ╔═╡ c9d085bc-59a5-11eb-0d76-a9f8d1e0fbb9
bird_original = load("aprettybird.jpg")

# ╔═╡ d72cd460-59a5-11eb-2e09-1f7acb30035c
typeof(bird_original)

# ╔═╡ dc7750c4-59a5-11eb-0095-83af6f5fa6a9
eltype(bird_original)

# ╔═╡ f54749c4-59a5-11eb-1629-99738fb7247c
md"So an image is basically a two-dimensional array of Colors. Which means it can be processed just like any other array. and because of the type system, a lot of interesting feature work out of the box."

# ╔═╡ 5dfd937c-59a8-11eb-1c4b-2fecfcc2b07e
md"Lets the define a function to reduce the size of the image"

# ╔═╡ 473c581c-2be5-11eb-1ddc-2d30a3468c8a
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ 79bde78a-59a8-11eb-0082-cb29383b0e8f
keep_working(md"Conver this to exercise")

# ╔═╡ 6ff6f622-59a8-11eb-2f12-2f44e7e35113
bird = decimate(bird_original, 6)

# ╔═╡ 0d32820e-59a6-11eb-284b-afe07cec30f5
md"""
☼
$(@bind brightness Slider(0:0.01:3, default=1.5))
☾
"""

# ╔═╡ fc2bb5d0-59a6-11eb-0af2-37897d8351b0
brightness

# ╔═╡ 14f5b260-59a6-11eb-23a0-9d1a62ac10bb
bird./brightness

# ╔═╡ 572369a2-59a6-11eb-2afa-bf64b27cc145
md"This is just a simple element-wise division of a matrix."

# ╔═╡ 49145bd6-4aa7-11eb-3c93-d90a36903d1a
md"""

## 2-D operations

Let us move from 1-D operations to 2-D operations. This will be a nice opportunity to learn something about image processing.
"""

# ╔═╡ 41297876-4aab-11eb-3e41-294b06cd19f2
md"""
### Two-dimensional convolutions on images

Just like we did in 1D, we can define a convolution on matrices and images:

$$Y_{i,j} = \sum_{k=-m}^{m} \, \sum_{l=-m}^{m} X_{i + k,\, j+l}\, K_{m+(k+1),\, m+(l+1)}\,.$$

This looks more complex but still amounts to the same thing as the 1D case. We have an $2m+1 \times 2m+1$ kernel matrix $K$, which we use to compute a weighted local sum.

"""

# ╔═╡ d4b6271e-59a7-11eb-3c7f-335c61564d0d
md"Let's fetch our bird,"

# ╔═╡ 35991636-59a8-11eb-2bb4-55b01255e94a
bird

# ╔═╡ eeeee44e-4b5c-11eb-159e-773457e1247f
size(bird)

# ╔═╡ 608e930e-2bfc-11eb-09f2-29600cfba1e6
function convolve_2d!(M::AbstractMatrix, out::AbstractMatrix, K::AbstractMatrix)
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

# ╔═╡ 1e98e96a-4b5d-11eb-2d9b-797cdd1e3978
md"""
Remember the 1-D Gaussian kernel? Its 2-D analogue is given by

$$K_{i,j} = \exp\left(-\frac{(i-m - 1)^2 +(j-m-1)^2}{2\sigma^2}\right)\,.$$

Using this kernel results in a smoothing operation, often refered to as a Gaussian blur. This kernel is frequently used to remove noise, but it will also remove some edges of the image. Gaussian kernel convolution gives a blurring effect making the image appearing to be viewed through a translucent screen, giving a slight [otherworldly effect](https://tvtropes.org/pmwiki/pmwiki.php/Main/GaussianGirl).


Let us implement the Gaussian kernel.
"""

# ╔═╡ 245deb30-2bfe-11eb-3e47-6b7bd5d73ccf
function gaussian_kernel(m; σ)
	K = [exp(-(x^2 + y^2) / 2σ^2) for x in -m:m, y in -m:m]
	K ./= sum(K)
	return K
end

# ╔═╡ 6278ae28-2bfe-11eb-3c36-9bf8cc703a3a
K_gaussian = gaussian_kernel(3, σ=2)

# ╔═╡ 6c40b89c-2bfe-11eb-3593-9d9ef6f45b80
heatmap(K_gaussian)

# ╔═╡ b05d0bdc-4b5e-11eb-14f6-6bf4e3b24949
function pepper_salt_noise(image; fraction=0.01)
	noisy_image = copy(image)
	mask = rand(size(image)...) .< fraction
	n_corrupted = sum(mask)
	noisy_image[mask] = rand([RGB(0, 0, 0), RGB(1, 1, 1)], n_corrupted)
	return noisy_image
end

# ╔═╡ 22285b5e-4b5f-11eb-197a-e39e5c525c8d
salt_and_pepper_philip = pepper_salt_noise(bird)

# ╔═╡ 73c3869a-2bfd-11eb-0597-29cd6c1c90db
convolve_2d(M, K) = convolve_2d!(M, similar(M), K) 

# ╔═╡ c80e4362-2bfe-11eb-2055-5fbf167be551
K_sharpen = [0 -1 0;
			-1 5 -1;
			0 -1 0]

# ╔═╡ 84880dfc-2bfd-11eb-32b7-47750e1c696b
function convolve_image(M, K)
	Mred = convolve_2d(red.(M), K)
	Mgreen = convolve_2d(green.(M), K)
	Mblue = convolve_2d(blue.(M), K)
	return RGB.(Mred, Mgreen, Mblue)
end

# ╔═╡ e1f23724-2bfd-11eb-1063-1d59909bcacc
convolve_image(bird, K_gaussian)

# ╔═╡ 39eae5c2-4b5f-11eb-151a-b76db57f04b8
convolve_image(salt_and_pepper_philip, K_gaussian)

# ╔═╡ 8c62855a-2bff-11eb-00f5-3702e142f76f
const Gx = [1 0 -1;
		   2 0 -2;
		   1 0 -1]

# ╔═╡ ae8d6258-2bff-11eb-0182-afc33d9d4efc
const Gy = [1 2 1;
		    0 0 0;
		   -1 -2 -1]

# ╔═╡ 3aba6b10-4b5c-11eb-0e4f-81b47568937a
convolve_2d(Gray.(bird) .|> Float64, Gx) .|> Gray

# ╔═╡ b5bf307a-4b5c-11eb-32eb-614b3193d8cb
convolve_2d(Gray.(bird) .|> Float64, Gy) .|> Gray

# ╔═╡ 746d3578-2bff-11eb-121a-f3d17397a49e
function edge_detection(M)
	M = M .|> Gray .|> Float64
	return convolve_2d(M, Gx).^2 + convolve_2d(M, Gy).^2 .|> Gray
end

# ╔═╡ f41919a4-2bff-11eb-276f-a5edd5b374ac
edge_detection(bird)

# ╔═╡ 55bfb46a-2be5-11eb-2be6-1bc153db11ac
RGB.(red.(bird), green.(bird), blue.(bird))

# ╔═╡ d523e4c6-301b-11eb-040a-f7a214cb785b
function count_neighbors((i, j), grid::Matrix{Bool})
	n_neighbors = grid[i+1,j+1] + grid[i+1,j] +
						grid[i+1,j-1] + grid[i,j-1] +
						grid[i-1, j-1] + grid[i-1,j] +
						grid[i-1,j+1] + grid[i, j+1]
	return n_neighbors
end

# ╔═╡ fafc7e74-34c6-11eb-0ce1-8fe2e3215739
function cell_state((i, j), grid::Matrix{Bool})
	return grid[i,j]
end

# ╔═╡ 0f7f9156-34c7-11eb-01dd-db5b3e1b0eca
function next_state((i, j), grid::Matrix{Bool})
	state = cell_state((i, j), grid)
	n_neighbors = count_neighbors((i, j), grid)
	next_state =  (state && (2 ≤ n_neighbors ≤ 3)) || # staying alive
				(!state && n_neighbors == 3)
	return next_state
end

# ╔═╡ 9c7ad77a-34c7-11eb-0636-5d4c8dd9542b
function next_gol!(grid, new_grid)
	n, m = size(grid)
	for j in 1:m
		for i in 1:m
			if 1 < i < n && 1 < j < m
				new_grid[i,j] = next_state((i, j), grid)
			else
				new_grid[i,j] = false
			end
		end
	end
	grid .= new_grid
	return grid
end

# ╔═╡ 24e09632-34ca-11eb-09c6-cd0a14601723
function update_gol!(grid; nsteps=1)
	new_grid = similar(grid)
	for t in 1:nsteps
		next_gol!(grid, new_grid)
	end
	return grid
end

# ╔═╡ ac4540e6-34ca-11eb-28a5-39a639f385a1
md"Updates via hashing, how many needed for all 3x3 grids"

# ╔═╡ 1937de5a-34c8-11eb-0a99-afc09e510273
grid = rand(Bool, 50, 50)

# ╔═╡ 47a40a70-34c8-11eb-2ae1-5fde1e1ef83c
new_grid = zero(grid)

# ╔═╡ a35eda0c-34c8-11eb-27e4-35a06de2df43
(next_gol!(grid, new_grid) for i in 1:1000)

# ╔═╡ 54e78bb0-34c8-11eb-0cf9-a1a2b398e107
#=
@gif for i ∈ 1:100
		next_gol!(grid, new_grid)
		#grid, new_grid = new_grid, grid
		plot(show_ca(grid))
end
=#

# ╔═╡ Cell order:
# ╟─981758aa-58e9-11eb-282c-89131d9317b4
# ╠═786b3780-58ec-11eb-0dfd-41f5af6f6a39
# ╠═2411c6ca-2bdd-11eb-050c-0399b3b0d7af
# ╠═cf4e10a8-4862-11eb-05fd-c1a09cbb1bcd
# ╠═14bb9c3a-34b5-11eb-0f20-75a14b584e0c
# ╠═2712ade2-34b5-11eb-0242-57f37f6607a3
# ╠═3d9c3fea-2bde-11eb-0f09-cf11dcb07c0d
# ╠═e1147d4e-2bee-11eb-0150-d7af1f51f842
# ╠═f272855c-3c9e-11eb-1919-6b7301b15699
# ╠═66a20628-4834-11eb-01a2-27cc2b1ec7be
# ╠═432c3892-482c-11eb-1467-a3b9c1592597
# ╠═8b220aea-4834-11eb-12bb-3b91414fe30a
# ╠═62aa3de4-58e0-11eb-01af-1b2d8c1b7d05
# ╠═88c10640-4835-11eb-14b0-abba18da058f
# ╠═a657c556-4835-11eb-12c3-398890e70105
# ╠═181c4246-4836-11eb-0368-61b2998f5424
# ╠═94a950fe-4835-11eb-029c-b70de72c20e6
# ╠═52706c6a-4836-11eb-09a8-53549f16f5c2
# ╠═4dc28cdc-4836-11eb-316f-43c04639da2a
# ╠═8b4c6880-4837-11eb-0ff7-573dd18a9664
# ╠═b0dd68f2-58ee-11eb-3c67-f1c4edf8f7c3
# ╠═a1f75f4c-2bde-11eb-37e7-2dc342c7032a
# ╠═6e95d126-598d-11eb-22a9-f3b895578acd
# ╠═7945ed1c-598c-11eb-17da-af9a36c6a68c
# ╠═546beebe-598d-11eb-1717-c9687801e647
# ╠═f39d88f6-5994-11eb-041c-012af6d3bae6
# ╠═f94e2e6c-598e-11eb-041a-0b6a068e464c
# ╟─0563fba2-5994-11eb-2d81-f70d10092ad7
# ╠═4e45e43e-598f-11eb-0a0a-2fa636748f7c
# ╠═8e53f108-598d-11eb-127f-ddd5be0ec899
# ╟─99a7e070-5995-11eb-0c53-51fc82db2e93
# ╠═22261bf2-5995-11eb-2d52-932589333c47
# ╠═64bf7f3a-58f0-11eb-1782-0d33a2b615e0
# ╠═7c12bcf6-4863-11eb-0994-fb7d763c0d47
# ╠═294140a4-2bf0-11eb-22f5-858969a4640d
# ╠═d8c7baac-49be-11eb-3afc-0fedae12f74f
# ╠═2b07134c-598c-11eb-155a-6b28a98e76ca
# ╠═ff3241be-4861-11eb-0c1c-2bd093e3cbe9
# ╠═c962de82-3c9e-11eb-13df-d5dec37bb2c0
# ╠═31e39938-3c9f-11eb-0341-53670c2e93e1
# ╠═caef0432-3c9f-11eb-2006-8ff54211b2b3
# ╠═b3ec8362-482d-11eb-2df4-2343ee17444a
# ╠═8a996336-2bde-11eb-10a3-cb0046ed5de9
# ╠═cb9945f6-5995-11eb-3b10-937cde05fa31
# ╠═696e252a-4862-11eb-2752-9d7bbd0a4b7d
# ╠═d2321a9c-5996-11eb-0380-47aa8ec777af
# ╠═b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
# ╠═87610484-3ca1-11eb-0e74-8574e946dd9f
# ╠═9c82d5ea-3ca1-11eb-3575-f1893df8f129
# ╠═a4ccb496-3ca1-11eb-0e7a-87620596eec1
# ╠═9f62891c-49c2-11eb-3bc8-47f5d2e008cc
# ╠═328385ca-49c3-11eb-0977-c79b31a6caaf
# ╠═c924a5f6-2bf1-11eb-3d37-bb63635624e9
# ╠═7e96f0d6-5999-11eb-3673-43f7f1fa0113
# ╠═c23ff59c-3ca1-11eb-1a31-2dd522b9d239
# ╠═17e7750e-49c4-11eb-2106-65d47b16308c
# ╠═dce6ec82-3ca1-11eb-1d87-1727b0e692df
# ╠═19a98dd4-599e-11eb-2b1c-172e00137e6c
# ╠═4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
# ╠═b0bd61f0-49f9-11eb-0e6b-69539bc34be8
# ╠═b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
# ╠═fabce6b2-59cc-11eb-2181-43fe08fcbab9
# ╠═05973498-59cd-11eb-2d56-7dd28db4b8e5
# ╠═c61755a6-49f9-11eb-05a0-01d914d305f3
# ╠═a6e7441a-482e-11eb-1edb-6bd1daa00390
# ╠═bec6e3d2-59c8-11eb-0ddb-79795043942d
# ╠═6e184088-59c9-11eb-22db-a5858eab786d
# ╠═1f6262b6-59cc-11eb-1306-0d1ca9f3f8e6
# ╠═2d4e9afe-59cc-11eb-3033-05d9b684b399
# ╠═b43157fa-482e-11eb-3169-cf4989528800
# ╠═781d38a8-59d4-11eb-28f9-9358f132782c
# ╠═1266818c-59d3-11eb-0b7d-d7253621762e
# ╠═1301a3f4-59d0-11eb-2fc5-35e9c1f0841a
# ╠═625c4e1e-2bf3-11eb-2c03-193f7d013fbe
# ╠═00f6e42c-59d4-11eb-31c7-d5aa0105e7cf
# ╠═d2e5787c-59d2-11eb-1bbd-d79672ab8f1b
# ╠═38e6a67c-49fa-11eb-287f-91a836f5752c
# ╠═511661de-59d5-11eb-16f5-4dbdf4e93ab2
# ╟─428af062-59d5-11eb-3cf7-99533810e83c
# ╟─be013232-59d4-11eb-360e-e97b6c388991
# ╠═4776ccca-482f-11eb-1194-398046ab944a
# ╠═5f97da58-2bf4-11eb-26de-8fc5f19f02d2
# ╠═e68101ca-59d5-11eb-18c2-351e9a68421a
# ╠═924461c0-2bf3-11eb-2390-71bad2541463
# ╠═21440956-2bf5-11eb-0860-11127d727282
# ╠═405a1036-2bf5-11eb-11f9-a1a714dbf7e1
# ╠═6405f574-2bf5-11eb-3656-d7b9c94f145a
# ╠═756ef0e0-2bf5-11eb-107c-8d1c65eacc45
# ╠═e1dd7abc-2bf5-11eb-1f5a-0f46c7405dd5
# ╠═9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
# ╠═fb9a97d2-2bf5-11eb-1b92-ab884f0014a8
# ╠═4810a052-2bf6-11eb-2e9f-7f9389116950
# ╠═0b847e26-4aa8-11eb-0038-d7698df1c41c
# ╠═90c3c542-4aa8-11eb-03fb-e70579c8e4f3
# ╠═57074882-4aa9-11eb-0ad5-a5ebadc22550
# ╠═3ee9cbbc-4aa9-11eb-1cb6-c37d007839e8
# ╠═7af6568e-4aa9-11eb-3fd5-97fa8401696a
# ╠═6e51e25e-4aa9-11eb-116f-09bad1bf0041
# ╠═87c5bb72-4aa7-11eb-3897-a523011703c5
# ╠═8ac8761c-4aa9-11eb-25d2-ed4c0f15bd66
# ╠═95942566-4aa9-11eb-318f-09cada65a5f7
# ╠═fbc9ceee-4aa9-11eb-308e-613f2a5f3646
# ╠═c8c58ce4-4aaa-11eb-1558-59028a05aba6
# ╠═0a47f23e-4aaa-11eb-020a-d5a6c4104aa9
# ╠═1c327406-4aaa-11eb-3212-9d6d00c9c35d
# ╠═470ef5c8-4aaa-11eb-0bab-ff6a21471bcc
# ╠═78bd5fa6-4aaa-11eb-11f9-bd6f571fdf8c
# ╠═7aae8510-4aaa-11eb-1622-a113684f9a7d
# ╠═991bcfe4-4aaa-11eb-22e8-935938437b51
# ╠═a07ab8ba-59a5-11eb-1fa5-39971674843b
# ╠═b8eac080-59a5-11eb-30e1-71c29adc8188
# ╠═c9d085bc-59a5-11eb-0d76-a9f8d1e0fbb9
# ╠═d72cd460-59a5-11eb-2e09-1f7acb30035c
# ╠═dc7750c4-59a5-11eb-0095-83af6f5fa6a9
# ╠═f54749c4-59a5-11eb-1629-99738fb7247c
# ╠═5dfd937c-59a8-11eb-1c4b-2fecfcc2b07e
# ╠═473c581c-2be5-11eb-1ddc-2d30a3468c8a
# ╠═79bde78a-59a8-11eb-0082-cb29383b0e8f
# ╠═6ff6f622-59a8-11eb-2f12-2f44e7e35113
# ╟─0d32820e-59a6-11eb-284b-afe07cec30f5
# ╠═fc2bb5d0-59a6-11eb-0af2-37897d8351b0
# ╠═14f5b260-59a6-11eb-23a0-9d1a62ac10bb
# ╠═572369a2-59a6-11eb-2afa-bf64b27cc145
# ╠═49145bd6-4aa7-11eb-3c93-d90a36903d1a
# ╠═41297876-4aab-11eb-3e41-294b06cd19f2
# ╠═d4b6271e-59a7-11eb-3c7f-335c61564d0d
# ╠═35991636-59a8-11eb-2bb4-55b01255e94a
# ╠═eeeee44e-4b5c-11eb-159e-773457e1247f
# ╠═608e930e-2bfc-11eb-09f2-29600cfba1e6
# ╠═1e98e96a-4b5d-11eb-2d9b-797cdd1e3978
# ╠═245deb30-2bfe-11eb-3e47-6b7bd5d73ccf
# ╠═6278ae28-2bfe-11eb-3c36-9bf8cc703a3a
# ╠═6c40b89c-2bfe-11eb-3593-9d9ef6f45b80
# ╠═e1f23724-2bfd-11eb-1063-1d59909bcacc
# ╠═b05d0bdc-4b5e-11eb-14f6-6bf4e3b24949
# ╠═22285b5e-4b5f-11eb-197a-e39e5c525c8d
# ╠═39eae5c2-4b5f-11eb-151a-b76db57f04b8
# ╠═73c3869a-2bfd-11eb-0597-29cd6c1c90db
# ╠═c80e4362-2bfe-11eb-2055-5fbf167be551
# ╠═84880dfc-2bfd-11eb-32b7-47750e1c696b
# ╠═8c62855a-2bff-11eb-00f5-3702e142f76f
# ╠═ae8d6258-2bff-11eb-0182-afc33d9d4efc
# ╠═3aba6b10-4b5c-11eb-0e4f-81b47568937a
# ╠═b5bf307a-4b5c-11eb-32eb-614b3193d8cb
# ╠═746d3578-2bff-11eb-121a-f3d17397a49e
# ╠═f41919a4-2bff-11eb-276f-a5edd5b374ac
# ╠═55bfb46a-2be5-11eb-2be6-1bc153db11ac
# ╠═d523e4c6-301b-11eb-040a-f7a214cb785b
# ╠═fafc7e74-34c6-11eb-0ce1-8fe2e3215739
# ╠═0f7f9156-34c7-11eb-01dd-db5b3e1b0eca
# ╠═9c7ad77a-34c7-11eb-0636-5d4c8dd9542b
# ╠═24e09632-34ca-11eb-09c6-cd0a14601723
# ╠═ac4540e6-34ca-11eb-28a5-39a639f385a1
# ╠═1937de5a-34c8-11eb-0a99-afc09e510273
# ╠═47a40a70-34c8-11eb-2ae1-5fde1e1ef83c
# ╠═a35eda0c-34c8-11eb-27e4-35a06de2df43
# ╠═54e78bb0-34c8-11eb-0cf9-a1a2b398e107
