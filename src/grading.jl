#=
Created on Friday 4 December 2020
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Automatic grading of answers in our Pluto notebook.
Templates heavily based on the MIT course "Computational Thinking"

https://computationalthinking.mit.edu/Fall20/installation/
=#

using Markdown

still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!",
        md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!",
        md"Let's move on to the next section."]

correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

fyi(text) = Markdown.MD(Markdown.Admonition("note", "For your information", [text]))

function check_answer(statements...)
	all_valid = all(statements)
	ismissing(all_valid) && return still_missing()
	some_valid = any(statements)
	some_valid && !all_valid && return keep_working(md"You are not quite there, but getting warmer!")
	!all_valid && return keep_working()
	all_valid && return correct()
end