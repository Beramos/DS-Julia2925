#=
Created on 09/01/2021 15:00:09
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Implement the information entropy:
$$
H(p) = -\sum_i p_i \log p_i\,,
$$

Take caution that, by definition,$0 \log 0$ is evaluated as 0 (i.e., its limit value).

Have an optional flag to specify the bag of log, default is base 2, making the output in bits.

Make a plot of the entropy of a Bernouilli-distributed variable for varying probability of success
$p$, i.e., the entropy of probability vector $[p, 1-p]$ for $p\in [0, 1]$.
=#

using Plots

entropy(p; base=2) = p .|> (pᵢ -> pᵢ > 0.0 ? -pᵢ * log(pᵢ) : 0.0) |> sum |> (H -> H / log(base))

entropy([0, 1, 0])  # 0.0
entropy([0.5, 0.5])  # 1.0
entropy([0.5, 0.5], base=10)  # 0.30102999566398114

plot(p->entropy((p, 1-p)), 0, 1, xlabel="p", label="entropy")
