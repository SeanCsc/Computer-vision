function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object

switch method
    case 'column' %column first
        heightMap = column(surfaceNormals);
        %%% implement this %%%
    case 'row'
        heightMap = row(surfaceNormals);
        %%% implement this %%%
    case 'average'
        heightMap = ave(surfaceNormals);
        %%% implement this %%%
    case 'random'
        heightMap = random(surfaceNormals);
        %%% implement this %%%
end

function height = row(surfaceNormals) %row first

[h,w,n] = size(surfaceNormals);
g1 = surfaceNormals(:,:,1);
g2 = surfaceNormals(:,:,2);
g3 = surfaceNormals(:,:,3);
fx = g1./g3;
fy = g2./g3;
height = zeros(h,w);
fx_row = cumsum(fx,2);
fy_col = cumsum(fy,1);
for y = 1:h
    for x = 1:w
        height(y,x) = fy_col(y,x) + fx_row(1,x); 
    end
end


function height = column(surfaceNormals) %col first

[h,w,n] = size(surfaceNormals);
g1 = surfaceNormals(:,:,1);
g2 = surfaceNormals(:,:,2);
g3 = surfaceNormals(:,:,3);
fx = g1./g3;
fy = g2./g3;
height = zeros(h,w);
fx_row = cumsum(fx,2);
fy_col = cumsum(fy,1);
for y = 1:h
    for x = 1:w
        height(y,x) = fy_col(y,1) + fx_row(y,x); 
    end
end


function height = ave(surfaceNormals)

rowf = column(surfaceNormals);
colf = row(surfaceNormals);
height = 1/2*(rowf+colf);


%%%%%%%%%%%%%%%%%%%%%%%random%%%%%%%%%%%

function distance = dis(fx,fy,i,j,m,n)
rowf = 0;
colf = 0;
for x = j:n
    rowf = rowf + fx(i,x);
    colf = colf + fx(m,x);
end
for y = i:m
    rowf = rowf + fy(y,n);
    colf = colf + fy(y,j);
end
distance = (rowf+colf)/2;

function height = random(surfaceNormals)

[h,w,n] = size(surfaceNormals);
g1 = surfaceNormals(:,:,1);
g2 = surfaceNormals(:,:,2);
g3 = surfaceNormals(:,:,3);
fx = g1./g3;
fy = g2./g3;
iter = 20;
heighti = zeros(h,w,iter);
for ite = 1:iter
    for y = 1:h
        for x = 1:w
        r = round(min(x,y)/2); %chose r points in the middle between (0,0) and (y,x)
        xr = sort(randi([1,x],r,1));
        yr = sort(randi([1,y],r,1));
        mid = zeros(r,2);
        for k = 1:r
            mid(k,:) = [yr(k),xr(k)];
        end
        distance = dis(fx,fy,1,1,mid(1,1),mid(1,2));
        for m = 2:r
            distance =distance + dis(fx,fy,mid(m-1,1),mid(m-1,2),mid(m,1),mid(m,2));
        end
        distance = distance + dis(fx,fy,mid(r,1),mid(r,2),y,x);
        heighti(y,x,ite) = distance;
    end
    end
end
height = mean(heighti,3);





        
