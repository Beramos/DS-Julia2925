# Download the café dataset
using HTTP, JSON
const URL_BAR = "https://data.stad.gent/api/explore/v2.1/catalog/datasets/cafes-gent/records"

resp_bar = HTTP.get(URL_BAR).body |> String |> JSON.parse

# Plotting
## Strip name, extract geometry
dict_geo = [
        Dict("name" => entry["name_en"],"geo" => entry["geo_point_2d"]
    )  for entry in resp_bar["results"]
]


## Actually Plotting
using Plots
println(resp_bar)


function plot9000(;URL_MAP = "https://github.com/blackmad/neighborhoods/blob/master/ghent.geojson")
    resp = HTTP.get(URL_MAP).body |> String |> JSON.parse
    map_json = resp["payload"]["blob"]["rawLines"][1] |> JSON.parse
    coords = map(nb -> nb["geometry"]["coordinates"] |> first |> first, map_json["features"])
    shapes = map(coord -> Shape(coord .|> first, coord .|> last), coords)
end

function plot_roads(;offsets=30, limit=100, URL_MAP = "https://data.stad.gent/api/explore/v2.1/catalog/datasets/straten-gent/records?")
    coords = []
    for offset in 1:limit:offsets*limit
        resp = HTTP.get(URL_MAP * "limit=$limit&offset=$offset").body |> String |> JSON.parse
        sleep(0.01)
        for road in resp["results"]
            geom = road["geometry"]["geometry"]
            if geom["type"] == "LineString"
                push!(coords, geom["coordinates"])
            else
                push!(coords, reduce(vcat, geom["coordinates"]))
            end
        end
    end
    return coords
end

coords = plot9000()
roads = plot_roads()


pl = plot(coords, color="#E5E9F0",label="", lw=0, axis=nothing, border=:none)
for road in roads
    plot!(road .|> first, road .|> last, color="#4C566A", alpha=0.5, label="")
end

display(pl)


#D8DEE9