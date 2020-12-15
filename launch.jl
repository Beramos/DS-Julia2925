#=
Created on Tuesday 15 December 2020
Last update: -

@author: Bram De Jaegher
bram.de.jaegher@gmail.com

Launches the Pluto notebooks for the project
=#

cd("notebooks")
import Pkg; Pkg.activate(".")

using Pluto
Pluto.run()