function encode(Video, gop_length, Block_size, X, Y, file_name)


	M_block = Block_size*2;

	block_X = X/Block_size;
	block_Y = Y/Block_size;


	MAD = 0;
	MV = 0;

	OutputFile = fopen(file_name, 'w');

	for frame = 1:5
		[Y, CB, CR] = SubSample(rgb2ycbcr(Video(:,:,:,frame)));

        % Procees the 'I' frame

		if mod(frame,gop_length) == 1
			dct_Y = DCT(Y, X, Y, Block_size);
			dct_CB = DCT(CB, X/2, Y/2, Block_size);
			dct_CR = DCT(CR, X/2, Y/2, Block_size);

        % Process 'P' frames

        else
			[Diff, MV, MAD] = Findmotion_vector(Y, decode_Y, M_block, block_X/2, block_Y/2);

            % Display motion vectors
            figure(frame);
            [X,Y]= meshgrid(1:11,1:9);
            quiver(X,Y,MV(:,:,1),MV(:,:,2))
            title (['Motion Vector - ',num2str(frame)])
            axis ij;
            saveas(figure(frame), ['MV - frame',num2str(frame), '.png'])
			p_CB = FindDiffFrame(round(MV./2), CB, decode_CB, Block_size, block_X/2, block_Y/2, MAD);
			p_CR = FindDiffFrame(round(MV./2), CR, decode_CR, Block_size, block_X/2, block_Y/2, MAD);

			dct_Y = DCT(Diff,X,Y,Block_size);
			dct_CB = DCT(p_CB,X/2,Y/2,Block_size);
			dct_CR = DCT(p_CR,X/2,Y/2,Block_size);
        end

        % Perform quantization
		[q_Y, qb_Y] = Quantize(dct_Y, X, Y, Block_size);
		[q_CB, qb_CB] = Quantize(dct_CB, X/2, Y/2, Block_size);
		[q_CR, qb_CR] = Quantize(dct_CR, X/2, Y/2, Block_size);

        % Perform ZigZag Coding
		[coeffient_Y_DC, zigzag_Y] = ZigZag(q_Y, block_X, block_Y);
		[coeffient_CB_DC, zigzag_CB] = ZigZag(q_CB, block_X/2, block_Y/2);
		[coeffient_CR_DC, zigzag_CR] = ZigZag(q_CR, block_X/2, block_Y/2);

		% Cast to ints to fix errors due to using doubles
		MV = cast(MV, 'int8');
		coeffient_Y_DC = cast(coeffient_Y_DC, 'int8');
		coeffient_CB_DC = cast(coeffient_CB_DC, 'int8');
		coeffient_CR_DC = cast(coeffient_CR_DC, 'int8');
		zigzag_Y = cast(zigzag_Y, 'int8');
		zigzag_CB = cast(zigzag_CB, 'int8');
		zigzag_CR = cast(zigzag_CR, 'int8');
		qb_Y = cast(qb_Y, 'int8');
		qb_CB = cast(qb_CB, 'int8');
		qb_CR = cast(qb_CR, 'int8');

        % Save data into file to be used for decoding
		writeToFile(OutputFile, block_X/2, block_Y/2, mod(frame,gop_length) == 1, MAD, ...
			MV, coeffient_Y_DC, zigzag_Y, qb_Y, coeffient_CB_DC, zigzag_CB, qb_CB, coeffient_CR_DC, zigzag_CR, qb_CR);

		% Cast to double to reduce truncation errors
		MV = cast(MV, 'double');
		coeffient_Y_DC = cast(coeffient_Y_DC, 'double');
		coeffient_CB_DC = cast(coeffient_CB_DC, 'double');
		coeffient_CR_DC = cast(coeffient_CR_DC, 'double');
		zigzag_Y = cast(zigzag_Y, 'double');
		zigzag_CB = cast(zigzag_CB, 'double');
		zigzag_CR = cast(zigzag_CR, 'double');
		qb_Y = cast(qb_Y, 'double');
		qb_CB = cast(qb_CB, 'double');
		qb_CR = cast(qb_CR, 'double');

 		dezigzag_Y = Inv_ZigZag(coeffient_Y_DC, zigzag_Y, block_X, block_Y);
 		dezigzag_CB = Inv_ZigZag(coeffient_CB_DC, zigzag_CB, block_X/2, block_Y/2);
 		dezigzag_CR = Inv_ZigZag(coeffient_CR_DC, zigzag_CR, block_X/2, block_Y/2);

		deq_Y = Dequantize(dezigzag_Y, qb_Y, X, Y, Block_size);
		deq_CB = Dequantize(dezigzag_CB, qb_CB, X/2, Y/2, Block_size);
		deq_CR = Dequantize(dezigzag_CR, qb_CR, X/2, Y/2, Block_size);

		% Process I frame to be used for subsequent frames
        if mod(frame,gop_length) == 1
			decode_Y = IDCT(deq_Y, X, Y, Block_size);
			decode_CB = IDCT(deq_CB, X/2, Y/2, Block_size);
			decode_CR = IDCT(deq_CR, X/2, Y/2, Block_size);

        % Process P frames to be used for subsequent frames
        else
			idct_Y = IDCT(deq_Y, X, Y, Block_size);
			idct_CB = IDCT(deq_CB, X/2, Y/2, Block_size);
			idct_CR = IDCT(deq_CR, X/2, Y/2, Block_size);

			decode_Y = FindSumFrame(MV(:,:,:), idct_Y, decode_Y, M_block, block_X/2, block_Y/2);
			decode_CB = FindSumFrame(round(MV(:,:,:)./2), idct_CB, decode_CB, Block_size, block_X/2, block_Y/2);
			decode_CR = FindSumFrame(round(MV(:,:,:)./2), idct_CR, decode_CR, Block_size, block_X/2, block_Y/2);
		end

		fprintf('Encoded Frame %u\n',frame);
	end
	disp('------------ Encoding complete -------------');

	fclose(OutputFile);
end
