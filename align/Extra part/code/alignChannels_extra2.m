function [imShift, predShift] = alignChannels_size(im_ori, maxShift)
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
assert(size(im_ori,3) == 3);
assert(all(maxShift > 0));

% Dummy implementation (replace this with your own)
predShift = zeros(2, 2);
max2 = 0;
max3 = 0;
imShift = zeros(size(im_ori));

%resize
shape = size(im_ori);
half = round(shape(2)/2);
im = im_ori(:,1:half,:);
im_tem1 = edge(im(:,:,1))*1; %get the edge of first channel


t1 = clock;
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
t2 = clock;
search_time = etime(t2,t1)

 imShift(:,:,1) = im_ori(:,:,1);
    imShift(:,:,2) = circshift(im_ori(:,:,2),predShift(1,:));
    imShift(:,:,3) = circshift(im_ori(:,:,3),predShift(2,:));



