### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ ec6273de-60ed-11eb-23af-05a59d76f2d2
begin 
	using PlutoUI
	using DrWatson
	using Pipe
	using Plots
	using CSV, DataFrames
	using DSJulia
end

# ╔═╡ f9549978-61a6-11eb-28ce-bdbbd524be6c
begin
	import Statistics:mean, std

	# the addition of SubArray to the type is necessary to allow the eachcol calls from a 2D input
	function snv(y::Union{SubArray{Float64, 1}, Array{Float64, 1}}; std_offset=zero(1))::Array{Float64, 1}
		(y .- mean(y)) ./ (std(y) .+ std_offset)
	end
	function snv(y::Array{Float64, 2}; std_offset=zero(1))::Array{Float64, 2}
		hcat(snv.(eachcol(y); std_offset=std_offset)...)
	end

	include("DirectConvolution/DirectConvolution.jl")
	function savitzkygolay(y::Union{SubArray{Float64, 1}, Array{Float64, 1}}; halfWidth::Int=5, degree::Int=2, derivativeOrder::Int=0)
		sg = DirectConvolution.SG_Filter(Float64, halfWidth=10, degree=5);
		smoothed = DirectConvolution.apply_SG_filter(y, sg, derivativeOrder=1)
		return smoothed
	end
	function savitzkygolay(y::Array{Float64, 2}; halfWidth::Int=5, degree::Int=2, derivativeOrder::Int=0)
		sg = DirectConvolution.SG_Filter(Float64, halfWidth=halfWidth, degree=degree);
		smoothed = hcat([DirectConvolution.apply_SG_filter(collect(y__), sg, derivativeOrder=derivativeOrder) for y__ in eachcol(y)]...)
		return smoothed
	end
end

# ╔═╡ 5f1f35ba-6184-11eb-11ec-63a6acb353fe
md"
In this intermezzo, we will talk about working with spectral data from an near-infrared (NIR) imaging device. In this application we are looking to link the concentration of an active pharmaceutical ingredient in a powder blend to its NIR spectrum.

We will show:
1. what data type could be choosen for such an approach
2. how to define functions (using multiple dispatch) for our new struct
3. an example of a plotting recipe (custom plot function on your struct)
4. data pipelines
5. simple IO data management for simulations using DrWatson
"

# ╔═╡ aa168338-60f1-11eb-1b4d-8b0a26902f90
md"""
Let us define the layout for the `Spectrum` composite type.
It has 2 fields:
* x is the wavelengths of the spectrum
* y is the measured spectrum.

The dimensions should match ofcourse! That is why this check is performed using the ternary ` ? : ` operator.
"""

# ╔═╡ 9ed1673e-60f1-11eb-04f3-7dae7d556332
mutable struct Spectrum
    x::Array{Float64, 1}
    # can be one or two dimensional
    # if 2D, each column is an experiment (dimensions checked in constructor)
    y::Array{Float64}
    Spectrum(x, y) = size(x)[1] === size(y)[1] ? new(x,y) : error("first dimension does not match")
end

# ╔═╡ bc58916a-6185-11eb-28f9-1d258204da39
md"To make it all a bit more appealing to the eyes, we are extending the `Base.show` functions with our newly defined struct. These functions determine what happens when `println` is called on an instance of, for instance, `Spectrum`."

# ╔═╡ 28987cf8-60f4-11eb-1776-0341eaa6c0bf
begin
	# show an instance of Spectrum in a nice way by adding two new methods to Base.show
	Base.show(io::IO, ::MIME"text/plain", s::Spectrum) = print(io, "Instance of Spectrum\n", "spectrum divided into $(size(s.x)[1]) parts, ranging from $(s.x[1]) to $(s.x[end])\n", "this instance contains $(size(s.y)[2]==1 ? "1 spectrum" : "$(size(s.y)[2]) spectra")")
	Base.show(io::IO, s::Spectrum) = print(io, "$(size(s.y)[2]==1 ? "1 spectrum" : "$(size(s.y)[2]) spectra"), defined between $(s.x[1]) to $(s.x[end])")
end

# ╔═╡ 85768488-60f4-11eb-0e21-53e8f0fff7a8
md"Load the measurement data. Here we convert tabular data into `Spectrum` instances. On the one hand, we have data from different experimental settings (`nir`). On the other hand, we have NIR spectra of pure components in our blend. These will be stored in a dictionary of type `Spectrum`, named `nir_components`"

# ╔═╡ 3b43acb0-60f4-11eb-3998-c1e1db1cb77a
begin
	data = CSV.read("./nir_data_small.csv", DataFrame; delim=",")
    nir = Spectrum(
		parse.(Float64, names(data)[3:end]), 
		Matrix(data[:, 3:end])'
	)
	data = CSV.read("nir_data_components_small.csv", DataFrame; delim=",");
    components = unique(data[!,1])
    x = parse.(Float64, names(data)[2:end])
    nir_components = Dict{String, Spectrum}()
    for component in components
        spectra = Matrix(data[data[!,1] .== component, 2:end])'
        nir_components[component] = Spectrum(x, spectra)
    end
end

# ╔═╡ 45656b44-6189-11eb-28b4-47d96215dcad
md"Let us showcase the print behaviour:"

# ╔═╡ f812abd4-60f4-11eb-3b88-69d0b6a4c9c8
@terminal println(nir)

# ╔═╡ 8f978728-60f4-11eb-33ae-4b5ce56a844d
nir

# ╔═╡ 718493cc-61a3-11eb-0382-6f056380132f
nir.x, nir.y

# ╔═╡ 74f71ac4-6189-11eb-2fa6-3dcaf193fc81
md"plotting time"

# ╔═╡ cbe8d980-61a2-11eb-3c3d-215b74cb3f04
@recipe function plot(spectrum::Spectrum)
    xguide --> "wavelength"
    yguide --> "intensity"
    spectrum.x, spectrum.y # return the arguments (input data) for the next recipe
end

# ╔═╡ 321f623a-61a3-11eb-033e-0d95dbaafec4
function plot_components(components::Dict{String, Spectrum})
    plot(palette=:Dark2_8)
    for component in keys(components)
        plot!(components[component]; label=component)
    end
    return current()
end

# ╔═╡ e4cdce24-61a2-11eb-0a0c-c76d52c6f44a
plot(nir) # or use a pipe: nir |> plot

# ╔═╡ 26dfb3a6-61a6-11eb-1cc6-bdcc9cf849ee
nir_components |> plot_components

# ╔═╡ 3a9f7890-61a6-11eb-3c83-079a65eb3044
md"
Now let us perform some preprocessing on these spectra. Since this is not an introduction in spectral data processing, this subject is only touched upon briefly and should be seen an implementation example.

We have two types of preprocessing:
1. Standard normal variate (snv), to normalise the spectrum
2. Savitzky-Golay filter, to smoothen and/or take the derivative (removes the baseline)

This is how we can define them for one- or twodimensional arrays:
"

# ╔═╡ 2067c21a-61a7-11eb-1f35-f1c8301812ad
md"
To make these functions work with our `Spectrum` data type, we will use multiple dispatching to create a function and call the functions above.
"

# ╔═╡ 585952e2-61a7-11eb-1fde-71e94e121eca
begin
	function snv(spectrum::Spectrum; std_offset=zero(1))
		Spectrum(spectrum.x, snv(spectrum.y; std_offset=std_offset))
	end
	function savitzkygolay(spectrum::Spectrum; halfWidth::Int=5, degree::Int=2, derivativeOrder::Int=0)
		Spectrum(spectrum.x, savitzkygolay(spectrum.y; halfWidth=halfWidth, degree=degree, derivativeOrder=derivativeOrder))
	end
end

# ╔═╡ 9f4e7a7c-61a9-11eb-3348-31d52b8ce735
snv(nir)

# ╔═╡ ab61f4e2-61a9-11eb-2d41-eb6089d1716a
md"
Let us visualise these preprocessing steps. 
We want to make a chain of functions to get our answer:
1. First smoothing and removal of the baseline
2. Normalisation
3. Plotting

You can do this in multiple ways. You can just chain the different functions:
```julia
plot(snv(savitzkygolay(nir)))
```
But this is not so easy to read. An alternative is using a pipeline. We are using the package `Pipe` to allow for more control in the pipeline and the ability to set some additional parameters in the functions. 
The underscore `_` is used to denote the variable that is passed from the previous function. If it is omitted, it will behave like the standard pipe, i.e. it is always the first argument. 

Also note, that you can add additional arguments to the call to the plot function, just as you would do it with any other regular plot.
"

# ╔═╡ 5573ddf8-61a8-11eb-3eb4-0382ea34c976
begin
	@pipe nir |> savitzkygolay |> snv |> plot(_; label="processed")
	@pipe nir |> plot!(_; label="raw")
end

# ╔═╡ 99480eee-61aa-11eb-0306-4500a7a9cd0e
md"
We will end this intermezzo with a showcase of some handy `DrWatson` features. 
Let us start by defining a function that performs the preprocessing (`run_preprocessing`). We will allow a dict of parameters as input so that we can make a scenario analysis of the effect of different parameter values. 

DrWatson has some handy functions, such as `savename` which creates a name with the parameter names and their values, and `datadir` which provides access to the folders on your hard disk where the (simulation) data is stored.

Note the (on purpose) heavy usage of macros to make the code more readable: `@unpack`, `@pipe`, `@ntuple`, `@dict`.
"

# ╔═╡ 9c8194c2-61ad-11eb-3fcc-39923da3be89
function run_preprocessing(d::Dict)
    @unpack derivativeOrder, degree = d
    spectrum = @pipe nir |> savitzkygolay(_; derivativeOrder=derivativeOrder, degree=degree) |> snv(_;)
    simulation = @ntuple derivativeOrder degree
    @tagsave(
        datadir("sims", "example_spectra_processing", savename(d, "bson")), # filename
        @dict spectrum simulation ;# data to be saved
        safe=true # do not overwrite existing files, counters will be added in case of existing file
    )
end

# ╔═╡ a0813a0a-61b4-11eb-1487-07e7bb763ad7
md"
Let us prepare all options for the simulations. These are all possible scenarios to be computed.
"

# ╔═╡ 543ed008-61af-11eb-046a-4bfb932764d9
begin
	allparams = Dict(
		:derivativeOrder => [0, 1, 2], # order of the derivative of SG
		:degree => [2, 3, 4], # order of the polynomial of SG
	);
	# how many parameter combinations?
	dict_list_count(allparams);
	# explicitly generate all parameter dicts
	dicts = dict_list(allparams);
end

# ╔═╡ b7573694-61b4-11eb-1cbf-cd4c8731d4d9
md"
Computing and storing all these scenarios can be done easily by mapping the parameters dict onto the function `run_preprocessing`.

Or if you, by this time, are really getting into pipelines:
```julia
dicts .|> run_preprocessing
```

Note in the output below, the two symbols `:script` and ':gitcommit`: `DrWatson` automatically saves information on which script generated the data and it is linking the git commit for maximum reproducibility.
"

# ╔═╡ 66bdcba8-61af-11eb-1994-f520f840df2d
map(run_preprocessing, dicts)

# ╔═╡ 353ac816-61b5-11eb-3a40-eb6a132258dd
md"
Using the function readdir, we list the contents of the simulation folder to see what files it contains. Note the filenames are the parameters that we defined!
"

# ╔═╡ 5616498e-61ae-11eb-3294-9fc244adec2e
readdir(datadir("sims", "example_spectra_processing"))

# ╔═╡ 05aa5ce4-61b6-11eb-30c9-cfc7a796e3fc
md"
We can take this one step further and make a function that first checks if the simulation already exists, and if not produces the result.
"

# ╔═╡ f4f31766-61af-11eb-2e6e-452e195f6c7e
simulate_or_load(d::Dict) = produce_or_load(
    datadir("sims", "example_spectra_processing"), # path
    d, # container with parameters
    run_preprocessing; # function
	verbose = true
)

# ╔═╡ 2b1f3364-61b6-11eb-14bb-9197c54b9ec5
md"
This parameter combination has been computed in the previous mapping, so the results will be loaded from the disk and no additional information is printed.
"

# ╔═╡ f680cfcc-61af-11eb-0a04-314c6b2ea701
@terminal simulate_or_load(Dict(:derivativeOrder => 0, :degree => 2))[1][:spectrum]

# ╔═╡ 9095b8c6-61b6-11eb-2ae4-67897b126e22
md"
This parameter combination was not part of the original set, so this will be computed and stored to disk.
"

# ╔═╡ fb3a876c-61af-11eb-1a11-35d2951e1582
@terminal simulate_or_load(Dict(:derivativeOrder => 0, :degree => 9))

# ╔═╡ Cell order:
# ╟─ec6273de-60ed-11eb-23af-05a59d76f2d2
# ╟─5f1f35ba-6184-11eb-11ec-63a6acb353fe
# ╟─aa168338-60f1-11eb-1b4d-8b0a26902f90
# ╠═9ed1673e-60f1-11eb-04f3-7dae7d556332
# ╟─bc58916a-6185-11eb-28f9-1d258204da39
# ╠═28987cf8-60f4-11eb-1776-0341eaa6c0bf
# ╟─85768488-60f4-11eb-0e21-53e8f0fff7a8
# ╠═3b43acb0-60f4-11eb-3998-c1e1db1cb77a
# ╟─45656b44-6189-11eb-28b4-47d96215dcad
# ╠═f812abd4-60f4-11eb-3b88-69d0b6a4c9c8
# ╠═8f978728-60f4-11eb-33ae-4b5ce56a844d
# ╠═718493cc-61a3-11eb-0382-6f056380132f
# ╠═74f71ac4-6189-11eb-2fa6-3dcaf193fc81
# ╠═cbe8d980-61a2-11eb-3c3d-215b74cb3f04
# ╠═321f623a-61a3-11eb-033e-0d95dbaafec4
# ╠═e4cdce24-61a2-11eb-0a0c-c76d52c6f44a
# ╠═26dfb3a6-61a6-11eb-1cc6-bdcc9cf849ee
# ╟─3a9f7890-61a6-11eb-3c83-079a65eb3044
# ╠═f9549978-61a6-11eb-28ce-bdbbd524be6c
# ╟─2067c21a-61a7-11eb-1f35-f1c8301812ad
# ╠═585952e2-61a7-11eb-1fde-71e94e121eca
# ╠═9f4e7a7c-61a9-11eb-3348-31d52b8ce735
# ╟─ab61f4e2-61a9-11eb-2d41-eb6089d1716a
# ╠═5573ddf8-61a8-11eb-3eb4-0382ea34c976
# ╟─99480eee-61aa-11eb-0306-4500a7a9cd0e
# ╠═9c8194c2-61ad-11eb-3fcc-39923da3be89
# ╟─a0813a0a-61b4-11eb-1487-07e7bb763ad7
# ╠═543ed008-61af-11eb-046a-4bfb932764d9
# ╟─b7573694-61b4-11eb-1cbf-cd4c8731d4d9
# ╠═66bdcba8-61af-11eb-1994-f520f840df2d
# ╟─353ac816-61b5-11eb-3a40-eb6a132258dd
# ╠═5616498e-61ae-11eb-3294-9fc244adec2e
# ╟─05aa5ce4-61b6-11eb-30c9-cfc7a796e3fc
# ╠═f4f31766-61af-11eb-2e6e-452e195f6c7e
# ╟─2b1f3364-61b6-11eb-14bb-9197c54b9ec5
# ╠═f680cfcc-61af-11eb-0a04-314c6b2ea701
# ╟─9095b8c6-61b6-11eb-2ae4-67897b126e22
# ╠═fb3a876c-61af-11eb-1a11-35d2951e1582
