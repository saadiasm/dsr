function [imOut] = showEllipseInImgThick(imT,theta)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
P0=getEllipsePoints(theta);
P0=round(P0);
% scatter(P0(1,:),P0(2,:));

P=[];

% filter out average distance from cluster centre;
[ind]= find(P0(1,:)>=1 & P0(1,:)<=size(imT,1) & P0(2,:)>=1 & P0(2,:)<=size(imT,2));
P=P0(:,ind);

n=size(P,2);
rows=size(imT,1);
cols=size(imT,2);

% imOut = zeros(rows,cols,'uint8');
imOut = imT;

for i=1:n
        x=P(1,i);
        y=P(2,i);
    %    Fill 8 neighbors of x,y
    %    First row
    if (x-1>=1 && x-1<=rows && y-1>=1 && y-1<=cols)
        imOut(x-1,y-1)=255;
    end
    if (x-1>=1 && x-1<=rows && y+1>=1 && y+1<=cols)
        imOut(x-1,y+1)=255;
    end    
    if (x>=1 && x<=rows && y-1>=1 && y-1<=cols)
        imOut(x,y-1)=255;
    end
        %    Second row
    if (x>=1 && x<=rows && y+1>=1 && y+1<=cols)
        imOut(x,y+1)=255;
    end
%     
    imOut(x,y)=255;

    if (x+1>=1 && x+1<=rows && y-1>=1 && y-1<=cols)
        imOut(x+1,y-1)=255;
    end
        %    Third row
    if (x+1>=1 && x+1<=rows && y-1>=1 && y-1<=cols)
        imOut(x+1,y-1)=255;
    end
    if (x+1>=1 && x+1<=rows && y>=1 && y<=cols)
        imOut(x+1,y)=255;
    end
    if (x+1>=1 && x+1<=rows && y+1>=1 && y+1<=cols)
       imOut(x+1,y+1)=255;
    end
end
end

