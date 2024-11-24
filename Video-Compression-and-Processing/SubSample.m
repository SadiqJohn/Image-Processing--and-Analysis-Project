% YCBCR 4:2:0 Subsampling
function [Y, CB, CR] = SubSample(YCBCR)
	Y = YCBCR(:,:,1);
	CB = YCBCR(1:2:end,1:2:end,2);
	CR = YCBCR(1:2:end,1:2:end,3);
end
