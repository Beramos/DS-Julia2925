using CSV, DataFrames

function get_data()
    # read data
    data = CSV.read("./nir_data_small.csv", DataFrame; delim=",");
    # each column is a spectrum
    # get one via: spectra[:,1]
    spectra = Matrix(data[:, 3:end])';
    x = parse.(Float64, names(data)[3:end]);
    return Spectrum(x, spectra);
end

function get_components()
    data = CSV.read("nir_data_components_small.csv", DataFrame; delim=",");
    components = unique(data[!,1])
    x = parse.(Float64, names(data)[2:end])
    dictofspectra = Dict{String, Spectrum}()
    for component in components
        spectra = Matrix(data[data[!,1] .== component, 2:end])'
        dictofspectra[component] = Spectrum(x, spectra)
    end
    return dictofspectra;
end



