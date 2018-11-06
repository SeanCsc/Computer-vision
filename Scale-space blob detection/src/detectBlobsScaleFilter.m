function blobs = detectBlobsScaleFilter(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSSCALEFILTER(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the filter and keeps the
%   image same which is slow for big filters.
% 
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector


% Dummy - returns a blob at the center of the image
%blobs = round([size(im,2)*0.5 size(im,1)*0.5 0.25*min(size(im,1), size(im,2)) 1]);
%preprocess

n_points = 1000;
im_g = rgb2gray(im);
im_g = im2double(im_g);

[h,w] = size(im_g);


sigma_initial = 2;
k = 1.2;
n = 15; %levels in the scale space
scaleSpace = zeros(h,w,n);
for i = 1:n
    
    %Create Laplacian filter
    sigma = sigma_initial * k^(i-1);
    hsize = [2*round(3*sigma)-1,2*round(3*sigma)-1];
    f = sigma*sigma*fspecial('log',hsize,sigma);
    % convolution
    tmp = imfilter(im_g,f,'replicate');
    tmp = tmp.^2;
    scaleSpace(:,:,i) =tmp;
end

maxiMask = zeros(h,w,n);
supSize = 7;
for i = 1:n
    fun = @(x) max(x(:));
    %maxiMask(:,:,i) = nlfilter(scaleSpace(:,:,i),[supSize,supSize],fun);
    maxiMask(:,:,i) = ordfilt2(scaleSpace(:,:,i),supSize^2,ones(supSize,supSize));
    %maxiMask(:,:,i) = colfilt(scaleSpace(:,:,i), [supSize supSize], 'sliding', @max);

end

for i = 1:n
    maxiMask(:,:,i) = max(maxiMask(:,:,max(1,i-1):min(i+1,n)),[],3);
end

maxValue = scaleSpace.*(maxiMask==scaleSpace); %nonmaximum suppression of a layer


maxScale = max(maxValue,[],3); %nonmaximum suppression of layers
blobs = zeros(n_points,4);

maxVector = reshape(maxScale,[h*w,1]);
maxVector = sort(maxVector,'descend');
threshold = maxVector(1000);

%use tmp to store all the scores of each pixel

for i = 1:n_points
    if (maxVector(i)>=threshold)
    [blobs(i,2),blobs(i,1),blobs(i,3)] = ind2sub(size(maxScale),find(maxValue == maxVector(i)));
    sigma = sigma_initial * k^(blobs(i,3)-1);
    blobs(i,4) = maxValue(blobs(i,2),blobs(i,1),blobs(i,3));
    blobs(i,3) = sqrt(2) * sigma;
    end
end


