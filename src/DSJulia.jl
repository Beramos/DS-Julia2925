#=
Created on Friday 4 December 2020
Last update: Saturday 26 December 2020

@author: Michiel Stock
michielfmstock@gmail.com

@author: Bram De Jaegher
bram.de.jaegher@gmail.com

Templates heavily based on the MIT course "Computational Thinking"

https://computationalthinking.mit.edu/Fall20/installation/
=#

module DSJulia
    using Markdown
    using Markdown: MD, Admonition

    export check_answer, still_missing, keep_working, correct, not_defined, hint, fyi  
    export ProgressTracker, grade
    export Question, validate
    export @safe

    include("styles.jl")
    include("admonition.jl")
    include("question.jl")
    include("grading.jl")
end