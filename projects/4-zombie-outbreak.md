# Modelling a zombie outbreak

**tags:** *zombies, modeling, simulation, SIR, agent-based models*

![project image](../img/apocalyps-daniel-lincoln-unsplash.jpg)

## 1. Abstract

*The globe is on the brink of a looming catastrophe. A virus broke out from a laboratory and is transforming humans into zombies! Nations are closing down borders, flights are canceled, and pandemonium is rapidly engulfing the entire world…*

This project explores an agent-based model (ABM) designed to simulate a zombie outbreak. Participants will gain proficiency in utilizing advanced simulation software by customizing it based on provided examples. DrWatson will be employed to store diverse simulation outcomes, and participants will be tasked with composing source code for fundamental components. The underlying model is a modified version of a SIR model.

## 2. Background

The Susceptible-Infectious-Recovered (SIR) model is a compartmental model commonly used in epidemiology to describe the spread of infectious diseases within a population. Susceptible, Infected, and Recovered represent the three main compartments of individuals in the population.

1. **Susceptible (S):** This group includes individuals susceptible to the infectious agent but have not yet been infected. The entire population is usually considered susceptible at the beginning of an outbreak.
1. **Infected (I):** This group comprises individuals currently infected with the infectious agent and can transmit it to susceptible individuals.
1. **Recovered (R):** This group includes individuals who have recovered from the infection and are assumed to have acquired immunity. Once an individual recovers, they move from the Infected compartment to the Recovered compartment.

Often, the SIR model considers a population as a whole, and the main compartments are simulated for the entire population; there is usually no spatial context. However, adding a spatial component introduces a lot of learning opportunities.  

To represent a zombie outbreak as an SIR problem, you can adapt the SIR model to incorporate the dynamics of a zombie scenario. Here's a simplified version:

1. **Susceptible (S):** Individuals who are alive and not yet infected by the zombie virus also known as *“humans”*.
1. **Infected (I):** Individuals who have succumbed to the zombie virus, also known as *“zombies”*.

## 3. Assignments

1. Get yourself familiar with agent-based modeling using [Agents.jl](https://juliadynamics.github.io/Agents.jl) by following [the tutorial](https://juliadynamics.github.io/Agents.jl/stable/tutorial/). It might help also to watch [this tutorial video](https://youtu.be/fgwAfAa4kt0) (YouTube).  
   
2. These examples involve using a fixed grid ([Gridspace](https://juliadynamics.github.io/Agents.jl/stable/api/#Discrete-spaces-1)). Modeling a zombie apocalypse is boring if nobody can move. Develop your SIR model using a [Continuous space](https://juliadynamics.github.io/Agents.jl/stable/api/#Continuous-spaces-1). One can take a look at the [other examples](https://juliadynamics.github.io/AgentsExampleZoo.jl/dev/examples/social_distancing/#Adding-Virus-spread-(SIR)) for inspiration.
   
3. To simplify, start by implementing the movement of the *zombies* and s*usceptibles.
   * Write a function `compute_velocity` which updates the velocity of *zombies* and *susceptibles.
   * For *zombies* the following steps should be included;

4. Initialise a simulation with 1000 individuals: 9990 susceptible and ten infected individuals. [This example](https://juliadynamics.github.io/AgentsExampleZoo.jl/dev/examples/social_distancing/#Adding-Virus-spread-(SIR)) can show an interesting intialisation setting. Run a simulation to see if everything is working as expected.
   
5. Model the spread of the zombie virus. When a zombie is close to a susceptible, there is a 60% chance of transmission (β), so that *susceptibles* can now become *zombies*.

6. Run a couple of simulations and visualise the effect of (β).

7. *Play around!* Here are some fun scenarios to implement;
   
   - Add [elastic collisions](https://juliadynamics.github.io/AgentsExampleZoo.jl/dev/examples/social_distancing/#Billiard-like-interaction) between agents.
   - Play around with the initial speed of the agents, e.g. sample the speed from distributions or give the *zombies* and *susceptibles* different speed characteristics.
   - Add **Hunters (H):** Individuals that are also **Susceptible (S)** but can kill a zombies within a certain range.
   - Add **Corpses (C):** Dead immobile humans/zombies, which can still cause collisions and limit movement.
   - Add a vision radius: zombies can only see *susceptibles* within a given range.


## 4. Resources

Julia packages:

- [Agents.jl Example zoo](https://juliadynamics.github.io/AgentsExampleZoo.jl/dev/): holds only examples of various models implemented in Agents.jl.
- [Agents.jl](https://juliadynamics.github.io/Agents.jl/stable/):  a pure [Julia](https://julialang.org/) framework for agent-based modeling (ABM): a computational simulation methodology where autonomous agents react to their environment (including other agents).