%CompE565 Project 1
%Feb. 13, 2022
%Instructions to execute: Each question has its own solution but was
%commented out for easier debugging, uncomment each section of codes and
%run to get the answer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 1: Display Original Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('Flooded_house.jpg','jpg');      %Read image into I
% figure,imshow(I)                            %Show Image
% title('Original Image','FontSize',18);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 2: Display each band (Red, Green, Blue)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Red = I(:,:,1);             %Get red component into Red
Green = I(:,:,2);           %Get green component
Blue = I(:,:,3);            %Get blue component
z = zeros(size(Red));       %Creates zero values
IRed = cat(3,Red,z,z);      %Creates a matrix with red values
IGreen = cat(3,z,Green,z);  %Creates a matrix with green values
IBlue = cat(3,z,z,Blue);    %Creates a matrix with blue values
%Display each matrix/band
% figure;
% subplot(1,3,1);
% imshow(IRed);        
% title('Red component','FontSize',12);
% subplot(1,3,2);
% imshow(IGreen);
% title('Green component','FontSize',12);
% subplot(1,3,3);
% imshow(IBlue);
% title('Blue component','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 3: Convert the image into YCbCr color space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
YCbCr = rgb2ycbcr(I);   %Convert using rgb2ycbcr
% figure,imshow(YCbCr);
% title('YCrCb Image','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 4: Display each band separately (Y,Cb,Cr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Get each components
Y = YCbCr(:,:,1);
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);
% figure;
% subplot(1,3,1);
% imshow(Y) %Display Y band
% title('Y component','FontSize',12);
% subplot(1,3,2);
% imshow(Cb) %Display Cb band
% title('Cb component','FontSize',12);
% subplot(1,3,3);
% imshow(Cr) %Display Cr band
% title('Cr component','FontSize', 12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 5: Subsample Cb and Cr bands using 4:2:0 and display both
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Subsampling 4:2:0 by reducing half of the x & y pixels
SubCb = Cb(1:2:end, 1:2:end);   
SubCr = Cr(1:2:end, 1:2:end);
% figure;
% subplot(1,2,1);
% imshow(SubCb);
% title('Cb 4:2:0 Subsampling','FontSize', 12);
% subplot(1,2,2);
% imshow(SubCr);
% title('Cr 4:2:0 Subsampling','FontSize', 12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 6: Upsample & display Cb and Cr bands using
% 6.1: Linear interpolation
% 6.2: Simple row or column replication
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%6.1 - Upsampling using linear interpolation
%Filling in rows and columns for Cb1 and Cr1 using the adjacent rows &
%columns (average)
YCbCr2(:,:,1) = YCbCr(:,:,1);
YCbCr2(1:2:535,1:2:703,2) = SubCb(:,:);
YCbCr2(1:2:535,1:2:703,3) = SubCr(:,:);
YCbCr2(1:2:535,2:2:702,2:3) = (double(YCbCr2(1:2:535,1:2:701,2:3)) ...
    + double(YCbCr2(1:2:535,3:2:703,2:3)))/2;
YCbCr2(1:2:535,704,2:3) = YCbCr2(1:2:535,703,2:3);
YCbCr2(2:2:534,:,2:3) = (double(YCbCr2(1:2:533,:,2:3)) ...
    + double(YCbCr2(3:2:535,:,2:3)))/2;
YCbCr2(536,:,2:3) = YCbCr2(535,:,2:3);
% figure;
% subplot(1,2,1);
% imshow(YCbCr2(:,:,2));
% title('Linear Upscaled Cb','FontSize', 12);
% subplot(1,2,2);
% imshow(YCbCr2(:,:,3));
% title('Linear Upscaled Cr','FontSize', 12);
%6.2 - Upsampling using row or column replication
YCbCr3 = YCbCr;
YCbCr3(1:2:535,2:2:704,2:3) = YCbCr3(1:2:535,1:2:703,2:3);
YCbCr3(2:2:536,:,2:3) = YCbCr3(1:2:535,:,2:3);
% figure;
% subplot(1,2,1);
% imshow(YCbCr3(:,:,2));
% title('Replication Upscaled Cb','FontSize', 12);
% subplot(1,2,2);
% imshow(YCbCr3(:,:,3));
% title('Replication Upscaled Cr','FontSize', 12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 7: Convert the image into RGB format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RGB2 = ycbcr2rgb(YCbCr2);
RGB3 = ycbcr2rgb(YCbCr3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 8: Display the original and the reconstructed image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% subplot(2,2,1);
% imshow(I);
% title('Original Image','FontSize', 12);
% subplot(2,2,3);
% imshow(RGB2);
% title('Linear Interpolation Upscaled','FontSize', 12);
% subplot(2,2,4);
% imshow(RGB3);
% title('Row or Column Replication Upscaled','FontSize', 12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 9: Comment on visual quality of the reconstructed images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Looking at both upscaled images from its original size, they seemed to be
%identical to each other, I believed there are differences in quality but
%human eyes can't detect those differences, at least without zooming in.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Question 10: Measure MSE between the original and reconstructed images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate MSE using the fomula provided
%Then devide by (NM):
double CbMSE;
double CrMSE;
CbMSE = 0;
CrMSE = 0;
% Subtract the reconstructed image with original image and get power of 2
% and take the sum and divide by (NM)
for row = 1:1:536
    for col = 1:1:704
    CbMSE = CbMSE + (double(YCbCr2(row,col,2)) ...
        - double(YCbCr(row,col,2))).^2;
    CrMSE = CrMSE + (double(YCbCr2(row,col,3)) ...
        - double(YCbCr(row,col,3))).^2;
    end
end
%Display Results
disp('MSE for Cb: ');
CbMSE = CbMSE / (704*536);
disp(CbMSE);
disp('MSE for Cr: ');
CrMSE = CrMSE / (704*536);
disp(CrMSE);