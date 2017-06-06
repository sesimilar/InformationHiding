%读取要隐藏的灰度图
img1=imread('images/yang1.bmp');
%读取载体图片
imghide=imread('images/lenaRGB.bmp');

%获取载体图片R值矩阵
image_r = imghide(:,:,1);
%获取载体图片G值矩阵
image_g = imghide(:,:,2);
%获取载体图片B值矩阵
image_b = imghide(:,:,3);
%置乱
img2 = zhiluan(img1);
[h w e]=size(img2);
img2 = double(img2);

%将图像的每个像素点转换成8位二进制
matrixImg = reshape(cellstr(dec2bin(img2,8)),size(img2));

%生成三个二维矩阵存放转换后的二进制串
matrixR=zeros(64,64);
matrixG=zeros(64,64);
matrixB=zeros(64,64);
%二进制个数
num = 1;
%将置乱的图像存入三个64*64的矩阵中，方便后续进行的加密算法（隐藏进入彩色图片R\G\B的三个二维矩阵）
for row = 1:h
    for column = 1:w
        for pos = 8:-1:1
            if(num<=64*64)
                %将前面64*64个比特隐藏进R二维矩阵
                if(mod(num,64)~=0)
                    matrixR(floor(num/64+1),mod(num,64)) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                else
                    matrixR(floor(num/64),64) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                end
            elseif(num<=64*64*2)
                %将中间64*64个比特隐藏进G二维矩阵
                if(mod(num,64)~=0)
                    matrixG(floor(num/64+1)-64,mod(num,64)) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                else
                    matrixG(floor(num/64)-64,64) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                end
            elseif(num<=64*64*3)
                %将最后64*64-120个比特隐藏进B二维矩阵，后面的120位不隐藏数据，因此全是2
                if(mod(num,64)~=0)
                    matrixB(floor(num/64+1)-128,mod(num,64)) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                else
                    matrixB(floor(num/64)-128,64) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                end
            end    
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%调用三种隐藏算法分别在彩色图片的三个二维矩阵中隐藏matrixR、matrixG、matrixB
%最终三种隐藏算法后输出一张藏有隐藏图片的彩色图片
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%用DWT对R值矩阵做信息隐藏，隐藏信息为matrixR
image_r = DWT(image_r,matrixR);
%用DCT对G值矩阵做信息隐藏，隐藏信息为matrixG
image_g = DCT(image_g,matrixG);
%用LSB对B值矩阵做信息隐藏，隐藏信息为matrixB
image_b = LSB(image_b,matrixB);

%将隐藏信息后的R、G、B重新写入图片矩阵imghide中
imghide(:,:,1) = image_r;
imghide(:,:,2) = image_g;
imghide(:,:,3) = image_b;

subplot(1,1,1)
imshow(imghide);
title('信息隐藏后的图片')
%保存隐藏信息后的图片
imwrite(imghide,'images/hide.bmp');