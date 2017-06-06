%下面为恢复算法
%使用三种隐藏算法的恢复算法得到三个64*64的二维矩阵matrixR、matrixG、matrixB
%三原色矩阵组合恢复成原图像
clear;
clc;
h=39;
w=39;
%读取含有隐藏信息的图片
imghiding=imread('../hidingCode/images/hide.bmp');
%分出R G B值矩阵
imagehide_r = imghiding(:,:,1);
imagehide_g = imghiding(:,:,2);
imagehide_b = imghiding(:,:,3);

%传入破解文件分块破解，传回隐藏信息的矩阵
matrixR = DWTP(imagehide_r);
matrixG = DCTP(imagehide_g);
matrixB = LSBP(imagehide_b);

imghuifu = zeros(h,w);
num2 = 1;
bits='';
bitsR = zeros(1,64*64);
bitsG = zeros(1,64*64);
bitsB = zeros(1,64*64);
%将取得的三个原色矩阵里的值存入一维矩阵中，方便后面恢复
for i=1:64
    for j=1:64
        bitsR(1,(i-1)*64+j) = matrixR(i,j);
        bitsG(1,(i-1)*64+j) = matrixG(i,j);
        bitsB(1,(i-1)*64+j) = matrixB(i,j);
    end
end
%每取八位组成二进制串转换为十进制存入恢复矩阵
for row = 1:h
    for column = 1:w
        if(num2<=64*64)
            for i=num2:num2+7
                bits = strcat(bits,num2str(bitsR(num2)));
                num2 = num2+1;
            end
        elseif(num2<=64*64*2)
            for i=num2:num2+7
                bits = strcat(bits,num2str(bitsG(num2-64*64)));
                num2 = num2+1;
            end
        elseif(num2<=64*64*3-120)  %因为最后一个矩阵后面还有120个位置是空的，没有隐藏数据，所以减去120位
            for i=num2:num2+7
                bits = strcat(bits,num2str(bitsB(num2-64*64*2)));
                num2 = num2+1;
            end
        end
        %将取得的八位二进制串转为十进制存入恢复矩阵
        imghuifu(row,column) = bin2dec(bits);
        bits = '';
    end
end;

%置乱恢复
huifu = huifu(imghuifu);
imshow(huifu,[]);
imwrite(huifu,'images/extract.bmp','bmp');
title('提取的水印图像');