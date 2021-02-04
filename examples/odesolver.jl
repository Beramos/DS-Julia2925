#=
Created on 20/01/2021 10:58:10
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Here, we illustrate type-based dispatch, using the type system
=#



abstract type ODESolver end

struct Euler <: ODESolver end
struct SecondOrder <: ODESolver end

function solve_ode(f′, (t₀, tₑ), y₀, Δt, method::ODESolver)
    tsteps = t₀:Δt:tₑ
    # initialize solution vector
    y = zeros(length(tsteps))
    # set initial value
    y[1] = y₀
    for (i, t) in enumerate(tsteps)
        i == 1 && continue
        yᵢ₋₁ = y[i-1]
        yᵢ = step(f′, t, yᵢ₋₁, Δt, method)
        y[i] = yᵢ
    end
    return y
end

step(f′, t, yᵢ₋₁, Δt, ::Euler) = yᵢ₋₁ + Δt * f′(t, yᵢ₋₁)

function step(f′, t, yᵢ₋₁, Δt, ::SecondOrder)
    y = yᵢ₋₁ + 0.5Δt * f′(t, yᵢ₋₁)  # half step
    return yᵢ₋₁ + Δt * f′(t, y)
end

f′(t, y) = -y + sin(t * y)

y_euler = solve_ode(f′, (0, 10), 1.0, 0.1, Euler())
y_second_order = solve_ode(f′, (0, 10), 1.0, 0.1, SecondOrder())


plot(y_euler, label="Euler", xlabel="t", ylabel="y")
plot!(y_second_order, label="second order")