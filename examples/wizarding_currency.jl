#=
Created on 22/01/2021 10:45:30
Last update: 04/02/2021

@author: Michiel Stock
michielfmstock@gmail.com

The British wizarding world uses Galleons, Sickles, and Knuts as a currency. There are 17 Sickles in a Galleon, and 29 Knuts in a Sickle, meaning there are 493 Knuts to a Galleon. We will make a structure `WizCur` to represent wizarding currency. This structure has three integer-valued fields: `galleons`, `sickles`, and `knuts`. The constructor should always create tidy representations, meaning that, for example, if the number of knuts is 29 or more, it just adds an appropriate number of sickles such that the number knuts is less than 29 (it's magical money). The same applies to the sickles, which can also never exceed 17.

Overload `Base.show` such that Julia prints your currency as, for example, `7G, 2S, 9K`.

Also, overload the function `+` to add two instances of `WizCur` and the `>` and `<` operators to compare two instances of wizarding currency.

The piggy bank with Ron's life savings contains 19 Sickles and 732 Knuts. Harry has 3 Galleons, 1 Sickle, and 7 Knuts pocket change. Who has the most money? How many do they have together?

HINT: you might find `%` and `div` useful here.
=#

struct WizCur
    galleons::Int
    sickles::Int
    knuts::Int
    function WizCur(galleons::Int, sickles::Int, knuts::Int)
        sickles += knuts ÷ 29
        knuts %= 29
        galleons += sickles ÷ 17
        sickles %= 17
        return new(galleons, sickles, knuts)
    end
end

galleons(money::WizCur) = money.galleons
sickles(money::WizCur) = money.sickles
knuts(money::WizCur) = money.knuts

moneyinknuts(money::WizCur) = 29*17galleons(money) + 29sickles(money) + knuts(money)

function Base.show(io::IO, money::WizCur)
    print(io, "$(galleons(money))G, $(sickles(money))S, $(knuts(money))K")
end

Base.isless(m1::WizCur, m2::WizCur) = moneyinknuts(m1) < moneyinknuts(m2) 
Base.isgreater(m1::WizCur, m2::WizCur) = moneyinknuts(m1) > moneyinknuts(m2) 
Base.isequal(m1::WizCur, m2::WizCur) = moneyinknuts(m1) == moneyinknuts(m2)

Base.:+(m1::WizCur, m2::WizCur) = WizCur(galleons(m1)+galleons(m2),
                                            sickles(m1)+sickles(m2),
                                            knuts(m1)+knuts(m2))

money_ron = WizCur(0, 19, 732)
money_harry = WizCur(3, 1, 7)

dungbomb_fund = money_ron + money_harry