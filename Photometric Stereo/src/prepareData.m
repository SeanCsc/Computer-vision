function output = prepareData(imArray, ambientImage)
% PREPAREDATA prepares the images for photometric stereo
%   OUTPUT = PREPAREDATA(IMARRAY, AMBIENTIMAGE)
%
%   Input:
%       IMARRAY - [h w n] image array
%       AMBIENTIMAGE - [h w] image 
%
%   Output:
%       OUTPUT - [h w n] image, suitably processed
%
% Author: Subhransu Maji
%

% Implement this %
% Step 1. Subtract the ambientImage from each image in imArray
imArray_am = imArray - ambientImage;


% Step 2. Make sure no pixel is less than zero
imArray_am(imArray_am < 0) = 0;
% Step 3. Rescale the values in imarray to be between 0 and 1
output = bsxfun(@rdivide,imArray_am,max(max(max(imArray_am))));