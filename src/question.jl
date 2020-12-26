#=
Created on Saturday 26 December 2020
Last update: -

@author: Bram De Jaegher
bram.de.jaegher@gmail.com
=#

# --- Types --- #

abstract type AbstractQuestion end

mutable struct Question <: AbstractQuestion
	title::Markdown.MD
	description::Markdown.MD
	validators::Any
	opt_validators::Dict{String,Any}
	hints::Array{Markdown.MD}
	status::Markdown.MD
	opt_statuses::Dict{String, Markdown.MD}

	Question(;title=title_default,
						description=description_default,
						validators=[missing],
						opt_validators=Dict{String,Array{Markdown.MD}}(),
						hints = Markdown.MD[]) = return new(title, 
																				description, 
																				validators, 
																				opt_validators, 
																				hints, 
																				still_missing(),
																				Dict(key=>still_missing() for (key, value) in opt_validators))
end

# --- Rendering --- # 
Base.show(io::IO, ::MIME"text/html", q::AbstractQuestion) = print(io::IO, tohtml(q))

function tohtml(q::Question)
	
	hint_string = ""
	if length(q.hints) > 0
		hint_string = "<br> <p><b>Hints:</b></p>"
		for hint in q.hints
			hint_string *= "<p>" * html(hint) * "</p>"
		end
	end

	state_string = "<p> $(html(q.status)) </p>"

	opt_state_string = ""
	if !isempty(q.opt_statuses)
		for (difficulty, status) in q.opt_statuses
			opt_state_string *= "<p> <b> Optional ($difficulty): </b> </p> <p> $(html(status)) </p>"
		end
	end

	out = """
		<div class="question">
			$(html(q.title))
			<p> $(html(q.description)) </p>
			$state_string
			$opt_state_string
			$hint_string
		</div>
		<style>
			div.question {
				padding-left: 20px;
				padding-right: 20px;
				padding-top: 10px;
				padding-bottom: 10px;
				border: 3px dotted lightgrey;
				border-radius: 15px;
				background: #F8F8F8;
			}
			</style>			
	"""
	return out
end


# --- Defaults --- #
title_default = Markdown.MD(md"### Question 0.: /insert title here/")
description_default = Markdown.MD(md"""Complete the function `myclamp(x)` that clamps a number `x` between 0 and 1.
Open assignments always return `missing`.
""")


# --- Macro(s) --- #
"""
The @safe macro is a hidden try-catch statement to avoid the Markdown admonitions to crash when
the user introduces an error in the exercise functions.

Usage:
-----
@safe test_func(input) == correct_output
@safe[test_func1(input) == correct_output1, test_func2(input) == correct_output2]

"""
macro safe(ex)
	safe_ex = quote
		try $(esc(ex))
		catch e 
			false
		end
	end
	return safe_ex
end

# --- Validation --- #
function check_answer(validators)
	all_valid = all(validators)
	some_valid = any(validators)
	if ismissing(all_valid) 
		status = still_missing()
	elseif some_valid && !all_valid
		status = keep_working()
	elseif !all_valid
		status = keep_working()
	elseif all_valid 
		status = correct()
	end
	return status
end

function validate(q::AbstractQuestion)
	q.status = check_answer(q.validators)
	
	for (key, status) in q.opt_statuses
		q.opt_statuses[key] = check_answer(q.opt_validators[key])
	end
	return q
end
