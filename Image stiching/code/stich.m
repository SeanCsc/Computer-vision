function res = stich(im1,im2,hmatrix)
trans = maketform('projective',hmatrix);
trans2 = maketform('affine',eye(3));
%combine the pic
[B,xdata,ydata] = imtransform(im1,trans);
xtotal = [min(1,xdata(1)) max(xdata(2),size(im2,2))];
ytotal = [min(1,ydata(1)) max(ydata(2),size(im2,1))];

total1 = imtransform(im1,trans,'nearest','Xdata',xtotal,'Ydata',ytotal);
total2 = imtransform(im2, trans2,'nearest','Xdata',xtotal,'Ydata',ytotal);

res = total1;
[hres,wres,channel] = size(res);
for i = 1:hres
    for j = 1:wres
        for c = 1:channel
         if(res(i,j,c) == 0)
             res(i,j,c) = total2(i,j,c);
         elseif(res(i,j,c)~=0 && total2(i,j,c)~=0)
                 res(i,j,c) = (res(i,j,c)/2)+total2(i,j,c)/2;
         end
        end
    end
end
figure();
imshow(res);