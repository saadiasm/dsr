% After work on regions : removing outliers for Lab6_* images on the basis
% of centre variance.

% This work uses euclidean distance to remove outliers for straight
% detectors. No removal is done for tilted detectors.

function removeOutliers(outfile_name_start)

% fname = sprintf('%s_rankedData.mat',outfile_name_start);
% load (fname)

global final;

if (final.num_ellipses>0)    
    centres_X=[];
    centres_Y=[];
    a=[]
    b=[]

    nFinalEllipses = size(final.ellipses,2);
    for i=1: nFinalEllipses
        centres_X = [centres_X final.ellipses{i}(1)];
        centres_Y = [centres_Y final.ellipses{i}(2)];
        a = [a final.ellipses{i}(4)];
        b = [b final.ellipses{i}(5)];
    end
    
    data=[centres_X ; centres_Y]';    
    n = size(data, 1);   
    
    majors = max(a,b);
    minors = min(a,b);
    ratioAB = [majors./minors];
    
    [count, bins] = hist(ratioAB,n);
    [value, index] = max(count);
    
    mode_bin_centre = bins(index); % bin centre containing mode values.
    if (mode_bin_centre <= 1.1)
        disp 'Orthognal detector'
        type = 'O';
    else
        disp 'Tilted detector'
        type = 'T';
    end
    
    if (type == 'O')
        

        if (n >= 2)
            if (n > 2)
                binSize = round(n/2);
            else 
                binSize = n;
            end
            select = zeros(n,1);
            [N,C] = hist3(data, [binSize binSize]);
            [r,c] = find(N==max(N(:)));
            men = [C{1}(r(1)) C{2}(c(1))];  % getting bin_centre of mode bin
            Mu = data - repmat(men, n,1);

            e_dist = sqrt(Mu(:,1).^2 + Mu(:,2).^2);         % Euclidean distance : e_dist
            select = (e_dist <= 50)';
        else
            select = ones(n,1);            
        end

        minSel = min(select(:));
        if (minSel == 0)      % There were some outliers i.e. zero exists means some are not selected for final      
            final.new_ellipses={};
            final.new_regions={};
            final.new_full_ellipses={};
            final.ranks=[];

            cNew=1;    % New Count
            for k=1:size(select,2)
                if (select(k) == 1)
                    final.new_ellipses{cNew} = final.ellipses{k};
                    final.new_regions{cNew} = final.regions{k};
                    final.new_full_ellipses{cNew} = final.full_ellipses{k};
                    final.ranks(cNew)=cNew;
        %             
                    cNew = cNew + 1;
                end
            end

            final.num_ellipses = cNew - 1;
            final.cap = final.cap(select);
            final.ade = final.ade(select);

            final.erank_show_point = final.erank_show_point(select,:);
            final.erank_show_point_full = final.erank_show_point_full(select,:);

            final.ellipses = final.new_ellipses;
            final.regions= final.new_regions;
            final.full_ellipses = final.new_full_ellipses;

            final.new_ellipses={};
            final.new_regions={};
            final.new_full_ellipses={};

            clear final.new_ellipses;
            clear final.new_regions;
            clear final.new_full_ellipses;
        %     fname = sprintf('%s', 'Results\LaB6_0021\o_LaB6_0021__outLClearData.mat');
        end
    end
%     fname = sprintf('%s_outLClearData.mat',outfile_name_start);
%     save(fname,'pd','final','thrsh'); 
end
end