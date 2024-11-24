
%function to do the DeQuantize
function [DCT] = Dequantize(quantized, q_b, X, Y, block_size)
	%Quantization matrix
	Q = [8 16 19 22 26 27 29 34;
		16 16 22 24 27 29 34 37;
		19 22 26 27 29 34 34 38;
		22 22 26 27 29 34 37 40;
		22 26 27 29 32 35 40 48;
		26 27 29 32 35 40 48 58;
		26 27 29 34 38 46 56 69;
		27 29 35 38 46 56 69 83];

	DCT = zeros(X, Y);

	for i=block_size:block_size:X
		for j=block_size:block_size:Y
			DCT(i+1-block_size:i,j+1-block_size:j) = ...
				quantized(i+1-block_size:i,j+1-block_size:j).*Q.*q_b(i/block_size, j/block_size);
		end
	end
end
