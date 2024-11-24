%IDCT
function [frame] = IDCT(DCT, X, Y, block_size)
	frame = zeros(X, Y);
	
	for i=block_size:block_size:X
		for j=block_size:block_size:Y
			frame(i+1-block_size:i,j+1-block_size:j) = idct2(DCT(i+1-block_size:i,j+1-block_size:j));
		end
	end
end
