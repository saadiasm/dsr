function [num_ellipses]=workOnRegions(flag_fig_out, flag_file_out)
% Input : Regions in pd.regions
% Output: 'Final' structure contains result of IED algorithm ; Paper-section 2.3
global final;
global pd;
global thrsh;
global const;

    pd.reg_status = zeros(pd.num_regs,1);  % Contains status of region i.e. region is part of some ellipse or not
    
    cur_region  = [];   % current region
    cur_ellipse = {};   % will contain current ellipse on current region
    elp_num = 1;        %ellipse number : counter of how many ellipses are final yet
    
    pd.allEllipses = ColorBackGround(pd.allEllipses,[255,255,255]);
    pd.allEllipses = showImageInImage(pd.allEllipses,pd.im,[0,0,0]);
    count = 0;
    correct_elp_num = 0;
    for ir = 1 : pd.num_regs   % Loop on all regions. Largest region is at first
        if (pd.reg_status(ir) == false)
            pd.reg_status(ir) = elp_num;
            pd.cur_region = pd.regions{ir};     % select next region as current region
            
            [ellp fit_flag]= fitEllipse(pd.cur_region);   %Get the ellipse fitted on next-region and return parameters of ellipse in ellp
            if(~fit_flag)  
                    continue;  % this region was not good enough to represent an ellipse, try next
            else
                    pd.cur_ellipse = ellp;   % store initial ellipse parameters
            end

            showOutput(pd.im, flag_fig_out, flag_file_out, sprintf('%sR_%d_%d.png',pd.outfile_name_start,elp_num, count), const.FULL, const.REGION)            
            showOutput(pd.im, flag_fig_out, flag_file_out, sprintf('%sE_%d_%d.png',pd.outfile_name_start,elp_num, count), const.FULL, const.ELLIPSE)          
            count = count + 1;    
            [cap, ade] = evaluateEllipse(pd.cur_ellipse, pd.cur_region, pd.size_im);   % get ade and cap (ellipse evaluation measures)
            disp(sprintf('Start Growing Ellipse no. %d',elp_num));
            
% GROW this ellipse
            count_Empty_E=0;
            
            reg_near_cur_region=[];
            reg_near_cur_reg_and_ellipse=[];
            
            while (cap < thrsh.tau_Cap && count_Empty_E<5)  
                reg_near_cur_region = pickRegionsNearCurRegion();  %Get neighboring regions of current region
                reg_near_cur_reg_and_ellipse = pickRegionsNearCurEllipse(reg_near_cur_region,elp_num);  %Get neighboring regions of current ellipse
              
                if isempty(reg_near_cur_reg_and_ellipse)
                    count_Empty_E = count_Empty_E + 1;
                else
                    count_Empty_E = 0;
                end
                pd.nearRegsList=[];
                if (~isempty(reg_near_cur_reg_and_ellipse))
%                   Show pd.cur_region in blue
%                   and regions in reg_near_cur_reg_and_ellipse in red
                    pd.nearRegsList = reg_near_cur_reg_and_ellipse;
                    showOutput(pd.im, flag_fig_out, flag_file_out, sprintf('%sDR_%d_%d.png',pd.outfile_name_start,elp_num, count), const.FULL, const.REGION_LIST)

                    Add_near_regions_to_cur_region(reg_near_cur_reg_and_ellipse,elp_num); %Expand the region to include current neighbours

                    [ellp fit_flag] = fitEllipse(pd.cur_region);  % Fit ellipse to newly grown region
                    if(fit_flag)
                        pd.cur_ellipse = ellp;
                        [cap, ade] = evaluateEllipse(pd.cur_ellipse, pd.cur_region, pd.size_im);
                        showOutput(pd.im, flag_fig_out, flag_file_out, sprintf('%sR_%d_%d.png',pd.outfile_name_start,elp_num, count), const.FULL, const.REGION)            
                        showOutput(pd.im, flag_fig_out, flag_file_out, sprintf('%sE_%d_%d.png',pd.outfile_name_start,elp_num, count), const.FULL, const.ELLIPSE)          
                        count = count + 1;                  
                    end
                end                
            end
            
            
            %Now ellipse has achieved basic properties to be called a valid
            %ellipse i.e. Cap >= thrsh.cap
            
            %Find ratio of larger-axis to smaller-axis
            ratio_ellipse = max(pd.cur_ellipse(4),pd.cur_ellipse(5))/min(pd.cur_ellipse(4),pd.cur_ellipse(5));
            if (cap >= thrsh.tau_Min_Cap && ratio_ellipse < thrsh.tau_Ratio && ade < thrsh.ADE1)
                disp(sprintf('Finding Ellipse no. %d IS successfull',elp_num));
                correct_elp_num = correct_elp_num + 1

                %Store detected ellipse in 'final' structure
                final.ellipses{correct_elp_num} = pd.cur_ellipse;
                final.regions{correct_elp_num} = pd.cur_region;
                final.cap(correct_elp_num) = cap;
                final.ade(correct_elp_num) = ade;
                if (ade > thrsh.ADE1)    %ADE1=6
                    keyboard;
                    disp 'Too large average distance to ellipse' , ade
                end
                showOutput(pd.im, flag_fig_out, flag_file_out, sprintf('%sRF_%d_%d.png',pd.outfile_name_start,elp_num, count), const.NORMAL, const.REGION)
                showFinalEllipse(pd.im, flag_fig_out, flag_file_out, sprintf('%sEF_%d_%d.png',pd.outfile_name_start,elp_num, count), const.NORMAL, const.ELLIPSE)                        
            else
                disp(sprintf('Finding Ellipse no. %d NOT successfull',elp_num));
            end
            elp_num = elp_num +1;
            count = 0;
        end
    end
    num_ellipses = correct_elp_num;
end