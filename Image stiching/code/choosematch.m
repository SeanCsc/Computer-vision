function match = choosematch(ndes,dist,r1,c1,r2,c2)
match = [];
for i = 1:ndes
    [lind,rind] = find(dist == min(min(dist)));
    if(length(lind) == 1)
        match = [match;r1(lind),c1(lind),r2(rind),c2(rind),dist(lind,rind)];
        %used to store the index and the location of the corresponding
        %points
        dist(lind,:) = 200;
        dist(:,rind) = 200; %avoid the duplicate
    end
end
end