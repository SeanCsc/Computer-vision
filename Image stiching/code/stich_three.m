function res = stich_three(im1,im2,im3)
im1_g = rgb2gray(im1);
im1_g = im2double(im1_g);
im2_g = rgb2gray(im2);
im2_g = im2double(im2_g);
im3_g = rgb2gray(im3);
im3_g = im2double(im3_g);
% Detect Features (corner detector)
sigma = 3;
thresh = 0.05;
radius = 3;
disp = 0;
[cim1, r1_tem, c1_tem] = harris(im1_g, sigma, thresh, radius, disp);
[cim2, r2_tem, c2_tem] = harris(im2_g, sigma, thresh, radius, disp);
[cim3, r3_tem, c3_tem] = harris(im3_g, sigma, thresh, radius, disp);
fsize = 5;
[feature1,r1,c1] = fe2ve(im1_g,r1_tem,c1_tem,fsize);
[feature2,r2,c2] = fe2ve(im2_g,r2_tem,c2_tem,fsize);
[feature3,r3,c3] = fe2ve(im3_g,r3_tem,c3_tem,fsize);

%Calculate the distances
dist12 = dist2(feature1,feature2);
dist23 = dist2(feature2,feature3);
dist13 = dist2(feature1,feature3);
%select putative matches
ndes = 200;
match12 = choosematch(ndes,dist12,r1,c1,r2,c2);
match23 = choosematch(ndes,dist23,r2,c2,r3,c3);
match13 = choosematch(ndes,dist13,r1,c1,r3,c3);

%RANSAC
[hmatrix12,final_match12] = ransac(match12);
[hmatrix23,final_match23] = ransac(match23);
[hmatrix13,final_match13] = ransac(match13);

ninlier12 = length(final_match12);
ninlier23 = length(final_match23);
ninlier13 = length(final_match13);
maxinlier = max([ninlier12,ninlier23,ninlier13])
if(ninlier12 == maxinlier)
    %stich two picture
fprintf('first stich 1 and 2, then 3')
im4 = stich(im1,im2,hmatrix12);
im4_g = rgb2gray(im4);
im4_g = im2double(im4_g);
%show the matched features
[cim4, r4_tem, c4_tem] = harris(im4_g, sigma, thresh, radius, disp);
[feature4,r4,c4] = fe2ve(im4_g,r4_tem,c4_tem,fsize);
dist = dist2(feature4,feature3);
match = choosematch(ndes,dist,r4,c4,r3,c3);
[hmatrix,final_match] = ransac(match);
res = stich(im4,im3,hmatrix);
elseif(ninlier23 == maxinlier)
 fprintf('first stich 2 and 3, then 1')

    %stich two picture
im4 = stich(im2,im3,hmatrix23);
im4_g = rgb2gray(im4);
im4_g = im2double(im4_g);
%show the matched features
[cim4, r4_tem, c4_tem] = harris(im4_g, sigma, thresh, radius, disp);
[feature4,r4,c4] = fe2ve(im4_g,r4_tem,c4_tem,fsize);
dist = dist2(feature4,feature1);
match = choosematch(ndes,dist,r4,c4,r1,c1);
[hmatrix,final_match] = ransac(match);
res = stich(im4,im1,hmatrix);

elseif(ninlier13 == maxinlier) 
 fprintf('first stich 1 and 3, then 2')

    %stich two picture
im4 = stich(im1,im3,hmatrix13);
im4_g = rgb2gray(im4);
im4_g = im2double(im4_g);
%show the matched features
[cim4, r4_tem, c4_tem] = harris(im4_g, sigma, thresh, radius, disp);
[feature4,r4,c4] = fe2ve(im4_g,r4_tem,c4_tem,fsize);
dist = dist2(feature4,feature2);
match = choosematch(ndes,dist,r4,c4,r2,c2);
[hmatrix,final_match] = ransac(match);
res = stich(im4,im2,hmatrix);
end
imshow(im4);
imshow(res);

end
    
    


%

