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

# ╔═╡ 3e0d3a6a-679d-11eb-16f9-2f27d680ad19
using Images

# ╔═╡ 0ef6dd72-67a1-11eb-0c79-8338b0ee9148
using Plots

# ╔═╡ f5a13664-679c-11eb-303b-d77d31b19660
# edit the code below to set your name and UGent username

student = (name = "Julia Janssen", email = "Julia.Janssen@UGent.be");

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ cd1cf886-679c-11eb-3a26-5f4fbfe204e8
begin 
	using DSJulia;
	using PlutoUI;
	tracker = ProgressTracker(student.name, student.email);
	md"""

	Submission by: **_$(student.name)_**
	"""
end

# ╔═╡ 0d372360-679d-11eb-3078-ed2a4a306497
md"""
# Exercises: convolution, images and cellular automata (part 2)

**Learning goals:**
- code reuse;
- efficient use of collections and unitRanges;
- control flow in julia;

"""

# ╔═╡ 2fb44f80-679d-11eb-0dea-c14a513d3572
md"""
### Intermezzo: What is an image?

An image is generally just a matrix of pixels. What is a pixel? Usually this corresponds to just a particular color (or grayscale). So let us play around with colors first.

There are many ways to encode colors. For our purposes, we can just work with the good old RGB scheme, where each color is described by three values, respectively the red, green and blue fraction.
"""

# ╔═╡ 41d81432-679d-11eb-1f1e-e37f78f1bb07
daanbeardred = RGB(100/255, 11/255, 13/255)

# ╔═╡ 8bedb93a-679d-11eb-008e-e10e18ecdd7e
md"We can extract the red, green, and blue components using the obvious functions."

# ╔═╡ 8bee4bb6-679d-11eb-0ec5-555b068ef863
red(daanbeardred), green(daanbeardred), blue(daanbeardred)

# ╔═╡ 8bfa95ea-679d-11eb-0896-9d54263302a6
md"Converting a color to grayscale is also easy."

# ╔═╡ 8c0486c4-679d-11eb-0808-8f47858313fc
Gray(daanbeardred)

# ╔═╡ 95904a3e-679d-11eb-1fd7-79cf59caac5a
md"An image is a matrix of colors, nothing more!"

# ╔═╡ 95a31fe0-679d-11eb-1298-c16d2cbb038b
mini_image = [RGB(0.8, 0.6, 0.1) RGB(0.2, 0.8, 0.9) RGB(0.8, 0.6, 0.1);
				RGB(0.2, 0.8, 0.9) RGB(0.8, 0.2, 0.2) RGB(0.2, 0.8, 0.9);
				RGB(0.8, 0.6, 0.1) RGB(0.2, 0.8, 0.9) RGB(0.8, 0.6, 0.1)]

# ╔═╡ 95a387ac-679d-11eb-1e81-c3817940e993
mini_image[2, 2]

# ╔═╡ 95adca78-679d-11eb-172c-59097b1a40fe
size(mini_image)

# ╔═╡ 95c26b5e-679d-11eb-1fb5-e116367e6b07
red.(mini_image), green.(mini_image), blue.(mini_image)

# ╔═╡ 95c2bbcc-679d-11eb-1d1b-898c5dc0c876
Gray.(mini_image)

# ╔═╡ 332e7f7a-67a0-11eb-3403-c727d526cff0
function redimage(image)
	return RGB.(red.(image), 0, 0)
end

# ╔═╡ 3347b5f8-67a0-11eb-0817-7b79cb682c92
function greenimage(image)
	return RGB.(0, green.(image), 0)
end

# ╔═╡ 3348b994-67a0-11eb-2b0f-71f9eca1867c
function blueimage(image)
	return RGB.(0, 0, blue.(image))
end

# ╔═╡ 335fab9a-67a0-11eb-1a38-bb375de6761a
redimage(mini_image), greenimage(mini_image), blueimage(mini_image)

# ╔═╡ 336009d0-67a0-11eb-34df-6ba1657fab1e
url = "https://i.imgur.com/BJWoNPg.jpg"

# ╔═╡ 3f0f3ec4-67a0-11eb-3d2b-03b2c33b8104
bird_original = load("aprettybird.jpg")

# ╔═╡ 3f32fddc-67a0-11eb-2514-e763286fe342
typeof(bird_original)

# ╔═╡ 3f333e98-67a0-11eb-29c4-d37af71c1891
eltype(bird_original)

# ╔═╡ 3f5c4a48-67a0-11eb-1717-0d2ee8e4a847
md"So an image is basically a two-dimensional array of Colors. Which means it can be processed just like any other array. and because of the type system, a lot of interesting features work out of the box."

# ╔═╡ 3f5fd148-67a0-11eb-1983-159335a071a4
md"Lets the define a function to reduce the size of the image."

# ╔═╡ 46dbc262-67a0-11eb-2dfa-4dd1c818da72
decimate(image, ratio=5) =  missing

# ╔═╡ 85ada2f8-67a0-11eb-148c-952f1b69f90c
begin
	q101 = Question(
			description=md"""
			Complete the function `decimate(image, ratio=5)`		
			""", 
			validators = @safe[
				decimate(bird_original, ratio=5) ==
					Solutions.decimate(bird_original, ratio=5)
			])
	
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

# ╔═╡ 46fa1864-67a0-11eb-0e6e-05e9ea7defda
smallbird = decimate(bird_original, 6)

# ╔═╡ 46fa61c2-67a0-11eb-18d3-c1f916a12c00
bird = Solutions.decimate(bird_original, 6);

# ╔═╡ 472706be-67a0-11eb-3b2f-494b7da24d20
md"""
☼
$(@bind brightness Slider(0:0.01:4, default=1.5))
☾
"""

# ╔═╡ 47089094-67a0-11eb-19b0-9bd186f1603d
brightness

# ╔═╡ 47277efa-67a0-11eb-1230-5148639dbed4
bird ./ brightness

# ╔═╡ b1314556-67a0-11eb-3318-e3a969452b44
md"This is just a simple element-wise division of a matrix."

# ╔═╡ bded9d80-67a0-11eb-0b66-810c8ba23685
md"""

## 2-D operations

After this colourful break, Let us move from 1-D operations to 2-D operations. This will be a nice opportunity to learn something about image processing.
"""

# ╔═╡ 33d2985e-67a1-11eb-2743-7586880534c7
function convolve_2d(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	#...
	return missing
end

# ╔═╡ 33e837de-67a1-11eb-1f70-fdebfa9202d8
function gaussian_kernel(m; σ=4)
	return missing
end

# ╔═╡ 33e87a82-67a1-11eb-046a-4d34ae2b122c
function convolve_image(M::Matrix{<:AbstractRGB}, K::Matrix)
	return missing
end

# ╔═╡ be100096-67a0-11eb-1ad9-bf4113cc6a5e
begin 	
	M_rand = rand(20, 20)
	K_rand = rand(5, 5)
	
	test_kernel = [0 -1 0;
					-1 5 -1;
					0 -1 0]
	
	q111 = Question(
			description=md"""
			**Exercise:**
		
			Complete the function `convolve_2d(M::Matrix, K::Matrix)` that performs a 2D-convolution of an input matrix `M` with a kernel matrix `K`.
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

# ╔═╡ 33f3970a-67a1-11eb-29c0-f51ccfd2ce4f
#K_gaussian = gaussian_kernel(3, σ=2)

# ╔═╡ 33ffe6c2-67a1-11eb-2460-a5f6e3137d5f
#heatmap(K_gaussian)

# ╔═╡ 34081f5e-67a1-11eb-14f1-75b46ba99402
#bird

# ╔═╡ 40897fc0-67a1-11eb-2029-d9893f11739b
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

# ╔═╡ 40a25b3a-67a1-11eb-0c38-7db7294c8913
K_gaussian2 = Solutions.gaussian_kernel(3, σ=2)

# ╔═╡ 40a2ade2-67a1-11eb-30d7-e96e9aaa4445
blurry_bird = Solutions.convolve_image(bird, K_gaussian2)

# ╔═╡ fa7ae654-67a5-11eb-118b-bbecfe4a46e2


# ╔═╡ fd84be38-67a5-11eb-15d6-0359f813b446


# ╔═╡ fe4de92a-67a5-11eb-2598-2d6c633612f3
function edge_detection(M)
	return missing
end

# ╔═╡ Cell order:
# ╟─cd1cf886-679c-11eb-3a26-5f4fbfe204e8
# ╠═f5a13664-679c-11eb-303b-d77d31b19660
# ╟─0d372360-679d-11eb-3078-ed2a4a306497
# ╟─2fb44f80-679d-11eb-0dea-c14a513d3572
# ╠═3e0d3a6a-679d-11eb-16f9-2f27d680ad19
# ╠═41d81432-679d-11eb-1f1e-e37f78f1bb07
# ╠═8bedb93a-679d-11eb-008e-e10e18ecdd7e
# ╠═8bee4bb6-679d-11eb-0ec5-555b068ef863
# ╠═8bfa95ea-679d-11eb-0896-9d54263302a6
# ╠═8c0486c4-679d-11eb-0808-8f47858313fc
# ╠═95904a3e-679d-11eb-1fd7-79cf59caac5a
# ╠═95a31fe0-679d-11eb-1298-c16d2cbb038b
# ╠═95a387ac-679d-11eb-1e81-c3817940e993
# ╠═95adca78-679d-11eb-172c-59097b1a40fe
# ╠═95c26b5e-679d-11eb-1fb5-e116367e6b07
# ╠═95c2bbcc-679d-11eb-1d1b-898c5dc0c876
# ╠═332e7f7a-67a0-11eb-3403-c727d526cff0
# ╠═3347b5f8-67a0-11eb-0817-7b79cb682c92
# ╠═3348b994-67a0-11eb-2b0f-71f9eca1867c
# ╠═335fab9a-67a0-11eb-1a38-bb375de6761a
# ╠═336009d0-67a0-11eb-34df-6ba1657fab1e
# ╠═3f0f3ec4-67a0-11eb-3d2b-03b2c33b8104
# ╠═3f32fddc-67a0-11eb-2514-e763286fe342
# ╠═3f333e98-67a0-11eb-29c4-d37af71c1891
# ╟─3f5c4a48-67a0-11eb-1717-0d2ee8e4a847
# ╟─3f5fd148-67a0-11eb-1983-159335a071a4
# ╟─85ada2f8-67a0-11eb-148c-952f1b69f90c
# ╠═46dbc262-67a0-11eb-2dfa-4dd1c818da72
# ╠═46fa1864-67a0-11eb-0e6e-05e9ea7defda
# ╠═46fa61c2-67a0-11eb-18d3-c1f916a12c00
# ╠═47089094-67a0-11eb-19b0-9bd186f1603d
# ╟─472706be-67a0-11eb-3b2f-494b7da24d20
# ╠═47277efa-67a0-11eb-1230-5148639dbed4
# ╟─b1314556-67a0-11eb-3318-e3a969452b44
# ╟─bded9d80-67a0-11eb-0b66-810c8ba23685
# ╠═0ef6dd72-67a1-11eb-0c79-8338b0ee9148
# ╟─be100096-67a0-11eb-1ad9-bf4113cc6a5e
# ╠═33d2985e-67a1-11eb-2743-7586880534c7
# ╠═33e837de-67a1-11eb-1f70-fdebfa9202d8
# ╠═33e87a82-67a1-11eb-046a-4d34ae2b122c
# ╠═33f3970a-67a1-11eb-29c0-f51ccfd2ce4f
# ╠═33ffe6c2-67a1-11eb-2460-a5f6e3137d5f
# ╠═34081f5e-67a1-11eb-14f1-75b46ba99402
# ╟─40897fc0-67a1-11eb-2029-d9893f11739b
# ╠═40a25b3a-67a1-11eb-0c38-7db7294c8913
# ╠═40a2ade2-67a1-11eb-30d7-e96e9aaa4445
# ╠═fa7ae654-67a5-11eb-118b-bbecfe4a46e2
# ╠═fd84be38-67a5-11eb-15d6-0359f813b446
# ╠═fe4de92a-67a5-11eb-2598-2d6c633612f3
