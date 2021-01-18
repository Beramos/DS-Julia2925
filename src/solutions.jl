#=
Created on Monday 18th of January 2021
Last update: -

@author: Bram De Jaegher
bram.de.jaegher@gmail.com
=#

# --- Solutions --- #
module Solutions
  for (root, dirs, files) in walkdir("../solutions")
    for file in files
      println("Found solution file: $file")
      include(joinpath(root,file))
    end
  end
end