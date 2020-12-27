
#=
Created on Saturday 26 December 2020
Last update: -

@author: Bram De Jaegher
bram.de.jaegher@gmail.com
=#

# --- Types --- #

abstract type AbstractQuestion end
abstract type AbstractDifficulty end
abstract type AbstractQuestionBlock end
struct NoDiff <: AbstractDifficulty end
struct Easy <: AbstractDifficulty end
struct Intermediate <: AbstractDifficulty end
struct Hard <: AbstractDifficulty end

mutable struct Question <: AbstractQuestion
	description::Markdown.MD
	validators::Any
	status::Markdown.MD
	Question(;description=description_default, 
						validators=[missing], 
						status=still_missing()) = new(description, validators, status)
end

mutable struct QuestionOptional{T<:AbstractDifficulty}  <: AbstractQuestion 
	description::Markdown.MD
	validators::Any
	status::Markdown.MD
	difficulty::T
	QuestionOptional{T}(;description=description_default, 
						validators=[missing], 
						status=still_missing()) where {T<:AbstractDifficulty} = new{T}(description, validators, status, T())
end


mutable struct QuestionBlock <: AbstractQuestionBlock
	title::Markdown.MD
	description::Markdown.MD
	hints::Array{Markdown.MD}
	questions::Array{T} where {T<:AbstractQuestion}

	QuestionBlock(;title=title_default,
									description=md"",
									hints = Markdown.MD[],
									questions = [Question()]) = new(title, description, hints, questions) 
end

# --- Rendering --- # 
Base.show(io::IO, ::MIME"text/html", q::AbstractQuestionBlock) = print(io::IO, tohtml(q))

function tohtml(q::QuestionBlock)
	
	hint_string = ""
	if length(q.hints) > 0
		hint_string = "<br> <p><b>Hints:</b></p>"
		for hint in q.hints
			hint_string *= "<p>" * html(hint) * "</p>"
		end
	end

	
	state_string = "<p> $(html(q.questions[1].status)) </p>"
	if q.questions[1].description !== ""
		state_string = "<p> $(html(q.questions[1].description)) </p>" * state_string
	end

	opt_state_string = ""
	if length(q.questions) > 1
		for opt_question in q.questions[2:end]
			if opt_question.difficulty !== ""
			opt_state_string *= "<p> <b> Optional ($(split(string(typeof(opt_question.difficulty), "."))[2])): </b> </p>"
			else
			opt_state_string *= "<p> <b> Optional: </b> </p>"
			end
			if opt_question.description !== ""
				opt_state_string *= "<p> $(html(opt_question.description)) </p>"
			end
			opt_state_string *= "<p> $(html(opt_question.status)) </p>"
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
		$question_css		
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

function validate(q::QuestionBlock)
	q.questions[1].status = check_answer(q.questions[1].validators)
	
	if length(q.questions) > 1
		for (index, opt_question) in enumerate(q.questions[2:end])
			q.questions[index+1].status = check_answer(opt_question.validators)
		end
	end
	return q
end
