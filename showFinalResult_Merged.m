function showFinalResult_Merged()
% Final result of family is displayed here. It consists of all final
% regions. Regions are stored in scaled.regions.
global scaled;
global cc;
global pd;
global const;
global thrsh;
global merged;

    img = pd.im;
    out_img = img*0;
%     figure;
%     hold on
    out_img = ColorBackGround(out_img,cc.BackColor);
    out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
    
    for i=1: merged.num_ellipses 
        m1 = out_img * 0;    
  
        tmpTheta = merged.ellipses{i};
        thick = const.thickness_increase * min(pd.size_X_factor, pd.size_Y_factor);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);                
        end
        out_img = showImageInImage(out_img,m1,cc.ForeColor_Merged);
%         imshow(out_img);            
    end
    imwrite(out_img, sprintf('%s_Merged_%d.png',pd.outfile_name_start,i));    
    
    img = pd.fullSizeImage;
    out_img = img*0;
%     figure;
%     hold on
    out_img = ColorBackGround(out_img,cc.BackColor);
    out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
    
    for i=1: merged.num_ellipses
        m1 = img * 0;
%         m1=showEllipseInImgThick(m1, scaled.ellipses{i}); 
        tmpTheta = merged.full_ellipses{i};
        thick = const.thickness_increase * min(pd.size_X_factor_full, pd.size_Y_factor_full);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);                
        end
       
        out_img = showImageInImage(out_img,m1,cc.ForeColor_Merged);               
        
%         Text = sprintf('%d',scaled.erank_show_point(i,3));                
%         H = vision.TextInserter(Text);
%         H.Location = [scaled.erank_show_point_full(i,2) scaled.erank_show_point_full(i,1)];
%         H.Color = cc.ForeColor_FinalEllipse(mod(i,10)+1,:);
%         H.FontSize = round(20+const.font_increase_full * max(pd.size_X_factor_full,pd.size_Y_factor_full));
%         out_img = step(H, out_img);                
%         
%         imshow(out_img);            
    end
    
    imwrite(out_img, sprintf('%s_MergedFullSize.png',pd.outfile_name_start));     

%     For Fold.png 
%     Z = showOnPng(pd.origImg, out_img);
%     imshow(Z);
%     imwrite(Z, sprintf('%s_MergedOnRealImage.png',pd.outfile_name_start));   
end