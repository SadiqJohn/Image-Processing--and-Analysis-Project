function [frame_type, motion_vector, coeffient_Y_DC, zigzag_Y, q_Y, coeffient_CB_DC, zigzag_CB, q_CB, coeffient_CR_DC, zigzag_CR, q_CR] = readFromFile(filename_input, GOPsize, numMBX, numMBY, frames_number)
	inputFile = fopen(filename_input, 'r');

	frame_type = zeros(1, frames_number);
	motion_vector = zeros(numMBX, numMBY, 2, frames_number);
	coeffient_Y_DC = zeros(numMBX*2, numMBY*2, frames_number);
	coeffient_CB_DC = zeros(numMBX, numMBY, frames_number);
	coeffient_CR_DC = zeros(numMBX, numMBY, frames_number);
	zigzag_Y = zeros(numMBX*2, numMBY*2, 63, frames_number);
	zigzag_CB = zeros(numMBX, numMBY, 63, frames_number);
	zigzag_CR = zeros(numMBX, numMBY, 63, frames_number);
	q_Y = zeros(numMBX*2, numMBY*2, frames_number);
	q_CB = zeros(numMBX, numMBY, frames_number);
	q_CR = zeros(numMBX, numMBY, frames_number);

	for Frame_Number = 1:frames_number
		frameStartCode = fread(inputFile, 1, 'uint8');
		if frameStartCode ~= 238; % new frame
			error('New Frame (0xEE) expected, but %X was found for frame# %u', frameStartCode, Frame_Number)
		end

		for mbNum_X=1:numMBX
			for mbNum_Y=1:numMBY
				frame_type(Frame_Number) = fread(inputFile, 1, 'uint8');

				if ((frame_type(Frame_Number) == 0) || (frame_type(Frame_Number) == 1))
					if mod(Frame_Number,GOPsize) == 1 % if this is an I frame
						if frame_type(Frame_Number) == 0
							error('This is an I frame, but the MacroBlock code was %u. frame# %u, mbNum_X = %u, mbNum_Y = %u', frame_type(Frame_Number), Frame_Number, mbNum_X, mbNum_Y)
						end
					else	% P frame
						if frame_type(Frame_Number) == 1
							error('This is a P frame, but the MacroBlock code was %u. frame# %u, mbNum_X = %u, mbNum_Y = %u', frame_type(Frame_Number), Frame_Number, mbNum_X, mbNum_Y)
						end
						motion_vector(mbNum_X, mbNum_Y, 1, Frame_Number) = fread(inputFile, 1, 'int8');
						motion_vector(mbNum_X, mbNum_Y, 2, Frame_Number) = fread(inputFile, 1, 'int8');
					end

					% top left Y block
					coeffient_Y_DC((mbNum_X*2)-1, (mbNum_Y*2)-1, Frame_Number) = fread(inputFile, 1, 'int8');
					zigzag_Y((mbNum_X*2)-1, (mbNum_Y*2)-1, :, Frame_Number) = fread(inputFile, 63, 'int8');
					q_Y((mbNum_X*2)-1, (mbNum_Y*2)-1, Frame_Number) = fread(inputFile, 1, 'int8');

					% top right Y block
					coeffient_Y_DC((mbNum_X*2)-1, mbNum_Y*2, Frame_Number) = fread(inputFile, 1, 'int8');
					zigzag_Y((mbNum_X*2)-1, mbNum_Y*2, :, Frame_Number) = fread(inputFile, 63, 'int8');
					q_Y((mbNum_X*2)-1, mbNum_Y*2, Frame_Number) = fread(inputFile, 1, 'int8');

					% bottom left Y block
					coeffient_Y_DC(mbNum_X*2, (mbNum_Y*2)-1, Frame_Number) = fread(inputFile, 1, 'int8');
					zigzag_Y(mbNum_X*2, (mbNum_Y*2)-1, :, Frame_Number) = fread(inputFile, 63, 'int8');
					q_Y(mbNum_X*2, (mbNum_Y*2)-1, Frame_Number) = fread(inputFile, 1, 'int8');

					% bottom right Y block
					coeffient_Y_DC(mbNum_X*2, mbNum_Y*2, Frame_Number) = fread(inputFile, 1, 'int8');
					zigzag_Y(mbNum_X*2, mbNum_Y*2, :, Frame_Number) = fread(inputFile, 63, 'int8');
					q_Y(mbNum_X*2, mbNum_Y*2, Frame_Number) = fread(inputFile, 1, 'int8');

					% CB block
					coeffient_CB_DC(mbNum_X, mbNum_Y, Frame_Number) = fread(inputFile, 1, 'int8');
					zigzag_CB(mbNum_X, mbNum_Y, :, Frame_Number) = fread(inputFile, 63, 'int8');
					q_CB(mbNum_X, mbNum_Y, Frame_Number) = fread(inputFile, 1, 'int8');

					% CR block
					coeffient_CR_DC(mbNum_X, mbNum_Y, Frame_Number) = fread(inputFile, 1, 'int8');
					zigzag_CR(mbNum_X, mbNum_Y, :, Frame_Number) = fread(inputFile, 63, 'int8');
					q_CR(mbNum_X, mbNum_Y, Frame_Number) = fread(inputFile, 1, 'int8');

				elseif frame_type(Frame_Number) == 2	% P frame that isn't stored
					if mod(Frame_Number,GOPsize) == 1
						error('This is an I frame, but the MacroBlock code was %u. frame# %u, mbNum_X = %u, mbNum_Y = %u', frame_type(Frame_Number), Frame_Number, mbNum_X, mbNum_Y)
					end
				else
					error('MacroBlock code (0, 1, 2) expected, but %u was found. frame# %u, mbNum_X = %u, mbNum_Y = %u', frame_type(Frame_Number), Frame_Number, mbNum_X, mbNum_Y)
				end
			end
		end
	end

	fclose(inputFile);



	% cast to double to prevent truncation errors
	frame_type = cast(frame_type, 'double');
	motion_vector = cast(motion_vector, 'double');
	coeffient_Y_DC = cast(coeffient_Y_DC, 'double');
	coeffient_CB_DC = cast(coeffient_CB_DC, 'double');
	coeffient_CR_DC = cast(coeffient_CR_DC, 'double');
	zigzag_Y = cast(zigzag_Y, 'double');
	zigzag_CB = cast(zigzag_CB, 'double');
	zigzag_CR = cast(zigzag_CR, 'double');
	q_Y = cast(q_Y, 'double');
	q_CB = cast(q_CB, 'double');
	q_CR = cast(q_CR, 'double');

end
