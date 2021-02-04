#=
Created on Tuesday 4 February 2021
Last update: -

@author: Daan.van.hauwermeiren
daan.van.hauwermeiren@gmail.com

Launches the Pluto notebooks for the spectra showcase
=#

import Pkg; Pkg.activate("."); Pkg.instantiate();
Pkg.add(url="https://github.com/Beramos/DS-Julia2925");

using Pluto
Pluto.run()