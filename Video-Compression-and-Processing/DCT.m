% DCT function to do the DCT in the encodeing
function [DCT] = DCT(frame, X, Y, block_size)
	DCT = zeros(X, Y);

	for i=block_size:block_size:X
		for j=block_size:block_size:Y
			DCT(i+1-block_size:i,j+1-block_size:j) = dct2(frame(i+1-block_size:i,j+1-block_size:j));
		end
	end
end
