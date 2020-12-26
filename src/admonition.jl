#=
Created on Saturday 26 December 2020
Last update: -

@author: Bram De Jaegher
bram.de.jaegher@gmail.com

@author: Michiel Stock
michielfmstock@gmail.com

Templates heavily based on the MIT course "Computational Thinking"

https://computationalthinking.mit.edu/Fall20/installation/
=#


correct(text=rand(yays)) = MD(Admonition("correct", "Got it!", [text]))
keep_working(text=md"The answer is not quite right.") = MD(Admonition("danger", "Keep working on it!", [text]))			
not_defined(variable_name) = MD(Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!",
        md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!",
				md"Let's move on to the next section."]
				
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))
still_missing(text=md"Replace `missing` with your answer.") = MD(Admonition("warning", "Here we go!", [text]))

fyi(text) = Markdown.MD(
	Markdown.Admonition("info",
		"Additional info",
		[fyi_css,
			text
		]
	)
)

bomb(text) = Markdown.MD(
	Markdown.Admonition("bomb",
		"Self destruct warning",
		[bomb_css,
			text
		]
	)
)
