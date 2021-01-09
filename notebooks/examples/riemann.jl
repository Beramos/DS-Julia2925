#=
Created on 09/01/2021 13:08:20
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Integrating for dummies. Compute the Riemann sum **without** making use of a for loop.

Compute the area of a circle.
=#

function riemann(f, a, b; n=100)
    dx = (b - a) / n
    return sum(f.(a:dx:b)) * dx
end

riemann(sin, 0, 2pi)

riemann(x->x*sin(x), 0, 2pi)

4riemann(x->(sqrt(1-x^2)), 0, 1, n=1000)
