%% This function will perform piecewise linear transformation for contrast stretching.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None.

function piecewisetransform(I)
    [img_r, img_c] = size(I);
    r1 = 100;
    s1 = 60;
    r2 = 180;
    s2 = 220;
    
    slopeA = (s1 - 0)/(r1 - 0);
    slopeB = (s2 - s1)/(r2 - r1);
    slopeC = (255 - s2)/(255 - r2);
    
    subplot(2,2,1); imshow(I);
    subplot(2,2,3); imhist(I);
    
    for i = 1:img_r
        for j = 1:img_c
            if (I(i,j) < r1)
                I(i,j) = slopeA * I(i,j); % used only I(i,j) because for slopeA, s1 and r1 are 0.
            elseif (I(i,j) < r2)
                I(i,j) = slopeB * (I(i,j) - r1) + s1;
            elseif (I(i,j) >= r2)
                I (i,j) = slopeC * (I(i,j) - r2) + s2;
            end
        end
    end
    
    subplot(2,2,2); imshow(I);
    subplot(2,2,4); imhist(I);
    imwrite(I, 'D:\Transformed.tif');