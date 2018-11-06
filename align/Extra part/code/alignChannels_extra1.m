function [imShift, predShift] = alignChannels_extra1(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)
predShift = zeros(2, 2);
max2 = 0;
max3 = 0;
hw = size(im);
im = im(20:hw(1)-20,20:hw(2)-20,:);
imshift_tem = zeros(size(im));
im_tem1 = edge(im(:,:,1))*1; %get the edge of first channel
%cut 20 pixel of the original

for i = -maxShift:1:maxShift
	im_tem2 = edge(im(:,:,2))*1;
	for j = -maxShift:1:maxShift
	Shift2 = circshift(im_tem2,[i,j]);
	dot_pro = dot(im_tem1(:), Shift2(:));
	if( sum(dot_pro) > max2)
		max2 = dot_pro;
		predShift(1,:) = [i,j];
	end
	end
end

for i = -maxShift:1:maxShift
	for j = -maxShift:1:maxShift
		im_tem3 = edge(im(:,:,3))*1;
		Shift3 = circshift(im_tem3,[i,j]);
		dot_pro = dot(im_tem1(:) ,Shift3(:));
	if( sum(dot_pro) > max3)
		max3 = dot_pro;
		predShift(2,:) = [i,j];
	end
    end
   
    
end
maxi = abs(predShift(1,:));
if(abs(predShift(1,1)) < abs(predShift(2,1)))
    maxi(1) = abs(predShift(2,1));
end
if(abs(predShift(1,2))<abs(predShift(2,2)))
    maxi(2) = abs(predShift(2,2));
end
 shape = size(imshift_tem);
    imshift_tem(:,:,1) = im(:,:,1);
    imshift_tem(:,:,2) = circshift(im(:,:,2),predShift(1,:));
    imshift_tem(:,:,3) = circshift(im(:,:,3),predShift(2,:));
    diff = [(maxi(1)+1),(maxi(2)+1)];
   % imShift = imshift_tem(maxi(1)+1:(shape(1)-maxi(1)-1),maxi(2)+1:(shape(2) - maxi(2)-1),:);
    imShift1 = imshift_tem(diff(1):(shape(1)-diff(1)),diff(2):(shape(2)-diff(2)),:);
    new_shape = size(imShift1);
    left = 1;
    right = new_shape(2);
    while((mean(imShift1(:,left,1)) > 0.9 || mean(imShift1(:,left,1))<0.1||mean(imShift1(:,left,2)) > 0.9 || mean(imShift1(:,left,2))<0.1||mean(imShift1(:,left,3)) > 0.9 || mean(imShift1(:,left,3))<0.1  ))
        left = left+1;
    end
    while(mean(imShift1(:,right,1)) > 0.9 || mean(imShift1(:,right,1))<0.1 ||mean(imShift1(:,left,2)) > 0.9 || mean(imShift1(:,left,2))<0.1 ||mean(imShift1(:,left,3)) > 0.9 || mean(imShift1(:,left,3))<0.1 )
        right = right-1;
    end
    imShift = imShift1(:,left:right,:);
    
   


