%% This function will reconstruct an image with four most significant bits of the bitplanes.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * orI = Original image, recI = Reconstructed image.

function [MSE, PSNR] = MSEandPSNR(orI, recI)
    [r, c] = size(orI);
    
    sq_err_img = (double(orI) - double(recI)) .^ 2; % Extracts error image with squared value.
    MSE = (sum(sum(sq_err_img))/(r * c)); % Calculates Mean Square Error.
    PSNR = (10 * log10((255^2)/MSE));