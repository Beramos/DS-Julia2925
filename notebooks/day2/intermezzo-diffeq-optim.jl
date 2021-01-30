begin 
  import Pkg; Pkg.activate(".")
  Pkg.add("DifferentialEquations")
  Pkg.add("Optim")
end

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

cb = ContinuousCallback(condition,affect!, save_positions=(false, false))

sol = solve(prob,Tsit5(), callback=cb)
plot(sol, label = ["Displacement" "Velocity"], 
  xlabel="Time (s)", 
  ylabel="Displacement (m) | Velocity (m/s)")


### Air resistance
function f₂(du,u,p,t)
  g, Cd = p
  du[1] = u[2]
  du[2] = -(g+u[2]^2*Cd*sign(u[2])) 
end

p = (9.81, 15e-2)

prob = ODEProblem(f₂, u₀,tspan, p)
sol = solve(prob, Tsit5(), callback=cb)

plot(sol, label = ["Displacement" "Velocity"], 
  xlabel="Time (s)", 
  ylabel="Displacement (m) | Velocity (m/s)")


### Optim.jl
using Optim

function compute_ODE(p; times=1:0.5:15)
  prob = ODEProblem(f₂, u₀,tspan, p)
  sol = solve(prob, Tsit5(), saveat=times, callback = cb)
  return sol.t , hcat(sol.u...)[1,:]
end

time, exp_disp = compute_ODE((9.81, 5e-2)) 
exp_disp .+= 0.75randn(length(exp_disp)) # add noise

scatter(time, exp_disp, label="Experiment", xlabel="Time(s)", ylabel="Displacement (m)")

function objective(Cd) 
  _, sim_disp = compute_ODE((9.81, Cd[1]))
  return sum((sim_disp.- exp_disp).^2)
end

res = optimize(objective, [5e-3], Newton(), Optim.Options(store_trace=true, extended_trace=true))
Cd = res.minimizer[1]

plot!(compute_ODE((9.81, Cd); times=0:0.1:15), label="Simulated")

### Visual
for iteration in res.trace[1:10]
  Cd = iteration.metadata["x"][1]
  pl = scatter(time, exp_disp, label="Experiment", xlabel="Time(s)", ylabel="Displacement (m)")
  plot!(pl, compute_ODE((9.81, Cd); times=0:0.1:15), label="Simulated (Cd: $Cd")
  display(pl)
  sleep(1.0)
end


