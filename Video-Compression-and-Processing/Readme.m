% CompE565 HW 4
% 04/26/2019
% Name: Fadee Kannah
% ID: 814844284
% email: fadeekannah@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ReadMe
% - Make sure the football_qcif.avi is in the same directory
% - Make sure all the addtional procedures are in the directory as well
% - Click the run button in the editor tab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

% Read the video
Videofile = read(VideoReader('football_qcif.avi'), [2 6]);

gop_length = 5;
block_size = 8;

[X,Y,c] = size(Videofile(:,:,:,1));
file_name = 'transmition';

encode(Videofile, gop_length, block_size,X,Y, file_name);
Decoded_Video = decode(gop_length, block_size,X,Y,file_name);

% display the original, reconstructed and error frames

fig = figure();

for i = 1:5
	subplot(5,3,1 + 3 * (i-1));
	imshow(Videofile(:,:,:,i));
	title(['Original frame - ',num2str(i)])
	subplot(5,3,2 + 3 * (i-1));
	imshow(cast(Decoded_Video(:,:,:,i), 'uint8'))
	title(['Reconstructed frame - ',num2str(i)])
    subplot(5,3,3 + 3 * (i-1));
    orig = rgb2ycbcr(Videofile(:,:,:,i));
    decoded = rgb2ycbcr(cast(Decoded_Video(:,:,:,i), 'uint8'));
    err = abs(orig(:,:,1) - decoded(:,:,1));
    imshow(err, [0 max(err(:))]);
    title (['Error frame - ',num2str(i)])
    set(fig, 'Position',  [0, 40, 800, 900])
end
saveas(fig, 'frames.png')
