function showFinalResult_Family()
global scaled;
global cc;
global pd;
global const;

% load('familyData.mat');      

    img = pd.im;
    out_img = img*0;
%     figure;
%     hold on
    out_img = ColorBackGround(out_img,cc.BackColor);
    out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
        
    for i=1: scaled.num_ellipses
        m1 = img * 0;
        tmpTheta = scaled.ellipses{i};
        thick = const.thickness_increase * min(pd.size_X_factor, pd.size_Y_factor);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);                
        end

        out_img = showImageInImage(out_img,m1,cc.ForeColor_Family);               
%         
%         Text = sprintf('%d',scaled.erank_show_point(i,3));                
%         H = vision.TextInserter(Text);
%         H.Location = [scaled.erank_show_point(i,2) scaled.erank_show_point(i,1)];
%         H.Color = [255 0 0];
%         H.FontSize = round(20+const.font_increase * max(pd.size_X_factor,pd.size_Y_factor));
%         out_img = step(H, out_img);                
%         
%         imshow(out_img);            
    end
    imwrite(out_img, sprintf('%s_Family_%d.png',pd.outfile_name_start,i));    
            
%         show full size image result

    img = (pd.fullSizeImage);
    out_img = img*0;
%     figure;
%     hold on
    out_img = ColorBackGround(out_img,cc.BackColor);
    out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
    
    for i=1: scaled.num_ellipses
        m1 = img * 0;
%         m1=showEllipseInImgThick(m1, scaled.ellipses{i}); 
        
%         scaled.full_ellipses{i} = scaled.ellipses{i};        
% %         Resize results to post on full size image
%         for para=1:5
%             if (para ~= 3)
%                 scaled.full_ellipses{i}(para) = scaled.ellipses{i}(para)*1/pd.scale;
%             else
%                 scaled.full_ellipses{i}(para) = scaled.ellipses{i}(para);
%             end
%         end
%         
        tmpTheta = scaled.full_ellipses{i};
        thick = const.thickness_increase * min(pd.size_X_factor_full, pd.size_Y_factor_full);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);                
        end
       
        out_img = showImageInImage(out_img,m1,cc.ForeColor_Family);               
        
%         Text = sprintf('%d',scaled.erank_show_point(i,3));                
%         H = vision.TextInserter(Text);
%         H.Location = [scaled.erank_show_point_full(i,2) scaled.erank_show_point_full(i,1)];
%         H.Color = cc.ForeColor_FinalEllipse(mod(i,10)+1,:);
%         H.FontSize = round(20+const.font_increase_full * max(pd.size_X_factor_full,pd.size_Y_factor_full));
%         out_img = step(H, out_img);                
%         
%         imshow(out_img);            
    end    
    imwrite(out_img, sprintf('%s_FamilyFullSize.png',pd.outfile_name_start));                   
end