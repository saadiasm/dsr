function im1 = showRegionInImg(P, im1)

r=size(im1,1);
c=size(im1,2);

for i=1:size(P,2)
    if (P(1,i)>0 && P(1,i)<=r && P(2,i)>0 && P(2,i)<=c)
        im1(round(P(1,i)), round(P(2,i)))=255;
    end
end

end
