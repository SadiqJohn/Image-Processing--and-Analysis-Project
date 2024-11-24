% Function "write to file " is used to tranfer data from Buffer (storage)
%----------------------------------------------------------------------------------------------------------------
function writeToFile(file_output, mx_X, mx_Y, frame_type, MADs, motion_vectors, coeffient_Y_DC, zigzag_Y, qb_Y, coeffient_CB_DC, zigzag_CB, qb_CB, coeffient_CR_DC, zigzag_CR, qb_CR)
	fwrite(file_output, 238, 'uint8'); %%% Evaluation of the new frame %%%%


	for mbNum_X=1:mx_X
		for mbNum_Y=1:mx_Y
			if ((frame_type == 0) && (MADs(mbNum_X, mbNum_Y) < 128) && (motion_vectors(mbNum_X, mbNum_Y, 1) == 0) &&(motion_vectors(mbNum_X, mbNum_Y, 2) == 0))
					fwrite(file_output, 2, 'uint8');
			else
				fwrite(file_output, frame_type, 'uint8'); % frame type

				if (frame_type == 0)	% P frame
					fwrite(file_output, motion_vectors(mbNum_X, mbNum_Y, 1), 'int8');
					fwrite(file_output, motion_vectors(mbNum_X, mbNum_Y, 2), 'int8');
				end

				% top left Y block
				fwrite(file_output, coeffient_Y_DC((mbNum_X*2)-1, (mbNum_Y*2)-1), 'int8');
				fwrite(file_output, zigzag_Y((mbNum_X*2)-1, (mbNum_Y*2)-1, :), 'int8');
				fwrite(file_output, qb_Y((mbNum_X*2)-1, (mbNum_Y*2)-1), 'int8');

				% top right Y block
				fwrite(file_output, coeffient_Y_DC((mbNum_X*2)-1, mbNum_Y*2), 'int8');
				fwrite(file_output, zigzag_Y((mbNum_X*2)-1, mbNum_Y*2, :), 'int8');
				fwrite(file_output, qb_Y((mbNum_X*2)-1, mbNum_Y*2), 'int8');

				% bottom left Y block
				fwrite(file_output, coeffient_Y_DC(mbNum_X*2, (mbNum_Y*2)-1), 'int8');
				fwrite(file_output, zigzag_Y(mbNum_X*2, (mbNum_Y*2)-1, :), 'int8');
				fwrite(file_output, qb_Y(mbNum_X*2, (mbNum_Y*2)-1), 'int8');

				% bottom right Y block
				fwrite(file_output, coeffient_Y_DC(mbNum_X*2, mbNum_Y*2), 'int8');
				fwrite(file_output, zigzag_Y(mbNum_X*2, mbNum_Y*2, :), 'int8');
				fwrite(file_output, qb_Y(mbNum_X*2, mbNum_Y*2), 'int8');

				% CB block
				fwrite(file_output, coeffient_CB_DC(mbNum_X, mbNum_Y), 'int8');
				fwrite(file_output, zigzag_CB(mbNum_X, mbNum_Y, :), 'int8');
				fwrite(file_output, qb_CB(mbNum_X, mbNum_Y), 'int8');

				% CR block
				fwrite(file_output, coeffient_CR_DC(mbNum_X, mbNum_Y), 'int8');
				fwrite(file_output, zigzag_CR(mbNum_X, mbNum_Y, :), 'int8');
				fwrite(file_output, qb_CR(mbNum_X, mbNum_Y), 'int8');
			end
		end
	end
end
