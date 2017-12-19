%% This function will perform piecewise linear transformation for contrast stretching.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None.

function myHistogramEquilization(I)
    [r, c] = size(I);
    
    occur = zeros(256); % to hold number of occuraces of pixel values.
    s = zeros(256); % to hold values after applying CDF.
    
    % Counting number of occurances/
    for i = 1:r
        for j = 1:c
            pixval = (I(i,j) + 1);
            occur(pixval) = occur(pixval) + 1;
        end
    end

    sum = 0;
    
    % Calculating CDF
    for k = 1:256
        sum = sum + occur(k);
        s(k) = (255/(r*c)) * sum;
    end

    subplot(2,2,1); imshow(I); subplot(2,2,3); imhist(I);    
    
    % Applying CDF
    for i = 1:r
        for j = 1:c
            pixval = I(i, j);
            I(i,j) = s(pixval + 1);
        end
    end

    subplot(2,2,2); imshow(I); subplot(2,2,4); imhist(I);
    imwrite(I, 'D:\Equalized.tif');