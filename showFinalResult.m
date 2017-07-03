function showFinalResult(outfile_name_start)
global final;
global cc;
global pd;
global const;
    img = pd.im;
    out_img = img*0;
    figure;
    hold on
    out_img = ColorBackGround(out_img,cc.BackColor);
    out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
    out_img_woRank = out_img;
    
    for i=1: final.num_ellipses
        m1 = img * 0;
        tmpTheta = final.ellipses{i};
        thick = const.thickness_increase * min(pd.size_X_factor, pd.size_Y_factor);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);                
        end

        out_img = showImageInImage(out_img,m1,cc.ForeColor_FinalEllipse);               
        out_img_woRank = showImageInImage(out_img_woRank,m1,cc.ForeColor_FinalEllipse);               
        
        Text = sprintf('%d',final.ranks(i));                
        H = vision.TextInserter(Text);
        H.Location = [final.erank_show_point(i,2) final.erank_show_point(i,1)];
        H.Color = cc.rankColor;
        H.FontSize = round(30+const.font_increase * max(pd.size_X_factor,pd.size_Y_factor));
        out_img = step(H, out_img);                
    end
    imshow(out_img);            
    imwrite(out_img, sprintf('%s_Ranked_%d.png',pd.outfile_name_start,i));    
    imwrite(out_img_woRank, sprintf('%s_woRank_%d.png',pd.outfile_name_start,i));    
    
            
%         show full size image result

    img = (pd.fullSizeImage);
    out_img = img*0;
    
    figure;
    hold on
    out_img = ColorBackGround(out_img,cc.BackColor);
    out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
    out_img_woRank = out_img;
    
    for i=1: final.num_ellipses
        m1 = img * 0;
        tmpTheta = final.full_ellipses{i};
        thick = const.thickness_increase * min(pd.size_X_factor_full, pd.size_Y_factor_full);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);                
        end
        
        out_img = showImageInImage(out_img,m1,cc.ForeColor_FinalEllipse);               
        out_img_woRank = showImageInImage(out_img_woRank,m1,cc.ForeColor_FinalEllipse);               
                   
        Text = sprintf('%d',final.ranks(i));   
        H = vision.TextInserter(Text);
        H.Location = [final.erank_show_point_full(i,2) final.erank_show_point_full(i,1)];
        H.Color = cc.rankColor;
        H.FontSize = round(80+const.font_increase_full * max(pd.size_X_factor_full,pd.size_Y_factor_full));
        out_img = step(H, out_img);                
    end
    
    imshow(out_img);
    imwrite(out_img, sprintf('%s_Ranked_FullSize_%d.png',outfile_name_start,i));
    imwrite(out_img_woRank, sprintf('%s_woRank_FullSize_%d.png',outfile_name_start,i));    
end