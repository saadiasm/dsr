function P=getEllipsePoints(theta)
xc=theta(1);
yc=theta(2);
tau=theta(3);
a=theta(4);
b=theta(5);

c=cos(tau);
s=sin(tau);

mat=[c -s;s c];
P=[];
ind=1;
prev_pt = [];

t=0;
P(:,ind)=[xc;yc]+mat*[a*cos(t);b*sin(t)];

for t=0:0.001:2*pi
%for t=0:0.01:2*pi  % change from above line to this while writing findMore()
    prev_pt = P(:,ind);    
    ind=ind+1;    
    P(:,ind)=[xc;yc]+mat*[a*cos(t);b*sin(t)];
    if(P(:,ind)== 0)
        P(:,ind)=1;
    end
    if (round(P(:,ind)) == round(prev_pt))
        ind = ind - 1;
    end
%     scatter(P(2,:),P(1,:),'r');
end
% P=unique(P','rows');
end