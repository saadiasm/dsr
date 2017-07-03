function m = whiteRegBkgrnd(m)
        for i=1:size(m,1);
            for j=1:size(m,2)
                if (m(i,j,1) == 0 && m(i,j,2)==0 && m(i,j,3)==0)
                    m(i,j,1) = 255;
                    m(i,j,2) = 255;
                    m(i,j,3) = 255;
                end
            end
        end
end