function M=MergeResult()
M=1;

% load familyData.mat;
global final;
global scaled;
global merged;
merged=struct;
merged.ellipses = {};
merged.full_ellipses = {};
all=struct;
all.ellipses={};

ie = final.num_ellipses;
fe = scaled.num_ellipses;

thresh_centre = 5;
thresh_angle = 5;
thresh_axis = 5;
thresh = [thresh_centre thresh_centre thresh_angle thresh_axis thresh_axis];


k=1;
for i=1: ie
    all.ellipses{k} = final.ellipses{i};
    all.full_ellipses{k} = final.full_ellipses{i};
    k=k+1;
end

z=k-1;
% z
disp 'ellipses from final group'
for i=1: fe
    all.ellipses{k} = scaled.ellipses{i};
    all.full_ellipses{k} = scaled.full_ellipses{i};
    k=k+1;
end
k=k-1;

k-z
disp 'ellipses from family group'

duplicate = zeros(k,1);

for i=1: k
    e_i = all.ellipses{i};
    for j=i+1:k
        e_j = all.ellipses{j};
        diff = abs([e_i - e_j]);
        if ( diff(1) < thresh_centre && diff(2)<thresh_centre && diff(3)<thresh_angle && diff(4)<thresh_axis && diff(5)<thresh_axis)
%         diff = Compare(e_i, e_j)
%         if (diff > 1)
            duplicate (j) = true;
        end
    end
end
total = 0;
for i=1:k
    if (~duplicate(i))
        total = total + 1;
        merged.ellipses{total} = all.ellipses{i};
        merged.full_ellipses{total} = all.full_ellipses{i};
    end
end
disp 'total ellipses = '
merged.num_ellipses = total
end

function r=Compare(e1,e2)
r=0;

[X1,Y1,phi1,a1,b1] = deal(e1(1),e1(2),e1(3),e1(4),e1(5));
[X2,Y2,phi2,a2,b2] = deal(e2(1),e2(2),e2(3),e2(4),e2(5));

r = sqrt((X1-X2)^2 + (Y1-Y2)^2 + (a1-a2)^2 + (b1-b2)^2);

end