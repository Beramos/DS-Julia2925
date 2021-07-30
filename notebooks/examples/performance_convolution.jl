#=
Created on 31/01/2021 16:19:17
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Illustrating performance improvements on 2D convolution.
=#

using BenchmarkTools

function convolve_2d(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	fill!(out, 0.0)
	m = div(size(K, 1), 2) 
	for i in 1:n_rows
		for j in 1:n_cols
			for k in -m:m
				for l in -m:m
					out[i,j] += M[clamp(i+k, 1, n_rows), clamp(j+l, 1, n_cols)] * K[k+m+1,l+m+1]
				end
			end
		end
	end
	return out
end

function convolve_2d2(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	fill!(out, 0.0)
	m = div(size(K, 1), 2) 
	for j in 1:n_rows
		for i in 1:n_cols
			for l in -m:m
				for k in -m:m
					out[i,j] += M[clamp(i+k, 1, n_rows), clamp(j+l, 1, n_cols)] * K[k+m+1,l+m+1]
				end
			end
		end
	end
	return out
end

function convolve_2d3(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	fill!(out, 0.0)
	m = div(size(K, 1), 2) 
	for j in 1:n_rows
		for i in 1:n_cols
			for l in -m:m
				for k in -m:m
					@inbounds out[i,j] += M[clamp(i+k, 1, n_rows), clamp(j+l, 1, n_cols)] * K[k+m+1,l+m+1]
				end
			end
		end
	end
	return out
end

function convolve_2d4(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	fill!(out, 0.0)
	m = div(size(K, 1), 2) 
	@simd for j in 1:n_rows
		@simd for i in 1:n_cols
			@simd for l in -m:m
				@simd for k in -m:m
					out[i,j] += M[clamp(i+k, 1, n_rows), clamp(j+l, 1, n_cols)] * K[k+m+1,l+m+1]
				end
			end
		end
	end
	return out
end

function convolve_2d5(M::Matrix, K::Matrix)
	out = similar(M)
	n_rows, n_cols = size(M)
	fill!(out, 0.0)
	m = div(size(K, 1), 2) 
	@simd for j in 1:n_rows
		@simd for i in 1:n_cols
			@simd for l in -m:m
				@simd for k in -m:m
					@inbounds out[i,j] += M[clamp(i+k, 1, n_rows), clamp(j+l, 1, n_cols)] * K[k+m+1,l+m+1]
				end
			end
		end
	end
	return out
end


M = randn(1000, 1000)
K = rand(5, 5)

@btime convolve_2d($M, $K);
@btime convolve_2d2($M, $K);
@btime convolve_2d3($M, $K);
@btime convolve_2d4($M, $K);
@btime convolve_2d5($M, $K);