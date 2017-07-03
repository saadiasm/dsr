function P=getEllipsePointAtAngle(theta,angle)
% angle in radians
xc=theta(1);
yc=theta(2);
tau=theta(3);
a=theta(4);
b=theta(5);

c=cos(tau);
s=sin(tau);

mat=[c -s;s c];
P=[];
ind=0;
% for t=0:1:360
% for t=0:0.01:2*pi
    t=deg2rad(angle);
    ind=ind+1;
    P(:,ind)=[xc;yc]+mat*[a*cos(t);b*sin(t)];
    if(P(:,ind)== 0)
        P(:,ind)=1;
    end
% end
end