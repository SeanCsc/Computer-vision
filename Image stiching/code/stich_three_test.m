imageName1 = '1.JPG'; 
imageName2 = '2.JPG';
imageName3 = '3.JPG'; 

% Read the data
dataDir = fullfile('MATLAB','hw4','data','pier');
im1 = imread(fullfile(dataDir, imageName1));
im2 = imread(fullfile(dataDir, imageName2));
im3 = imread(fullfile(dataDir, imageName3));
stich_three(im1,im2,im3);