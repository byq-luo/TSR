close all
for i=1:1220

pth=strcat('train\',num2str(i),'.jpg');
%pth=strcat('ircnn_train\',num2str(i),'.jpg');
rgb_image=imread(pth)   %读取图像

mai=imread(strcat('.\wm',num2str(round(rand(1,1)*2)+1),'.jpg'));
m=imresize(mai,[32 32]);
%figure,imshow(rgb_image)
%实现rgb图像转化为NTSC彩色空间的图像
yiq_image=rgb2ntsc(rgb_image); 
fY=yiq_image(:,:,1);           %图像的亮度
fI=yiq_image(:,:,2);            %图像的色调
fQ=yiq_image(:,:,3);           %图像的饱和度

yiq_image2=rgb2ntsc(m); 
fY2=yiq_image2(:,:,1);           %图像的亮度
fI2=yiq_image2(:,:,2);            %图像的色调
fQ2=yiq_image2(:,:,3);           %图像的饱和度

RGB_image2(:,:,1)=(fY+fY2)/2.0;
RGB_image2(:,:,2)=(fI+fI2)/2.0;
RGB_image2(:,:,3)=(fQ+fQ2)/2.0;

RGB_image2=ntsc2rgb(RGB_image2);
path=strcat(strcat('.\train_noise\',num2str(i)),'.jpg');
%path=strcat(strcat('.\ircnn_train2\',num2str(i)),'.jpg');
imwrite(RGB_image2,path);

end