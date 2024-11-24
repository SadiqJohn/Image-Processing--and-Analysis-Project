%Motion vectors using conjugate direction search
function [diff_frame, motion, MADs] = Findmotion_vector(curr_Y_frame, ref_Y_frame, m_blocksize, mx_X, mx_Y)
	diff_frame = zeros(size(curr_Y_frame));
	motion = zeros(mx_X, mx_Y, 2);
	MADs = zeros(mx_X, mx_Y);

	for mbNum_X=1:mx_X
		for mbNum_Y=1:mx_Y
			minSAD = 65536; % this is bigger than the largest possible SAD
			for offset_X=-m_blocksize:m_blocksize
				for offset_Y=-m_blocksize:m_blocksize
					if(((((mbNum_X-1)*m_blocksize)+offset_X)>=0)&&((mbNum_X*m_blocksize+offset_X)<=mx_X*m_blocksize)&&((((mbNum_Y-1)*m_blocksize)+offset_Y)>=0)&&((mbNum_Y*m_blocksize+offset_Y)<=mx_Y*m_blocksize))
						tempDiff = cast(curr_Y_frame((mbNum_X-1)*m_blocksize+1:mbNum_X*m_blocksize,(mbNum_Y-1)*m_blocksize+1:mbNum_Y*m_blocksize),'double') ...
								 - ref_Y_frame((mbNum_X-1)*m_blocksize+1+offset_X:mbNum_X*m_blocksize+offset_X,(mbNum_Y-1)*m_blocksize+1+offset_Y:mbNum_Y*m_blocksize+offset_Y);
						tempSAD = sum(sum(abs(tempDiff)));
						if(tempSAD < minSAD)
							minSAD = tempSAD;
							diff_frame((mbNum_X-1)*m_blocksize+1:mbNum_X*m_blocksize,(mbNum_Y-1)*m_blocksize+1:mbNum_Y*m_blocksize) = tempDiff;
							motion(mbNum_X,mbNum_Y,:) = [offset_X offset_Y];
						end
					end
				end
			end

			if ~((minSAD < 128) && (motion(mbNum_X, mbNum_Y, 1) == 0) && (motion(mbNum_X, mbNum_Y, 2) == 0))
				MADs(mbNum_X, mbNum_Y) = minSAD;
			end
		end
	end
end
