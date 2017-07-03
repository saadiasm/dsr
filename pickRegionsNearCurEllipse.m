function [reg_near_cur_elp] = pickRegionsNearCurEllipse(reg_near_cur_reg,elp_num)

    global pd;
    global thrsh;

    reg_near_cur_elp = [];
    
    for i = 1 : size(reg_near_cur_reg,1)
        Pts = pd.regions{reg_near_cur_reg(i)};
        pts_near_reg_and_elp = pickPointsNearEllipse(Pts, pd.cur_ellipse);
        if ((size(pts_near_reg_and_elp,1) / size(pd.regions{reg_near_cur_reg(i)},1)) > 0.1)
            reg_near_cur_elp = [reg_near_cur_elp ; reg_near_cur_reg(i)];
            pd.reg_status(reg_near_cur_reg(i)) = elp_num;
        else
            pd.cur_region = [pd.cur_region ; pts_near_reg_and_elp];  %save the points (if not full region)
        end
    end
end