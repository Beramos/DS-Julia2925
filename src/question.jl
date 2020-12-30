
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

"""
Defines a mandatory question.

# Arguments

- description (md_str): a markdown string to be displayed above the validators
- validators (Array{Bool}): an array of booleans with the tests the answer to the question should solve.
- status (md_str): a markdown string used to change/display the question state (correct, missing, incorrect).
	the default value is missing and should probably not be changed.
"""
mutable struct Question <: AbstractQuestion
	description::Markdown.MD
	validators::Any
	status::Markdown.MD

	Question(;description=description_default, 
						validators=[missing], 
						status=still_missing()) = new(description, validators, status)
end

"""
Defines an optional question.

# Arguments

- `description` (md_str): a markdown string to be displayed above the validators
- `validators` (Array{Bool}): an array of booleans with the tests the answer to the question should solve.
- `status` (md_str): a markdown string used to change/display the question state (correct, missing, incorrect).
	the default value is missing and should probably not be changed.

Difficulty types
------
- `T ∈ [NoDiff, Easy, Intermediate, Hard]` 
- At this point purely easthetic since the difficulty is only used as display
"""
mutable struct QuestionOptional{T<:AbstractDifficulty}  <: AbstractQuestion 
	description::Markdown.MD
	validators::Any
	status::Markdown.MD
	difficulty::T

	QuestionOptional{T}(;description=description_default, 
						validators=[missing], 
						status=still_missing()) where {T<:AbstractDifficulty} = new{T}(description, validators, status, T())
end

"""
Defines a Question block.

# Arguments
- `title` (md_str): a markdown string to be displayed as title
- `description` (md_str): the general descriptions, this is diplayed directly below the title.
- `hints` (Array{md_str}): an array of markdown strings for hint admonitions but this can me any markdown and will be displayed in the \"hints\" section.
- `questions` (Array{AbstractQuestion}): an array of questions. Currently exactly one mandatory question is expected but 0-∞ optional questions can be defined.

# Examples
```julia
q₁ = Question(;
	description=md\"\"\"
	Complete the function `myclamp(x)` that clamps a number `x` between 0 and 1.

	Open assignments always return `missing`. 
	\"\"\",
	validators= @safe[myclamp(-1)==0, myclamp(0.3)==0.3, myclamp(1.1)==1.0]
)

q₂ = QuestionOptional{Easy}(;
	description=md\"\"\"
	Try to make the clamping also work for arrays.
	\"\"\",
	validators= @safe[myclamp([2.0, 0.3])==[1.0, 0.3]]
)

q₃ = QuestionOptional{Intermediate}(;
	description=md\"\"\"
	This is an intermediate question. Surely you can complete this
	\"\"\",
	validators= @safe[true]
)

q₄ = QuestionOptional{Hard}(;
	description=md\"\"\"
	I admit, this one is definitely harder
	\"\"\",
	validators= @safe[false]
)


 qb = QuestionBlock(;
title=md"### Question 1.0: What a crazy exercise",
description=md\"\"\"
	Some additional general kind off description and all.
	Anything markdowny. Just make sure to use the triple accolades.
	
	\"\"\",
questions = [q₁, q₂, q₃, q₄],
hints=[	hint(md"Have you tried this?"),
		hint(md"Have you tried switching it on and off again?")]
);
```
"""
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
	
	N_mandatory = sum(isa.(q.questions,Question))
	state_string = ""
	for index in 1:N_mandatory
		state_string *= "<p> $(html(q.questions[index].status)) </p>"
		if q.questions[index].description !== ""
			state_string = "<p> $(html(q.questions[index].description)) </p>" * state_string
		end
	end

	opt_state_string = ""
	if length(q.questions) > 1
		for opt_question in q.questions[N_mandatory+1:end]
			if opt_question.difficulty !== ""
			opt_state_string *= "<p> <b> Optional ($(split(string(typeof(opt_question.difficulty)), ".")[2])): </b> </p>"
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
function check_answer(q::AbstractQuestion)
	validators = q.validators
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
	for (index, question) in enumerate(q.questions)
		q.questions[index].status = check_answer(question)
	end
	return q
end
