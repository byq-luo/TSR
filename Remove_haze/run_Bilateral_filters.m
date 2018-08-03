clear all;%clear the values
clc;%clear the command window
for ii=1:400
    
strhead =strcat('train_noise\',num2str(ii));%the name of file
strtail = '.jpg' ;% the format of the file
str = strcat(strhead,strtail);
img = im2double(imread(str));%read the image and convert to double.
N = 15;%the size of filter
sigma = [100 , 0.3];%the parameters of bilateral filter 
retimg = bialteral(img , N , sigma );%get the illumination image


%% s-l
img_copy = rgb2hsv(img);
img_copy3 = log(img_copy(:,:,3));
retimg_copy = rgb2hsv(retimg);
retimg_copy3 = log(retimg_copy(:,:,3));%only to v layer
r_img = img_copy3 - retimg_copy3;
r_img = exp(r_img);
N = 4;
sigma = [100,0.3];
retinex_img(:,:,3) = bialteral2(r_img,N,sigma);%get reflect image

dim = size(img);
for i = 1:dim(1)
     for j = 1:dim(2)        
         img_copy(i,j,3) = img_copy(i,j,3)^(1/3);         
     end
end
retinex_img(:,:,3) = retinex_img(:,:,3).*(img_copy(:,:,3));
 
retinex_img(:,:,1) = img_copy(:,:,1);
retinex_img(:,:,2) = img_copy(:,:,2);
retinex_img = hsv2rgb(retinex_img);

%% Gamma-correction
% dim = size(img);
% for i = 1:dim(1)
%      for j = 1:dim(2)
%          for c=1:3
%          img(i,j,c) = img(i,j,c)^(1/3);
%          end
%      end
%  end
%         retinex_img(:,:,1) = retinex_img(:,:,1).*(img(:,:,1));
%         retinex_img(:,:,2) = retinex_img(:,:,2).*(img(:,:,2));
%         retinex_img(:,:,3) = retinex_img(:,:,3).*(img(:,:,3));


path=strcat(strcat('.\Bilateral_filters\',num2str(ii)),'.jpg');
imwrite(retinex_img,path,'jpg');
end