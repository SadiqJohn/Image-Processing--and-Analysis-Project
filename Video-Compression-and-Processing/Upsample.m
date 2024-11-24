
% Chroma half the luma characteristics
% Upsampling using Simple X Y replication 


function [YCBCR] = Upsample420(Y, CB, CR)
	[X, Y] = size(Y);
	YCBCR = zeros(X, Y, 3);

	YCBCR(:,:,1) = Y;


	YCBCR(1:2:end, 1:2:end, 2) = CB;
	YCBCR(2:2:end, 1:2:end, 2) = YCBCR(1:2:end, 1:2:end, 2);
	YCBCR(:, 2:2:end, 2) = YCBCR(:, 1:2:end, 2);

	YCBCR(1:2:end, 1:2:end, 3) = CR;
	YCBCR(2:2:end, 1:2:end, 3) = YCBCR(1:2:end, 1:2:end, 3);
	YCBCR(:, 2:2:end, 3) = YCBCR(:, 1:2:end, 3);
end
