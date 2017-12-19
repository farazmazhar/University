%% This function will return all or specific bitplane of an image.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None.
% NOTE:
%  * Variables names from template were replaced by more descriptive names.
%  * im -> I, y -> bitplanes, n -> bit.

function [ibp] = showImageBitPlanes(I, bit)
    [r,c]= size(I);
    bitplanes = zeros(r,c,8);
    
    for i=1:r
        for j=1:c            
            bitplane = de2bi(I(i,j),8,'left-msb');            
            bitplanes(i,j,:) = bitplane;
        end
    end
    

    if (nargin == 1)
        ibp = bitplanes;
        bit = 0;
    elseif (nargin == 2)
        ibp = bitplanes(:,:, bit);
    end
    
    switch bit
        case 1
            disp('First bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 2
            disp('Second bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 3
            disp('Third bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 4
            disp('Fourth bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 5
            disp('Fifth bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 6
            disp('Sixth bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 7
            disp('Seventh bit plane');            
            subplot(2,1,2); imshow(ibp);
        case 8
            disp('Eighth bit plane');            
            subplot(2,1,2); imshow(ibp);
        otherwise
            disp('All bit planes');
            subplot(3,3,1); imshow(I);
            for i=2:9
                subplot(3,3,i); imshow(ibp(:,:,i-1));
            end
    end