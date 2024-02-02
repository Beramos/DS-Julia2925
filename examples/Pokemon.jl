### A Pluto.jl notebook ###
# v0.19.37

using Markdown
using InteractiveUtils

# ╔═╡ 1dffac12-ef71-11eb-3d44-537b4ed77dc9
using PlutoUI

# ╔═╡ 63456a8a-6821-446c-9279-8a9fc269b047
md"""# Pokémon Fights In Julia
Welcome great adventurer, in this notebook we will take you on a `Pokémon` journey. We will try to take adnvantage of the **multiple dispatch** system of Julia by implementing a very efficient Pokémon fight system. 
"""

# ╔═╡ 0f6fc6b1-6d79-4ab7-9263-92adecb6e495
md"""## The Mechanics 
Let us first take a look at the fighting mechanics of Pokémon.
As you can see in the image below there are different types and each type is effective against some types but weak against others.

$(Resource("https://img.pokemondb.net/images/typechart.png"))
*Image from https://img.pokemondb.net/images/typechart.png*

So let us first start by defining a general PokéType.
"""

# ╔═╡ fc131461-7d14-4301-aad5-1c91ed54c972
abstract type PokéType end

# ╔═╡ d53461a0-8124-4108-b8a9-909313c01b55
md"Next we will define all the separate types that we will need later on."

# ╔═╡ 7fed909f-d803-4059-b253-8b1f1fe930a3
begin
	struct Normal <: PokéType end
	struct Fire <: PokéType end
	struct Water <: PokéType end
	struct Electric <: PokéType end
	struct Grass <: PokéType end
	struct Ice <: PokéType end
	struct Fighting <: PokéType end
	struct Poison <: PokéType end
	struct Ground <: PokéType end
	struct Flying <: PokéType end
	struct Psychic <: PokéType end
	struct Bug <: PokéType end
	struct Rock <: PokéType end
	struct Ghost <: PokéType end
	struct Dragon <: PokéType end
	struct Dark <: PokéType end
	struct Steel <: PokéType end
	struct Fairy <: PokéType end
end

# ╔═╡ 78ca9717-a44c-4289-8827-4cd67274059f
md"""## The Core Function 
Now it's time to create our effect function. This function will have as an input the type of the attacker and the type of the defender and then determine how effective the attack was.
"""

# ╔═╡ 8fd10c7d-e3e3-4575-8694-22b10f9a9c41
begin
	NO_EFFECT = 0
	NOT_VERY_EFFECTIVE = 0.5
	NORMAL_EFFECTIVE   = 1.0
	SUPER_EFFECTIVE    = 2.0
end;

# ╔═╡ 6fd02628-ccf5-4f85-a03c-2591fbdf3eb5
md"First we'll define the most general case, this way our function will always have an output for every Pokémon battle."

# ╔═╡ c4632665-51f2-46bf-b2aa-4849d635de43
function eff(atk::T1,def::T2) where {T1 <: PokéType, T2 <: PokéType}
	return NORMAL_EFFECTIVE
end

# ╔═╡ a3e53c87-5f15-47d0-a80c-4d5388b31eb8
md"Now we need to define all the other cases. Normally we this would mean defining 18x18 = $(18*18) cases. Luckily for us there are some patterns that make it so we don't need to define all of them. We will start by defining the cases where the attacker and defender are of the same type, then move on to all the `SUPER_EFFECTIVE` moves and so on."

# ╔═╡ 20ec0a99-9b6e-40a4-aa44-144765b86a3d
begin
	eff(atk::T,def::T) where {T <: PokéType} = NOT_VERY_EFFECTIVE
	eff(atk::Normal,def::Normal) = NORMAL_EFFECTIVE
	eff(atk::Fighting,def::Fighting) = NORMAL_EFFECTIVE
	eff(atk::Ground,def::Ground) = NORMAL_EFFECTIVE
	eff(atk::Flying,def::Flying) = NORMAL_EFFECTIVE
	eff(atk::Bug,def::Bug) = NORMAL_EFFECTIVE
	eff(atk::Rock,def::Rock) = NORMAL_EFFECTIVE
	eff(atk::Fairy,def::Fairy) = NORMAL_EFFECTIVE
	eff(atk::Ghost,def::Ghost) = SUPER_EFFECTIVE
	eff(atk::Dragon,def::Dragon) = SUPER_EFFECTIVE
end

# ╔═╡ af7579be-e3ee-408b-bb7e-2c1362a0c427
md"`SUPER_EFFECTIVE` fights:"

# ╔═╡ 9997973b-2992-4df2-ad71-b25fb80a3655
begin
	eff(atk::Fire,def::Grass) = SUPER_EFFECTIVE
	eff(atk::Fire,def::Ice) = SUPER_EFFECTIVE
	eff(atk::Fire,def::Bug) = SUPER_EFFECTIVE
	eff(atk::Fire,def::Steel) = SUPER_EFFECTIVE
	eff(atk::Water,def::Fire) = SUPER_EFFECTIVE
	eff(atk::Water,def::Ground) = SUPER_EFFECTIVE
	eff(atk::Water,def::Rock) = SUPER_EFFECTIVE
	eff(atk::Electric,def::Water) = SUPER_EFFECTIVE
	eff(atk::Electric,def::Flying) = SUPER_EFFECTIVE
	eff(atk::Grass,def::Water) = SUPER_EFFECTIVE
	eff(atk::Grass,def::Ground) = SUPER_EFFECTIVE
	eff(atk::Grass,def::Rock) = SUPER_EFFECTIVE
	eff(atk::Ice,def::Grass) = SUPER_EFFECTIVE
	eff(atk::Ice,def::Ground) = SUPER_EFFECTIVE
	eff(atk::Ice,def::Flying) = SUPER_EFFECTIVE
	eff(atk::Ice,def::Dragon) = SUPER_EFFECTIVE
	eff(atk::Fighting,def::Normal) = SUPER_EFFECTIVE
	eff(atk::Fighting,def::Ice) = SUPER_EFFECTIVE
	eff(atk::Fighting,def::Rock) = SUPER_EFFECTIVE
	eff(atk::Fighting,def::Dark) = SUPER_EFFECTIVE
	eff(atk::Fighting,def::Steel) = SUPER_EFFECTIVE
	eff(atk::Poison,def::Grass) = SUPER_EFFECTIVE
	eff(atk::Poison,def::Fairy) = SUPER_EFFECTIVE
	eff(atk::Ground,def::Fire) = SUPER_EFFECTIVE
	eff(atk::Ground,def::Electric) = SUPER_EFFECTIVE
	eff(atk::Ground,def::Poison) = SUPER_EFFECTIVE
	eff(atk::Ground,def::Rock) = SUPER_EFFECTIVE
	eff(atk::Ground,def::Steel) = SUPER_EFFECTIVE
	eff(atk::Flying,def::Grass) = SUPER_EFFECTIVE
	eff(atk::Flying,def::Fighting) = SUPER_EFFECTIVE
	eff(atk::Flying,def::Bug) = SUPER_EFFECTIVE
	eff(atk::Psychic,def::Fighting) = SUPER_EFFECTIVE
	eff(atk::Psychic,def::Poison) = SUPER_EFFECTIVE
	eff(atk::Bug,def::Grass) = SUPER_EFFECTIVE
	eff(atk::Bug,def::Psychic) = SUPER_EFFECTIVE
	eff(atk::Bug,def::Dark) = SUPER_EFFECTIVE
	eff(atk::Rock,def::Fire) = SUPER_EFFECTIVE
	eff(atk::Rock,def::Ice) = SUPER_EFFECTIVE
	eff(atk::Rock,def::Flying) = SUPER_EFFECTIVE
	eff(atk::Rock,def::Bug) = SUPER_EFFECTIVE
	eff(atk::Ghost,def::Psychic) = SUPER_EFFECTIVE
	eff(atk::Dark,def::Psychic) = SUPER_EFFECTIVE
	eff(atk::Dark,def::Ghost) = SUPER_EFFECTIVE
	eff(atk::Steel,def::Ice) = SUPER_EFFECTIVE
	eff(atk::Steel,def::Rock) = SUPER_EFFECTIVE
	eff(atk::Steel,def::Fairy) = SUPER_EFFECTIVE
	eff(atk::Fairy,def::Fighting) = SUPER_EFFECTIVE
	eff(atk::Fairy,def::Dragon) = SUPER_EFFECTIVE
	eff(atk::Fairy,def::Dark) = SUPER_EFFECTIVE
	
end

# ╔═╡ 1e075548-6898-457b-8cec-dbccc0fd8ec7
md"`NOT_VERY_EFFECTIVE` fights:"

# ╔═╡ eb578e80-f4fe-4c14-91b7-d7b267bd9046
begin
	eff(atk::Normal,def::Rock) = NOT_VERY_EFFECTIVE
	eff(atk::Normal,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Fire,def::Water) = NOT_VERY_EFFECTIVE
	eff(atk::Fire,def::Rock) = NOT_VERY_EFFECTIVE
	eff(atk::Fire,def::Dragon) = NOT_VERY_EFFECTIVE
	eff(atk::Water,def::Grass) = NOT_VERY_EFFECTIVE
	eff(atk::Water,def::Dragon) = NOT_VERY_EFFECTIVE
	eff(atk::Electric,def::Grass) = NOT_VERY_EFFECTIVE
	eff(atk::Electric,def::Dragon) = NOT_VERY_EFFECTIVE
	eff(atk::Grass,def::Fire) = NOT_VERY_EFFECTIVE
	eff(atk::Grass,def::Poison) = NOT_VERY_EFFECTIVE
	eff(atk::Grass,def::Bug) = NOT_VERY_EFFECTIVE
	eff(atk::Grass,def::Dragon) = NOT_VERY_EFFECTIVE
	eff(atk::Grass,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Grass,def::Flying) = NOT_VERY_EFFECTIVE
	eff(atk::Ice,def::Fire) = NOT_VERY_EFFECTIVE
	eff(atk::Ice,def::Water) = NOT_VERY_EFFECTIVE
	eff(atk::Ice,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Fighting,def::Poison) = NOT_VERY_EFFECTIVE
	eff(atk::Fighting,def::Flying) = NOT_VERY_EFFECTIVE
	eff(atk::Fighting,def::Psychic) = NOT_VERY_EFFECTIVE
	eff(atk::Fighting,def::Bug) = NOT_VERY_EFFECTIVE
	eff(atk::Fighting,def::Fairy) = NOT_VERY_EFFECTIVE
	eff(atk::Poison,def::Ground) = NOT_VERY_EFFECTIVE
	eff(atk::Poison,def::Rock) = NOT_VERY_EFFECTIVE
	eff(atk::Poison,def::Ghost) = NOT_VERY_EFFECTIVE
	eff(atk::Ground,def::Grass) = NOT_VERY_EFFECTIVE
	eff(atk::Ground,def::Bug) = NOT_VERY_EFFECTIVE
	eff(atk::Flying,def::Electric) = NOT_VERY_EFFECTIVE
	eff(atk::Flying,def::Rock) = NOT_VERY_EFFECTIVE
	eff(atk::Flying,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Psychic,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Fire) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Poison) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Fighting) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Flying) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Fairy) = NOT_VERY_EFFECTIVE
	eff(atk::Bug,def::Ghost) = NOT_VERY_EFFECTIVE
	eff(atk::Rock,def::Fighting) = NOT_VERY_EFFECTIVE
	eff(atk::Rock,def::Ground) = NOT_VERY_EFFECTIVE
	eff(atk::Rock,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Ghost,def::Dark) = NOT_VERY_EFFECTIVE
	eff(atk::Dragon,def::Steel) = NOT_VERY_EFFECTIVE
	eff(atk::Dark,def::Fighting) = NOT_VERY_EFFECTIVE
	eff(atk::Dark,def::Fairy) = NOT_VERY_EFFECTIVE
	eff(atk::Steel,def::Fire) = NOT_VERY_EFFECTIVE
	eff(atk::Steel,def::Water) = NOT_VERY_EFFECTIVE
	eff(atk::Steel,def::Electric) = NOT_VERY_EFFECTIVE
	eff(atk::Fairy,def::Fire) = NOT_VERY_EFFECTIVE
	eff(atk::Fairy,def::Poison) = NOT_VERY_EFFECTIVE
	eff(atk::Fairy,def::Steel) = NOT_VERY_EFFECTIVE
end

# ╔═╡ f6c4ed81-0251-4973-bdc7-75951a2657c7
md"`NO_EFFECT` fights:"

# ╔═╡ 2e80f947-1447-4809-b31a-337abaedd955
begin
	eff(atk::Normal,def::Ghost) = NO_EFFECT
	eff(atk::Electric,def::Ground) = NO_EFFECT
	eff(atk::Fighting,def::Ghost) = NO_EFFECT
	eff(atk::Poison,def::Steel) = NO_EFFECT
	eff(atk::Ground,def::Flying) = NO_EFFECT
	eff(atk::Psychic,def::Dark) = NO_EFFECT
	eff(atk::Ghost,def::Normal) = NO_EFFECT
	eff(atk::Dragon,def::Fairy) = NO_EFFECT
end

# ╔═╡ db9ba5b4-0573-4bd0-9359-24cdc2885082
md"""Now that we have defined all of the effects, it's time to take a small brake and heal up at the PokéCenter!\
$(Resource("http://25.media.tumblr.com/tumblr_lzm9prI6UJ1qeh39oo1_500.gif"))\
*Gif from http://pokemondailylr.blogspot.com/2012/12/pokemon-center.html* """

# ╔═╡ 4c5e5e24-aea6-4573-b9a2-f25d83c22f19
md"""## The Actual Fight Function
Now we will define the last couple of functions that we need to implement the fighting system. First we'll make a function that makes a nice string based on the effectiveness of an attack, next we will use that function to complete our attack function.
"""

# ╔═╡ 7539d614-67d5-4a2a-b03a-00c5f873c8ae
function eff_string(effectiveness)
	if effectiveness == 0
		return "not effective"
	elseif effectiveness < 1.0
		return "not very effective ($effectiveness × damage)"
	elseif effectiveness == 1
		return "effective"
	else
		return "very effective  ($effectiveness × damage)"
	end
end

# ╔═╡ e9b22426-0c7f-4f15-8bd3-361b3b5ed5cf
md"We also want to correctly display the type of our Pokémon. For this reason we overload the `Base.show()` function."

# ╔═╡ 0be3dd43-188f-460d-8df8-3ae9ac8adae1
Base.string(x::PokéType) = split(string(typeof(x)),".")[end]

# ╔═╡ a5ebeeca-349e-4777-9acf-491da20efd88
Base.show(io::IO, x::PokéType) = string(x)

# ╔═╡ 2326a03a-3f53-420f-896b-cf3620f06a60
md"So now it's time for a small test:"

# ╔═╡ ae08b2e9-f864-458d-89e5-ebe07320f322
md"""## Dual Types
So now our function works for Pokémons with only one type but as we all know there are a lot of Pokémon with two types. Defining a function that lets us use our `attack!()` function for dual type Pokémon is actually very easy.


First we define what a dualtype is:
"""

# ╔═╡ b0f76cc7-0fb4-48ca-9844-c0fe186b32eb
struct DualType <: PokéType
	Type1::PokéType
	Type2::PokéType
end

# ╔═╡ c8f1021f-f230-428c-9685-0eb03a63def8
md"Let us also display the `DualType` correctly."

# ╔═╡ 0ce4e7e0-3d99-4ae4-8a11-905ce6e7708f
Base.show(io::IO, x::DualType) = "$(string(x.Type1))-$(string(x.Type2))"

# ╔═╡ e4870042-9c91-41d8-8770-47940cffce0a
md"Now we adjust our `effect` function so that it knows what to do with Dualtypes. When the Dual type is the attacker, it will choose its most effective attack."

# ╔═╡ 7ff0187e-12c2-497d-b5d1-29dd0770a8e1
eff(atk::DualType, def::PokéType) = max(eff(atk.Type1, def), eff(atk.Type2, def))

# ╔═╡ 33cb3990-d126-41e1-ac9f-c9f9d6b85ae5
md"When the dual type is the defender, we have to compute the correct effect of the attack."

# ╔═╡ bda2dba7-4be5-4ad0-bfdc-ad02a64297a4
eff(atk::PokéType, def::DualType) = eff(atk, def.Type1) * eff(atk, def.Type2)

# ╔═╡ aa5abb6c-2289-4c34-a062-2e84187559dd
function attack!(atk::PokéType, def::PokéType)
    effectiveness = eff(atk, def)
	println("A $(show(atk)) Pokémon used an attack")
    println("against a $(show(def)) Pokémon")
    println("it was $(eff_string(effectiveness))")
end

# ╔═╡ a5ecc6c7-d08b-4cf8-8a3b-580ada462edc
begin
	Squirtle = Water()
	Charmander = Fire()
	with_terminal() do
		attack!(Squirtle,Charmander)
	end
end

# ╔═╡ fd2d5874-46a0-47ae-9f13-45079f42cfab
md"So now we can very easily define a Pokémon with two types!"

# ╔═╡ faa0448f-7470-4d2e-84bf-f2dcaa92fc37
begin
	Venusaur = DualType(Grass(),Poison())
	
	with_terminal() do
		println("Venusaur vs Charmander:")
		attack!(Venusaur, Charmander)
		attack!(Charmander, Venusaur)
		println("")
		println("Venusaur vs Squirtle:")
		attack!(Venusaur, Squirtle)
		attack!(Squirtle, Venusaur)
	end
end

# ╔═╡ 4d67eb11-e859-4213-ae0b-9298d5c79bdf
show(Venusaur)

# ╔═╡ 88d51607-8d4f-4087-ab00-2113a9c65ad4
md"""As you can see, the sky is the limit with these types and take note of the fact that it's all calculated very efficiently!\
For now, this notebook is over but the Pokémon adventure never stops!\

"""

# ╔═╡ 6209b50b-5ded-4529-a895-2ae533ef63b6
md"""[^1]This notebook was based on a great blogpost about Pokémon and Julia. You can find it here: [https://www.moll.dev/projects/effective-multi-dispatch/?s=03](https://www.moll.dev/projects/effective-multi-dispatch/?s=03).\
\
[^2]The sounds used in this notebook where all gathered from: [https://downloads.khinsider.com/game-soundtracks/album/pokemon-gameboy-sound-collection](https://downloads.khinsider.com/game-soundtracks/album/pokemon-gameboy-sound-collection)."""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─1dffac12-ef71-11eb-3d44-537b4ed77dc9
# ╟─63456a8a-6821-446c-9279-8a9fc269b047
# ╟─0f6fc6b1-6d79-4ab7-9263-92adecb6e495
# ╠═fc131461-7d14-4301-aad5-1c91ed54c972
# ╟─d53461a0-8124-4108-b8a9-909313c01b55
# ╠═7fed909f-d803-4059-b253-8b1f1fe930a3
# ╟─78ca9717-a44c-4289-8827-4cd67274059f
# ╠═8fd10c7d-e3e3-4575-8694-22b10f9a9c41
# ╟─6fd02628-ccf5-4f85-a03c-2591fbdf3eb5
# ╠═c4632665-51f2-46bf-b2aa-4849d635de43
# ╟─a3e53c87-5f15-47d0-a80c-4d5388b31eb8
# ╠═20ec0a99-9b6e-40a4-aa44-144765b86a3d
# ╟─af7579be-e3ee-408b-bb7e-2c1362a0c427
# ╠═9997973b-2992-4df2-ad71-b25fb80a3655
# ╟─1e075548-6898-457b-8cec-dbccc0fd8ec7
# ╠═eb578e80-f4fe-4c14-91b7-d7b267bd9046
# ╟─f6c4ed81-0251-4973-bdc7-75951a2657c7
# ╠═2e80f947-1447-4809-b31a-337abaedd955
# ╟─db9ba5b4-0573-4bd0-9359-24cdc2885082
# ╟─4c5e5e24-aea6-4573-b9a2-f25d83c22f19
# ╠═7539d614-67d5-4a2a-b03a-00c5f873c8ae
# ╠═aa5abb6c-2289-4c34-a062-2e84187559dd
# ╟─e9b22426-0c7f-4f15-8bd3-361b3b5ed5cf
# ╠═0be3dd43-188f-460d-8df8-3ae9ac8adae1
# ╠═a5ebeeca-349e-4777-9acf-491da20efd88
# ╟─2326a03a-3f53-420f-896b-cf3620f06a60
# ╠═a5ecc6c7-d08b-4cf8-8a3b-580ada462edc
# ╟─ae08b2e9-f864-458d-89e5-ebe07320f322
# ╠═b0f76cc7-0fb4-48ca-9844-c0fe186b32eb
# ╟─c8f1021f-f230-428c-9685-0eb03a63def8
# ╠═0ce4e7e0-3d99-4ae4-8a11-905ce6e7708f
# ╠═4d67eb11-e859-4213-ae0b-9298d5c79bdf
# ╟─e4870042-9c91-41d8-8770-47940cffce0a
# ╠═7ff0187e-12c2-497d-b5d1-29dd0770a8e1
# ╟─33cb3990-d126-41e1-ac9f-c9f9d6b85ae5
# ╠═bda2dba7-4be5-4ad0-bfdc-ad02a64297a4
# ╟─fd2d5874-46a0-47ae-9f13-45079f42cfab
# ╠═faa0448f-7470-4d2e-84bf-f2dcaa92fc37
# ╟─88d51607-8d4f-4087-ab00-2113a9c65ad4
# ╟─6209b50b-5ded-4529-a895-2ae533ef63b6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
