%% This function performs forward mapping.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * None

function [Ifm] = forwardmapping(I, affine)
    [rows, col, d] = size(I);
    Ifm = uint8(zeros(rows, col, d));
    affineMatrix = [affine(1), affine(2), affine(3); affine(4), affine(5), affine(6); 0, 0, 1];
    
    for r = 1:rows
        for c = 1:col
            X = [r, c, 1]';
            
            transformed = affineMatrix * X;
            
            transformed = round(transformed);
            
            if ((transformed(1) >= 1 && transformed(1) <= col) && (transformed(2) >= 1 && transformed(2) <= rows))
                Ifm(transformed(2), transformed(1), 1) = I(c, r, 1);
                Ifm(transformed(2), transformed(1), 2) = I(c, r, 2);
                Ifm(transformed(2), transformed(1), 3) = I(c, r, 3);
            end
        end
    end
end