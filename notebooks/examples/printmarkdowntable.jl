#=
Created on 09/01/2021 12:41:34
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Inputs a matrix and a list with headers and prints a table in markdown
format. Automatically copies this to the clipboard using the `clipboard` function/
=#


table = rand(1:10, 8, 4)
header = ["A", "B", "C", "D"]

function markdowntable(table, header)
    n, m = size(table)
    table_string = ""
    # add header
    table_string *= "| " * join(header, " | ") * " |\n"
    # horizontal lines for separating the columns
    table_string *= "| " * repeat(":--|", m) * "\n"
    for i in 1:n
        table_string *= "| " * join(table[i,:], " | ") * " |\n"
    end
    clipboard(table_string)
    return table_string
end

markdowntable(table, header)


