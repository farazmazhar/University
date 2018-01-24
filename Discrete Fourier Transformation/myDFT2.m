%% This function will perform discrete fourier transformation on the given image.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None.

function [G, spectrum, spectrumUncomp] = myDFT2(Im)
    [row, col, depth] = size(Im);
    G = zeros(row, col, depth);
    centerI = Im;
    
    for d=1:depth
        for x=1:row
            for y=1:col
                centerI(x, y, d) = centerI(x ,y , d) * ((-1)^(x + y));
            end
        end
    end
    
    for d=1:depth
        for m=1:row
            for n=1:col
                dftSum = 0;
                for u=0:row-1
                    dftSum_col = 0;
                    for v=0:col-1
                        dftSum_col = dftSum_col + (double(centerI(u+1, v+1, d)) * exp(-1i*2*pi*((((m-1)*u)/row)+(((n-1)*v)/col))));
                    end
                    dftSum = dftSum + dftSum_col;
                end
                G(m, n, d) = dftSum;
            end
        end
    end
    
    spectrum = zeros(row, col, depth);
    
    R = real(G);
    I = imag(G);
    
    for d = 1:depth
         for x = 1:row
            for y = 1:col
                spectrum(x, y, d) = sqrt(((R(x, y, d)^2)+(I(x, y, d)^2))); % Fourier spectrum formula 4.6-16.
            end
         end
    end
    
    spectrumUncomp = spectrum;
    
    c = (255/(log10(1+double((max(max(max(Im)))))))); % Scaling constant.
    logtrans = (c*(log10(1+spectrum))); % Compressing the dynamic range by applying log transformation.
    spectrum = mat2gray(logtrans);
end