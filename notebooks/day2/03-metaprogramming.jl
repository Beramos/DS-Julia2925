### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 42e620aa-5f4c-11eb-2ebf-85814cf720e7
begin 
	using PlutoUI
	using DSJulia
end

# ╔═╡ 122cffca-5fdc-11eb-3555-b39b818f1116
let 
	using JuMP
	using GLPK
end

# ╔═╡ 0963185c-5fdc-11eb-0eed-89d514850353
using BioSequences

# ╔═╡ 24806108-5fdc-11eb-2f19-bb09f836f893
using Sockets

# ╔═╡ 4621c212-5fc7-11eb-2c9d-ad577506420e
using Plots

# ╔═╡ b2c1cef8-5fe5-11eb-20c7-134432196893
using Distributed

# ╔═╡ 31c1e25e-5e53-11eb-2467-9153d30962d5
md"""
# Metaprogramming

The strongest legacy of [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)) in the Julia language is its metaprogramming support. Like Lisp,
Julia represents its own code as a data structure of the language itself. Since code is represented
by objects that can be created and manipulated from within the language, it is possible for a
program to transform and generate its own code. This allows sophisticated code generation without
extra build steps, and also allows true Lisp-style macros operating at the level of abstract syntax trees.
Because all data types and
code in Julia are represented by Julia data structures, powerful reflection
capabilities are available to explore the internals of a program and its types just like any other
data.
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

The next step is to parse each string
into an object called an expression, represented by the Julia type `Expr`. 
Parsing means taking the input (in this case, a string) and building a data structure – often some kind of parse tree, [abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) or other hierarchical structure, giving a structural representation of the input while checking for correct syntax. 
"""

# ╔═╡ 15aaa5b6-5e54-11eb-067f-9dcd096940b6
ex1 = Meta.parse(prog)

# ╔═╡ 34b6a71e-5e54-11eb-0324-4bffbe85c813
typeof(ex1)

# ╔═╡ 22770a30-5e54-11eb-28db-1359ab1f402f
md"""
`Expr` objects contains two parts:

  * a `Symbol` identifying the kind of expression. A symbol is an [interned string](https://en.wikipedia.org/wiki/String_interning)
    identifier (string interning is a method of storing only one copy of each distinct string value, which must be immutable).

"""

# ╔═╡ 41f9633c-5e54-11eb-323b-e9703c674b0f
ex1.head

# ╔═╡ 48104478-5e54-11eb-2f23-c98c4ccbb763
md"""
  * the expression arguments, which may be symbols, other expressions, or literal values:
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

The `dump` function provides indented and annotated display of `Expr` objects:
"""

# ╔═╡ 985a57f2-5e54-11eb-1f2f-bf23014c6171
@terminal dump(ex2)

# ╔═╡ d66ea502-5e54-11eb-2694-4766a05aed38
md"""
### Symbols

The `:` character has two syntactic purposes in Julia. The first form creates a [`Symbol`](@ref),
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
Otherwise the `Symbol(str)` constructor must be used.

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

# ╔═╡ 2ae6ac9c-5e5a-11eb-060c-b3eae1df0493
md"""
### Interpolation

Direct construction of `Expr` objects with value arguments is powerful, but `Expr` constructors
can be tedious compared to "normal" Julia syntax. As an alternative, Julia allows *interpolation* of
literals or expressions into quoted expressions. Interpolation is indicated by a prefix `$`.

In this example, the value of variable `a` is interpolated:
"""

# ╔═╡ 5ef3d532-5e5a-11eb-30b3-a569e0bd736e
a = 1

# ╔═╡ 3bb1f892-5e5a-11eb-0946-e5e977a4e5b2
:($a + b)

# ╔═╡ 5763cca0-5e5a-11eb-1341-3d9bfb47fb58
md"""
Interpolating into an unquoted expression is not supported and will cause a compile-time error:
"""

# ╔═╡ e6a3902a-5e58-11eb-2bd2-4bc779bcebe7
$a + b

# ╔═╡ 11991248-5e55-11eb-2748-992f6fe48620
md"""
The use of `$` for expression interpolation is intentionally reminiscent of string interpolation and command interpolation. Expression interpolation allows convenient, readable programmatic construction of complex Julia expressions.
"""

# ╔═╡ 1c016bec-5e5d-11eb-3687-931da82f8c04
md"""

### Splatting interpolation

Notice that the `$` interpolation syntax allows inserting only a single expression into an
enclosing expression.
Occasionally, you have an array of expressions and need them all to become arguments of
the surrounding expression.
This can be done with the syntax `$(args...)`.

For example, the following code generates a function call where the number of arguments is
determined programmatically:
"""

# ╔═╡ 552ea3bc-5e5d-11eb-0c97-e1e6db526df3
args = [:x, :y, :z]

# ╔═╡ 629c4f9a-5e5d-11eb-2731-bf7457755829
:(f(1, $(args...)))

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
@terminal @sayhello

# ╔═╡ bda7fd66-5e5e-11eb-1e06-eb67a0178e14
@terminal @sayhello()

# ╔═╡ 2dcacdfc-5e60-11eb-3d04-9f2ffb46d0fe
md"""
This macro takes one argument: `name`. When `@sayhello` is encountered, the quoted expression is *expanded* to interpolate the value of the argument into the final expression:
"""

# ╔═╡ 36fc5076-5e60-11eb-04be-bd9f542b1ff3
@terminal @sayhello("Mr. Bond")

# ╔═╡ 0c787198-61a0-11eb-1e30-fbcb5a624076
@terminal @sayhello "Mr. Bond"

# ╔═╡ 4a732eb8-5e60-11eb-197b-0729d0f1be15
md"""
We can view the quoted return expression using the function `macroexpand` or the macro `@macroexpand` (**important note:**
this is an extremely useful tool for debugging macros).
We can see that the `"Mr. Bond"` literal has been interpolated into the expression."""

# ╔═╡ 536addec-5e61-11eb-1a9d-d7f2c190d6c2
@macroexpand @sayhello("Mr. Bond")

# ╔═╡ 855412b2-5e61-11eb-3aba-bb862489414e
md"""

### Hold on: why macros?

We have already seen a function `f(::Expr...) -> Expr` in a previous section. In fact, `macroexpand` is also such a function. So, why do macros exist?

Macros are necessary because they execute when code is parsed, therefore, macros allow the programmer
to generate and include fragments of customized code *before* the full program is run. To illustrate
the difference, consider the following example.

Note that in this case, you need to look at your REPL to see the output. A macro definition is not allowed in the local scope, so we cannot wrap this with our `@terminal` macro.
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
md"""Note that the computation of message is compiled away if we expand the macro!"""

# ╔═╡ 01feeca0-5e63-11eb-11a0-1b66a92127d1
ex_twostep = @macroexpand @twostep :(1, 2, 3)

# ╔═╡ f1969888-5e65-11eb-18a3-879d2f87b447
@terminal dump(ex_twostep)

# ╔═╡ 0613f620-5e66-11eb-08d9-01dd3a403321
md"""
### Macro invocation

Macros are invoked with the following general syntax:

```julia
@name expr1 expr2 ...
@name(expr1, expr2, ...)
```

"""

# ╔═╡ 29a2c0ee-5e66-11eb-2194-6f1c3cef563a
md"""
Note the distinguishing `@` before the macro name and the lack of commas between the argument
expressions in the first form, and the lack of whitespace after `@name` in the second form. The
two styles should not be mixed. For example, the following syntax is different from the examples
above; it passes the tuple `(expr1, expr2, ...)` as one argument to the macro:

```julia
@name (expr1, expr2, ...)
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
Notice that it would not be possible to write this as a function, since only the *value* of the
condition is available and it would be impossible to display the expression that computed it in
the error message.

The actual definition of `@assert` in Julia Base is more complicated. It allows the
user to optionally specify their own error message, instead of just printing the failed expression.
Just like in functions with a variable number of arguments, this is specified with an ellipses
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

# ╔═╡ 558920ca-5e68-11eb-3533-d5d596e3884d
md"""

There is yet another case that the actual `@assert` macro handles: what if, in addition to printing
"a should equal b," we wanted to print their values? One might naively try to use string interpolation
in the custom message, e.g., `@assert a==b "a ($a) should equal b ($b)!"`, but this won't work
as expected with the above macro. Can you see why? Recall from string interpolation that an interpolated string is rewritten to a call to `string`. Compare:
"""

# ╔═╡ 6d69106a-5e68-11eb-0d50-e17b4db5db74
typeof(:("a should equal b"))

# ╔═╡ 715464cc-5e68-11eb-3e1a-977db04a7db6
typeof(:("a ($a) should equal b ($b)!"))

# ╔═╡ 7588018e-5e68-11eb-3be2-b97ce124d6bf
@terminal dump(:("a ($a) should equal b ($b)!"))

# ╔═╡ 84771eaa-5e68-11eb-0684-cf1a3118d10b
md"""
So now instead of getting a plain string in `msg_body`, the macro is receiving a full expression that will need to be evaluated in order to display as expected. This can be spliced directly into the returned expression as an argument to the `string` call; see `error.jl` for the complete implementation.

The `@assert` macro makes great use of splicing into quoted expressions to simplify the manipulation of expressions inside the macro body.
"""

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
sin(x)

# ╔═╡ 18e3753a-5f55-11eb-0a11-47ca6abe9186
md"This will not work since we only have defined `log` and not `log10`."

# ╔═╡ 2f4fe6ce-5e6c-11eb-1744-2f9534c8b6ba
log10(y)

# ╔═╡ cae2546a-5e6b-11eb-3fc2-69f9a15107cf
md"""In this manner, Julia acts as its own preprocessor, and allows code generation from inside the language."""

# ╔═╡ 0ac5096e-61a1-11eb-24ba-13bc0a3377c6


# ╔═╡ efc1357a-61a0-11eb-20f5-a15338080e4c
md"### Example: domain specific languages"

# ╔═╡ 4d9de330-5f55-11eb-0d89-eb81e6c9ffab
md"
Code generation can for instance be used to simplify the creation of a mathematical optimisation problem. In this case, we we'll use the `JuMP` package.
`JuMP` ('Julia for Mathematical Programming') is an open-source modeling language that is embedded in Julia. It allows users to users formulate various classes of optimization problems (linear, mixed-integer, quadratic, conic quadratic, semidefinite, and nonlinear) with easy-to-read code. `JuMP` also makes advanced optimization techniques easily accessible from a high-level language. 

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

# ╔═╡ 57f243ec-5fe3-11eb-04d9-d776ccba4c0f
md"Finally, this section on code generation ends with two more examples:
1. a macro to repeat a certain expression n-times
2. a macro to repeat a certain expression until a condition is met

Are these macros the best way to tackle the problems at hand? Maybe not, but they do give a nice illustration of how the code generation works.
"

# ╔═╡ 211cf9ca-5fe3-11eb-2596-71b1848753d7
macro dotimes(n, body)
    quote
        for i = 1:$(esc(n))
            $(esc(body))
        end
    end
end

# ╔═╡ 35ccaee2-5fe3-11eb-3bd0-e355b0fd3f71
@macroexpand @dotimes 3 println("hi there")

# ╔═╡ 434669d2-5fe3-11eb-1f4a-27edf1f9e7f6
macro until(condition, block)
    quote
        while true
            $(esc(block))
            if $(esc(condition))
                break
            end
        end
    end
end

# ╔═╡ 9612965e-5fe3-11eb-172a-59cc73a26ab6
PlutoUI.with_terminal() do
	i = 0
	@until i == 10 begin
		i += 1
		println(i) 
	end
end

# ╔═╡ 3c2cce20-5fe3-11eb-32e3-f542f9a94a6e
@macroexpand @until j == 10 begin
	j += 1
	println(j) 
end

# ╔═╡ 10a8532a-5e60-11eb-3331-974e708cb39d
md"""
## Non-Standard String Literals

String literals prefixed by an identifier are called non-standard string literals, and can have different semantics than un-prefixed string literals. For example:


  * `r"^\s*(?:#|$)"` produces a regular expression object rather than a string
  * `b"DATA\xff\u2200"` is a byte array literal for `[68,65,84,65,255,226,136,128]`.

Perhaps surprisingly, these behaviors are not hard-coded into the Julia parser or compiler. Instead,
they are custom behaviors provided by a general mechanism that anyone can use: prefixed string
literals are parsed as calls to specially-named macros. For example, the regular expression macro
is just the following:
"""

# ╔═╡ d46324d8-5e7a-11eb-005c-f7fec5a39880
macro r_str(p)
    Regex(p)
end

# ╔═╡ d8a9ad46-5e7a-11eb-1cce-3d4bc49cd332
md"""
That's all. This macro says that the literal contents of the string literal `r"^\s*(?:#|$)"` should
be passed to the `@r_str` macro and the result of that expansion should be placed in the syntax
tree where the string literal occurs. In other words, the expression `r"^\s*(?:#|$)"` is equivalent
to placing the following object directly into the syntax tree:
"""

# ╔═╡ e85b2d3c-5e7a-11eb-3b89-e11bc274f7cf
Regex("^\\s*(?:#|\$)")

# ╔═╡ ec73cd70-5e7a-11eb-0285-6b1fabd1289d
md"""
Not only is the string literal form shorter and far more convenient, but it is also more efficient:
since the regular expression is compiled, which takes time, and the `Regex` object is actually created *when the code is compiled*,
the compilation occurs only once, rather than every time the code is executed. Consider if the
regular expression occurs in a loop:
"""

# ╔═╡ f1d24ba2-5e7a-11eb-010a-f543cfc306b5
PlutoUI.with_terminal() do
	for line ∈ ["first", "sec#nd", "third"]
		m = match(r"#", line)
		if m === nothing
			println("nothing found")
		else
			println("found something")
		end
	end
end

# ╔═╡ f838762c-5e7a-11eb-000a-e963fab5e97d
md"""
Since the regular expression `r"^\s*(?:#|$)"` is compiled and inserted into the syntax tree when
this code is parsed, the expression is only compiled once instead of each time the loop is executed.
In order to accomplish this without macros, one would have to write this loop like this:
"""

# ╔═╡ 149c1c12-5e7b-11eb-297d-6da57f45891b
PlutoUI.with_terminal() do
	re = Regex("#")
	for line ∈ ["first", "sec#nd", "third"]
		m = match(re, line)
		if m === nothing
			println("nothing found")
		else
			println("found something")
		end
	end
end

# ╔═╡ 780da60e-5e7c-11eb-0c1a-55be73da188f
md"""
Moreover, if the compiler could not determine that the regex object was constant over all loops,
certain optimizations might not be possible, making this version still less efficient than the
more convenient literal form above. Of course, there are still situations where the non-literal
form is more convenient: if one needs to interpolate a variable into the regular expression, one
must take this more verbose approach. In the vast majority of use cases, however, regular expressions
are not constructed based on run-time data. In this majority of cases, the ability to write regular
expressions as compile-time values is invaluable.
"""

# ╔═╡ 90a672d0-5f5c-11eb-3a62-1b034cd41e67
md"
Designing your own custom string literals can be done as such:
"

# ╔═╡ b4104d12-5e7c-11eb-3e22-a78b74526129
macro foo_str(str, flag)
    # do stuff
	str, flag
end

# ╔═╡ 20393e86-5e7d-11eb-18e3-613890472903
foo"this is the string"theflag

# ╔═╡ 5069df16-5e7d-11eb-217d-6b740e9b3559
md"""
The first example of a custom macro can be found in every notebook in this course! It is the markdown string literal, which allows the usage of Markdown markup language to prettify these lectures!

```julia
md"I am a Markdown string with glorious **formatting capabilities**."
```
I am a Markdown string with glorious *formatting* **capabilities**.
"""

# ╔═╡ 1a50ff0e-5e7d-11eb-2fc4-cd5c12015751
md"The second example is from the `BioSequences.jl` package. In that bioinformatics package, you can define sequences e.g. DNA and RNA as string literals:
"

# ╔═╡ 0664eb22-5e7d-11eb-07a6-ed35143bf03f
dna"ACGT"

# ╔═╡ a965bd70-5e7c-11eb-13dd-5fe83950af11
md"Repetition and concatenation can be performed pretty straightforward:"

# ╔═╡ fb0c59fa-5f61-11eb-1ab7-bf7b80746aa2
repeat(dna"TTAGGG", 10)

# ╔═╡ a157dafc-5e7c-11eb-105d-4db3ee9dbec6
dna = dna"ACGT" * dna"TGCAA"

# ╔═╡ 0ec9887c-5f5e-11eb-29e5-931881dcb222
md"Other typical string operations such as pushing new values work as you would expect"

# ╔═╡ 1d4aca5a-5f5e-11eb-23c3-d1ddef4e6ee6
push!(dna, DNA_A)

# ╔═╡ c4c2137a-5f5d-11eb-1e06-8f5e2b1f1c0e
md"There exist methods to convert a DNA sequence to its RNA equivalent:"

# ╔═╡ e13fcbbe-5f5d-11eb-2074-fdbc945861e1
rna = convert(LongRNASeq, dna)

# ╔═╡ 2c1308f4-5f5e-11eb-058f-79cbf7dd23c6
md"Note that altough the printout of the DNA and RNA object is different because of different nucleotides. The information content is the same, and as such this statement is true:"

# ╔═╡ fdf46c92-5f5d-11eb-345b-e145c9c2874c
dna.data === rna.data

# ╔═╡ 37da420a-5f61-11eb-3688-09e6188165e3
md"Remember before that we mentioned that you can add a flag to a string literal? In `BioSequences.jl` this has a use case. 

If you have a function that generates a sequence, and you want it to create a new sequence each time it is called, then you can add a flag to the end of the sequence literal to dictate behaviour: A flag of 's' means 'static': the sequence will be allocated before code is run, as is the default behaviour. However providing 'd' flag changes the behaviour: 'd' means 'dynamic': the sequence will be allocated whilst the code is running, and not before. So to change foo so as it creates a new sequence each time it is called, simply add the 'd' flag to the sequence literal:"

# ╔═╡ d9f18616-5e8d-11eb-1b1a-3bcc749fb467
function getdna_dynamic()
	s = dna"CTT"d     # 'd' flag appended to the string literal.
	push!(s, DNA_A)
end

# ╔═╡ ea3da4dc-5e8d-11eb-0910-091b926aea58
getdna_dynamic()

# ╔═╡ f13dd22a-5e8d-11eb-1def-137de66123ba
getdna_dynamic()

# ╔═╡ be11ec9a-5f61-11eb-374a-c96489ea582d
md"Output of `getdna_dynamic()` stays the same!"

# ╔═╡ f44d757e-5e8d-11eb-18f1-719d3c7b8688
function getdna_static()
	s = dna"CTT"s     # 's' flag appended to the string literal.
	push!(s, DNA_A)
end

# ╔═╡ fa310fdc-5e8d-11eb-024b-7ded3e213112
getdna_static()

# ╔═╡ 1acb02d4-5e8e-11eb-232c-f756e92c3f97
getdna_static()

# ╔═╡ 2dcb4600-5e8e-11eb-093e-59eb79f0cf20
md"""
Be careful when you are using sequence literals inside of functions, and inside the bodies of things like for loops. And if you use them and are unsure, use the 's' and 'd' flags to ensure the behaviour you get is the behaviour you intend.
"""

# ╔═╡ 2e2601b6-5e94-11eb-3613-eb5fee19b6b7
md"
## Overview of some interesting macros
"

# ╔═╡ 311a4666-5fc5-11eb-2cc0-ef66e5be96e3
md"check if an expression is true"

# ╔═╡ 4622422a-5fc5-11eb-20f2-9bfe466f8f30
@assert true == true

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
@terminal println("There is nothing like ", ip"127.0.0.1")

# ╔═╡ f26e65a8-5fc6-11eb-3cd7-3f40c12a6abb
md"Find out what function is exactly used in multiple dipatching."

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

Note, to make `@debug` you need to set an environment variable to mark that you are in debug mode: `ENV["JULIA_DEBUG"] = "all"`
"""

# ╔═╡ 4a9d85ba-5fc7-11eb-1b6e-59ef2259dd24
PlutoUI.with_terminal() do
	@info "Information comes here"
	@error "Error has been found at this exact location"
	@warn "Same. but for a warning"
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
plot(TemperatureMeas(Plots.fakedata(50), Plots.fakedata(50), Plots.fakedata(50)))

# ╔═╡ d418dca4-5fe5-11eb-3f1a-a31e5dc5f7e9
md"
Using the `Distributed` module, one can easily transform certain types of code to run distributed (i.e. on multiple cores). Below is an example of how you can transform a for-loop into its distributed version.
"

# ╔═╡ f1b70998-5fdb-11eb-292b-0776f1b03816
PlutoUI.with_terminal() do
	@sync @distributed for i ∈ 1:5
		println(i)
	end
end

# ╔═╡ Cell order:
# ╟─42e620aa-5f4c-11eb-2ebf-85814cf720e7
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
# ╠═8b23cac8-5e54-11eb-2424-5972ea3d2e21
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
# ╟─2ae6ac9c-5e5a-11eb-060c-b3eae1df0493
# ╠═5ef3d532-5e5a-11eb-30b3-a569e0bd736e
# ╠═3bb1f892-5e5a-11eb-0946-e5e977a4e5b2
# ╟─5763cca0-5e5a-11eb-1341-3d9bfb47fb58
# ╠═e6a3902a-5e58-11eb-2bd2-4bc779bcebe7
# ╟─11991248-5e55-11eb-2748-992f6fe48620
# ╟─1c016bec-5e5d-11eb-3687-931da82f8c04
# ╠═552ea3bc-5e5d-11eb-0c97-e1e6db526df3
# ╠═629c4f9a-5e5d-11eb-2731-bf7457755829
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
# ╟─855412b2-5e61-11eb-3aba-bb862489414e
# ╠═cabb3cdc-5e62-11eb-2479-bb8337c05292
# ╟─f33f0cfe-5f52-11eb-30e0-93c4b899aaa7
# ╠═01feeca0-5e63-11eb-11a0-1b66a92127d1
# ╠═f1969888-5e65-11eb-18a3-879d2f87b447
# ╟─0613f620-5e66-11eb-08d9-01dd3a403321
# ╟─29a2c0ee-5e66-11eb-2194-6f1c3cef563a
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
# ╟─558920ca-5e68-11eb-3533-d5d596e3884d
# ╠═6d69106a-5e68-11eb-0d50-e17b4db5db74
# ╠═715464cc-5e68-11eb-3e1a-977db04a7db6
# ╠═7588018e-5e68-11eb-3be2-b97ce124d6bf
# ╟─84771eaa-5e68-11eb-0684-cf1a3118d10b
# ╟─43a19ace-5e6b-11eb-005b-b7d2d9a46878
# ╠═508167c4-5e6b-11eb-2587-b967b79cf74c
# ╠═59f86d98-5e6b-11eb-3259-7312501b70bf
# ╠═5edf55e2-5e6b-11eb-383e-5965ae694c4c
# ╠═65c94e9c-5e6b-11eb-38a8-4d60c692222b
# ╠═42fc5284-5e6c-11eb-0edb-9555a320ec55
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
# ╟─0ac5096e-61a1-11eb-24ba-13bc0a3377c6
# ╟─efc1357a-61a0-11eb-20f5-a15338080e4c
# ╟─4d9de330-5f55-11eb-0d89-eb81e6c9ffab
# ╠═122cffca-5fdc-11eb-3555-b39b818f1116
# ╠═92458f54-5f57-11eb-179f-c749ce06f7e2
# ╟─d1222dcc-5f57-11eb-2c87-77a16ea8e65d
# ╠═0b1f3542-5f58-11eb-1610-75df3e2a4a76
# ╟─57f243ec-5fe3-11eb-04d9-d776ccba4c0f
# ╠═211cf9ca-5fe3-11eb-2596-71b1848753d7
# ╠═35ccaee2-5fe3-11eb-3bd0-e355b0fd3f71
# ╠═434669d2-5fe3-11eb-1f4a-27edf1f9e7f6
# ╠═9612965e-5fe3-11eb-172a-59cc73a26ab6
# ╠═3c2cce20-5fe3-11eb-32e3-f542f9a94a6e
# ╟─10a8532a-5e60-11eb-3331-974e708cb39d
# ╠═d46324d8-5e7a-11eb-005c-f7fec5a39880
# ╟─d8a9ad46-5e7a-11eb-1cce-3d4bc49cd332
# ╠═e85b2d3c-5e7a-11eb-3b89-e11bc274f7cf
# ╟─ec73cd70-5e7a-11eb-0285-6b1fabd1289d
# ╠═f1d24ba2-5e7a-11eb-010a-f543cfc306b5
# ╟─f838762c-5e7a-11eb-000a-e963fab5e97d
# ╠═149c1c12-5e7b-11eb-297d-6da57f45891b
# ╟─780da60e-5e7c-11eb-0c1a-55be73da188f
# ╟─90a672d0-5f5c-11eb-3a62-1b034cd41e67
# ╠═b4104d12-5e7c-11eb-3e22-a78b74526129
# ╠═20393e86-5e7d-11eb-18e3-613890472903
# ╟─5069df16-5e7d-11eb-217d-6b740e9b3559
# ╟─1a50ff0e-5e7d-11eb-2fc4-cd5c12015751
# ╠═0963185c-5fdc-11eb-0eed-89d514850353
# ╠═0664eb22-5e7d-11eb-07a6-ed35143bf03f
# ╟─a965bd70-5e7c-11eb-13dd-5fe83950af11
# ╠═fb0c59fa-5f61-11eb-1ab7-bf7b80746aa2
# ╠═a157dafc-5e7c-11eb-105d-4db3ee9dbec6
# ╟─0ec9887c-5f5e-11eb-29e5-931881dcb222
# ╠═1d4aca5a-5f5e-11eb-23c3-d1ddef4e6ee6
# ╟─c4c2137a-5f5d-11eb-1e06-8f5e2b1f1c0e
# ╠═e13fcbbe-5f5d-11eb-2074-fdbc945861e1
# ╟─2c1308f4-5f5e-11eb-058f-79cbf7dd23c6
# ╠═fdf46c92-5f5d-11eb-345b-e145c9c2874c
# ╟─37da420a-5f61-11eb-3688-09e6188165e3
# ╠═d9f18616-5e8d-11eb-1b1a-3bcc749fb467
# ╠═ea3da4dc-5e8d-11eb-0910-091b926aea58
# ╠═f13dd22a-5e8d-11eb-1def-137de66123ba
# ╟─be11ec9a-5f61-11eb-374a-c96489ea582d
# ╠═f44d757e-5e8d-11eb-18f1-719d3c7b8688
# ╠═fa310fdc-5e8d-11eb-024b-7ded3e213112
# ╠═1acb02d4-5e8e-11eb-232c-f756e92c3f97
# ╟─2dcb4600-5e8e-11eb-093e-59eb79f0cf20
# ╟─2e2601b6-5e94-11eb-3613-eb5fee19b6b7
# ╟─311a4666-5fc5-11eb-2cc0-ef66e5be96e3
# ╠═4622422a-5fc5-11eb-20f2-9bfe466f8f30
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
