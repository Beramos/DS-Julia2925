# Weighted mean

weighted_mean(x, w) = sum(x .* w)

# 1D convolution

function convolve_1d(x::Vector, w::Vector)
	@assert length(w) % 2 == 1 "length of `w` has to be odd!"
	n = length(x)
	m = length(w) ÷ 2
	out = zeros(n)

	fill!(out, 0.0)
	for (i, xj) in enumerate(x)
		for (j, wj) in enumerate(w)
			k = clamp(i + j - m, 1, n)
			out[i] += w[j] * x[k]
		end
	end
	return out
end

# weight functions
function uniform_weights(m)
	return ones(2m+1) / (2m+1)
end

function triangle_weigths(m)
	w = zeros(2m+1)
	for i in 1:(m+1)
		w[i] = i
		w[end-i+1] = i
	end
	w ./= sum(w)
	return w
end	

function gaussian_weigths(m; σ=4)
	w = exp.(-(-m:m).^2 / 2σ^2)
	return w ./ sum(w)
end