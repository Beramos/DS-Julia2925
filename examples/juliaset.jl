# Julia Set Visualization
#
# This script generates and plots a Julia fractal using the escape time algorithm
# for a given complex constant `c`. It colors points based on how quickly their
# orbits escape to infinity under iteration of f(z) = z^2 + c.
#
# Author: Michiel Stock
# Date: 2025-07-04

using Plots

R = 50.0  # escape radius
dx = 1e-3
dy = dx

c = -0.8 + 0.156im
f = z -> z^2 + c   # single map


function escape_time(z, max_iter=500, R=R)
    for i in 1:max_iter
        z = f(z)
        abs(z) > R && return i
    end
    return missing
end

Z = [x + y*im for x in -2:dx:2, y in -2:dy:2]

T = escape_time.(Z)

heatmap(log.(T), framestyle = :none, color=:Paired_12)