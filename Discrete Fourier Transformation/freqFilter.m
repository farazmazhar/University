%% This function will multiply two matrix that are in fourier spectrum.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * freq and mask are in frequency domain.

function [filtered] = freqFilter(freq, mask)
    [row, col] = size(freq);
    filtered = zeros(row, col);
    
    for x = 1:row
        for y = 1:col
            filtered(x, y) = (freq(x, y) * mask(x, y));
        end
    end         
end