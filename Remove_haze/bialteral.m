function retimg = bialteral(img ,N ,sigma)
%% colorspace transformation
   img = rgb2hsv(img);%convert rgb to hsv colorspace in order to process

%% pre-computer domain filtering
sigma_d = sigma(1);
sigma_r = sigma(2);
[X,Y] = meshgrid(-N:N,-N:N);%generate two matrix 
D = exp(-(X.^2+Y.^2)/(2*sigma_d^2));%domain weights with Euclidean distance

%% create waitbar
h = waitbar(0,'illumination retinex algorithm¡­¡­');
set(h,'Name','Illumination Retinex');

%% rang filtering in v layer
dim = size(img);%dim=[height,length,3]
B = zeros(dim);%create an image B with the same size and dimension with the zero value.
for i = 1:dim(1)
    for j = 1:dim(2)
        iMin = max(i-N,1);
        iMax = min(i+N,dim(1));
        jMin = max(j-N,1);
        jMax = min(j+N,dim(2));
        L = img(iMin:iMax,jMin:jMax,3);%extract the local region
        
        d = L-img(i,j,3);%the dissimilarity between the surroud and center
          
        R = exp(-(d.^2)/(2*sigma_r^2));%range filter weights
                
        F = R.*D((iMin:iMax)-i+N+1,(jMin:jMax)-j+N+1);%its row is from iMin-i+N+1 to iMax-i+N+1,and so as line
        for m = 1:iMax-iMin+1
            for n = 1:jMax-jMin+1
                if d(m,n) < 0
                    F(m,n) = 0;
                end
            end
        end
        norm_F = sum(F(:));
        B(i,j,3) = sum(sum(F.*L))/norm_F;

        retimg(i,j,1) = img(i,j,1);
        retimg(i,j,2) = img(i,j,2);
        retimg(i,j,3) = B(i,j,3);
    end
    waitbar(i/dim(1));
end
close(h);%close the bar

%% display colorspace transformation
img = hsv2rgb(img);
retimg = hsv2rgb(retimg);