% Image Processing Project - Flooded House Analysis
% Demonstrates basic image processing techniques in MATLAB.
% Created on Feb. 13, 2022

% Instructions:
% Each section contains a specific image processing task. Uncomment the relevant
% section of the code and run it to observe the output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 1: Display the Original Image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('Flooded_house.jpg', 'jpg');       % Read the image into variable I
% figure, imshow(I)                            % Display the image
% title('Original Image', 'FontSize', 18);     % Add a title to the image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 2: Extract and Display Individual Color Channels (Red, Green, Blue)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Red = I(:, :, 1);             % Extract the red channel
Green = I(:, :, 2);           % Extract the green channel
Blue = I(:, :, 3);            % Extract the blue channel
z = zeros(size(Red));         % Create a matrix of zeros for merging

% Combine each channel into isolated color images
IRed = cat(3, Red, z, z);     % Image with only the red channel
IGreen = cat(3, z, Green, z); % Image with only the green channel
IBlue = cat(3, z, z, Blue);   % Image with only the blue channel

% Uncomment to display each channel:
% figure, imshow(IRed), title('Red Channel', 'FontSize', 18);
% figure, imshow(IGreen), title('Green Channel', 'FontSize', 18);
% figure, imshow(IBlue), title('Blue Channel', 'FontSize', 18);
