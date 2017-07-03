function pts_near_reg = pickPointsNearRegion(test_pts, cur_reg)
global thrsh;
min_dists=[]; % min distance bw each testpts and region
pts_near_reg=[];
tauP = thrsh.tau_P_Start;

for i=1:size(test_pts,1)
    repeat_test_point = repmat(test_pts(i,:), size(cur_reg,1),1);
    diff_pt_reg = repeat_test_point - cur_reg;
    min_dists(i) = min(sqrt(diff_pt_reg(:,1).^2 + diff_pt_reg(:,2).^2));
end

while (isempty(pts_near_reg) && tauP < thrsh.tau_P_Max)
    pts_near_reg = test_pts(min_dists < tauP,:);
    tauP = tauP + 1;
end
end