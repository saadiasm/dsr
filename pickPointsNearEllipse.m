function pts_near_ellipse = pickPointsNearEllipse(pts, ellipse)
global thrsh;

dist_from_ellipse = distPointToEllipse(pts(:,1),pts(:,2),ellipse(4),ellipse(5),ellipse(1),ellipse(2),ellipse(3));
            
% points that pass dist to ellipse test
pts_near_ellipse = pts(dist_from_ellipse < thrsh.tauE,:);
                
end