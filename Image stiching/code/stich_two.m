imageName1 = 'tower_left.jpeg'; 
imageName2 = 'tower_right.jpeg'; 
% Read the data
dataDir = fullfile('MATLAB','hw4','data');
im1 = imread(fullfile(dataDir, imageName1));
im2 = imread(fullfile(dataDir, imageName2));
%Transform it to gray and then double
im1_g = rgb2gray(im1);
im1_g = im2double(im1_g);
im2_g = rgb2gray(im2);
im2_g = im2double(im2_g);
% Detect Features (corner detector)
sigma = 2;
thresh = 0.07;
radius = 2;
disp = 1;
[cim1, r1_tem, c1_tem] = harris(im1_g, sigma, thresh, radius, disp);
[cim2, r2_tem, c2_tem] = harris(im2_g, sigma, thresh, radius, disp);
%Drop the features on the edge and extract features (transform feature to vector)
fsize = 5;
[feature1,r1,c1] = fe2ve(im1_g,r1_tem,c1_tem,fsize);
[feature2,r2,c2] = fe2ve(im2_g,r2_tem,c2_tem,fsize);
%Calculate the distances
dist = dist2(feature1,feature2);
%select putative matches
ndes = 200;
match = choosematch(ndes,dist,r1,c1,r2,c2);
%RANSAC
[hmatrix,match_res] = ransac(match);
%stich two picture
res = stich(im1,im2,hmatrix);
%show the matched features
figure();
showMatchedFeatures(im1, im2, match_res(:, 2:-1:1), match_res(:, 4:-1:3),'montage', 'PlotOptions', {'yo', 'yo', 'b-'});

            

