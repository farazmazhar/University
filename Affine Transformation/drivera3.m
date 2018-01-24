%% Affine transformation
%  * author: Faraz Mazhar, BCSF14M529
% ASSUMPTIONS:
%  * Equal number of points were selected from both images.

I1 = imread('Image-1.png');
I2 = imread('Image-2.png');

% Default values for demo. (Comment these if not in use)
% xa = [123.053191489362;196.887706855792;195.072104018913];
% ya = [2.743534278959810e+02;2.785898345153664e+02;3.905520094562647e+02];
% xb = [69.795508274231790;1.436300236406621e+02;1.424196217494091e+02];
% yb = [2.695118203309692e+02;2.743534278959810e+02;3.869208037825059e+02];

% Uncomment to choose points yourself. (Comment these if not in use)
subplot(1,2,1);imshow(I1);
imshow(I1);
[xa, ya] = getpts;

imshow(I2);
[xb, yb] = getpts;


affine = recoverAffine(xa, ya, xb, yb);
disp(affine);

% Forward mapping: Orignal -> Transformed.
Ifm = forwardmapping(I1, affine);
% Backward mapping: Transformed -> Orignal.
Ibm = backwardmapping(I2, affine);

subplot(2,2,1);imshow(I1);
subplot(2,2,2);imshow(Ifm);
subplot(2,2,3);imshow(I2);
subplot(2,2,4);imshow(Ibm);

% Fix following folder path to save output images.
% folder = 'D:\7th semester\6. Assignment solution\CV-A3\output\'; 
% imwrite(Ifm, fullfile(folder, 'Output-12.png'));
% imwrite(Ibm, fullfile(folder, 'Output-21.png'));