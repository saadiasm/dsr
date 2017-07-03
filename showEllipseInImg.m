function [ imT ] = showEllipseInImg(imT,theta)
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
for i=1:n
   imT(P(1,i),P(2,i))=255;
end

end

