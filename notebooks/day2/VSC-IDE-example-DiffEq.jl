### Basic usage
# - Shift + enter execute all
# - Ctrl + enter execute line
# - Alt + enter execute block

import Pkg
Pkg.activate("DiffEq")
using DifferentialEquations, Plots

function f(du,u,p,t)
  du[1] = u[2]
  du[2] = -p
end

u₀ = [50.0,0.0]
tspan = (0.0,15.0)
p = 9.8

prob = ODEProblem(f,u₀,tspan, p)
sol = solve(prob,Tsit5())
plot(sol, label = ["Displacement" "Velocity"],
  xlabel="Time (s)", 
  ylabel="Displacement (m) | Velocity (m/s)")


# But where is the ground?
function condition(u,t,integrator) # Event when event_f(u,t) == 0
  u[1]
end

function affect!(integrator)
  integrator.u[2] = -integrator.u[2]
end

cb = ContinuousCallback(condition,affect!)

sol = solve(prob,Tsit5(), callback=cb)
plot(sol, label = ["Displacement" "Velocity"], 
  xlabel="Time (s)", 
  ylabel="Displacement (m) | Velocity (m/s)")


### Debugger usage
function f₂(du,u,p,t)
  g, Cd = p
  du[1] = u[2]
  du[2] = -(p+u[2]^2*Cd*sign(u[2])) 
end

p = (9.81, 1e-2)

prob = ODEProblem(f₂, u₀,tspan, p)
sol = solve(prob, Tsit5(), callback=cb)

plot(sol, label = ["Displacement" "Velocity"], 
  xlabel="Time (s)", 
  ylabel="Displacement (m) | Velocity (m/s)")
