%% This function recovers best affine tranformation parameters.
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * Measurements are noisy.

function [affine] = recoverAffine(xa, ya, xb, yb)
    rows = (2*size(xa)); rows = rows(1);
    columns = 6;
    rowstrans = size(xb)+size(yb); rowstrans = rowstrans(1);
    
    A = zeros(rows, columns);  
    b = zeros(rowstrans, 1);
    
    for x = 1:rows
        for y = 1:columns
            if (mod(x, 2) == 0)
                A(x, 4) = xa(x/2);
                A(x, 5) = ya(x/2);
                A(x, 6) = 1;
            else
                A(x, 1) = xa((x+1)/2);
                A(x, 2) = ya((x+1)/2);
                A(x, 3) = 1;
            end
        end
    end
    
    
    for x=1:rowstrans
        if (mod(x, 2) == 0)
            b(x) = yb(x/2);
        else
            b(x) = xb((x+1)/2);
        end 
    end
    
    disp(A);
    disp(b);
    
    if (rows == columns)
        affine = A\b; % similar to 'inv(A) * b'.
    else
        affine = pinv(A) * b;
    end
end