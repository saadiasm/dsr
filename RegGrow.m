function [ region , regAngle] = RegGrow(LLA, pt, tau)
global pd;
global const;

% Grow one region by finding neighbors starting from seed pixel 'pt'

% A level-line field LLA, a seed pixel P
% an angle tolerance tau and a Status variable for each pixel.
region = pt;
pd.status(pt(1),pt(2))=true;
regAngle = LLA(pt(1,1), pt(1,2));

Sx = cos(regAngle);
Sy = sin(regAngle);

N=size(region,1);
i=1;
while (i<=N)   % For all region points. Grow starting from every point
    P = region(i,:);
    pNH = NeigH(P,size(LLA));
    npNH= size(pNH,1);

    for j = 1 : npNH
        Q = pNH(j,:);
        if (pd.status(Q(1), Q(2)) == false)
            absAngleDiff = abs(regAngle-LLA(Q(1), Q(2)));
            if (absAngleDiff<=tau  || ((pi - absAngleDiff) < const.angleDiff_tolerance)) %or both differ by 6 degree
                region = [region ; Q]; 
                pd.status(Q(1), Q(2)) = true;
                Sx = Sx + cos(LLA(Q(1),Q(2)));
                Sy = Sy + sin(LLA(Q(1),Q(2)));
                regAngle = atan2(Sy,Sx);                
                if regAngle  < 0
                    regAngle = regAngle + pi;
                end
            
            end
        end
    end
    N=size(region,1);
    i=i+1;
end
% N
end

function [neighbors] = NeigH(p, siz)
global pd;
img = pd.im;
    x = p(1,1);
    y = p(1,2);
% %   x is row , y is col
%   Write all 16 neighbors
%     neighb = [x-2,y-1;      % 16
%               x-2,y;        % 16
%               x-2,y+1;      % 16
%               x-1,y-1;  
%               x-1,y;
%               x-1,y+1;
%               x,y-2;        % 16
%               x,y-1;
%               x,y+1;
%               x,y+2;        % 16
%               x+1,y-1;
%               x+1,y;
%               x+1,y+1;
%               x+2,y-1;      % 16
%               x+2,y;        % 16
%               x+2,y+1;      % 16
%               ];
          
%   Write all 8 neighbors
    neighb = [x-1,y-1;  
              x-1,y;
              x-1,y+1;
              x,y-1;
              x,y+1;
              x+1,y-1;
              x+1,y;
              x+1,y+1;
              ];
%           
%           ind=find (neighb(:,1)>0 && neighb(:,1)<siz(1) && neighb(:,2)>0 && neighb(:,2)<siz(2));
% Select only valid neighbors
      neighbors=[];
      for i=1:size(neighb,1)
          if (neighb(i,1)>0 && neighb(i,1)<siz(1) && neighb(i,2)>0 && neighb(i,2)<siz(2))
              if (img(neighb(i,1),neighb(i,2))==1)
                    neighbors=[neighbors ; neighb(i,:)];
              end
          end
      end   
end