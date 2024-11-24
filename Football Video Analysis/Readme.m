% This is the main.m file - ready for execution
% CompE565 Homework 3
% April 3, 2022
% Names: Dustin Nguyen, John Sadiq
% IDs: 824783655, 825764388
% Emails: dnguyen2468@sdsu.edu, jsadiq0352@sdsu.edu
% Executing: Make sure the video file is in the same directory as the
% Readme.m. Then, run Readme.m on Matlab.

clc;
close all;
% Extract frames (#10 to #14)
frames = read(VideoReader('football_qcif.avi'), [10 14]); 
% Define MacroBlock
MB = 16;                                       
MBsize = 8;
% Extract frame size
[width,height] = size(frames(:,:,1));
% Initialize Motion Vectors
MVex = zeros(1,4,4);

% Initialize MAD
MADminEX = zeros(width/MB,height/MB,4);

% Initialize Residue
residueEX = zeros(width,height,4);

% Initialize Prediction
PredictEX = zeros(width,height,4);

% Initialize Reconstruction
ReconEX = zeros(width,height,4);

% Initialize Addition Values
addEX = 0;

% Initialize Comparison Values
comparisonEX = 0;

% Temporary Errors
blockErrorT = zeros(16,16);
blockErrorP = zeros(16,16);
% Frames Processing
for n = 1:4
    % Get the reference frame
    ref = frames(:,:,1,n);
    % Get the current frame
    current = frames(:,:,1, n+1);
    % Init indexes
    i = 1;
    j = 1;
    k = 1;
    for row = 1:MB:width
        for column = 1:MB:height
            % Set window values
            wl = 8;
            wr = 8;
            wu = 8;
            wd = 8;
            if (column == 1)
                wl = 0;
            end
            if (column == (height-MB+1))
                wr = 0;
            end
            if (row == 1)
                wu = 0;
            end
            if (row == (width-MB+1))
                wd = 0;
            end
            % Get current MB
            curMB = current(row:row+15,column:column+15);
            % Get ref MB
            refMB = ref(-wu+row:-wu+row+MB-1,-wl+column:-wl+column+MB-1);
            % Assign the ref MB as predicted value
            pred = refMB;
            % Calculate error
            blockErrorP = int16(curMB)-int16(refMB);
            % Calculate mad for assigned block
            MADp = sum(abs(blockErrorP(:)));
            % Get assigned block
            MVex(i,1:4,n) = [column row -wl wu];
            % Find the minimum MAD 
            for rw = -wu:wd 
                for cw = -wl:wr
                    % Assign MAD value, error, predicted, and motion vector
                    % Update additions and comparisons
                    refMB = ref(rw+row:rw+row+15,cw+column:cw+column+15);
                    blockErrorT = int16(curMB)-int16(refMB);
                    MADt = sum(abs(blockErrorT(:)));
                    addEX = addEX + (2*16*16);
                    comparisonEX = comparisonEX + 1;
                    if (MADt<MADp)
                        MADp = MADt;
                        blockErrorP = blockErrorT;
                        MVex(i,3:4,n) = [cw -rw];
                        pred = refMB;
                    end
                end
            end
            % Increment indexes
            k = k+1;
            i = i+1;
            % Assigned reconstructed values
            MADminEX(j,k,n) = MADp;
            residueEX(row:row+15,column:column+15,n) = blockErrorP;
            PredictEX(row:row+15,column:column+15,n) = pred;
            ReconEX(row:row+15,column:column+15,n) = int16(pred)+blockErrorP;
        end
        j = j+1;
        k = 1;
    end
end
% Generate figures
for n = 1:4
    figure(1)
    subplot(2,2,n)
    imshow(uint8(PredictEX(:,:,n)))
    title(['Predicted Frame ',num2str(n),' (Exhaustive)']);
    figure(2)
    subplot(2,2,n)
    quiver(MVex(:,1,n),MVex(:,2,n),MVex(:,3,n),MVex(:,4,n))
    axis('manual',[0 width 0 height])
    title(['Quiver Motion Vectors ',num2str(n),' (Exhaustive)']);
    figure(3)
    subplot(2,2,n)
    imshow(uint8(residueEX(:,:,n)))
    title(['Residue ',num2str(n),' (Exhaustive)']);
    figure(4)
    subplot(2,2,n)
    imshow(uint8(ReconEX(:,:,n)))
    title(['Reconstructed Image ',num2str(n),' (Exhaustive)']);
    if (n == 4) 
        saveas(figure(1), 'PredictedFramesEx.png')
        saveas(figure(2), 'MotionVectorsEx.png')
        saveas(figure(3), 'residueEX.png')
        saveas(figure(4), 'ReconstructedEx.png')
    end
end
% Show number of additions and comparison
addEX
comparisonEX
