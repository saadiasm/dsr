function Add_near_regions_to_cur_region(reg_near_cur_reg_and_elp,eNum)
    global pd;
    
    for i = 1 : size(reg_near_cur_reg_and_elp,1)
        tmpRegNo = reg_near_cur_reg_and_elp(i);
        pd.cur_region = [pd.cur_region ; pd.regions{tmpRegNo}];
    end
end