% For Reconstruction, the following are used :
% 1. Original Image 2. Errorframe 3. Motion Vector.
% Error image that has generated from the MV is added pixel by pixel to the
% reference frame to retrieve the target frame.


function [frames] = Reconstruct(iFrame, errFrame, motion_vectors)
	[X Y 5] = size(errFrame);
	frames(:,:,1:5+1) = zeros(X, Y, 5+1);
	frames(:,:,1) = iFrame;
	for frame=1:5
		for macroBlock_X = 1:X/16
			for macroBlock_Y = 1:Y/16
				frames(16*(macroBlock_X-1)+1:16*macroBlock_X,16*(macroBlock_Y-1)+1:16*macroBlock_Y,frame+1) = errFrame(16*(macroBlock_X-1)+1:16*macroBlock_X,16*(macroBlock_Y-1)+1:16*macroBlock_Y,frame)...
					+ frames(16*(macroBlock_X-1)+1+motion_vectors(macroBlock_X,macroBlock_Y,1,frame):16*macroBlock_X+motion_vectors(macroBlock_X,macroBlock_Y,1,frame),...
						16*(macroBlock_Y-1)+1+motion_vectors(macroBlock_X,macroBlock_Y,2,frame):16*macroBlock_Y+motion_vectors(macroBlock_X,macroBlock_Y,2,frame),...
						frame);
			end
		end
	end
end
