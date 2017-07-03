% function showCombineImages()

function showCombineImages(dir, imFile, nIED, nFamily, nMerged)
global pd
im1 = imread(sprintf('%s%s_Regs.png',dir,imFile));
im2 = imread(sprintf('%s%s__Ranked_%d.png',dir,imFile,nIED));
im3 = imread(sprintf('%s%s__Family_%d.png',dir,imFile,nFamily));
im4 = imread(sprintf('%s%s__Merged_%d.png',dir,imFile,nMerged));

im = [im1 im2 ; im3 im4];
figure; imshow(im);
imwrite(im, sprintf('%s%s_CombineResult.png',dir, imFile));   

% SHOW Full Size Result
im1 = imread(sprintf('%s%s__Ranked_FullSize_%d.png',dir,imFile,nIED));
im2 = imread(sprintf('%s%s__FamilyFullSize.png',dir,imFile));
im3 = imread(sprintf('%s%s__MergedFullSize.png',dir,imFile));
im = [im1 im2 im3];
figure; imshow(im);
imwrite(im, sprintf('%s%s_CombineResult_FullSize.png',dir, imFile));   
end