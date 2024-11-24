function [diff_frame] = FindDiffFrame(motion, current_frame, ref_frame, block_size, block_X, block_Y, MADs) %function to find difference frame
	diff_frame = zeros(size(current_frame));
	current_frame = cast(current_frame, 'double');

	for blockNum_X = 1:block_X
		for blockNum_Y = 1:block_Y
			if MADs(blockNum_X, blockNum_Y) >=128
				diff_frame((blockNum_X-1)*block_size+1:blockNum_X*block_size,(blockNum_Y-1)*block_size+1:blockNum_Y*block_size) = ...
					current_frame((blockNum_X-1)*block_size+1:blockNum_X*block_size,(blockNum_Y-1)*block_size+1:blockNum_Y*block_size) ...
					- ref_frame((blockNum_X-1)*block_size+1+motion(blockNum_X,blockNum_Y,1):blockNum_X*block_size+motion(blockNum_X,blockNum_Y,1),...
										  (blockNum_Y-1)*block_size+1+motion(blockNum_X,blockNum_Y,2):blockNum_Y*block_size+motion(blockNum_X,blockNum_Y,2));
			end
		end
	end
end
