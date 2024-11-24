function [sum_frame] = FindSumFrame(motion, diff_frame, ref_frame, block_size, block_X, block_Y)
	sum_frame = zeros(size(diff_frame));

	for blockNum_X = 1:block_X
		for blockNum_Y = 1:block_Y
			sum_frame((blockNum_X-1)*block_size+1:blockNum_X*block_size,(blockNum_Y-1)*block_size+1:blockNum_Y*block_size) = ...
				diff_frame((blockNum_X-1)*block_size+1:blockNum_X*block_size,(blockNum_Y-1)*block_size+1:blockNum_Y*block_size) ...
				+ ref_frame((blockNum_X-1)*block_size+1+motion(blockNum_X,blockNum_Y,1):blockNum_X*block_size+motion(blockNum_X,blockNum_Y,1),...
								 (blockNum_Y-1)*block_size+1+motion(blockNum_X,blockNum_Y,2):blockNum_Y*block_size+motion(blockNum_X,blockNum_Y,2));
		end
	end
end
