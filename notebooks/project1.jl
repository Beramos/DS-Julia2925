### A Pluto.jl notebook ###
# v0.12.12

using Markdown
using InteractiveUtils

# ╔═╡ 485292d8-2bde-11eb-0a97-6b44d54596dd
using Plots

# ╔═╡ fc8ff7b8-2be1-11eb-0c9c-b9d2ee7c2880
using Markdown, Images

# ╔═╡ 2411c6ca-2bdd-11eb-050c-0399b3b0d7af
md"""
# Project 1: images and cellular automata

We wrap up the day by exploring convolutions and similar operations on 1-D and 2-D (or even n-D!) matrices. Departing from some basic building blocks we will cover signal processing, image processing and cellular automata!

Learning goals:
- code reuse;
- speed and performance (including optimizations);
- learning to plot and make animations.
"""

# ╔═╡ 3d9c3fea-2bde-11eb-0f09-cf11dcb07c0d
md"""
## 1-D operations
"""

# ╔═╡ e1147d4e-2bee-11eb-0150-d7af1f51f842
md"""
### 1-D convolution

Convolution:

$$y_i = \sum_j x_{j-m} k_{j}$$

Boundary effects.
"""

# ╔═╡ 6115f95c-2bde-11eb-01ce-3d17b78aa8a9
noisy_signal = 0:0.1:10 .|> x -> x * sin(x) + rand()  # use covid cases?

# ╔═╡ 8a996336-2bde-11eb-10a3-cb0046ed5de9
plot(noisy_signal)

# ╔═╡ a1f75f4c-2bde-11eb-37e7-2dc342c7032a
function convolve_1d!(x::Vector, out::Vector, w::Vector)
	n = length(x)
	m = div(length(w), 2)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	@assert n == length(out) "`x` and `out` have to be of the same length!"
	fill!(out, 0.0)
	for (i, xj) in enumerate(x)
		for (j, wj) in enumerate(w)
			k = clamp(i + j - m, 1, n)
			out[i] += w[j] * x[k]
		end
	end
	return out
end

# ╔═╡ 906841ee-2be1-11eb-03f4-49b5a8b47a6b
convolve_1d(x::Vector, w::Vector) = convolve_1d!(x, similar(x), w)

# ╔═╡ ef84b6fe-2bef-11eb-0943-034b8b90c4c4
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

# ╔═╡ fa911a76-2be3-11eb-1c85-3df313eb0fcb
w = triangle_weigths(2)

# ╔═╡ 20c46656-2bf0-11eb-2dc4-af2cc2161f6a
scatter(w, xlabel="j", ylabel="weight")

# ╔═╡ cb5f4a20-2be8-11eb-0000-c59f23a024ef
signal_c = convolve_1d(noisy_signal, w)

# ╔═╡ eb5f8062-2be1-11eb-1e96-1f89be62f3b0
plot(signal_c)

# ╔═╡ af33214a-2be7-11eb-34f5-0d046c9db735
function generalized_convolve_1d!(x::Vector, out::Vector, m, f)
	n = length(x)
	@assert n == length(out) "`x` and `out` have to be of the same length!"
	fill!(out, 0.0)
	for (i, xj) in enumerate(x)
		if  m < i < n - m
			out[i] = f(@view(x[(i-m):(i+m)]))
		else
			out[i] = x[i]
		end
	end
	return out
end

# ╔═╡ 4263e920-2bf1-11eb-1db1-ed644a480a2d


# ╔═╡ 21ce0552-2be9-11eb-2359-152a7c75cc2e
vec_conv(x_s) = sum(x_s .* w)

# ╔═╡ 9bfd0e60-2bf1-11eb-3de4-03308da53e73
mean(x) = sum(x) / length(x)

# ╔═╡ 04a8eb54-2be4-11eb-06af-890cebf38da4
signal_gc = generalized_convolve_1d!(noisy_signal, similar(noisy_signal), 2, minimum)

# ╔═╡ b94aae80-2be8-11eb-0c88-cb3d2820e9ef
plot(signal_gc)

# ╔═╡ b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
md"""
### Sliding window: secundary structure prediction

Chou-Fasman method
"""

# ╔═╡ c924a5f6-2bf1-11eb-3d37-bb63635624e9
spike_sars2 = "MFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKVFRSSVLHSTQDLFLPFFSNVTWFHAIHVSGTNGTKRFDNPVLPFNDGVYFASTEKSNIIRGWIFGTTLDSKTQSLLIVNNATNVVIKVCEFQFCNDPFLGVYYHKNNKSWMESEFRVYSSANNCTFEYVSQPFLMDLEGKQGNFKNLREFVFKNIDGYFKIYSKHTPINLVRDLPQGFSALEPLVDLPIGINITRFQTLLALHRSYLTPGDSSSGWTAGAAAYYVGYLQPRTFLLKYNENGTITDAVDCALDPLSETKCTLKSFTVEKGIYQTSNFRVQPTESIVRFPNITNLCPFGEVFNATRFASVYAWNRKRISNCVADYSVLYNSASFSTFKCYGVSPTKLNDLCFTNVYADSFVIRGDEVRQIAPGQTGKIADYNYKLPDDFTGCVIAWNSNNLDSKVGGNYNYLYRLFRKSNLKPFERDISTEIYQAGSTPCNGVEGFNCYFPLQSYGFQPTNGVGYQPYRVVVLSFELLHAPATVCGPKKSTNLVKNKCVNFNFNGLTGTGVLTESNKKFLPFQQFGRDIADTTDAVRDPQTLEILDITPCSFGGVSVITPGTNTSNQVAVLYQDVNCTEVPVAIHADQLTPTWRVYSTGSNVFQTRAGCLIGAEHVNNSYECDIPIGAGICASYQTQTNSPRRARSVASQSIIAYTMSLGAENSVAYSNNSIAIPTNFTISVTTEILPVSMTKTSVDCTMYICGDSTECSNLLLQYGSFCTQLNRALTGIAVEQDKNTQEVFAQVKQIYKTPPIKDFGGFNFSQILPDPSKPSKRSFIEDLLFNKVTLADAGFIKQYGDCLGDIAARDLICAQKFNGLTVLPPLLTDEMIAQYTSALLAGTITSGWTFGAGAALQIPFAMQMAYRFNGIGVTQNVLYENQKLIANQFNSAIGKIQDSLSSTASALGKLQDVVNQNAQALNTLVKQLSSNFGAISSVLNDILSRLDKVEAEVQIDRLITGRLQSLQTYVTQQLIRAAEIRASANLAATKMSECVLGQSKRVDFCGKGYHLMSFPQSAPHGVVFLHVTYVPAQEKNFTTAPAICHDGKAHFPREGVFVSNGTHWFVTQRNFYEPQIITTDNTFVSGNCDVVIGIVNNTVYDPLQPELDSFKEELDKYFKNHTSPDVDLGDISGINASVVNIQKEIDRLNEVAKNLNESLIDLQELGKYEQYIKWPWYIWLGFIAGLIAIVMVTIMLCCMTSCCSCLKGCCSCGSCCKFDEDDSEPVLKGVKLHYT"

# ╔═╡ 4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
md"""
### Elementary cellular automata
"""

# ╔═╡ 625c4e1e-2bf3-11eb-2c03-193f7d013fbe
function nextstate(l::Bool, s::Bool, r::Bool, rule::UInt8)
	bitstring(rule)[8-(4r+2s+1r)] == '1';
end

# ╔═╡ b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
rule = 110 |> UInt8

# ╔═╡ a9ffc05c-2bf3-11eb-0771-b3732ed7d68d
md"""
Table for rule $rule:

| l      | s     | r    | result |
| :--------: | :-----: | :-----: | :--: |
| 10 | $true | $true | $false |

CAN BE DONE IN TABLE?

"""

# ╔═╡ 5f97da58-2bf4-11eb-26de-8fc5f19f02d2
Dict((l, s, r) => nextstate(l, s, r, rule)
	for l in [true, false]
	for s in [true, false]
	for r in [true, false]
				)
										

# ╔═╡ 924461c0-2bf3-11eb-2390-71bad2541463
function update1dca!(xnew, x, rule::UInt8)
	n = length(x)
	xnew[1] = nextstate(x[end], x[1], x[2], rule)
	xnew[end] = nextstate(x[end-1], x[end], x[1], rule)
	for i in 2:n-1
		xnew[i] = nextstate(x[i-1], x[i], x[i+1], rule)
	end
	return xnew
end

# ╔═╡ 21440956-2bf5-11eb-0860-11127d727282
next1dca(x, rule::UInt8) = update1dca!(similar(x), x, rule::UInt8)

# ╔═╡ 405a1036-2bf5-11eb-11f9-a1a714dbf7e1
x0_ca = rand(Bool, 200)

# ╔═╡ 6405f574-2bf5-11eb-3656-d7b9c94f145a
next1dca(x0_ca, rule)

# ╔═╡ 756ef0e0-2bf5-11eb-107c-8d1c65eacc45
"""
    simulate(x0, rule; nsteps::Integer=100)

Simulate `nsteps` time steps according to `rule` with `X0` as the initial condition.
Returns a matrix X, where the rows are the state vectors at different time steps.
"""
function simulate(x0, rule::UInt8; nsteps::Integer=100)
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
X = simulate(x0_ca, rule; nsteps=200)

# ╔═╡ 9ab79ad4-2bf6-11eb-1d0e-bb6434b520a3
heatmap(X)

# ╔═╡ 9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
show_ca(X) = Gray.(X)

# ╔═╡ fb9a97d2-2bf5-11eb-1b92-ab884f0014a8
show_ca(X)

# ╔═╡ 4810a052-2bf6-11eb-2e9f-7f9389116950
all_cas = Dict(rule=>show_ca(simulate(x0_ca, rule; nsteps=200)) for rule in UInt8(0):UInt8(251))

# ╔═╡ 47e3c2f8-2bf6-11eb-1fbf-d5f3fc899056
all_cas[0]

# ╔═╡ aea84d6c-2be3-11eb-2fe7-63e0d0c28507
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("correct", "Keep working on it!", [text]))

# ╔═╡ dc2230ac-2be3-11eb-24d7-f980be57d697
keep_working()

# ╔═╡ 41e7ef30-2be4-11eb-1b9a-e7f7eae7a115
philip_file = download("https://i.imgur.com/VGPeJ6s.jpg")

# ╔═╡ 473c581c-2be5-11eb-1ddc-2d30a3468c8a
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ 4c9d2e0e-2be4-11eb-2fb3-377f29141076
philip = let
	original = Images.load(philip_file)
	decimate(original, 8)
end

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

# ╔═╡ 245deb30-2bfe-11eb-3e47-6b7bd5d73ccf
function gaussian_kernel(m; σ)
	K = [exp(-(x^2 + y^2) / σ^2) for x in -m:m, y in -m:m]
	K ./= sum(K)
	return K
end

# ╔═╡ 6278ae28-2bfe-11eb-3c36-9bf8cc703a3a
K = gaussian_kernel(1, σ=10)

# ╔═╡ 6c40b89c-2bfe-11eb-3593-9d9ef6f45b80
heatmap(K)

# ╔═╡ 73c3869a-2bfd-11eb-0597-29cd6c1c90db
convolve_2d(M, K) = convolve_2d!(M, similar(M), K) 

# ╔═╡ a34f1e4c-2bfd-11eb-127e-295a7039c301
convolve_2d(randn(1000, 1000), K)

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

# ╔═╡ 8c62855a-2bff-11eb-00f5-3702e142f76f
const Gx = [1 0 -1;
		   2 0 -2;
		   1 0 -1]

# ╔═╡ ae8d6258-2bff-11eb-0182-afc33d9d4efc
const Gy = [1 2 1;
		    0 0 0;
		   -1 -2 -1]

# ╔═╡ 746d3578-2bff-11eb-121a-f3d17397a49e
function edge_detection(M)
	M = Gray.(M) |> Matrix
	return convolve_2d(M, Gx).^2 + convolve_2d(M, Gy).^2
end

# ╔═╡ f41919a4-2bff-11eb-276f-a5edd5b374ac
edge_detection(philip)

# ╔═╡ e1f23724-2bfd-11eb-1063-1d59909bcacc
convolve_image(philip, K)

# ╔═╡ 55bfb46a-2be5-11eb-2be6-1bc153db11ac
RGB.(red.(philip), green.(philip), blue.(philip))

# ╔═╡ 04f3c460-2bed-11eb-1039-238bfb3ec445
images = [rand([RGB(0, 0, 1),RGB(1, 0, 0)], 50, 100) for i in 1:100]

# ╔═╡ b3eed0e0-2bed-11eb-21d3-19323b600edf
images[1]

# ╔═╡ 2a3b0be4-2bee-11eb-3e26-f1d850c752b6
@gif for i ∈ 1:100
	plot(rand([RGB(0, 0, 1),RGB(1, 0, 0)], 100, 100))
end

# ╔═╡ Cell order:
# ╠═2411c6ca-2bdd-11eb-050c-0399b3b0d7af
# ╠═3d9c3fea-2bde-11eb-0f09-cf11dcb07c0d
# ╠═e1147d4e-2bee-11eb-0150-d7af1f51f842
# ╠═6115f95c-2bde-11eb-01ce-3d17b78aa8a9
# ╠═8a996336-2bde-11eb-10a3-cb0046ed5de9
# ╠═485292d8-2bde-11eb-0a97-6b44d54596dd
# ╠═a1f75f4c-2bde-11eb-37e7-2dc342c7032a
# ╠═fa911a76-2be3-11eb-1c85-3df313eb0fcb
# ╠═20c46656-2bf0-11eb-2dc4-af2cc2161f6a
# ╠═906841ee-2be1-11eb-03f4-49b5a8b47a6b
# ╠═cb5f4a20-2be8-11eb-0000-c59f23a024ef
# ╠═eb5f8062-2be1-11eb-1e96-1f89be62f3b0
# ╠═ef84b6fe-2bef-11eb-0943-034b8b90c4c4
# ╠═294140a4-2bf0-11eb-22f5-858969a4640d
# ╠═af33214a-2be7-11eb-34f5-0d046c9db735
# ╠═4263e920-2bf1-11eb-1db1-ed644a480a2d
# ╠═21ce0552-2be9-11eb-2359-152a7c75cc2e
# ╠═9bfd0e60-2bf1-11eb-3de4-03308da53e73
# ╠═04a8eb54-2be4-11eb-06af-890cebf38da4
# ╠═b94aae80-2be8-11eb-0c88-cb3d2820e9ef
# ╠═b7ba4ed8-2bf1-11eb-24ee-731940d1c29f
# ╠═c924a5f6-2bf1-11eb-3d37-bb63635624e9
# ╠═4e6dedf0-2bf2-11eb-0bad-3987f6eb5481
# ╠═625c4e1e-2bf3-11eb-2c03-193f7d013fbe
# ╠═b03c60f6-2bf3-11eb-117b-0fc2a259ffe6
# ╠═a9ffc05c-2bf3-11eb-0771-b3732ed7d68d
# ╠═5f97da58-2bf4-11eb-26de-8fc5f19f02d2
# ╠═924461c0-2bf3-11eb-2390-71bad2541463
# ╠═21440956-2bf5-11eb-0860-11127d727282
# ╠═405a1036-2bf5-11eb-11f9-a1a714dbf7e1
# ╠═6405f574-2bf5-11eb-3656-d7b9c94f145a
# ╠═756ef0e0-2bf5-11eb-107c-8d1c65eacc45
# ╠═e1dd7abc-2bf5-11eb-1f5a-0f46c7405dd5
# ╠═9ab79ad4-2bf6-11eb-1d0e-bb6434b520a3
# ╠═9dbb9598-2bf6-11eb-2def-0f1ddd1e6b10
# ╠═fb9a97d2-2bf5-11eb-1b92-ab884f0014a8
# ╠═4810a052-2bf6-11eb-2e9f-7f9389116950
# ╠═47e3c2f8-2bf6-11eb-1fbf-d5f3fc899056
# ╠═fc8ff7b8-2be1-11eb-0c9c-b9d2ee7c2880
# ╠═aea84d6c-2be3-11eb-2fe7-63e0d0c28507
# ╠═dc2230ac-2be3-11eb-24d7-f980be57d697
# ╠═41e7ef30-2be4-11eb-1b9a-e7f7eae7a115
# ╠═4c9d2e0e-2be4-11eb-2fb3-377f29141076
# ╠═473c581c-2be5-11eb-1ddc-2d30a3468c8a
# ╠═608e930e-2bfc-11eb-09f2-29600cfba1e6
# ╠═245deb30-2bfe-11eb-3e47-6b7bd5d73ccf
# ╠═6278ae28-2bfe-11eb-3c36-9bf8cc703a3a
# ╠═6c40b89c-2bfe-11eb-3593-9d9ef6f45b80
# ╠═73c3869a-2bfd-11eb-0597-29cd6c1c90db
# ╠═a34f1e4c-2bfd-11eb-127e-295a7039c301
# ╠═c80e4362-2bfe-11eb-2055-5fbf167be551
# ╠═84880dfc-2bfd-11eb-32b7-47750e1c696b
# ╠═8c62855a-2bff-11eb-00f5-3702e142f76f
# ╠═ae8d6258-2bff-11eb-0182-afc33d9d4efc
# ╠═746d3578-2bff-11eb-121a-f3d17397a49e
# ╠═f41919a4-2bff-11eb-276f-a5edd5b374ac
# ╠═e1f23724-2bfd-11eb-1063-1d59909bcacc
# ╠═55bfb46a-2be5-11eb-2be6-1bc153db11ac
# ╠═04f3c460-2bed-11eb-1039-238bfb3ec445
# ╠═b3eed0e0-2bed-11eb-21d3-19323b600edf
# ╠═2a3b0be4-2bee-11eb-3e26-f1d850c752b6
