using DSJulia

pn = "../submissions/Day1/Basic/"

fns = readdir(pn)

trackers = []
for fn in fns
  tracker = grade(pn*fn)
  push!(trackers, tracker)
end

trackers