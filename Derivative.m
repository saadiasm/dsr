function [LL gD gM gX gY] = Derivative(im)
im=double(im);
nRows=size(im,1);
nCols=size(im,2);
LL=zeros(nRows,nCols);
gM=zeros(nRows,nCols);
for i=1:nRows-1
    for j=1:nCols-1
        x = i;
        y = j;
        
        gx =double( (im(x+1,y)+im(x+1,y+1)-im(x,y)-im(x,y+1))/(2.0));
        gy =double( (im(x,y+1)+im(x+1,y+1)-im(x,y)-im(x+1,y))/(2.0));
        
%         v = gx/-gy;
%         LL(i,j) = atan2(v);
%         LL(i,j) = atan2(gx,-gy);         % try reversing x and y
        LL(i,j) = atan2(gx,-gy);
        gD(i,j) = atan2(gy,gx);
        gM(i,j) = (gx .^ 2 + gy .^ 2) .^ 0.5;
        gX(i,j) = gx;
        gY(i,j) = gy;
    end
end

end