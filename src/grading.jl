#=
Created on Friday 4 December 2020
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

@author: Bram De Jaegher
bram.de.jaegher@gmail.com

Automatic grading of answers in our Pluto notebook.
Templates heavily based on the MIT course "Computational Thinking"

https://computationalthinking.mit.edu/Fall20/installation/
=#

using Markdown
using Markdown: MD, Admonition

struct QuestionTracker 
	correct::Int
	total::Int
	QuestionTracker() = new(0, 0)
end

addQuestion!(t::QuestionTracker) = t.total += 1
accept!(t::QuestionTracker) =	t.correct += 1


# --- Admonition options --- #
still_missing(text=MD("Replace `missing` with your answer.")) = MD(Admonition("warning", "Here we go!", [text]))

keep_working(text=MD("The answer is not quite right.")) = MD(Admonition("danger", "Keep working on it!", [text]))

yays = [MD("Great!"), MD("Yay ❤"), MD("Great! 🎉"), MD("Well done!"),
        MD("Keep it up!"), MD("Good job!"), MD("Awesome!"), MD("You got the right answer!"),
				MD("Let's move on to the next section.")]
				
correct(text=rand(yays)) = MD(Admonition("correct", "Got it!", [text]))

not_defined(variable_name) = MD(Admonition("danger", "Oopsie!", [MD("Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**")]))

# --- Autograder function --- #
""""
	Validates answer statements and updates question tracker
"""
function check_answer(statements..., t::QuestionTracker)
	addQuestion!(t)
	all_valid = all(statements)
	ismissing(all_valid) && return still_missing()
	some_valid = any(statements)
<<<<<<< HEAD
	some_valid && !all_valid && return keep_working(MD("You are not quite there, but getting warmer!"))
=======
	some_valid && !all_valid && return keep_working(MD"You are not quite there, but getting warmer!")
>>>>>>> 4fbeb89384fefd22c2348191a0a48b6da524ae86
	!all_valid && return keep_working()
	if all_valid 
		accept!(t)
		return correct()
	end 
end

""""
	Function to validate answers
"""
function check_answer(statements...)
	all_valid = all(statements)
	ismissing(all_valid) && return still_missing()
	some_valid = any(statements)
	some_valid && !all_valid && return keep_working(MD"You are not quite there, but getting warmer!")
	!all_valid && return keep_working()
	all_valid && return correct()
end

# --- Non-checking admonitions --- #
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



