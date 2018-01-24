%% This function performs forward mapping.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None

function [Ibm] = backwardmapping(I, affine)
    [rows, col, d] = size(I);
    Ibm = uint8(zeros(rows, col, d));
    affineMatrix = [affine(1), affine(2), affine(3); affine(4), affine(5), affine(6); 0, 0, 1];
    
    for r = 1:rows
        for c = 1:col
            X = [r, c, 1]';
            
            restored = affineMatrix \ X; % similar to 'inv(affineMatrix) * X'.
            restored = round(restored);
            
            if ((restored(1) >= 1 && restored(1) <= col) && (restored(2) >= 1 && restored(2) <= rows))
                Ibm(restored(2), restored(1), 1) = interpolation(c, r, I(:, :, 1));
                Ibm(restored(2), restored(1), 2) = interpolation(c, r, I(:, :, 2));
                Ibm(restored(2), restored(1), 3) = interpolation(c, r, I(:, :, 3));
            end
        end
    end
end