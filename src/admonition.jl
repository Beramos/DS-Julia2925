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

still_missing(text=md"Replace `missing` with your answer.") = MD(Admonition("warning", "Here we go!", [text]))

hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

keep_working(text=md"The answer is not quite right.") = MD(Admonition("danger", "Keep working on it!", [text]))

yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!",
        md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!",
				md"Let's move on to the next section."]
				
correct(text=rand(yays)) = MD(Admonition("correct", "Got it!", [text]))

not_defined(variable_name) = MD(Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

fyi(text) = Markdown.MD(
	Markdown.Admonition("info",
		"Additional info",
		[html"""
			<style> pluto-output div.admonition.info .admonition-title {
						background: rgb(161, 161, 161);
					} 

					pluto-output div.admonition.info {
						background: rgba(161, 161, 161, 0.2);
						border: 5px solid rgb(161, 161, 161);
					}
			</style>
		""",
			text
		]
	)
)

bomb(text) = Markdown.MD(
	Markdown.Admonition("bomb",
		"Self destruct warning",
		[html"""
			<style> pluto-output div.admonition.bomb .admonition-title {
						background: rgb(226, 157, 148);
						animation:blinkingBox 1.5s infinite;
					} 

					pluto-output div.admonition.bomb {
						background: rgba(226, 157, 148, 0.2);
						border: 5px solid rgb(226, 157, 148);
						animation:blinkingBox 1.5s infinite;
					}

			@keyframes blinkingBox{
				0%{     visibility: hidden;    }
				30%{    visibility: hidden; }
				31%{    visibility: visible; }
				99%{    visibility: visible;  }
				100%{   visibility: hidden;     }
			}
			</style>
		""",
			text
		]
	)
)
