%% This function will reconstruct an image with four most significant bits of the bitplanes.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None.

function [recI] = fourMSBtoImage(bitplanes) % Takes bitplanes as an arguement.
    [r, c, bitplane] = size(bitplanes);
    fourMSBbitplane = zeros(size(bitplanes));
    recI = zeros(r, c, 'uint8');
    
    for i=1:r
        for j=1:c
            for bit=1:4
                fourMSBbitplane(i,j,bit) = bitplanes(i,j,bit);
            end
        end
    end
    
    for i=1:r
        for j=1:c
            for k=1:4
                recI(i, j) = recI(i, j) + (fourMSBbitplane(i,j,k) * 2^(9 - k));
            end
        end
    end
    
    subplot(3,3,1); imshow(recI);
    for i=2:9
        subplot(3,3,i); imshow(fourMSBbitplane(:,:,i-1));
    end
    
    imwrite(recI, 'D:/reconstructedDollar.tif');
    