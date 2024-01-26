# Extreme bar crawl

**tags:** *REST API, optimisation, geographical, traveling salesperson, Ghent*

![project image](../img/pubCrawlImpression.png)
*An AIrtist impression of an algorithmically-optimised bar crawl.*

## 1. Abstract
Day 3 of the Julia doctoral schools is actually a cover to explore some of Ghent’s amazing bars. An efficient algorithm will be developed for computing the ideal bar crawl route, starting at the closest available rental bicycle. Using optimization techniques and real-time API data, the goal is to enhance the overall bar crawl experience by minimizing travel time. [Ghent's Open Data Portal](https://data.stad.gent/) will be used to obtain an up-to-date overview of the bars and real-time availability of bicycles in a [bicycle-sharing system](https://en.wikipedia.org/wiki/Bicycle-sharing_system).

## 2. Background

**RESTful API:**

A RESTful API is like a set of rules that helps different web applications talk to each other. It treats things, like users or posts, as resources and uses standard methods (GET, POST, PUT, DELETE) for actions. APIs enable efficient access to data, offering real-time updates and better security through authentication. APIs allow selective access to specific data in contrast to downloading entire files.

**Bar crawls:**

A bar crawl is a social activity where a group of people moves from one bar to another. The goal is to explore various establishments, enjoy the atmosphere, and have a good time with friends. Bar crawls are often organized for special occasions like birthdays, bachelor or bachelorette parties, or during doctoral schools. Participants may follow a planned route or spontaneously choose bars along the way, creating a dynamic and lively experience as they hop from one location to another.

**Travelling salesperson problem:**

The Traveling Salesperson Problem (TSP) is a classic optimization problem aiming to find the shortest route that visits each location exactly once while returning to the starting point. 

The TSP is an NP-hard problem, meaning that there is no known polynomial-time algorithm that can solve it for all possible inputs. As the number of location increases, the number of possible routes grows factorially, making it computationally infeasible to check all possible solutions for large instances.

Several approaches and algorithms have been proposed to tackle the TSP. It's important to note that the choice of algorithm depends on factors such as the size of the problem instance, the desired level of optimality and the available computational resources. In practice, heuristic and approximation algorithms are often employed for large-scale TSP instances. 

## 3. Assignments

1. Retrieve information about bars in Ghent from [Ghent’s data portal](https://data.stad.gent/explore/dataset/cafes-gent/). The API is [documented](https://data.stad.gent/explore/dataset/cafes-gent/api/), and [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl) can be employed to call the API endpoint. Note that the default number of bars returned per request is 20. The `offset`-parameter is utilized to request the next set of records. To fetch all records in the database, multiple API calls need to be made with an increasing offset until all records have been retrieved.

2. Create a map of the bars and the faculty. This snippet constructs a [Plots.jl](https://docs.juliaplots.org) plot with the background map and streets of Ghent **(TODO)**.

3. Optimize the bar crawl starting at and returning to the Faculty (*latitude:* 51.0529, *longitude:* 3.7093) by determining the distance (bird's-eye distance) to visit all bars and return to the faculty. This is a Salesman Problem (TSP), making it impossible to find an exact solution for a large number of bars. Some subtasks are defined to get you started, 

   **An exact solution (brute-force):**

   It is possible to compute the optimal sequence of bars by computing the distance for all possible routes. This is only possible for a small subset of bars.

   - Develop a program to estimate the computationally feasible number of bars for which an exact solution can be computed.
   - Sort the bars by distance to the faculty
   - Lastly, based on the feasible number of bars in the barcrawl (*X*) compute the optimal route to visit the *X*-closest bars, and visualize this route on the map.
   
    **\[Optional\] An approximate solution:**

    The number of bars in the barcrawl can increase considerably when stepping away from exact solutions. Several approaches can be applied with a varying degree of optimality:
    Nearest Neighbor Algorithm: This algorithm starts at a randomly chosen city and selects the nearest unvisited city at each step. While simple and fast, it may not always yield an optimal solution.

    - Try to find the most optimal route to visit all bars in Ghent starting from and returning to the faculty.

4. **Why are you walking?**   
   When time is of concern (... and it is!), the time spend between bars should be minimised. Luckily there are plenty of mobility solutions in Ghent. Create an application that, starting from a specified location (e.g. the faculty), finds the closest public bicycle, computes the optimal barcrawl route of a specified number of bars, given that the bicycle needs to be returned to the starting location. Ghent's data portal has an API endpoint to find available [“BAQME bicycles”](https://data.stad.gent/api/explore/v2.1/catalog/datasets/baqme-locaties-vrije-deelfietsen-gent/records?).

## 4. Resources
- DrWatson.js - Introduction ([source](https://juliadynamics.github.io/DrWatson.jl/dev/))
- Julia documentation ([source](https://docs.julialang.org/en/v1/))
- (**TODO**)
