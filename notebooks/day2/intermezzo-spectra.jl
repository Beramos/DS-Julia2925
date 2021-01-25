cd("./notebooks/day2")
# activate current environment and load packages
import Pkg
Pkg.activate(".")
using DrWatson
using Pipe
include("Spectrum.jl")

# get data
nir_components = get_components();
nir = get_data()

# data on all individual components
nir_components
# data on ASA
nir_components["ASA"]
# the wavelengths and the collected spectra
nir_components["ASA"].x
nir_components["ASA"].y
# integration into plotting
nir_components["ASA"] |> plot

# SNV
@pipe nir_components["ASA"] |> snv
# SG
@pipe nir_components["ASA"] |> savitzkygolay(_; derivativeOrder=1)

# SNV after SG
@pipe nir_components["ASA"] |> savitzkygolay |> snv
# SNV after SG, but plot the results
@pipe nir_components["ASA"] |> savitzkygolay |> snv |> plot(_; label="processed")
#@pipe nir_components["ASA"] |> savitzkygolay(_; derivativeOrder=1) |> snv |> plot(_; label="processed")

# note the difference with the original data
# we use plot! instead of plot to add to the previous plot
@pipe nir_components["ASA"] |> plot!(_; label="raw")


# define functions on how the processing should be done using DrWatson

function run_preprocessing(d::Dict)
    @unpack derivativeOrder, degree = d
    spectrum = @pipe nir_components["ASA"] |> savitzkygolay(_; derivativeOrder=derivativeOrder, degree=degree) |> snv(_;)
    simulation = @ntuple derivativeOrder degree
    @tagsave(
        datadir("sims", "example_spectra_processing", savename(d, "bson")), # filename
        @dict spectrum simulation ;# data to be saved
        safe=true # do not overwrite existing files, counters will be added in case of existing file
    )
    #spectrum
end


# prepare all options for the simulations
# this is all possible scenarios to be computed
allparams = Dict(
    :derivativeOrder => [0, 1, 2], # order of the derivative of SG
    :degree => [2, 3, 4], # order of the polynomial of SG
)
# how many parameter combinations?
dict_list_count(allparams)
# explicitly generate all parameter dicts
dicts = dict_list(allparams)



# run all scenarios and store results
# note the filenames!
map(run_preprocessing, dicts)

# making a shorthand function to produce or load simulation results
simulate_or_load(d::Dict) = produce_or_load(
    datadir("sims", "example_spectra_processing"), # path
    d, #@dict(N, T), # container
    run_preprocessing, # function
    #prefix = "fig5_toyparams" # prefix for savename
)

# interface to simulate the model or load the results if the model has been run before in the past
# this will load from a file
simulate_or_load(Dict(:derivativeOrder => 0, :degree => 2))
# this will simulate and store to a file
simulate_or_load(Dict(:derivativeOrder => 0, :degree => 7))