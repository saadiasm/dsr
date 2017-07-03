function rankEllipses_forScaled()
    global scaled;
    global pd;
    
    num_elp = scaled.num_ellipses;
    ind=[];
    [sRanks ind]=sort(scaled.ade);
    scaled.erank_show_point = [];
    scaled.erank_show_point_full = [];
    for i= 1 : num_elp
        scaled.ranks(i) = i;
        scaled.new_ellipses{i} = scaled.ellipses{ind(i)};
        scaled.new_regions{i} = scaled.regions{ind(i)};
%         Resize results to post on full size image
        for para=1:5
            if (para ~= 3)
                scaled.full_ellipses{i}(para) = scaled.new_ellipses{i}(para)*1/pd.scale;
            else
                scaled.full_ellipses{i}(para) = scaled.new_ellipses{i}(para);
            end
        end
        iSp = 0;
        sp = [0 0];
        while ((iSp < 360) && (sp(1)<=0 || sp(1)>pd.size_im(1) || sp(2)<=0 || sp(2)>pd.size_im(2)))
            iSp = iSp+1;
            sp=getEllipsePointAtAngle(scaled.new_ellipses{i},iSp);
        end
            
        if (iSp<360)
            scaled.erank_show_point =[scaled.erank_show_point ; [(sp)'  i]];
        else
            sp=getEllipsePointAtAngle(scaled.new_ellipses{i},0);
            scaled.erank_show_point =[scaled.erank_show_point ; [(sp)'  i]];
        end
% SHOW point for full size image        
        iSp = 0;
        sp = [0 0];
        while ((iSp<360) && (sp(1)<=0 || sp(1)>size(pd.fullSizeImage,1) || sp(2)<=0 || sp(2)>size(pd.fullSizeImage,2)))
            iSp = iSp+1;
            sp=getEllipsePointAtAngle(scaled.full_ellipses{i},iSp);
        end
        if (iSp < 360)
            scaled.erank_show_point_full =[scaled.erank_show_point_full ; [(sp)'  i]];
        else
            sp=getEllipsePointAtAngle(scaled.full_ellipses{i},0);
            scaled.erank_show_point_full =[scaled.erank_show_point_full ; [(sp)'  i]];
        end
    end
    scaled.cap = scaled.cap(ind);
    scaled.ade = scaled.ade(ind);

    scaled.ellipses = scaled.new_ellipses;
    scaled.regions = scaled.new_regions;
    scaled.num_ellipses = num_elp;
    clear scaled.new_ellipses;
    clear scaled.new_regions;
end