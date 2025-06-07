### A Pluto.jl notebook ###
# v0.20.10

using Markdown
using InteractiveUtils

# ╔═╡ 42e620aa-5f4c-11eb-2ebf-85814cf720e7
using PlutoUI; TableOfContents()

# ╔═╡ 122cffca-5fdc-11eb-3555-b39b818f1116
let 
	using JuMP
	using GLPK
end

# ╔═╡ 24806108-5fdc-11eb-2f19-bb09f836f893
using Sockets

# ╔═╡ 4621c212-5fc7-11eb-2c9d-ad577506420e
using Plots

# ╔═╡ b2c1cef8-5fe5-11eb-20c7-134432196893
using Distributed

# ╔═╡ 31c1e25e-5e53-11eb-2467-9153d30962d5
md"""
# Metaprogramming

The strongest legacy of [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)) in the Julia language is its metaprogramming  support. Like Lisp, Julia represents its own code as a data structure of the language itself. 

Since code is represented by objects that can be created and manipulated from within the language, it is possible for a program to transform and generate its own code. This allows sophisticated code generation without extra build steps, and also allows true Lisp-style macros operating at the level of abstract syntax trees.


Because all data types and code in Julia are represented by Julia data structures, powerful reflection capabilities are available to explore the internals of a program and its types just like any other data.

First, we will talk about how to represent a program (aka the building blocks), then how to manipulate Julia code from Julia with macros. Finally, we end with examples of code generation and some interesting macros
"""

# ╔═╡ 4ab33c0e-5e53-11eb-2e63-2dd6f06de3ba
md"""
## Program representation

Every Julia program starts its life as a string:
"""

# ╔═╡ e76d8f04-5e53-11eb-26df-db496622642d
prog = "1 + 1"

# ╔═╡ f361d734-5e53-11eb-3957-61bd0a370b5a
md"""
**What happens next?**

The next step is to parse each string into an object called an expression, represented by the Julia type `Expr`. 

Parsing means taking the input (in this case, a string) and building a data structure – often some kind of parse tree, [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) or other hierarchical structure, giving a structural representation of the input while checking for correct syntax. 
"""

# ╔═╡ 15aaa5b6-5e54-11eb-067f-9dcd096940b6
ex1 = Meta.parse(prog)

# ╔═╡ 34b6a71e-5e54-11eb-0324-4bffbe85c813
typeof(ex1)

# ╔═╡ 22770a30-5e54-11eb-28db-1359ab1f402f
md"""
`Expr` objects contain two parts:

  1. a `Symbol` identifying the kind of expression (e.g. a call, for loop, conditional statement, etc.). A symbol is an [interned string](https://en.wikipedia.org/wiki/String_interning) identifier (string interning is a method of storing only one copy of each distinct string value, which must be immutable).

"""

# ╔═╡ 41f9633c-5e54-11eb-323b-e9703c674b0f
ex1.head

# ╔═╡ 48104478-5e54-11eb-2f23-c98c4ccbb763
md"""
  2. the expression arguments, which may be symbols, other expressions, or literal values:
"""

# ╔═╡ 538e2054-5e54-11eb-2b9c-451637e1d8ee
ex1.args

# ╔═╡ 6e3beaf8-5e54-11eb-154b-95f5887efcb0
md"""
Expressions may also be constructed directly in [prefix notation](https://en.wikipedia.org/wiki/Polish_notation) (= Polish notation, a mathematical notation in which operators precede their operands, i.e. `+ 1 1` instead of `1 + 1` with infix notation):
"""

# ╔═╡ 7de376a8-5e54-11eb-0356-9b74225b671e
ex2 = Expr(:call, :+, 1, 1)

# ╔═╡ 825b45a6-5e54-11eb-27e6-f3cca8a2f67e
md"""
The two expressions constructed above – by parsing and by direct construction – are equivalent:
"""

# ╔═╡ 8b23cac8-5e54-11eb-2424-5972ea3d2e21
ex1 == ex2

# ╔═╡ 8ecd49ba-5e54-11eb-24b6-a328043b7a07
md"""
**The key point here is that Julia code is internally represented as a data structure that is accessible
from the language itself.**

The `dump` function provides an indented and annotated display of `Expr` objects:
"""

# ╔═╡ 985a57f2-5e54-11eb-1f2f-bf23014c6171
dump(ex2)

# ╔═╡ d66ea502-5e54-11eb-2694-4766a05aed38
md"""
### Symbols

The `:` character has two syntactic purposes in Julia. The first form creates a [`Symbol`](https://docs.julialang.org/en/v1/base/base/#Core.Symbol),
an [interned string](https://en.wikipedia.org/wiki/String_interning) used as one building-block
of expressions:
"""

# ╔═╡ db1e9936-5e54-11eb-376f-8ddea65d976c
s = :foo

# ╔═╡ e4f50fda-5e54-11eb-2210-6b8eb531d898
typeof(s)

# ╔═╡ ea891b6e-5e54-11eb-24c9-357a8a65d1c0
md"""
The `Symbol` constructor takes any number of arguments and creates a new symbol by concatenating
their string representations together:
"""


# ╔═╡ efe79c46-5e54-11eb-23c9-3107ea94e5b9
:foo == Symbol("foo")

# ╔═╡ f5fac50e-5e54-11eb-2ff9-cf7e30a4a8ad
Symbol("func", 10)

# ╔═╡ fe35b31e-5e54-11eb-258e-29913f1e8723
Symbol(:var, '_', "sym")

# ╔═╡ 0464f1be-5e55-11eb-34df-ef1217012663
md"""Note that to use `:` syntax, the symbol's name must be a valid identifier.
Otherwise, the `Symbol(str)` constructor must be used.

In the context of an expression, symbols are used to indicate access to variables; when an expression
is evaluated, a symbol is replaced with the value bound to that symbol in the appropriate **scope**.
"""

# ╔═╡ abfc3392-5e5a-11eb-149d-ad3dd2755524
md"""
### Quoting

The second syntactic purpose of the `:` character is to create expression objects without using
the explicit `Expr` constructor. This is referred to as *quoting*. The `:` character, followed
by paired parentheses around a single statement of Julia code, produces an `Expr` object based
on the enclosed code. Here is an example of the short form used to quote an arithmetic expression:
"""

# ╔═╡ 917a579c-5e5a-11eb-3fe6-cb0dcad5e4e6
ex = :(a + b * c + 1)

# ╔═╡ 82d3220a-5e5a-11eb-3c49-d5e7afb1af2a
typeof(ex)

# ╔═╡ 67954702-5e5a-11eb-1ab1-e9a285ee208d
ex.args

# ╔═╡ 66c113d0-5e5d-11eb-0aab-b3fa7f98eae5
md"""
### Evaluating expressions

Given an expression object, one can cause Julia to evaluate (execute) it at global scope using `eval`
"""

# ╔═╡ 6fc2fb9c-5e5d-11eb-0f21-6524555a9c42
:(1 + 2)

# ╔═╡ 6dab1d58-5e5d-11eb-3381-a1796f8d14c5
eval(:(1 + 2))

# ╔═╡ b833d8ba-5e5d-11eb-3311-899efb15c1b0
md"""
## Macros

Now that we have an understanding of the basic concepts of code representation in Julia, we can introduce the core concept of this notebook: macros. 

Macros provide a method to include generated code in the final body of a program. A macro maps
a tuple of arguments to a returned *expression*, and the resulting expression is compiled directly
rather than requiring a runtime `eval` call. Macro arguments may include expressions,
literal values, and symbols. 

In the following examples, we will show that macros allow us to
1. modify code before it runs
2. elegantly add new features or syntax
3. process strings at compile time instead of runtime

### Basics

Here is an extraordinarily simple macro:
"""

# ╔═╡ 169c6aa2-5e5e-11eb-1d84-e7e3b4641e10
macro sayhello()
	return :( println("Hello, world!") )
end

# ╔═╡ c40cebe6-5e5e-11eb-1f7f-37134b7a449f
md"""
Macros have a dedicated character in Julia's syntax: the `@` (at-sign), followed by the unique
name declared in a `macro NAME ... end` block. In this example, the compiler will replace all
instances of `@sayhello` with:
"""

# ╔═╡ f5ab41f4-5e5f-11eb-02f7-efcb3e05e616
:( println("Hello, world!") )

# ╔═╡ 0001a53a-5e60-11eb-18df-d7e9e7dcf43f
md"""
When `@sayhello` is entered in the REPL, the expression executes immediately, thus we only see the evaluation result:
"""

# ╔═╡ 1707320e-5e60-11eb-3f33-798c81663488
md"""Now, consider a slightly more complex macro:"""

# ╔═╡ 1fdf9600-5e60-11eb-30d3-b167811ae47f
macro sayhello(name)
	return :( println("Hello, ", $name) )
end

# ╔═╡ ae1525ea-5e5e-11eb-3906-593143776559
@sayhello

# ╔═╡ bda7fd66-5e5e-11eb-1e06-eb67a0178e14
@sayhello

# ╔═╡ 2dcacdfc-5e60-11eb-3d04-9f2ffb46d0fe
md"""
This macro takes one argument: `name`. When `@sayhello` is encountered, the quoted expression is *expanded* to interpolate the value of the argument into the final expression:
"""

# ╔═╡ 36fc5076-5e60-11eb-04be-bd9f542b1ff3
@sayhello("Mr. Bond")

# ╔═╡ 0c787198-61a0-11eb-1e30-fbcb5a624076
@sayhello "Mr. Bond"

# ╔═╡ 4a732eb8-5e60-11eb-197b-0729d0f1be15
md"""
We can view the quoted return expression using the function `macroexpand` or the macro `@macroexpand` (**important note:**
this is an extremely useful tool for debugging macros).
We can see that the `"Mr. Bond"` literal has been interpolated into the expression."""

# ╔═╡ 536addec-5e61-11eb-1a9d-d7f2c190d6c2
@macroexpand @sayhello("Mr. Bond")

# ╔═╡ d1730db6-eb2d-4233-b0a0-bdd84afef88f
md"""
!!! note 

	This in a simple example to show the machinery of macros but as an example it does not offer much benefits over a function.
"""

# ╔═╡ 855412b2-5e61-11eb-3aba-bb862489414e
md"""

### Hold on: why macros?

Macros are necessary because they execute when code is parsed, therefore, macros allow the programmer
to generate and include fragments of customized code *before* the full program is run. To illustrate
the difference, consider the following example.
"""

# ╔═╡ cabb3cdc-5e62-11eb-2479-bb8337c05292
macro twostep(arg)
	println("I execute at parse time. The argument is: ", arg)
	str1 = "I execute at runtime. "
	str2 = "The argument is: "
	message = str1 * str2
	return :(println($message, $arg))
end

# ╔═╡ f33f0cfe-5f52-11eb-30e0-93c4b899aaa7
md"""Note that the computation of `message` is compiled away if we expand the macro!"""

# ╔═╡ 01feeca0-5e63-11eb-11a0-1b66a92127d1
ex_twostep = @macroexpand @twostep :(1, 2, 3)

# ╔═╡ f1969888-5e65-11eb-18a3-879d2f87b447
dump(ex_twostep)

# ╔═╡ da275ff1-b3d9-4a91-b03a-914878555418
md"If you need another example, check out the code below that is generated using the `@elapsed` macro: a functionality that lets you time an expression by injecting `time_ns()` before and after the expression.
"

# ╔═╡ 876ea56f-d426-4908-a832-96ccbd83d950
@macroexpand @elapsed sleep(1)

# ╔═╡ 0613f620-5e66-11eb-08d9-01dd3a403321
md"""
### Macro invocation

Macros are invoked with the following general syntax:

```julia
@name expr1 expr2 ... # only spaces!
@name(expr1, expr2, ...) # no space, with commas!
```

"""

# ╔═╡ a1e86478-5e66-11eb-2ef9-6d460e707013
md"""
### Building an advanced macro

Here is a simplified definition of Julia's `@assert` macro, which checks if an expression is true:

(`... ? ... : ...` is the ternary if-else operator seen in `01-basics.jl` )
"""

# ╔═╡ e61381aa-5e66-11eb-3347-5d26b61e6c17
macro assert(ex)
	return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
end

# ╔═╡ a43490de-5e67-11eb-253e-f7455ade3ffe
md"""This macro can be used like this:"""

# ╔═╡ c79ad04c-5e67-11eb-1fd9-bf7ff40f0862
md"""
In place of the written syntax, the macro call is expanded at parse time to its returned result. This is equivalent to writing:"""

# ╔═╡ f34e9020-5e67-11eb-1987-e3e6a0969705
1 == 1.0 ? nothing : throw(AssertionError("1 == 1.0"))

# ╔═╡ f81955fe-5e67-11eb-11b9-5f9fd0096a09
1 == 0 ? nothing : throw(AssertionError("1 == 0"))

# ╔═╡ fb772ef4-5e67-11eb-218e-330ba087bcc8
md"""
That is, in the first call, the expression `:(1 == 1.0)` is spliced into the test condition slot,
while the value of `string(:(1 == 1.0))` is spliced into the assertion message slot. The entire
expression, thus constructed, is placed into the syntax tree where the `@assert` macro call occurs.
Then at execution time, if the test expression evaluates to true, then `nothing` is returned,
whereas if the test is false, an error is raised indicating the asserted expression that was false.

**Notice that it would not be possible to write this as a function since only the value of the condition is available and it would be impossible to display the expression that computed it in the error message.**

The actual definition of `@assert` in Julia Base is more complicated. It allows the
user to optionally specify their own error message, instead of just printing the failed expression.
Just like in functions with a variable number of arguments, this is specified with an ellipsis
following the last argument:
"""

# ╔═╡ 2df2baa8-5e68-11eb-2f28-9968b7ecbcd5
macro assert(ex, msgs...)
	msg_body = isempty(msgs) ? ex : msgs[1]
	msg = string(msg_body)
	return :($ex ? nothing : throw(AssertionError($msg)))
end

# ╔═╡ b0dfd0dc-5e67-11eb-19cf-5970a2e80bfa
@assert 1 == 1.0

# ╔═╡ c42d2d6a-5e67-11eb-1564-2dcb0e91fb19
@assert 1 == 0

# ╔═╡ 376fe8e4-5e68-11eb-1d7d-c9b1945b133f
md"""
Now `@assert` has two modes of operation depending upon the number of arguments it receives!
If there is only one argument, the tuple of expressions captured by `msgs` will be empty and it
will behave the same as the simpler definition above with only one argument. But now if the user specifies a second argument,
it is printed in the message body instead of the failing expression. You can inspect the result
of a macro expansion with `@macroexpand`.
"""

# ╔═╡ 4750ce04-5e68-11eb-237e-3fed9eb1f4c5
@macroexpand @assert a == b

# ╔═╡ 4dce26dc-5e68-11eb-1ff7-8974f93e3cb8
@macroexpand @assert a==b "a should equal b!"

# ╔═╡ 43a19ace-5e6b-11eb-005b-b7d2d9a46878
md"""
### Macros and dispatch

Macros, just like Julia functions, are generic. This means they can also have multiple method definitions, thanks to multiple dispatch:
"""

# ╔═╡ 508167c4-5e6b-11eb-2587-b967b79cf74c
macro m end

# ╔═╡ 59f86d98-5e6b-11eb-3259-7312501b70bf
macro m(args...)
	"$(length(args)) arguments"
end

# ╔═╡ 5edf55e2-5e6b-11eb-383e-5965ae694c4c
macro m(x,y)
   	"Two arguments"
end

# ╔═╡ 3dc3aa10-5e6c-11eb-3338-7777b8cb97a5
md"""
However one should keep in mind, that macro dispatch is based on the types of AST
that are handed to the macro, not the types that the AST evaluates to at runtime:"""

# ╔═╡ 34565ba8-5e6c-11eb-2a27-2ff13394bcc8
macro m(::Int)
	"An Integer"
end

# ╔═╡ 65c94e9c-5e6b-11eb-38a8-4d60c692222b
@m "asdl"

# ╔═╡ 42fc5284-5e6c-11eb-0edb-9555a320ec55
@m 1 2

# ╔═╡ dc168cf8-484f-4054-a6d2-55703e99fda2
@m 1 2 3

# ╔═╡ 02e4bf64-5e6d-11eb-36b5-fb57c87bff81
@m 3

# ╔═╡ 07f8cc34-5e6d-11eb-36e4-b56b2b92a2e2
x = 2

# ╔═╡ 0bbfce80-5e6d-11eb-07f6-b71086357384
@m x

# ╔═╡ 0e00bff6-5e6d-11eb-342d-bfded7ef8a96
md"""
## Code Generation

When a significant amount of repetitive boilerplate code is required, it is common to generate
it programmatically to avoid redundancy. In most languages, this requires an extra build step,
and a separate program to generate the repetitive code. In Julia, expression interpolation and `eval` allow such code generation to take place in the normal course of program execution.
For example, consider the following custom type
"""

# ╔═╡ 36805374-5e6d-11eb-205c-0524096bdf27
struct MyNumber
    x::Float64
end

# ╔═╡ 4056c9bc-5e6d-11eb-377e-238ef8633c74
md"""for which we want to add a number of methods to. We can do this programmatically in the following loop:"""

# ╔═╡ 49807d8c-5e6d-11eb-0170-f1419837d958
for op = (:sin, :cos, :tan, :log, :exp, :log)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end

# ╔═╡ 4ef3f280-5e6d-11eb-2020-b7cd9e6b9c03
md"""and we can now use those functions with our custom type:"""

# ╔═╡ 53f36f36-5e6d-11eb-3f06-6de0eff4d173
y = MyNumber(π)

# ╔═╡ 3428d7b8-5e6d-11eb-32bc-af1df0579e60
sin(y)

# ╔═╡ 18e3753a-5f55-11eb-0a11-47ca6abe9186
md"This will not work since we only have defined `log` and not `log10`."

# ╔═╡ 2f4fe6ce-5e6c-11eb-1744-2f9534c8b6ba
log10(y)

# ╔═╡ cae2546a-5e6b-11eb-3fc2-69f9a15107cf
md"""In this manner, Julia acts as its own preprocessor, and allows code generation from inside the language."""

# ╔═╡ efc1357a-61a0-11eb-20f5-a15338080e4c
md"### Example: domain-specific languages"

# ╔═╡ 4d9de330-5f55-11eb-0d89-eb81e6c9ffab
md"
Code generation can for instance be used to simplify the creation of a mathematical optimisation problem. In this case, we will use the `JuMP` package.
`JuMP` ('Julia for Mathematical Programming') is an open-source modeling language that is embedded in Julia. It allows users to formulate various classes of optimization problems (linear, mixed-integer, quadratic, conic quadratic, semidefinite, and nonlinear) with easy-to-read code. `JuMP` also makes advanced optimization techniques easily accessible from a high-level language. 

As a dummy example, let us consider the following linear programming problem:

``\max_{x,y}\,\,x + 2y``

``\text{s.t.}``

``x + y \leq 1``

``0\leq x, y \leq 1``

Which can be transcribed into a `JuMP` model as:
"

# ╔═╡ 92458f54-5f57-11eb-179f-c749ce06f7e2
let
	model = Model(GLPK.Optimizer)
	@variable(model, 0 <= x <= 1)
	@variable(model, 0 <= y <= 1)
	@constraint(model, x + y <= 1)
	@objective(model, Max, x + 2y)
	optimize!(model)
	value(x), value(y), objective_value(model)
end


# ╔═╡ d1222dcc-5f57-11eb-2c87-77a16ea8e65d
md"
Without the macros, the code would be more difficult to read. As an example, check the `macroexpansion` of `@constraint` to see the bunch of code that is generated behind the scenes:
"

# ╔═╡ 0b1f3542-5f58-11eb-1610-75df3e2a4a76
let
	model = Model(GLPK.Optimizer)
	@macroexpand @constraint(model, x + y <= 1)
end

# ╔═╡ 2e2601b6-5e94-11eb-3613-eb5fee19b6b7
md"
## Overview of some interesting macros
"

# ╔═╡ d889f68e-4d15-4bab-92f6-c42bac58e60a
md"""
The first example of a custom macro can be found in every notebook in this course! It is the markdown string literal, which allows the usage of Markdown markup language to prettify these lectures!

```julia
md"I am a Markdown string with glorious **formatting capabilities**."
```
I am a Markdown string with glorious *formatting* **capabilities**.

```julia
macro md_str(p)
	...
end
```
"""

# ╔═╡ fe4095e9-0c35-4459-98b0-30ba91fc90b4
md"""
The regular expression macro is just the following:
```julia
macro r_str(p)
    Regex(p)
end
```
That's all. This macro says that the literal contents of the string literal `r"^\s*(?:#|$)"` should
be passed to the `@r_str` macro and the result of that expansion should be placed in the syntax
tree where the string literal occurs. In other words, the expression `r"^\s*(?:#|$)"` is equivalent
to placing the following object directly into the syntax tree:

"""

# ╔═╡ ce8b16fa-7644-4c64-ad3c-cbf667b4811b
Regex("^\\s*(?:#|\$)")

# ╔═╡ 48a68105-9a30-4dd1-9f7b-eebf1c19c856
md"""
!!! note

	It might be confusion that the `@`-symbol is not used for calling these macros. It is a convention that when defining a macro with the `_str` suffix, one can use the macro as a prefix to string literals. These object are called [non-standard string literals](https://docs.julialang.org/en/v1/manual/metaprogramming/#meta-non-standard-string-literals).

"""

# ╔═╡ f20221ca-82d1-4973-9f68-e46638c929f7
md"Not only is the string literal form shorter and far more convenient, but it is also more efficient:
since the regular expression is compiled, which takes time, and the `Regex` object is actually created *when the code is compiled*, the compilation occurs only once, rather than every time the code is executed."


# ╔═╡ cb0907b5-a8d9-4954-85cc-2040887f5e3c
md"**Other examples of useful macros:**"

# ╔═╡ 5ba5d6b6-5fc5-11eb-256b-73a954a5db68
md"Integers and floating point numbers with arbitrary precision. This macro exists because promoting a floating point number to a `BigFloat` will keep the approximation error of `Float64`."

# ╔═╡ a47ab60e-5fc5-11eb-368a-d76fc6ee640d
big"0.1"

# ╔═╡ a99546c2-5fc5-11eb-0902-71cb283543c8
@big_str "0.1"

# ╔═╡ af2c7d4e-5fc5-11eb-30d4-a367d2c0db23
big(0.1)

# ╔═╡ 4a335466-5fc6-11eb-2273-312fd3928616
md"There exists a lot more unique string literals than we have shown here, such as html strings, ip address literals, etc."

# ╔═╡ 17f771dc-5fc6-11eb-3b83-ed51f87194e0
html"""<!-- HTML generated using hilite.me --><div style="background: #ffffff; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;"><table><tr><td><pre style="margin: 0; line-height: 125%">1</pre></td><td><pre style="margin: 0; line-height: 125%">println(<span style="color: #a31515">&quot;hello world!&quot;</span>)
</pre></td></tr></table></div>
"""

# ╔═╡ 92836b48-5fc6-11eb-19b6-1d7a5c310052
println("There is nothing like ", ip"127.0.0.1")

# ╔═╡ f26e65a8-5fc6-11eb-3cd7-3f40c12a6abb
md"Find out what function is exactly used in multiple dipatch."

# ╔═╡ 154e2392-5fc7-11eb-250b-e726ab7710e7
@which sin(2.2)

# ╔═╡ 2cfa3952-5fc7-11eb-2e79-95f86aafbf2c
@which sin(2)

# ╔═╡ 4aece42a-5fc7-11eb-291f-99120483339f
md"
There exist some handy macros to analyse execution time and memory allocation.

```julia
using BenchmarkTools
@btime sin(2)
@benchmark sin(2)
@elapsed sin(2)
```
"

# ╔═╡ 295e0028-5fd6-11eb-39e4-b392de1c0de2
md"""
When developing modules, scripts or julia packages, you can use the `@info`, `@warn`, `@error` and `@debug` as logging macros. They are mostly useful in packages, not in notebooks like this.

An example usage would be a warning thrown by an optimisation algorithm to tell you that e.g. the predefined accuracy or tolerance was not reached.

Note, to make `@debug` you need to set an environment variable to mark that you are in debug mode: 
```julia
ENV["JULIA_DEBUG"] = "all"
```
"""

# ╔═╡ 4a9d85ba-5fc7-11eb-1b6e-59ef2259dd24
PlutoUI.with_terminal() do
	@info "Information comes here"
	@error "Error has been found at this exact location"
	@warn "Same. but for a warning"
	@debug "Debugging info, not printed by default"
end

# ╔═╡ 34829ada-5fdc-11eb-263a-cf60a9650556
md"Plot recipes are a nifty thing to make plots for your custom data type:"

# ╔═╡ 5c33798c-5fda-11eb-186f-79450fb59e3b
struct TemperatureMeas
	t1
	t2
	t3
	TemperatureMeas(t1, t2, t3) = new(t1, t2, t3)
end

# ╔═╡ 1ca80d42-5fdb-11eb-153f-9ddb25a4fb6b
@recipe function f(tempmeas::TemperatureMeas)
    xguide --> "time (seconds)"
    yguide --> "temperature (Celsius)"
    [tempmeas.t1, tempmeas.t2, tempmeas.t3] # return the arguments (input data) for the next recipe
end

# ╔═╡ 1a793992-5fdb-11eb-3b38-05544f268a65
plot(TemperatureMeas(Plots.fakedata(50), -Plots.fakedata(50), Plots.fakedata(50).^2))

# ╔═╡ d418dca4-5fe5-11eb-3f1a-a31e5dc5f7e9
md"
Using the `Distributed` module, one can easily transform certain types of code to run distributed (i.e. on multiple cores). Below is an example of how you can transform a for-loop into its distributed version.
"

# ╔═╡ f1b70998-5fdb-11eb-292b-0776f1b03816
@sync @distributed for i ∈ 1:5
	println(i)
end

# ╔═╡ 7fb1899d-7ed2-44ad-a76b-79ab401ba9f3
md"
With `@time` or `@elapsed` you can check the execution time of an expression. Note that `@time` returns the result of the expression, whereas `@elapsed` returns the execution time in seconds
"

# ╔═╡ 0b4f0a03-8556-4009-9c3f-89c3628c006f
@time 1:100_000_000 |> sum

# ╔═╡ 867805fe-bc86-4b81-9237-2a056076d138
@elapsed 1:100_000_000 |> sum

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"
GLPK = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
JuMP = "4076af6c-e467-56ae-b986-b466b2749572"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Sockets = "6462fe0b-24de-5631-8697-dd941f90decc"

[compat]
GLPK = "~1.1.0"
JuMP = "~1.5.0"
Plots = "~1.38.0"
PlutoUI = "~0.7.55"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "7873a76c415cdbfe580f027b7e9ac986e3b66c93"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BenchmarkTools]]
deps = ["Compat", "JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "e38fbc49a620f5d0b660d7f543db1009fe0f8336"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.6.0"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "fde3bf89aead2e723284a8ff9cdf5b551ed700e8"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.5+0"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "TranscodingStreams"]
git-tree-sha1 = "84990fa864b7f2b4901901ca12736e45ee79068c"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.8.5"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "37ea44092930b1811e666c3bc38065d7d87fcc74"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.1"

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4e1fe97fdaed23e9dc21d4d664bea76b65fc50a0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.22"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "473e9afc9cf30814eb67ffa5f2db7df82c3ad9fd"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.16.2+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "7442a5dfe1ebb773c29cc2962a8980f47221d76c"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.5"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "301b5d5d731a0654825f1f2e906990f7141a106b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.16.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "910febccb28d493032495b7009dce7d7f7aee554"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "1.0.1"

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

    [deps.ForwardDiff.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "2c5512e11c791d1baed2049c5652441b28fc6a31"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7a214fdac5ed5f59a22c2d9a885a16da1c74bbc7"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.17+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GLPK]]
deps = ["GLPK_jll", "MathOptInterface"]
git-tree-sha1 = "e37c68890d71c2e6555d3689a5d5fc75b35990ef"
uuid = "60bf3e95-4087-53dc-ae20-288a0d20c6a6"
version = "1.1.3"

[[deps.GLPK_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6aa6294ba949ccfc380463bf50ff988b46de5bc7"
uuid = "e8aa6df9-e6ca-548a-97ff-1f85fc5b8b98"
version = "5.0.1+1"

[[deps.GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"
version = "6.3.0+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "27442171f28c952804dede8ff72828a96f2bfc1f"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.72.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "025d171a2847f616becc0f84c8dc62fe18f0f6dd"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.72.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "fee60557e4f19d0fe5cd169211fdda80e494f4e8"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.84.0+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a6dbda1fd736d60cc477d99f2e7a042acfa46e8"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.15+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "f93655dc73d7a0b4a368e3c0bce296ae035ad76e"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.16"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "f923f9a774fcf3f5cb761bfa43aeadd689714813"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.1+0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.JLFzf]]
deps = ["REPL", "Random", "fzf_jll"]
git-tree-sha1 = "82f7acdc599b65e0f8ccd270ffa1467c21cb647b"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.11"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "411eccfe8aba0814ffa0fdf4860913ed09c34975"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.14.3"

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

    [deps.JSON3.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.JuMP]]
deps = ["LinearAlgebra", "MathOptInterface", "MutableArithmetics", "OrderedCollections", "Printf", "SparseArrays"]
git-tree-sha1 = "97792e3d04971c41fdc4917e1ae9bf6d313599e3"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "1.5.0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eb62a3deb62fc6d8822c0c4bef73e4412419c5d8"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.8+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "4f34eaabe49ecb3fb0d58d6015e32fd31a733199"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.8"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"
    TectonicExt = "tectonic_jll"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"
    tectonic_jll = "d7dd28d6-a5e6-559c-9131-7eb760cdacc5"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c8da7e6a91781c41a863611c7e966098d783c57a"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.4.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "d36c21b9e7c172a44a10484125024495e2625ac0"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.1+1"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a31572773ac1b745e0343fe5e2c8ddda7a37e997"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.41.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "2da088d113af58221c52828a80378e16be7d037a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.5.1+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "321ccef73a96ba828cd51f2ab5b9f917fa73945a"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.41.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "DataStructures", "ForwardDiff", "JSON3", "LinearAlgebra", "MutableArithmetics", "NaNMath", "OrderedCollections", "PrecompileTools", "Printf", "SparseArrays", "SpecialFunctions", "Test"]
git-tree-sha1 = "a946919f378668e92e6e3b8bde260999111ccd5f"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "1.40.2"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "491bdcdc943fcbc4c005900d7463c9f216aabf4c"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.6.4"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "9b8215b1ee9e78a293f99797cd31375471b2bcae"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.3"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.5+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "f1a7e086c677df53e064e0fdd2c9d0b0833e3f6e"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.5.0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9216a80ff3682833ac4b733caa8c00390620ba5d"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.0+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "05868e21324cede2207c6f0f466b4bfef6d5e7ee"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "275a9a6d85dc86c24d03d1837a0010226a96f540"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.3+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "db76b1ecd5e9715f3d043cec13b2ec93ce015d53"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.44.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "9f8675a55b37a70aa23177ec110f6e3f4dd68466"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.17"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "3876f0ab0390136ae0b5e3f064a109b87fa1e56e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.63"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Profile]]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"
version = "1.11.0"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "37b7bb7aabf9a085e0044307e1717436117f2b3b"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.5.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "41852b8679f78c8d8961eeadc8f62cef861a52e3"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.5.1"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "95af145932c2ed859b63329952ce8d633719f091"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.3"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "9d72a13a3f4dd3795a195ac5a44d7d6ff5f552ff"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.1"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "b81c5035922cc89c2d9523afc6c54be512411466"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.5"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "159331b30e94d7b11379037feeb9b690950cace8"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.11.0"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d62610ec45e4efeabf7032d67de2ffdea8344bed"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.1"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "af305cc62419f9bd61b6644d19170a4d258c7967"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.7.0"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "XML2_jll"]
git-tree-sha1 = "49be0be57db8f863a902d59c0083d73281ecae8e"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.23.1+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fee71455b0aaa3440dfdd54a9a36ccef829be7d4"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.8.1+0"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a3ea76ee3f4facd7a64684f9af25310825ee3668"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.2+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "9c7ad99c629a44f81e7799eb05ec2746abb5d588"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.6+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "b5899b25d17bf1889d25906fb9deed5da0c15b3b"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.12+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aa1261ebbac3ccc8d16558ae6799524c450ed16b"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.13+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "6c74ca84bbabc18c4547014765d194ff0b4dc9da"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.4+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "52858d64353db33a56e13c341d7bf44cd0d7b309"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.6+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a4c0ee07ad36bf8bbce1c3bb52d21fb1e0b987fb"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.7+0"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "9caba99d38404b285db8801d5c45ef4f4f425a6d"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.1+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "a376af5c7ae60d29825164db40787f15c80c7c54"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.3+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a5bc75478d323358a90dc36766f3c99ba7feb024"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.6+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "aff463c82a773cb86061bce8d53a0d976854923e"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.5+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "7ed9347888fac59a618302ee38216dd0379c480d"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.12+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXau_jll", "Xorg_libXdmcp_jll"]
git-tree-sha1 = "bfcaf7ec088eaba362093393fe11aa141fa15422"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.1+0"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "e3150c7400c41e207012b41659591f083f3ef795"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.3+0"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "801a858fc9fb90c11ffddee1801bb06a738bda9b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.7+0"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "00af7ebdc563c9217ecc67776d1bbf037dbcebf4"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.44.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a63799ff68005991f9d9491b6e95bd3478d783cb"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.6.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "b6a34e0e0960190ac2a4363a1bd003504772d631"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.61.1+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3cad2cf2c8d80f1d17320652b3ea7778b30f473f"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.3.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "002748401f7b520273e2b506f61cab95d4701ccf"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.48+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "c950ae0a3577aec97bfccf3381f66666bc416729"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.8.1+0"
"""

# ╔═╡ Cell order:
# ╠═42e620aa-5f4c-11eb-2ebf-85814cf720e7
# ╟─31c1e25e-5e53-11eb-2467-9153d30962d5
# ╟─4ab33c0e-5e53-11eb-2e63-2dd6f06de3ba
# ╠═e76d8f04-5e53-11eb-26df-db496622642d
# ╟─f361d734-5e53-11eb-3957-61bd0a370b5a
# ╠═15aaa5b6-5e54-11eb-067f-9dcd096940b6
# ╠═34b6a71e-5e54-11eb-0324-4bffbe85c813
# ╟─22770a30-5e54-11eb-28db-1359ab1f402f
# ╠═41f9633c-5e54-11eb-323b-e9703c674b0f
# ╟─48104478-5e54-11eb-2f23-c98c4ccbb763
# ╠═538e2054-5e54-11eb-2b9c-451637e1d8ee
# ╟─6e3beaf8-5e54-11eb-154b-95f5887efcb0
# ╠═7de376a8-5e54-11eb-0356-9b74225b671e
# ╟─825b45a6-5e54-11eb-27e6-f3cca8a2f67e
# ╟─8b23cac8-5e54-11eb-2424-5972ea3d2e21
# ╟─8ecd49ba-5e54-11eb-24b6-a328043b7a07
# ╠═985a57f2-5e54-11eb-1f2f-bf23014c6171
# ╟─d66ea502-5e54-11eb-2694-4766a05aed38
# ╠═db1e9936-5e54-11eb-376f-8ddea65d976c
# ╠═e4f50fda-5e54-11eb-2210-6b8eb531d898
# ╟─ea891b6e-5e54-11eb-24c9-357a8a65d1c0
# ╠═efe79c46-5e54-11eb-23c9-3107ea94e5b9
# ╠═f5fac50e-5e54-11eb-2ff9-cf7e30a4a8ad
# ╠═fe35b31e-5e54-11eb-258e-29913f1e8723
# ╟─0464f1be-5e55-11eb-34df-ef1217012663
# ╟─abfc3392-5e5a-11eb-149d-ad3dd2755524
# ╠═917a579c-5e5a-11eb-3fe6-cb0dcad5e4e6
# ╠═82d3220a-5e5a-11eb-3c49-d5e7afb1af2a
# ╠═67954702-5e5a-11eb-1ab1-e9a285ee208d
# ╟─66c113d0-5e5d-11eb-0aab-b3fa7f98eae5
# ╠═6fc2fb9c-5e5d-11eb-0f21-6524555a9c42
# ╠═6dab1d58-5e5d-11eb-3381-a1796f8d14c5
# ╟─b833d8ba-5e5d-11eb-3311-899efb15c1b0
# ╠═169c6aa2-5e5e-11eb-1d84-e7e3b4641e10
# ╠═ae1525ea-5e5e-11eb-3906-593143776559
# ╟─c40cebe6-5e5e-11eb-1f7f-37134b7a449f
# ╠═f5ab41f4-5e5f-11eb-02f7-efcb3e05e616
# ╟─0001a53a-5e60-11eb-18df-d7e9e7dcf43f
# ╠═bda7fd66-5e5e-11eb-1e06-eb67a0178e14
# ╟─1707320e-5e60-11eb-3f33-798c81663488
# ╠═1fdf9600-5e60-11eb-30d3-b167811ae47f
# ╟─2dcacdfc-5e60-11eb-3d04-9f2ffb46d0fe
# ╠═36fc5076-5e60-11eb-04be-bd9f542b1ff3
# ╠═0c787198-61a0-11eb-1e30-fbcb5a624076
# ╟─4a732eb8-5e60-11eb-197b-0729d0f1be15
# ╠═536addec-5e61-11eb-1a9d-d7f2c190d6c2
# ╟─d1730db6-eb2d-4233-b0a0-bdd84afef88f
# ╟─855412b2-5e61-11eb-3aba-bb862489414e
# ╠═cabb3cdc-5e62-11eb-2479-bb8337c05292
# ╟─f33f0cfe-5f52-11eb-30e0-93c4b899aaa7
# ╠═01feeca0-5e63-11eb-11a0-1b66a92127d1
# ╠═f1969888-5e65-11eb-18a3-879d2f87b447
# ╟─da275ff1-b3d9-4a91-b03a-914878555418
# ╠═876ea56f-d426-4908-a832-96ccbd83d950
# ╟─0613f620-5e66-11eb-08d9-01dd3a403321
# ╟─a1e86478-5e66-11eb-2ef9-6d460e707013
# ╠═e61381aa-5e66-11eb-3347-5d26b61e6c17
# ╟─a43490de-5e67-11eb-253e-f7455ade3ffe
# ╠═b0dfd0dc-5e67-11eb-19cf-5970a2e80bfa
# ╠═c42d2d6a-5e67-11eb-1564-2dcb0e91fb19
# ╟─c79ad04c-5e67-11eb-1fd9-bf7ff40f0862
# ╠═f34e9020-5e67-11eb-1987-e3e6a0969705
# ╠═f81955fe-5e67-11eb-11b9-5f9fd0096a09
# ╟─fb772ef4-5e67-11eb-218e-330ba087bcc8
# ╠═2df2baa8-5e68-11eb-2f28-9968b7ecbcd5
# ╟─376fe8e4-5e68-11eb-1d7d-c9b1945b133f
# ╠═4750ce04-5e68-11eb-237e-3fed9eb1f4c5
# ╠═4dce26dc-5e68-11eb-1ff7-8974f93e3cb8
# ╟─43a19ace-5e6b-11eb-005b-b7d2d9a46878
# ╠═508167c4-5e6b-11eb-2587-b967b79cf74c
# ╠═59f86d98-5e6b-11eb-3259-7312501b70bf
# ╠═5edf55e2-5e6b-11eb-383e-5965ae694c4c
# ╠═65c94e9c-5e6b-11eb-38a8-4d60c692222b
# ╠═42fc5284-5e6c-11eb-0edb-9555a320ec55
# ╠═dc168cf8-484f-4054-a6d2-55703e99fda2
# ╟─3dc3aa10-5e6c-11eb-3338-7777b8cb97a5
# ╠═34565ba8-5e6c-11eb-2a27-2ff13394bcc8
# ╠═02e4bf64-5e6d-11eb-36b5-fb57c87bff81
# ╠═07f8cc34-5e6d-11eb-36e4-b56b2b92a2e2
# ╠═0bbfce80-5e6d-11eb-07f6-b71086357384
# ╟─0e00bff6-5e6d-11eb-342d-bfded7ef8a96
# ╠═36805374-5e6d-11eb-205c-0524096bdf27
# ╟─4056c9bc-5e6d-11eb-377e-238ef8633c74
# ╠═49807d8c-5e6d-11eb-0170-f1419837d958
# ╟─4ef3f280-5e6d-11eb-2020-b7cd9e6b9c03
# ╠═53f36f36-5e6d-11eb-3f06-6de0eff4d173
# ╠═3428d7b8-5e6d-11eb-32bc-af1df0579e60
# ╟─18e3753a-5f55-11eb-0a11-47ca6abe9186
# ╠═2f4fe6ce-5e6c-11eb-1744-2f9534c8b6ba
# ╟─cae2546a-5e6b-11eb-3fc2-69f9a15107cf
# ╟─efc1357a-61a0-11eb-20f5-a15338080e4c
# ╟─4d9de330-5f55-11eb-0d89-eb81e6c9ffab
# ╠═122cffca-5fdc-11eb-3555-b39b818f1116
# ╠═92458f54-5f57-11eb-179f-c749ce06f7e2
# ╟─d1222dcc-5f57-11eb-2c87-77a16ea8e65d
# ╠═0b1f3542-5f58-11eb-1610-75df3e2a4a76
# ╟─2e2601b6-5e94-11eb-3613-eb5fee19b6b7
# ╟─d889f68e-4d15-4bab-92f6-c42bac58e60a
# ╟─fe4095e9-0c35-4459-98b0-30ba91fc90b4
# ╠═ce8b16fa-7644-4c64-ad3c-cbf667b4811b
# ╟─48a68105-9a30-4dd1-9f7b-eebf1c19c856
# ╟─f20221ca-82d1-4973-9f68-e46638c929f7
# ╟─cb0907b5-a8d9-4954-85cc-2040887f5e3c
# ╟─5ba5d6b6-5fc5-11eb-256b-73a954a5db68
# ╠═a47ab60e-5fc5-11eb-368a-d76fc6ee640d
# ╠═a99546c2-5fc5-11eb-0902-71cb283543c8
# ╠═af2c7d4e-5fc5-11eb-30d4-a367d2c0db23
# ╟─4a335466-5fc6-11eb-2273-312fd3928616
# ╟─17f771dc-5fc6-11eb-3b83-ed51f87194e0
# ╠═24806108-5fdc-11eb-2f19-bb09f836f893
# ╠═92836b48-5fc6-11eb-19b6-1d7a5c310052
# ╟─f26e65a8-5fc6-11eb-3cd7-3f40c12a6abb
# ╠═154e2392-5fc7-11eb-250b-e726ab7710e7
# ╠═2cfa3952-5fc7-11eb-2e79-95f86aafbf2c
# ╟─4aece42a-5fc7-11eb-291f-99120483339f
# ╟─295e0028-5fd6-11eb-39e4-b392de1c0de2
# ╠═4a9d85ba-5fc7-11eb-1b6e-59ef2259dd24
# ╟─34829ada-5fdc-11eb-263a-cf60a9650556
# ╠═4621c212-5fc7-11eb-2c9d-ad577506420e
# ╠═5c33798c-5fda-11eb-186f-79450fb59e3b
# ╠═1ca80d42-5fdb-11eb-153f-9ddb25a4fb6b
# ╠═1a793992-5fdb-11eb-3b38-05544f268a65
# ╟─d418dca4-5fe5-11eb-3f1a-a31e5dc5f7e9
# ╠═b2c1cef8-5fe5-11eb-20c7-134432196893
# ╠═f1b70998-5fdb-11eb-292b-0776f1b03816
# ╟─7fb1899d-7ed2-44ad-a76b-79ab401ba9f3
# ╠═0b4f0a03-8556-4009-9c3f-89c3628c006f
# ╠═867805fe-bc86-4b81-9237-2a056076d138
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
