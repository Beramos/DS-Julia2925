#=
Created on 03/02/2021 09:20:46
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

This example shows a practical application (error propagation) of the type system and the fact that
you can define them yourselves.
=#

struct Measurement{T<:AbstractFloat} <: Number
    x::T
    σ::T
    function Measurement(x::T, σ::T) where {T<:AbstractFloat}
        if σ ≤ zero(σ)
            error("Measurement error should be positive")
        end
        new{T}(x, σ)
    end
end

val(m::Measurement) = m.x;
err(m::Measurement) = m.σ;

# this is done so that the terminal can display our results
Base.show(io::IO, measurement::Measurement) = print(io, "$(measurement.x) ± $(measurement.σ)");

±(x, σ) = Measurement(x, σ);

# scalar multiplication
Base.:*(a::Real, m::Measurement) = a * m.x ± abs(a) * m.σ;
Base.:/(m::Measurement, a::Real) = inv(a) * m;
# adding and substracting measurements
Base.:+(m1::Measurement, m2::Measurement) = (m1.x + m2.x) ± √(m1.σ^2 + m2.σ^2);
Base.:-(m1::Measurement, m2::Measurement) = (m1.x - m2.x) ± √(m1.σ^2 + m2.σ^2);
Base.:-(m::Measurement) = -m.x ± m.σ;
# adding a constant
Base.:+(m::Measurement, a::Real) = m + (a ± zero(a));
Base.:+(a::Real, m::Measurement) = m + a;
# multiplying two measurments
Base.:*(m1::Measurement, m2::Measurement) = m1.x * m2.x ± (m1.x * m2.x) * √((m1.σ / m1.x)^2 + (m2.σ / m2.x)^2);

m1 = 9.1 ± 0.3
m2 = 8.0 ± 0.2
m3 = 10.2 ± 0.3