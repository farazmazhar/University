%% This function performs bilinear interpolation.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None

function [interpolated] = interpolation(x, y, I)
    [r, c, ~] = size(I);
    
    interpolated = 0;

    uX = floor(x);
    uY = floor(y);
    uXi = uX + 1;
    uYi = uY + 1;
    
    Exi = uXi - x;
    Eyi = uYi - y;
    Ex = x - uX;
    Ey = y - uY;
    
    if (uX <= r && uXi <= r && uY <= c && uYi <= c)
        interpolated = (Exi * Eyi * I(uX, uY)) + (Ex * Eyi * I(uXi, uY)) + (Exi * Ey * I(uX, uYi)) + (Ex * Ey * I(uXi, uYi));
    end
end