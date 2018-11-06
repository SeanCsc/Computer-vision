function blobs = detectBlobsScaleImage(im)
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSCALEIMAGE(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the image and keeps the
%   filter same for speed. 
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
blobs = round([size(im,2)*0.5 size(im,1)*0.5 0.25*min(size(im,1), size(im,2)) 1]);
n_points = 1000;
im_g = rgb2gray(im);
im_g = im2double(im_g);
im_new = im_g;
[h,w] = size(im_g);
sigma = 2;
n = 15;
scaleSpace = zeros(h,w,n);
imageCell = cell(n,1);
hsize = [2*round(3*sigma)-1,2*round(3*sigma)-1];
rate = 1.2; %resize rate
for i = 1:n
    imageCell{i} = im_new;
    if(i<n)
        im_new = imresize(im_g,1/(rate^i));
    end
end
for i = 1:n
    [hnew,wnew] = size(imageCell{i});
    f = fspecial('log',hsize,sigma);
    tmp = imfilter(imageCell{i},f,'replicate');
    tmp = tmp.^2;
    [htmp,wtmp] = size(tmp);
    factor = rate^(i-1); %used to reflect back
    scaleSpace(:,:,i) = imresize(tmp,size(im_g),'bicubic');
end
maxiMask = zeros(size(scaleSpace));
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
    blobs(i,4) = maxValue(blobs(i,2),blobs(i,1),blobs(i,3));
    r = sigma*rate^(blobs(i,3)-1);
    blobs(i,3) = sqrt(2) *r ;
    end
end
end
    
    









        










