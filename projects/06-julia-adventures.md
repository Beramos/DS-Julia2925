A pool of small, ~1-hour projects. The rhythm for each is the same: skim the linked docs, run the canonical example until it works, then build a not-too-tricky variant of your own.

> **Assignment: pick _two_ adventures that interest you.** For each, reproduce the example and build a variant. Be ready to show both at the wrap-up — a plot, a number, or a one-line "here's what surprised me" is plenty.

---

# A KERMIT logo in Luxor.jl

**tags:** *vector graphics, turtle graphics, creative coding*

![project image](https://kermit.ugent.be/images/KERMIT_cold.png)

## 1. Abstract

Luxor.jl draws 2D vector graphics from a sequence of simple, readable commands (`circle`, `poly`, `sethue`, `text`) and saves the result as PNG or SVG. In this adventure you design a small logo from primitives — a gentle, visual way into the language that ends with something you can actually share.

## 2. Background

Luxor is thoroughly procedural: you open a `Drawing`, move the origin to the centre with `origin()`, issue drawing commands, and `finish()`. The official quickstart walks through designing a logo for a fictional organisation out of coloured circles in a spiral, which is enough to understand the coordinate system and how shapes stack.

## 3. Assignments

1. Work through the [quickstart "design a logo" tutorial](https://juliagraphics.github.io/Luxor.jl/stable/tutorial/quickstart/) until you can produce and save your own drawing.
2. Study how the real three-disc Julia logo is built from primitives on the [examples page](https://juliagraphics.github.io/Luxor.jl/stable/example/examples/).
3. Recreate the [KERMIT group logo](https://kermit.ugent.be/images/KERMIT_cold.png) (or your own initials / a small emblem) from `circle`, `poly`, and `text`.
4. **Bonus:** bind one parameter — a hue, a rotation angle, the number of shapes — to a Pluto `@bind` slider so the logo updates live.

## 4. Resources
- Luxor.jl documentation ([source](https://juliagraphics.github.io/Luxor.jl/stable/))
- DrWatson.jl - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# A strange attractor with DifferentialEquations.jl

**tags:** *ODEs, chaos, dynamical systems*


## 1. Abstract

Some simple, deterministic systems of ODEs never settle down — instead their trajectory traces out an intricate "strange attractor". In this adventure you solve such a system and plot the result, then swap in a different attractor by editing only the equations.

## 2. Background

DifferentialEquations.jl works by defining a right-hand side `f(du, u, p, t)`, wrapping it in an `ODEProblem` with an initial condition and time span, and calling `solve`. The Lorenz system is the canonical chaotic example; with the standard parameters it produces the famous butterfly shape.

## 3. Assignments

1. Reproduce the Lorenz attractor using this [line-by-line walkthrough](https://tng-daryl.medium.com/visualizing-the-lorenz-attractor-in-julia-c9417f219e9b): build the RHS, solve, and make a 3D plot.
2. Colour the trajectory by time (or speed) for a prettier figure.
3. Swap *only* the right-hand side for another attractor — the [Rössler attractor](https://en.wikipedia.org/wiki/R%C3%B6ssler_attractor) (simpler, one manifold) or [Thomas' cyclically symmetric attractor](https://en.wikipedia.org/wiki/Thomas%27_cyclically_symmetric_attractor) (elegant, `sin`-coupled). The defining equations are on those Wikipedia pages, and [this blog](https://gereshes.com/2020/01/13/attracted-to-attractors/) shows all three side by side.
4. Vary a single parameter and watch how drastically the shape changes.

## 4. Resources
- DifferentialEquations.jl documentation ([source](https://docs.sciml.ai/DiffEqDocs/stable/))
- DrWatson.jl - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# Optimization I: test functions with Optim.jl

**tags:** *optimization, numerical methods*


## 1. Abstract

Optim.jl minimises a function you hand it as a black box. Different algorithms — gradient-free versus gradient-based — take very different paths to the minimum, and on tricky landscapes they can even end up in different places. This adventure builds intuition for that.

## 2. Background

The classic test problem is the Rosenbrock function, a narrow curved valley that is easy to define but awkward to minimise. Optim lets you call `optimize(f, x0, method)` with methods like `NelderMead()` or `BFGS()` and reports the minimiser, the minimum, and diagnostics such as the number of iterations.

## 3. Assignments

1. Run the [Rosenbrock minimization example](https://julianlsolvers.github.io/Optim.jl/stable/user/minimization/) with Nelder–Mead and then BFGS, and compare the iteration counts.
2. Minimise **Himmelblau's function**, which has *four* equally-good global minima — run from several starting points and tabulate which minimum each one converges to.
3. Minimise **Beale's function** (a narrow curved valley) as a second stress test. Formulas for both are on the [test-functions page](https://en.wikipedia.org/wiki/Test_functions_for_optimization).
4. **Bonus:** draw a contour plot of one landscape and overlay the optimiser's trajectory.

## 4. Resources
- Optim.jl documentation ([source](https://julianlsolvers.github.io/Optim.jl/stable/))
- DrWatson.jl - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# Optimization II: the dessert problem with JuMP.jl

**tags:** *linear programming, optimal transport*


## 1. Abstract

JuMP is an algebraic modelling language: you *declare* variables, an objective, and constraints, and a solver does the rest. The **transportation problem** — moving supply to demand as cheaply as possible — is the discrete cousin of optimal transport (the Monge–Kantorovich LP). Here you solve a tasty instance of it.

## 2. Background

The transportation problem: origins $i \in O$ have supplies $s_i$, destinations $j \in D$ have demands $d_j$, and shipping one unit from $i$ to $j$ costs $c_{ij}$. Choose $x_{ij} \ge 0$ to

$$
\min_{x \ge 0} \sum_{i,j} c_{ij}\, x_{ij}
\quad\text{s.t.}\quad
\sum_{j} x_{ij} \le s_i \;\;\forall i,
\qquad
\sum_{i} x_{ij} = d_j \;\;\forall j .
$$

This is exactly the structure of the **dessert problem** from [this blog post](https://michielstock.github.io/posts/2017/2017-11-5-OptimalTransport/): a number of desserts must be divided among teaching staff according to their preferences. The preference matrix becomes a cost matrix (flip the sign), the amount each person eats and the amount available of each dessert become the demand and supply marginals, and the optimal assignment is the transport plan.

## 3. Assignments

1. Run the [JuMP transportation tutorial](https://jump.dev/JuMP.jl/stable/tutorials/linear/transp/) to learn `@variable`, `@constraint`, `@objective`, and `optimize!`.
2. Set up the **dessert problem** from the blog as an LP in JuMP: build the cost matrix from the preferences, use the marginals as supply and demand, and minimise total cost.
3. Inspect the optimal plan — who gets which desserts, and how much.
4. Perturb the problem: change someone's preferences (e.g. make a colleague lactose intolerant), or make supply and demand unbalanced, and watch the plan reroute. **Bonus:** compare your exact LP solution with the entropy-regularised (Sinkhorn) solution from the blog post.

## 4. Resources
- "Notes on Optimal Transport" — the dessert problem ([source](https://michielstock.github.io/posts/2017/2017-11-5-OptimalTransport/))
- JuMP.jl introduction ([source](https://jump.dev/JuMP.jl/stable/))
- DrWatson.jl - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# Emergence with Agents.jl

**tags:** *agent-based modelling, emergence*


## 1. Abstract

Simple local rules can produce surprising global behaviour. Schelling's segregation model shows how a *mild* preference for similar neighbours can still drive a population into total segregation — a textbook case of emergence you can simulate in an hour.

## 2. Background

Agents.jl structures a model around an agent type (defined with the `@agent` macro), a space (here a 2D grid), and a stepping function `agent_step!` that encodes each agent's rule. The Schelling model: unhappy agents (too few same-group neighbours) keep relocating until they are happy.

## 3. Assignments

1. Work through the [main Agents.jl tutorial](https://juliadynamics.github.io/Agents.jl/stable/tutorial/), built around Schelling — there's a fast copy-pasteable version if you want a running model in minutes.
2. Run it, step the model, and visualise the grid segregating.
3. Change a rule without touching the scaffolding: raise the happiness threshold, add a third group, or widen the neighbourhood.
4. **Bonus:** pick a different model from the [examples zoo](https://juliadynamics.github.io/Agents.jl/stable/) (forest fire, flocking/boids).

## 4. Resources
- Agents.jl documentation ([source](https://juliadynamics.github.io/Agents.jl/stable/))
- DrWatson.jl - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# A real ecological network with Graphs.jl + GraphMakie

**tags:** *networks, ecology, centrality*


## 1. Abstract

Load a network, ask which nodes are most important, and draw it. In this adventure you do it with a real, published ecological network rather than a toy graph, and read off something biologically meaningful.

## 2. Background

Graphs.jl provides a uniform API across graph types: `degree`, `betweenness_centrality`, shortest paths, and more, all called the same way regardless of where the graph came from. GraphMakie renders them. Starting on a small built-in graph lets you learn the API before pointing it at real data.

## 3. Assignments

1. Learn the API on the built-in Zachary karate club graph (`smallgraph(:karate)`): compute `degree` and `betweenness_centrality` using the [centrality page](https://juliagraphs.org/Graphs.jl/stable/algorithms/centrality/) and plot it with the [plotting guide](https://juliagraphs.org/Graphs.jl/stable/first_steps/plotting/).
2. Browse the [**Web of Life** database](https://www.web-of-life.es/) (Bascompte lab), pick a network — e.g. a plant–pollinator one — and download its interaction matrix / edge list as CSV.
3. Load it into Graphs.jl, compute the centralities, and colour the nodes by centrality with GraphMakie. For a bipartite pollination network, colour plants and pollinators differently.
4. **Bonus:** remove the highest-degree species and watch how the network fragments.

## 4. Resources
- Graphs.jl documentation ([source](https://juliagraphs.org/Graphs.jl/stable/))
- GraphMakie.jl ([source](https://github.com/MakieOrg/GraphMakie.jl))
- Web of Life — ecological networks database ([source](https://www.web-of-life.es/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# The seven scientists with Turing.jl

**tags:** *Bayesian inference, probabilistic programming, hierarchical models*

## 1. Abstract

Seven scientists each measure the same quantity, but they have different lab skills — so each measurement carries its own *unknown* noise level (the data are heteroscedastic). What is the posterior distribution of the true value? The lovely part: a good Bayesian model automatically distrusts the wildly-off measurement instead of letting it ruin the estimate.

## 2. Background

The measurements are:

| Scientist | $x_n$    |
|-----------|----------|
| A         | −27.020  |
| B         |   3.570  |
| C         |   8.191  |
| D         |   9.898  |
| E         |   9.603  |
| F         |   9.945  |
| G         |  10.056  |

We model a shared true value $\mu$, give each scientist their own variance $\sigma^2_i$, and let the data infer who was precise and who was not. Scientist A's −27 doesn't drag $\mu$ down: the model simply concludes A has a large $\sigma^2$ and down-weights them — robust inference with no hand-coded outlier rule.

```julia
using Turing

x = [-27.020, 3.570, 8.191, 9.898, 9.603, 9.945, 10.056]

@model function measurement(x)
    n = length(x)
    σ²_μ ~ InverseGamma(10, 0.1)
    μ ~ Normal(0.0, √(σ²_μ))
    σ² = Vector(undef, n)
    for i in 1:n
        σ²[i] ~ InverseGamma(10, 0.1)
        x[i] ~ Normal(μ, √(σ²[i]))
    end
end
```

## 3. Assignments

1. Learn the `@model` syntax and `sample(model, NUTS(), ...)` on the [Turing coin-flipping tutorial](https://turinglang.org/docs/tutorials/coin-flipping/index.html).
2. Run the `measurement` model above on the seven measurements and plot the posterior of $\mu$.
3. Compare the posterior mean to the naive equal-weight average — see how badly the outlier corrupts the naive estimate.
4. Inspect the inferred $\sigma^2_i$ to confirm A (and B) are flagged as imprecise. **Bonus:** try the tiny dataset `[13.01, 7.39]`, and explore how the `InverseGamma` priors change the result.

## 4. Resources
- Turing.jl documentation ([source](https://turinglang.org/))
- This is MacKay, *Information Theory, Inference, and Learning Algorithms* (2003), Exercise 22.15 / 24.3; a worked Bayesian solution ([source](https://jem-mosig.com/2021/03/seven-scientists/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))

---

# Image filtering with Images.jl + ImageFiltering.jl

**tags:** *images, convolution, arrays*


## 1. Abstract

An image is just an array of coloured numbers, so filtering it is array arithmetic. This adventure runs a couple of standard filters and then builds an edge detector — and connects straight back to the day-1 images-and-cellular-automata material.

## 2. Background

In JuliaImages, an image is an array of colour values. `imfilter(img, kernel)` convolves it with a kernel; the `Kernel` module provides ready-made ones (`gaussian`, `Laplacian`, `sobel`). Building a Sobel filter by hand and then comparing it to the built-in one is a satisfying way to see what convolution actually does.

## 3. Assignments

1. Run the [ImageFiltering quickstart](https://juliaimages.org/ImageFiltering.jl/stable/): load a test image and apply `imfilter(img, Kernel.gaussian(3))` and a Laplacian.
2. Build edge detection — [this walkthrough](https://learningjulia.com/2017/03/09/imfilter-and-arrays.html) writes a [Sobel](https://en.wikipedia.org/wiki/Sobel_operator) filter by hand, then shows `Kernel.sobel` does it for free.
3. Chain a different effect (sharpen, emboss, threshold) or try crude colour-based segmentation.
4. **Bonus:** run it on a photo of your own.

## 4. Resources
- JuliaImages documentation ([source](https://juliaimages.org/stable/))
- ImageFiltering.jl ([source](https://juliaimages.org/ImageFiltering.jl/stable/))
- DrWatson.jl - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))
