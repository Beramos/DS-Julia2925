#=
Created on Monday 18th of January 2021
Last update: -

@author: Bram De Jaegher
bram.de.jaegher@gmail.com
=#

## Day 1
### Clipping

function clip(x)
  if x ≤ 0 && return 0  
  elseif x ≥ 1 && return 1  
  return x
end