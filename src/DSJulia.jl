module DSJulia
    include("grading.jl")
    export check_answer, still_missing, keep_working, correct, not_defined, hint, fyi  
    export ProgressTracker, grade
    export Question, validate
end