function [dist] = distPointToEllipse(X,Y,ra,rb,xc,yc,phi,accuracy)
    %Find the distance between one or more points and an ellipse
    %X and Y are the coordinates of the point(s) under consideration. X and Y may be
    %vectors representing lists of point ordinates.
    %xc is the ellipse centre x ordinate, yc is the y centre ordinate, ra is the semi-major axis length
    %rb is the semi-minor axis length, phi is the orientation of the ellipse major axis with respect to
    %the x axis (in radians).
    %xc, yc, phi and accuracy are optional and optionally empty, if not given the ellipse will be centred
    %at the origin and have an orientation of zero. The accuracy defaults to 10^-6.
    %This function is dumb. It simply finds a minimum by evaluating the funtion at lots of
    %positions and taking the lowest, then searching again until the desired accuracy is reached.
    %However it is evaluated quickly enough so that the user is
    %unlikely to notice the poor performance unless calculating distance for millions of points.
  
    if ~(exist('xc','var') && ~isempty(xc))
        xc = 0;
    end
    if ~(exist('yc','var') && ~isempty(yc))
        yc = 0;
    end
    if ~(exist('phi','var') && ~isempty(phi))
        phi = 0;
    end
    if ~(exist('accuracy','var') && ~isempty(accuracy))
        accuracy = 10^-2;
    end
    accuracy = max([accuracy^2 10^-12]);

    numSearchPoints = 100; %This is how many distances to evaluate per iteration

    %Align the axes with the ellipse
    X = X-xc;
    Y = Y-yc;
    XY = [X(:) Y(:)];
    XY = [cos(phi) sin(phi);-sin(phi) cos(phi)]*XY';
    X = XY(1,:);
    Y = XY(2,:);
    X = abs(X);%By symmetry of an aligned ellipse, we can use the point in the positive quadrant to get distance
    Y = abs(Y);
    x = X;
    y = Y;
    A = 1/ra^2;
    B = 1/rb^2;

    dist = zeros(length(x),1);
    for i=1:length(x)
        X = x(i);
        Y = y(i);
        T = 0:(pi/2)/(numSearchPoints-1):pi/2;
        %Evaluate the distance as a function of angle around the ellipse
        dist2 = X.^2+Y.^2+1./(A.*cos(T).^2+B*sin(T).^2)-(2*X*cos(T)+2*Y*sin(T))./(A*cos(T).^2+B*sin(T).^2).^(1/2);
        sd2 = sort(dist2);
        dist(i) = sqrt(min(abs(dist2)));
    end
end
