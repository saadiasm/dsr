function [cap ade] = evaluateEllipse(th, regPts, imSize)
% th is theta of ellipse parameters
% regPts are points that were used to fit this ellipse
% in scatter first value is col. and 2nd is row
% imSize is size of Image in [row col] format

% rankPCA : rank using percetage of claimed Angles
% rankED  : rank using Distance from Ellipse
hold on
        claimAngles=zeros(360,1);
        ep = (getEllipsePointAtAngle(th,0))'; %Ellipse point at zero angle
        centre = [th(1) th(2)];
        epc = ep - centre;
        epc = [epc 1];
%         scatter(ep(2),ep(1),'w');
        totalAngles=0;
        for ir = 1: size(regPts,1)
%             rp = regPts(ir,:);   % Next Point of region in loop.
%             rp=[regPts(ir,2) regPts(ir,1)];            
            rp=[regPts(ir,1) regPts(ir,2)];   
            rpc = rp - centre;            
            rpc = [rpc 1];
            cA = atan2(rpc(2),rpc(1))-atan2(epc(2),epc(1));
            if (cA<0)
                cA=cA+2*pi;
            end
            cAbin=round(rad2deg(cA));
            if (cAbin==0)
                cAbin=360;
            end
            
            anglePt = (getEllipsePointAtAngle(th,cAbin))';
            if (anglePt(1)>1 && anglePt(1)<imSize(1) && anglePt(2)>1 && anglePt(2)<imSize(2))
                claimAngles(cAbin) = claimAngles(cAbin)+1;
            end
            %scatter(anglePt(2),anglePt(1),'r');
        end
        
        % Count total no. of viewable angles.
        for ia = 1:360
            anglePt = (getEllipsePointAtAngle(th,ia))';
            if (anglePt(1)>1 && anglePt(1)<imSize(1) && anglePt(2)>1 && anglePt(2)<imSize(2))
                totalAngles= totalAngles+1;
            end
        end
        
        cACount = size(find(claimAngles>0),1);
        cap = round(cACount/totalAngles*100);
%         rankPCA = round(cACount/360*100);
        
        distRegWithEllipse = distPointToEllipse(regPts(:,1),regPts(:,2),th(4),th(5),th(1),th(2),th(3));
        ade = mean(distRegWithEllipse);  %average distance to ellipse
    end