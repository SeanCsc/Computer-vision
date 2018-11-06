function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosaicing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;



%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
[imageHeight, imageWidth] = size(im);
im_g = zeros(imageHeight,imageWidth);
im_g(1:2:imageHeight, 2:2:imageWidth) = im(1:2:imageHeight, 2:2:imageWidth);
im_g(2:2:imageHeight, 1:2:imageWidth) = im(2:2:imageHeight, 1:2:imageWidth);
im_b = zeros(imageHeight,imageWidth);
im_b(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
im_r = zeros(imageHeight,imageWidth);
im_r(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);
filter_r = [0,0,0;0,1,1;0,1,1];
channel_r = conv2(im_r,filter_r,'same');
filter_g = [0,1,0; 0,1,0;0,0,0];
channel_g = conv2(im_g,filter_g,'same');
filter_b = [1,1,0;1,1,0;0,0,0];
channel_b = conv2(im_b,filter_b,'same');
%fill in the edge
channel_b(imageHeight,:) = channel_b(imageHeight-1,:);
channel_b(:,imageWidth) = channel_b(:,imageWidth-1);
channel_g(imageHeight,:) = channel_g(imageHeight-1,:);
channel_g(:,imageWidth) = channel_g(:,imageWidth-1);
mosim(:,:,1) = channel_r;
mosim(:,:,2) = channel_g;
mosim(:,:,3) = channel_b;


%
% Implement this 
  

%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
mosim = demosaicBaseline(im);
%
% Implement this 
%
[imageHeight, imageWidth] = size(im);
mosim = im;
im_g = zeros(imageHeight,imageWidth);
im_g(1:2:imageHeight, 2:2:imageWidth) = im(1:2:imageHeight, 2:2:imageWidth);
im_g(2:2:imageHeight, 1:2:imageWidth) = im(2:2:imageHeight, 1:2:imageWidth);
im_b = zeros(imageHeight,imageWidth);
im_b(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
im_r = zeros(imageHeight,imageWidth);
im_r(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);
filter_r = [0.25,0.5,0.25;0.5,1,0.5;0.25,0.5,0.25];
channel_r = conv2(im_r,filter_r,'same');

filter_g = [0,0.25,0;0.25,1,0.25;0,0.25,0];
channel_g = conv2(im_g,filter_g,'same');
filter_b = [0.25,0.5,0.25;0.5,1,0.5;0.25,0.5,0.25];
channel_b = conv2(im_b,filter_b,'same');

%%%%%%%%%deal with the edge
for i = 3:2:imageWidth-1
    channel_b(1,1) = channel_b(2,2);
    channel_b(1,i) = 1/2*(channel_b(2,i-1)+channel_b(2,i+1));
    channel_g(1,1) = 1/2*(channel_g(1,2)+channel_g(2,1));
    channel_g(1,i) = 1/3*( channel_g(1,i-1)+ channel_g(1,i+1)+ channel_g(2,i));
end
for i = 2:2:imageWidth-1
    channel_b(1,i) = channel_b(2,i);
end
for i = 3:2:imageHeight-1
    channel_b(i,1) = 1/2*(channel_b(i-1,2) + channel_b(i+1,2));
    channel_g(i,1) = 1/3*(channel_g(i-1,1)+channel_g(i+1,1)+channel_g(i,2));
end
for i =2:2:imageHeight
    channel_b(i,1) = channel_b(i,2);
end
if(mod(imageHeight,2) == 0)
    for i = 3:2:imageWidth-1
        channel_r(imageHeight,1) = channel_r(imageHeight-1,1);
        channel_r(imageHeight,i) = channel_r(imageHeight-1,i);
    end
    for i =2:2:imageWidth-1
        channel_r(imageHeight,i) = (channel_r(imageHeight-1,i-1)+channel_r(imageHeight-1,i+1))/2;
        channel_g(imageHeight,i) = 1/3*(channel_g(imageHeight,i-1)+channel_g(imageHeight,i+1)+channel_g(imageHeight-1,i));

    end
    
end

if(mod(imageWidth,2)==0)
    for i = 1:2:imageHeight
        channel_r(i,imageWidth) = channel_r(i,imageWidth-1);
    end
    for i = 2:2:imageHeight-1
        channel_r(i,imageWidth) = (channel_r(i-1,imageWidth-1)+channel_r(i+1,imageWidth-1))/2;
        channel_g(i,imageWidth) = 1/3*(channel_g(i-1,imageWidth)+channel_g(i+1,imageWidth)+channel_g(i,imageWidth-1));
    end
end

if(mod(imageHeight,2) == 1)
    channel_b(imageHeight,1) = channel_b(imageHeight-1,1);
    for i = 2:2:imageWidth
        channel_b(imageHeight,i) = channel_b(imageHeight-1,i);
    end
    for i =3:2:imageWidth-1
        channel_b(imageHeight,i) = (channel_b(imageHeight-1,i-1)+channel_b(imageHeight-1,i+1))/2;
        channel_g(imageHeight,i) = 1/3*(channel_g(imageHeight,i-1)+channel_g(imageHeight,i+1)+channel_g(imageHeight-1,i));

    end
end

if(mod(imageWidth,2)==1)
    channel_b(1,imageWidth) = channel_b(2,imageWidth-1);
    for i = 2:2:imageHeight
        channel_b(i,imageWidth) = channel_b(i,imageWidth-1);
    end
    for i = 3:2:imageHeight-1
        channel_b(i,imageWidth) = (channel_b(i-1,imageWidth-1)+channel_b(i+1,imageWidth-1))/2;
        channel_g(i,imageWidth) = 1/3*(channel_g(i-1,imageWidth)+channel_g(i+1,imageWidth)+channel_g(i,imageWidth-1));
        channel_g(imageHeight,imageWidth)=1/2*(channel_g(imageHeight-1,imageWidth)+channel_g(imageHeight,imageWidth-1));
    end
end
mosim(:,:,1) = channel_r;
mosim(:,:,2) = channel_g;
mosim(:,:,3) = channel_b;




%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
mosim = demosaicLinear(im);
%
% Implement this 
%
[imageHeight, imageWidth] = size(im);
im_g = zeros(imageHeight,imageWidth);
im_g(1:2:imageHeight, 2:2:imageWidth) = im(1:2:imageHeight, 2:2:imageWidth);
im_g(2:2:imageHeight, 1:2:imageWidth) = im(2:2:imageHeight, 1:2:imageWidth);
im_b = zeros(imageHeight,imageWidth);
im_b(2:2:imageHeight, 2:2:imageWidth) = im(2:2:imageHeight, 2:2:imageWidth);
im_r = zeros(imageHeight,imageWidth);
im_r(1:2:imageHeight, 1:2:imageWidth) = im(1:2:imageHeight, 1:2:imageWidth);

%%%red channel
filter_r_ud = [0.5,0.5,0;0.5,1,0.5;0,0.5,0.5]; %ud denotes the top left and botomn right
filter_r_lr = [0,0.5,0.5;0.5,1,0.5;0.5,0.5,0];%lr denotes the top right and botomn left
filter_r_uddiff =[1,0,0;0,0,0;0,0,-1];
diff_r_ud = abs(conv2(im_r,filter_r_uddiff,'same'));
filter_r_lrdiff = [0,0,1;0,0,0;-1,0,0];
diff_r_lr = abs(conv2(im_r,filter_r_lrdiff,'same'));
tem_1 = mosim(:,:,1);
r_ud = conv2(im_r,filter_r_ud,'same');
r_lr = conv2(im_r,filter_r_lr,'same');
tem_1(diff_r_ud < diff_r_lr) = r_ud(diff_r_ud < diff_r_lr); %choose the ud direction
tem_1(diff_r_ud >= diff_r_lr) = r_lr(diff_r_ud >= diff_r_lr); %choose the lr direction
mosim(:,:,1) = tem_1;
%%%green channel
filter_g_ud = [0,0.5,0;0,1,0;0,0.5,0];
filter_g_lr = [0,0,0;0.5,1,0.5;0,0,0];
filter_g_uddiff =[0,1,0;0,0,0;0,-1,0];
diff_g_ud = abs(conv2(im_g,filter_g_uddiff,'same'));
filter_g_lrdiff = [0,0,0;1,0,-1;0,0,0];
diff_g_lr = abs(conv2(im_g,filter_g_lrdiff,'same'));
tem_2 = mosim(:,:,2);
g_ud = conv2(im_g,filter_g_ud,'same');
g_lr = conv2(im_g,filter_g_lr,'same');
tem_2(diff_g_ud < diff_g_lr) = g_ud(diff_g_ud < diff_g_lr); %choose the ud direction
tem_2(diff_g_ud >= diff_g_lr) = g_lr(diff_g_ud >= diff_g_lr); %choose the lr direction
mosim(:,:,2) = tem_2;
%%%blue channel
filter_b_ud = [0.5,0.5,0;0.5,1,0.5;0,0.5,0.5]; %ud denotes the top left and botomn right
filter_b_lr = [0,0.5,0.5;0.5,1,0.5;0.5,0.5,0];%lr denotes the top right and botomn left
filter_b_uddiff =[1,0,0;0,0,0;0,0,-1];
diff_b_ud = abs(conv2(im_b,filter_b_uddiff,'same'));
filter_b_lrdiff = [0,0,1;0,0,0;-1,0,0];
diff_b_lr = abs(conv2(im_b,filter_b_lrdiff,'same'));
tem_3 = mosim(:,:,3);
b_ud = conv2(im_b,filter_b_ud,'same');
b_lr = conv2(im_b,filter_b_lr,'same');
tem_1(diff_b_ud < diff_b_lr) = b_ud(diff_b_ud < diff_b_lr); %choose the ud direction
tem_1(diff_b_ud >= diff_b_lr) = b_lr(diff_b_ud >= diff_b_lr); %choose the lr direction
mosim(:,:,3) = tem_3;


