function ellipseDetector(im_File, flag_fig_out, flag_file_out, out_dir)
% Input: Image
% im_File is path and name of file with extention
% flag_fig_out  is for figure (how much output in on-screen figures)
%                1 : MINIMAL
%                2 : NORMAL
%                3 : FULL

% flag_file_out  is for files (how much output in files)  
%                1 : MINIMAL
%                2 : NORMAL
%                3 : FULL
% Usually use 1

% Output: parameter list and ranking of all ellipses
% Usually use 1 or 3


close all
% Add color codes
global cc; % cc = color codes
cc.BackColor = [255;255;255];
cc.ForeColor_Image = [0;0;0];
cc.ForeColor_GrowingEllipse=[0;255;0]; %Color used in all intermediate ellipse outputs even in final ellipses (_EF.png)
cc.ForeColor_GrowingRegion=[0;20;190];
cc.ForeColor_NearRegions=[255;0;0];
cc.ForeColor_FinalRegion=[0;255;0];

cc.rankColor = [0;0;255];
cc.ForeColor_FinalEllipse=[0;255;0];
cc.ForeColor_Family=[0;0;200];
cc.ForeColor_Merged=[.75;0;.75];

global thrsh;
% Thresholds

thrsh.min_Pts_In_Region = 20;       
thrsh.tau_Angle = deg2rad(45);      % For regio growig
thrsh.tau_Cap=90;           % claimed angled percentage: measure of accuracy
thrsh.tau_Min_Cap = 50;     % minimum 'cap' for some fitting to be called as ellipse
thrsh.tau_Ratio = 2;        % Ration of major and minor axis
thrsh.ADE = 10;
thrsh.ADE1 = 6;
thrsh.tau_P_Start = 10;
thrsh.tau_P_Max = 30;
thrsh.tauE = 10;

% Global Data
global final;           %final = Used to store final values of region-points and ellipse parameters
final=struct;
global pd;              % pd = processing_data. Use to store and share intermediate data while processig
pd = struct;

global const;           % constants used to identify different options for output
const.MINIMAL = 1;
const.NORMAL = 2;
const.FULL = 3;
const.IMAGE = 1;
const.REGION = 2;
const.ELLIPSE = 3;
const.REGION_LIST = 4;
const.font_increase = 6;  % increase in font size w.r.t. size of image with a factor of 5.
const.thickness_increase = 3; % increase in thickness of ellipse in output w.r.t. size of image with a factor of 2.
const.font_increase_full = 10;
const.angleDiff_tolerance = pi/30;

global scaled;
global final;
global merged;
tic
% Read File
[path,fName,ext]=fileparts(im_File);
pd.outDir = out_dir;
pd.outfile_name_start=strcat(out_dir,'\o_',fName,'_');
pd.orig_im = imread(im_File);

% Show file without any pre-processing to *orig.png
showOutput(pd.orig_im, flag_fig_out, flag_file_out, sprintf('%sorig.png',pd.outfile_name_start), const.MINIMAL,const.IMAGE)

% Pre-Processing         
[pd.pre_proc_im] = preProcess(pd.orig_im);  %(Gap Filling Section 2.1 in paper)
showOutput(pd.fullSizeImage, flag_fig_out, flag_file_out, sprintf('%sorigVisible.png',pd.outfile_name_start), const.MINIMAL,const.IMAGE)

pd.im = pd.pre_proc_im;
pd.size_im = [size(pd.im,1) size(pd.im,2)];

% standard size of image 500x500. X is row, Y is col
pd.size_X_factor = size(pd.im,1) / 500;
pd.size_Y_factor = size(pd.im,2) / 500;
pd.size_X_factor_full = size(pd.fullSizeImage,1) / 500;
pd.size_Y_factor_full = size(pd.fullSizeImage,2) / 500;

showOutput(pd.im(:,:,1), flag_fig_out, flag_file_out, sprintf('%s_preProcess.png',pd.outfile_name_start), const.MINIMAL, const.IMAGE)

% Storage for combined result
pd.allEllipses = zeros(size(pd.im,1),size(pd.im,2),3);
pd.allEFile_name = sprintf('%sEF.png',pd.outfile_name_start);

pd.points=struct;
[pd.points.X pd.points.Y] = find(pd.im>0);

% Initital image segmentation i.e. Group regions (Region Growing Section
% 2.2)
growRegions();
disp 'total regions = ' , pd.num_regs
tic;
% Now merge regions to form ellipses (Incremetal Ellipse Detection IED :
% section 2.3)
% Detected ellipses are stored in 'Final' structure
pd.num_ellipses = workOnRegions(flag_fig_out, flag_file_out);

t=toc;
disp(sprintf('Total Time Consumed after ellipse growing : %d minutes',t/60));
keyboard;

% pd.num_ellipses
if (pd.num_ellipses > 0)    
    rankEllipses(pd.num_ellipses);  % Assign Ranks to ellipses (Section 3)
    disp(sprintf('Total Ellipses Detected %d',pd.num_ellipses));
    
% showFinalResult_1(pd.outfile_name_start);
    showFinalResult(pd.outfile_name_start);
    
% Remove Outliers (Removal of false detections Section 4)    
    removeOutliers(pd.outfile_name_start);
    showFinalResult(pd.outfile_name_start);
    
%   Find families of ellipses (Section 5)
    findMore(flag_fig_out, flag_file_out,pd.outfile_name_start);
    if (scaled.num_ellipses > 0)
        disp(sprintf('Total Ellipses Detected %d',scaled.num_ellipses));
        showFinalResult_Family();        
%       Merge Results of IED and Family of ellipses (Section 5, page 23
%       last paragraph)
        MergeResult();
        showFinalResult_Merged();
%         show all results in one image. Combine image contains regions,
%         result of IED, result of family and result of merging
        showCombineImages(pd.outDir,strcat('\o_',fName), final.num_ellipses,scaled.num_ellipses,merged.num_ellipses)        
    else
        disp 'No Ellipses detected in scaled version';
    end
else
    disp 'No Ellipse Detected by exploiting Family Constraint';
end

t=toc;
disp(sprintf('Total Time Consumed %d minutes',t/60));
end