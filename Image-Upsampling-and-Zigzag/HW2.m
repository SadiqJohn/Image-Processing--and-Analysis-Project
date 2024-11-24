% CompE565 Homework 2
% Mar. 12, 2022
% Names: Dustin Nguyen, John Sadiq
% IDs: 824783655, 825764388
% Emails: dnguyen2468@sdsu.edu, jsadiq0352@sdsu.edu
% Executing: First, check if all files and the original image are in the
% same folder. Then, run Readme.m.
%-----------------------References--------------------
% HW1, Matlab Commands PDF, Zig-Zag Scan (MathWorks)
% <https://www.mathworks.com/matlabcentral/fileexchange/27078-zig-zag-scan>
%
%-----------------------------------------------------

% Load Image, Convert to YCbCr, and Subsampling
I = imread('Flooded_house.jpg','jpg');      % Read image into I
figure,imshow(I)                            % Show Image
title('Original Image','FontSize',18);
YCbCr = rgb2ycbcr(I);                       % Convert using rgb2ycbcr
% Get each components
Y = uint8(zeros(size(I)));
Y(:,:,1)=YCbCr(:,:,1);
Cb = uint8(zeros(size(I)));
Cb(:,:,2)=YCbCr(:,:,2);
Cr = uint8(zeros(size(I)));
Cr(:,:,3)=YCbCr(:,:,3);
% Subsampling 4:2:0 by reducing half of the x & y pixels
subCb = Cb(1:2:end, 1:2:end);   
subCr = Cr(1:2:end, 1:2:end);
% Cb(:,2:2:size(1,2),:)=[];
% Cb(2:2:size(1,1),:,:)=[];
% Cr(:,2:2:size(1,2),:)=[];
% Cr(2:2:size(1,1),:,:)=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------Encoder-----------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for DCT block processing
blockDCT=@(block_struct) dct2(block_struct.data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a) Compute the 8x8 block DCT transform coefficients of the luminance and 
% chrominance components of the image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Block processing
YDCT = blockproc(Y(:,:,1), [8 8], blockDCT);
CbDCT = blockproc(Cb(:,:,2), [8 8], blockDCT, 'PadPartialBlocks' ,true);
CrDCT = blockproc(Cr(:,:,3), [8 8], blockDCT, 'PadPartialBlocks' ,true);
% Get the Luminance blocks
firstBlock = YDCT(49:56, 1:8);
secondBlock = YDCT(49:56, 9:16);
% Display
display(firstBlock);
display(secondBlock);
figure, imshow(YDCT);
title('Luminance DCT Matrix','FontSize',18);
figure('name','First 2 Luminance Blocks In The 6th Row');
subplot(1,2,1);
firstBlock = imresize(firstBlock, 50, 'box');
imshow(firstBlock);
title('First Block');
subplot(1,2,2);
secondBlock = imresize(secondBlock, 50, 'box');
imshow(secondBlock);
title('Second Block');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% b) Quantize the DCT image by using the JPEG luminance and chrominance
% quantizer matrix from the lecture notes.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Luminance quantization matrix
QLum = [16 11 10 16 24 40 51 61;
        12 12 14 19 26 58 60 55;
        14 13 16 24 40 57 69 56;
        14 17 22 29 51 87 89 62;
        18 22 37 56 68 109 103 77;
        24 35 55 64 81 104 113 92;
        49 64 78 87 108 121 120 101;
        72 92 95 98 112 100 103 99];
% Chrominance quantization matrix
QChroma = [17 18 24 47 99 99 99 99;
           18 21 26 66 99 99 99 99;
           24 26 56 99 99 99 99 99;
           47 66 99 99 99 99 99 99;
           99 99 99 99 99 99 99 99;
           99 99 99 99 99 99 99 99;
           99 99 99 99 99 99 99 99;
           99 99 99 99 99 99 99 99];
% Functions for quantizing the blocks
quantizeY=@(block_struct) round(block_struct.data./QLum);
quantizeCbCr=@(block_struct) round(block_struct.data./QChroma);
% Quantizing each component
quantizedY = blockproc(YDCT, [8 8], quantizeY);
quantizedCb = blockproc(CbDCT, [8 8], quantizeCbCr);
quantizedCr = blockproc(CrDCT, [8 8], quantizeCbCr);
% Quantizing first 2 blocks
quantizedFirstBlock = quantizedY(49:56, 1:8);
quantizedSecondBlock = quantizedY(49:56, 9:16);
% Call zigzag function to get block coefficients
firstBlockCoef = zigzag(quantizedFirstBlock);
secondBlockCoef = zigzag(quantizedSecondBlock);

% Display part a and b
fprintf('First block DC DCT coefficient: %0.2f\n', firstBlock(1));
fprintf('First block AC DCT coefficient matrix:\n')
display(reshape(firstBlockCoef, 8,8));
fprintf('Second block DC DCT coefficient: %0.2f\n', secondBlock(1));
fprintf('Second block AC DCT coefficient matrix:\n')
display(reshape(secondBlockCoef, 8,8));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------Decoder-----------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inverse_YQ = @(block_struct)  block_struct.data.*Q;
inverse_CbCrQ = @(block_struct)  block_struct.data.*QChroma;
inverse_IDCT = @(block_struct) idct2(block_struct.data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c) Compute the inverse Quantized images obtained in Step (b).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dequantized_Y = blockproc(quantizedY, [8 8], inverse_YQ);
dequantized_Cb = blockproc(quantizedCb, [8 8], inverse_CbCrQ);
dequantized_Cr = blockproc(quantizedCr, [8 8], inverse_CbCrQ);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d) Reconstruct the image by computing Inverse DCT coefficients.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
restored_Y = blockproc(dequantized_Y, [8 8], inverse_IDCT);
restored_Cb = upsample(blockproc(dequantized_Cb, [8 8], inverse_IDCT));
restored_Cr = upsample(blockproc(dequantized_Cr, [8 8], inverse_IDCT));
reconstructed_YCbCr = cat(3, uint8(restored_Y),uint8(restored_Cb),uint8(restored_Cr));

% concert from YCBCR to RGB
figure(4)
imshow(ycbcr2rgb(reconstructed_YCbCr));

% Y Image error
image_Error = abs(YCbCr(:,:,1) - reconstructed_YCbCr(:,:,1));
figure, imshow(image_Error, [0 max(image_Error(:))]);
title('Error Image');

% PSNR calculations
MSE = mean(image_Error(:).^2);
PSNR = 10 * log10(255^2/MSE);





