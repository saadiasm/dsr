function destIm=showImageInImage(destIm,sourceIm,foreColor)
% Source image is assumed as logical 2-d image
% destination image is an RGB blank Image

for i=1:size(sourceIm,1)
    for j=1:size(sourceIm,2)
        if (sourceIm(i,j) == 1 || sourceIm(i,j)==255)       
            destIm(i,j,1)=foreColor(1);
            destIm(i,j,2)=foreColor(2);
            destIm(i,j,3)=foreColor(3);
        end
    end
end

end