# Modeling antibiotics treatment

**tags:** *antibiotics, ordinary differential equations, parameter estimation*

![project image](https://images.unsplash.com/photo-1596051827487-7b3d6f6df842?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)

## 1. Abstract

The discovery of antibiotics is one of the greatest medical advancements of the 20th century. In this project, we use a simple ordinary differential equation (ODE) system to model the effect of antibiotic dosing on a system containing susceptible and resistant bacteria. Bacteria grow with a simple completion model (susceptible bacteria grow faster due to the fitness cost associated with being resistant). Antibiotics can be added to the system. Higher concentrations kill bacteria more effectively, though antibiotics are quickly removed from the system. When choosing doses and dosing time, can we maximally reduce bacterial infection while limiting our total use?

## 2. Background

In this project, we will study the regime of treating a bacterial infection with antibiotics.

We assume there is an infection with susceptible (S) and resistant (R) bacteria. Both bacteria have a growth rate dependent on their total density:

$$\mu=r\left(1-\frac{S+R}{K}\right)$$

For resistant bacteria, there is a fitness cost $a$, meaning their growth rate is only $\mu\times(1-a)$.

Both bacteria die naturally, given by a first-order rate of $\theta$.

Antibiotics can also be present in the system at a concentration $C$. It decays at a constant rate $g$. Antibiotics kill bacteria with a dose-dependent rate of $A_S(C)$ and $A_R(C)$, respectively. For  $A_S(C)$ and $A_R(C)$ you can use these equations. See the paper cited below for the derivation.

```julia
Aₛ(c) = (2.5 + 2.1) * (c/16)^4 / ((c/16)^4 - (-2.1/2.5))

Aᵣ(c) = (2.5 + 2.1) * (c/32)^4 / ((c/32)^4 - (-2.1/2.5))
```


$$\frac{d S}{d t}=\underbrace{r S\left(1-\frac{S+R}{K}\right)-\theta S}_{\text {Natural Growth }}-\underbrace{\beta S R}_{\text {HGT }}-\underbrace{A_{S}(C) S}_{\text {AB Death }}$$ 
(1)

$$\frac{d R}{d t}=\underbrace{r R\left(1-\frac{S+R}{K}\right)(1-a)-\theta R}_{\text {Natural Growth }}+\underbrace{\beta S R}_{\text {HGT }}-\underbrace{A_{R}(C) R}_{\text {AB Death }}$$ 
(2)

$$\frac{d C}{d t}=\underbrace{\sum_{n=1}^{10} D_{n} \delta\left(t-\hat{t}_{n}\right)}_{\text {Antibiotic Doses }}-\underbrace{g C}_{\text {Degredation }}$$
(3)

The paper used the following objective function:

$$F = \underbrace{w_1\,\alpha_1\,\sum^{10}_{i=1}D_i}_{\text{Total Antibiotic}} + \underbrace{w_2\,\alpha_2\,\int^{30}_{0}N(t)\,dt}_{\text{Bacterial Load}}$$

## 3. Assignments

1. Implement the antibiotics dosing model using Catalyst. **Don’t implement the ODEs directly, instead, add all processes as reactions.** Ignore HGT. The part “antibiotic dosing” does not need to be implemented. This can be addressed by the solver. 
2. Convert your system into an ODE system. 
3. Perform a simulation! Start with the following initial conditions: `u₀map = [:S=>500, :R=>100, :C=>50.0]`. Use the paper to get some realistic parameter values. Simulate for 35 days and make a plot.
4. Try out `DiscreteProblem` and `JumpProblem` for stochastic versions.
5. Now use `PresetTimeCallback` to give antibiotics dosing on set time points. This requires making a function to give the solver’s callback to have the variable $C$ increase at set times (your dosing times) with a specific value (i.e. the dosis of antibiotics you add). Make a bunch of plots with different schemes. You can use DrWatson’s functionality to save these figures systematically.
6. Make a function that gives different dosing schemes and concentrations. Either use random sampling or optimization to minimize the bacterial load. Make a Pareto plot of the bacterial load vs total antibiotics used in your treatments.
7. Perform a sensitivity analysis of a parameter of your choice.

## 4. Resources

This work is based on the paper “*[Optimising Antibiotic Usage to Treat Bacterial Infections](https://www.nature.com/articles/srep37853)*”, which explains the model and lists sensible values for the parameters.


Julia packages:

- [Catalyst.jl](https://docs.sciml.ai/Catalyst/stable/introduction_to_catalyst/introduction_to_catalyst/): a modeling library for (bio)chemical reactions.
    - you might look at jump equations and stochastical chemical kinetics to account for the discrete nature of the bacteria
    - check the tab “Constraint Equations and Events” for event handling, i.e. dosing antibiotics at a set time
- Catalyst mainly uses DifferentialEquations.jl, you might check that out!
- For optimizing the dosis, you can use [Optimization.jl](https://github.com/SciML/Optimization.jl) or try a couple of thousand random scenarios.
- [SciMLSensitivity](https://docs.sciml.ai/SciMLSensitivity/stable/) can be used for a sensitivity analysis