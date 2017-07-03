function rankEllipses(num_elp)
    global final;
    global pd;
    
    ind=[];
    [sRanks ind]=sort(final.ade);
    final.erank_show_point = [];
    final.erank_show_point_full = [];
    for i= 1 : num_elp
        final.ranks(i) = i;
        final.new_ellipses{i} = final.ellipses{ind(i)};
        final.new_regions{i} = final.regions{ind(i)};
%         Resize results to post on full size image
        for para=1:5
            if (para ~= 3)
                final.full_ellipses{i}(para) = final.new_ellipses{i}(para)*1/pd.scale;
            else
                final.full_ellipses{i}(para) = final.new_ellipses{i}(para);
            end
        end
        iSp = 0;
        sp = [0 0];
        while ((iSp < 360) && (sp(1)<=0 || sp(1)>pd.size_im(1) || sp(2)<=0 || sp(2)>pd.size_im(2)))
            iSp = iSp+1;
            sp=getEllipsePointAtAngle(final.new_ellipses{i},iSp);
        end
            
        if (iSp<360)
            final.erank_show_point =[final.erank_show_point ; [(sp)']];
        else
            sp=getEllipsePointAtAngle(final.new_ellipses{i},0);
            final.erank_show_point =[final.erank_show_point ; [(sp)']];
        end
% SHOW point for full size image        
        iSp = 0;
        sp = [0 0];
        while ((iSp<360) && (sp(1)<=0 || sp(1)>size(pd.fullSizeImage,1) || sp(2)<=0 || sp(2)>size(pd.fullSizeImage,2)))
            iSp = iSp+1;
            sp=getEllipsePointAtAngle(final.full_ellipses{i},iSp);
        end
%       theta has -ve xc in centre(xc,yc) so never get valid show point. So
%       limit to check for angles.
        if (iSp < 360)
            final.erank_show_point_full =[final.erank_show_point_full ; [(sp)']];
        else
            sp=getEllipsePointAtAngle(final.full_ellipses{i},0);
            final.erank_show_point_full =[final.erank_show_point_full ; [(sp)']];
        end
    end
    final.cap = final.cap(ind);
    final.ade = final.ade(ind);

    final.ellipses = final.new_ellipses;
    final.regions = final.new_regions;
    final.num_ellipses = num_elp;
    clear final.new_ellipses;
    clear final.new_regions;
end