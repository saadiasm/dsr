function growRegions()
% Output is regions stored after sorting on size of region.
global pd;
global thrsh;

m1=zeros(size(pd.im,1),size(pd.im,2),3,'uint8');
k=1;
pd.regions={};
pd.reg_angles=[];
pd.status = zeros(size(m1,1),size(m1,2),'uint8');
pd.LL(pd.LL<0)=pd.LL(pd.LL<0)+pi;   %Map Level line angles from (-pi to pi) to (0 to pi)
figure;
hold on;
for i=1:size(pd.points.X,1)   % For all points in the image, try to grow region.
    p0 = [pd.points.X(i) pd.points.Y(i)];
    if (pd.status(p0(1),p0(2))==false)
        [rg, regAngle] = RegGrow(pd.LL, p0, thrsh.tau_Angle);
        if (size(rg,1)> thrsh.min_Pts_In_Region)
            pd.regions{k} = rg;
            pd.reg_angles(k)=regAngle;            
            k=k+1;

            m1(:,:,mod(i,3)+1) = showRegionInImg2D(rg', m1(:,:,mod(i,3)+1));
            imshow(m1);
        end
    end
end
    
pd.num_regs = size(pd.regions,2);
m1=whiteRegBkgrnd(m1);
imwrite(m1,strcat(pd.outfile_name_start,'Regs.png'));                   
imshow(m1);

% Show results of regions zoomed in
% imwrite(m1(135:197,160:222,:),strcat(pd.outfile_name_start,'Regs_Zin_thin.png'));           

 %%%%%%%%%%%%%%%%%%% Sort regions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sz=0;
    for i=1:pd.num_regs
        sz(i) = size(pd.regions{i},1);
    end

% Sort Regions
    [a,ind]=sort(sz);
    newRegs={};
    ii=pd.num_regs;
    for i=1:pd.num_regs
        newRegs{i}=pd.regions{ind(ii)};
        ii=ii-1;
    end

    pd.regions = newRegs;

end