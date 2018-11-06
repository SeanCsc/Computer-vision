function [hmatrix,final_match] = ransac(match)
npairs = length(match);
nmatch = 4;
niter = 1000;
inlier_threshold = 1;
num_in_threshold = 10;
n = 1;
ninlier_max = 0;
for n = 1:niter
    randInd = randsample(npairs,nmatch);
    %form the left matrix
    A = [];
    for i = 1:nmatch
        curGroup = match(randInd(i),:);
        xl = curGroup(2);
        yl = curGroup(1);
        xlve = [xl;yl;1]; %[x,y,1]
        xr = curGroup(4); %x'
        yr = curGroup(3); %y'
        A = [A;xlve'*0,xlve',-yr.*xlve';xlve',xlve'*0,-xr.*xlve'];
    end
    
    %find h (eigenvector of A'A corresponding to the smallest eigenvalue)
    [U, S, V] = svd(A);
    h = V(:, end);
    hmatrix = reshape(h,3,3);
    ninlier = 0;
    inlier = [];
    res = 0;
    %After getting the transform h, we could do transform for the features
    %and find the inlier index in the match matrix
   for i = 1:npairs
        xrVe = hmatrix'*[match(i,2);match(i,1);1];
        xr_new = xrVe(1)/xrVe(3);
        yr_new = xrVe(2)/xrVe(3);
        if(dist2([xr_new,yr_new],[match(i,4),match(i,3)])<inlier_threshold)
            inlier = [inlier;i];
            res = res + dist2([xr_new,yr_new],[match(i,4),match(i,3)]);
            ninlier = ninlier + 1;
        end
    end
    if(ninlier > ninlier_max )
        tem_inlier = inlier;
        tem_res_ave = res/ninlier;
        ninlier_max = ninlier;
    end
end

%Reestimate
A = [];
for i = 1:length(tem_inlier)
   curGroup = match(tem_inlier(i),:);
   xl = curGroup(2);
   yl = curGroup(1);
   xlve = [xl;yl;1]; %[x;y;1]
   xr = curGroup(4); %x'
   yr = curGroup(3); %y'
   A = [A;xlve'*0,xlve',-yr*xlve';xlve',xlve'*0,-xr*xlve'];
end
    
    %find h (eigenvector of A'A corresponding to the smallest eigenvalue)
[U,S,V] = svd(A);

h = V(:,end);
hmatrix = reshape(h,3,3);
final_ninlier = 0;
final_inlier = [];
final_res = 0;
    %After getting the transform h, we could do transform for the features
    %and find the inlier index in the match matrix
 for i = 1:npairs
    xrVe = hmatrix'*[match(i,2);match(i,1);1];
    xr_new = xrVe(1)/xrVe(3);
    yr_new = xrVe(2)/xrVe(3);
      if(dist2([xr_new,yr_new],[match(i,4),match(i,3)])<inlier_threshold)
           final_inlier = [final_inlier;i];
           final_res = final_res + dist2([xr_new,yr_new],[match(i,4),match(i,3)]);
           final_ninlier = final_ninlier + 1;
      end
 end

 
final_res = final_res/length(final_inlier);
final_match = [];
for i = 1:length(final_inlier)
    final_match = [final_match;match(final_inlier(i),:)];
end
final_ninlier
final_res
end