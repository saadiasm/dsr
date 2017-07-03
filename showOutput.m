function showOutput(img, flag_fig, flag_file, outfile_name, this_item, what)
global cc;
global const;
global pd;

% this_item is about item i.e. is it detailed step or normal step or
% minimal step

% flag_fig and flag_file both contains 1 , 2 or 3
% 1 : MINIMAL (very basic output)
% 2 : NORMAL  (reasonable output)
% 3 : FULL    (all output)

% what = 1 : image
%      = 2 : region
%      = 3 : ellipse

out_img = zeros(size(img,1), size(img,2),3,'uint8');
% Show in file

if (flag_file == const.MINIMAL && this_item<=const.MINIMAL) ...
    || (flag_file == const.NORMAL && this_item<=const.NORMAL) ...
    || (flag_file == const.FULL && this_item<=const.FULL)
    
    if (what == 1)  % Image
        out_img = ColorBackGround(out_img,cc.BackColor);
        out_img = showImageInImage(out_img, img, cc.ForeColor_Image);
%         out_fname = strcat(pd.outfile_name_start, outfile_name);  
    elseif (what == 2)  % region            
        m1 = out_img;
        m1=showRegionInImg(pd.cur_region',m1);    
        out_img = ColorBackGround(out_img,cc.BackColor);
        out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
        out_img = showImageInImage(out_img,m1,cc.ForeColor_GrowingRegion);
    elseif (what == 3)  % ellipse
        m1=out_img;
%                 m1=showEllipseInImgThick(m1, pd.cur_ellipse);
        tmpTheta = pd.cur_ellipse;
        thick = const.thickness_increase * min(pd.size_X_factor, pd.size_Y_factor);
        for tmp = round(-(thick/2)): round(thick/2)
            tmpTheta(4)=tmpTheta(4)+tmp;
            tmpTheta(5)=tmpTheta(5)+tmp;
            m1=showEllipseInImgThick(m1, tmpTheta);   
        end

        out_img = ColorBackGround(out_img,cc.BackColor);
        out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
        out_img = showImageInImage(out_img,m1,cc.ForeColor_GrowingEllipse);
    elseif (what == const.REGION_LIST)
        m1 = out_img;
        m1=showRegionInImg(pd.cur_region',m1);    
        out_img = ColorBackGround(out_img,cc.BackColor);
        out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
        out_img = showImageInImage(out_img,m1,cc.ForeColor_GrowingRegion);        
        
        for k=1:size(pd.nearRegsList,1)
            rn = pd.nearRegsList(k);
            m1=m1*0;
            m1=showRegionInImg(pd.regions{rn}',m1);  
            out_img = showImageInImage(out_img,m1,cc.ForeColor_NearRegions);       
        end
    end
    imwrite(out_img, outfile_name);
end

% Show in figure

if (flag_fig == const.MINIMAL && this_item<=const.MINIMAL) ...
    || (flag_fig == const.NORMAL && this_item<=const.NORMAL) ...
    || (flag_fig == const.FULL && this_item<=const.FULL)
    
    if (what == 1)  % Image
        out_img = ColorBackGround(out_img,cc.BackColor);
        out_img = showImageInImage(out_img, img, cc.ForeColor_Image);
    else
        if (what == 2) % region
            figure;
            m1 = out_img;
            m1=showRegionInImg(pd.cur_region',m1);    
            out_img = ColorBackGround(out_img,cc.BackColor);
            out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
            out_img = showImageInImage(out_img,m1,cc.ForeColor_GrowingRegion);
        else
            if (what == 3) % ellipse
                m1 = out_img;
                m1=showEllipseInImgThick(m1, pd.cur_ellipse);
                out_img = ColorBackGround(out_img,cc.BackColor);
                out_img = showImageInImage(out_img,img,cc.ForeColor_Image);
                out_img = showImageInImage(out_img,m1,cc.ForeColor_GrowingEllipse);               
            end
        end
    end
    imshow(out_img);
%     pause(2);
end