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
      include(joinpath(root,file))
      println("Found solution file: $file")
    end
  end
end