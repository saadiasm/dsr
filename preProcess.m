function binary_img = preProcess(img)
% Input:    img contains raw image sent here just after reading from file.
% Output:   Pre-Procesed Binary Image
global pd;
global const;

MaxPixelValue = 255;  % Highest grey Level required

pd.All=[];

%   For fold.png
%     pd.origImg = img;

%   Convert gray if colored image
    if (size(img,3)>1)
        img=rgb2gray(img);
    end
    img=double(img);

% Make Full Size Visible Image    
    pd.normFull=(img-min(img(:)))/(max(img(:))-min(img(:)))*255;
    pd.normFull = img;
    imshow(pd.normFull);
    
    pd.norSmoothFull = conv2(pd.normFull,fspecial('gaussian',2,1),'same'); %Smoothing using 2x2 guassian
    ntyPerc = quantile(pd.norSmoothFull(:),.9); %ntyPerc = 90th percentile 
    pd.normSmoothBinarFull = pd.norSmoothFull > ntyPerc; % Get binary images. A normalized, smoothed and binarized image
    pd.fullSizeImage = pd.normSmoothBinarFull;
    
%   For fold.png
%     pd.fullSizeImage = origImg;
    
    pre_filename='';
    pre_filename = sprintf('%sorigVisible.png',pd.outfile_name_start)
    imwrite(pd.fullSizeImage, pre_filename);

%   Scale down to smaller size
    scaleCount=0;
    SCALE=1;
    r=size(img,1);
    c=size(img,2);
    while (r >= 1024 && c >= 1024)
        scaleCount = scaleCount+1;   
        c=c/2;
        r=r/2;
    end
    
    if (scaleCount > 0)
        SCALE = 1 / (2^scaleCount);    
        img=imresize(img,SCALE);
    end
    pd.scale = SCALE;
    
% Work on scaled-sized Image: This image is origional one just scaled to
% smaller size
    pd.normImage=(img-min(img(:)))/(max(img(:))-min(img(:)))*255;  % Map all intensities to 0-255
    pd.normSmooth = conv2(pd.normImage,fspecial('gaussian',2,1),'same');  % Smooth Image

    pre_filename='';
    % all stages of pre-processing are stored in pd.All image
    pre_filename = sprintf('%snormImage.png',pd.outfile_name_start);
    imwrite(pd.normImage, pre_filename);
    pd.All=[pd.All pd.normImage];
    
    pre_filename = sprintf('%snormSmooth.png',pd.outfile_name_start);
    imwrite(pd.normSmooth, pre_filename);
    pd.All=[pd.All pd.normSmooth];
    
    [pd.LL pd.gD pd.gM pd.gX pd.gY] = Derivative(pd.normSmooth);
    ntyPercGM = quantile(pd.gM(:),.90);         % ntyPercGM = 90th pemcentile of gradiant magnitude
    pd.normSmoothGBinar = pd.gM > ntyPercGM;    % Normalized, smoothed and gradiant Binarized Image

    pre_filename = sprintf('%sNorSmoothGBinarized.png',pd.outfile_name_start)
    imwrite(pd.normSmoothGBinar, pre_filename);
    pd.All=[pd.All pd.normSmoothGBinar];
     
% Apply morphological operations  (dilation and thining)    
    dilt=bwmorph(pd.normSmoothGBinar,'dilate');
    
%   Following two lines are to show results in ESRF paper, we use an example of max1.png to show
%   effect of dilation and thinning.
    %pre_filename = sprintf('%sDilatedPart.png',pd.outfile_name_start)
    %imwrite(1-dilt(135:197,160:222), pre_filename);
    
    pre_filename = sprintf('%sDilated.png',pd.outfile_name_start)
    imwrite(dilt, pre_filename);
    pd.All=[pd.All dilt];
    
    thin=bwmorph(dilt,'thin');          
%   Following two lines are to show results in ESRF paper, we use an example to show
%   effect of dilation and thinning.
    %pre_filename = sprintf('%sThinnedPart.png',pd.outfile_name_start)
    %imwrite(1-thn(135:197,160:222), pre_filename);
    pre_filename = sprintf('%sThinned.png',pd.outfile_name_start)
    imwrite(thin, pre_filename);
    pd.All=[pd.All thin];
    pre_filename = sprintf('%sAll.png',pd.outfile_name_start)
    imwrite(pd.All, pre_filename);
    
    binary_img = thin;
    
    [pd.LL pd.gD pd.gM pd.gX pd.gY] = Derivative(binary_img); 
end