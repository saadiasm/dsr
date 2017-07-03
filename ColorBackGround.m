function Img1 = ColorBackGround(Img1,BackColor)
    Img1(:,:,1)=BackColor(1);
    Img1(:,:,2)=BackColor(2);
    Img1(:,:,3)=BackColor(3);
end