function decoded = decode(GOPsize, block_size, X_number, Y_number, filename_input)
	block_X = X_number/block_size;
	block_Y = Y_number/block_size;
	M_block = block_size*2;
    frames_number=5;

	decoded = zeros(X_number, Y_number, 3, frames_number);

	[frame_type, motion_vector, coeffient_Y_DC, zigzag_Y, q_Y, coeffient_CB_DC, zigzag_CB, q_CB, coeffient_CR_DC, zigzag_CR, q_CR] = readFromFile(filename_input, GOPsize, block_X/2, block_Y/2, frames_number);

	for Frame_Number = 1:frames_number
        % Reverse zigzag encoding
		dezigzag_Y = Inv_ZigZag(coeffient_Y_DC(:,:,Frame_Number), zigzag_Y(:,:,:,Frame_Number), block_X, block_Y);
		dezigzag_CB = Inv_ZigZag(coeffient_CB_DC(:,:,Frame_Number), zigzag_CB(:,:,:,Frame_Number), block_X/2, block_Y/2);
		dezigzag_CR = Inv_ZigZag(coeffient_CR_DC(:,:,Frame_Number), zigzag_CR(:,:,:,Frame_Number), block_X/2, block_Y/2);
		% Dequantize image components
		deq_Y = Dequantize(dezigzag_Y, q_Y(:,:,Frame_Number), X_number, Y_number, block_size);
		deq_CB = Dequantize(dezigzag_CB, q_CB(:,:,Frame_Number), X_number/2, Y_number/2, block_size);
		deq_CR = Dequantize(dezigzag_CR, q_CR(:,:,Frame_Number), X_number/2, Y_number/2, block_size);

        % Process I Frame
		if frame_type(Frame_Number) == 1
			decode_Y = IDCT(deq_Y, X_number, Y_number, block_size);
			decode_CB = IDCT(deq_CB, X_number/2, Y_number/2, block_size);
			decode_CR = IDCT(deq_CR, X_number/2, Y_number/2, block_size);
        % Process P frames
        else
			idct_Y = IDCT(deq_Y, X_number, Y_number, block_size);
			idct_CB = IDCT(deq_CB, X_number/2, Y_number/2, block_size);
			idct_CR = IDCT(deq_CR, X_number/2, Y_number/2, block_size);

			decode_Y = FindSumFrame(motion_vector(:,:,:,Frame_Number), idct_Y, decode_Y, M_block, block_X/2, block_Y/2);
			decode_CB = FindSumFrame(round(motion_vector(:,:,:,Frame_Number)./2), idct_CB, decode_CB, block_size, block_X/2, block_Y/2);
			decode_CR = FindSumFrame(round(motion_vector(:,:,:,Frame_Number)./2), idct_CR, decode_CR, block_size, block_X/2, block_Y/2);
		end

		decoded(:,:,:,Frame_Number) = ycbcr2rgb(cast(Upsample(decode_Y, decode_CB, decode_CR),'uint8'));

		fprintf('Decoded Frame %u\n', Frame_Number);
	end
	disp('------------- Decoding complete -------------');
end
