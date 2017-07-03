function [reg_list]=pickRegionsNearCurRegion()

global final;
global pd;
global thrsh;
global const;

% check which of pd.regions are near to pd.cur_region.
    reg_list=[];
    for i=1:pd.num_regs
        if (pd.reg_status(i) == false)
            pts = pickPointsNearRegion(pd.regions{i}, pd.cur_region);
            size_Pts = size(pts,1);
            if (size_Pts > thrsh.min_Pts_In_Region) % if more than 20 points are near then add this region to selected list
                reg_list = [reg_list ; i];
            end
        end
    end


end