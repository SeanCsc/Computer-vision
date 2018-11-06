function [feature,r,c] = fe2ve(im_g,r_tem,c_tem,fsize)
n = length(r_tem);
feature = [];
fsq = fsize*2+1;
r =[];
c =[];
for i = 1:length(r_tem)
    [h1,w1] = size(im_g);
     if((r_tem(i) > fsize) && (c_tem(i) > fsize) && (r_tem(i) < h1-fsize-1) && (c_tem(i) < w1-fsize-1))
            c = [c;c_tem(i)];
            r = [r;r_tem(i)];
     end
end
for i = 1:length(r)
    tmp = im_g(r(i)-fsize:r(i)+fsize,c(i)-fsize:c(i)+fsize);
    fvector = reshape(tmp,[],fsq*fsq);
    feature = [feature;fvector];
end
end