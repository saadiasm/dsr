function findMore(flag_fig_out, flag_file_out, outfile_name_start)
%This version of findMore uses another stucture of scaled ellipses and show
%only those ones.

% fname = sprintf('%s_rankedData.mat',outfile_name_start);
% load (fname)

global final;
global cc;
global pd;
global const;
global thrsh;
global scaled;

% pd.outfile_name_start='Results\Lab6_0021';
scaled.num_ellipses = 0;
scaled.ellipses={};
scaled.full_ellipses = {};
scaled.fitFlag=0;
scaled.regions={};
scaled.cap=[];
scaled.ade=[];
scaled.ratio_ellipse=[];


m1= zeros(size(pd.im,1),size(pd.im,2),3);
m1(:,:,3) = pd.im;
figure;
% m2= zeros(size(pd.im,1),size(pd.im,2),3);
% m2(:,:,3) = pd.im;
% figure;
% pd.reg_status = zeros(final.num_regs,1);

%for i=1:1   % to pd.num_ellipses
eNum=1;
F=[];

for i=1:final.num_ellipses
theta = final.ellipses{i};  % grow this ellipse
P = [pd.points.X pd.points.Y];
E=[];

th = theta;
fitFlag = false;
% figure;
    for s=0.1 : 0.1 : 4.0  
        if (s < 0.9 || s > 1.1)
            th(4)=theta(4) * s;
            th(5)=theta(5) * s;
            E = round(getEllipsePoints(th));
            E= unique(E','rows');
            
% Check intersection
            I = intersect(P,E,'rows');
            if (~ isempty(I))
%                 disp 'size of I is ', size(I,1)
%                 disp 'size of E is ', size(E,1)
%                   sprintf('[I=%d E=%d]',size(I,1),size(E,1))
%                 imshow(pd.im);
%                 hold on;
%                 scatter(E(2,:),E(1,:),'r');

                similarity = size(I,1)/size(E,1);
                F = [F ; i s similarity];
                sprintf('I=%d E=%d i=%d s=%2.2f similarity=%2.4f',size(I,1),size(E,1),i,s,similarity)
                m1(:,:,1)=showEllipseInImgThick(m1(:,:,1), th);   
                imshow(m1);
                fit_flag=-1;
%                 if (similarity >= 0.60 * (1/s)) % size of (intersection of ellipse points / total points) must be greater than 0.7
%                 Idea of adaptive threshold cancelled due to smaller-wrong
%                 detected ellipses in Lab6_0021
                intr_thresh = (12/th(4)); % adaptive threshold on the basis of major axis
                if (similarity >= 0.2) % size of (intersection of ellipse points / total points) must be greater than 0.7
% 0.2 for others and 0.4 for Lab6.
                    %                 if (similarity >= intr_thresh) % size of (intersection of ellipse points / total points) must be greater than 0.7
                    pd.cur_region = E;
                    [ellp fit_flag] = fitEllipse(pd.cur_region);
                    if (fit_flag)
                        pd.cur_ellipse = ellp;
                        th = ellp;
                        [cap, ade] = evaluateEllipse(pd.cur_ellipse, pd.cur_region, pd.size_im);
                        ratio_ellipse = max(pd.cur_ellipse(4),pd.cur_ellipse(5))/min(pd.cur_ellipse(4),pd.cur_ellipse(5));
                        if (cap >= thrsh.tau_Min_Cap && ratio_ellipse < thrsh.tau_Ratio && ade < thrsh.ADE)
                            sprintf('I=%d E=%d i=%d s=%2.2f similarity=%2.4f\ncap=%f ade=%f',size(I,1),size(E,1),i,s,similarity,cap,ade)
                            m1(:,:,2)=showEllipseInImgThick(m1(:,:,2), th);
%                             figure(1);
%                             imshow(m1);        
                            scaled.num_ellipses = scaled.num_ellipses + 1;
                            scaled.regions{scaled.num_ellipses} = pd.cur_region;
                            scaled.ellipses{scaled.num_ellipses} = th;
                            scaled.fitFlag(scaled.num_ellipses) = fit_flag;
                            scaled.cap(scaled.num_ellipses) = cap;
                            scaled.ade(scaled.num_ellipses) = ade;
                            scaled.ratio_ellipse(scaled.num_ellipses) = ratio_ellipse;
                  
                            scaled.full_ellipses{scaled.num_ellipses} = scaled.ellipses{scaled.num_ellipses};        
                  %         Resize results to post on full size image
                            for para=1:5
                                if (para ~= 3)
                                    scaled.full_ellipses{scaled.num_ellipses}(para) = scaled.ellipses{scaled.num_ellipses}(para)*1/pd.scale;
                                else
                                    scaled.full_ellipses{scaled.num_ellipses}(para) = scaled.ellipses{scaled.num_ellipses}(para);
                                end
                            end
                        end
                    end
                        eNum=eNum+1;
                end
            end
        end
    end
end
if (scaled.num_ellipses > 0)
    sprintf('Total Ellipses Detected %d',scaled.num_ellipses)
end
end
            

