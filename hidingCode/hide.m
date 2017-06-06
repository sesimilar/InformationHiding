%��ȡҪ���صĻҶ�ͼ
img1=imread('images/yang1.bmp');
%��ȡ����ͼƬ
imghide=imread('images/lenaRGB.bmp');

%��ȡ����ͼƬRֵ����
image_r = imghide(:,:,1);
%��ȡ����ͼƬGֵ����
image_g = imghide(:,:,2);
%��ȡ����ͼƬBֵ����
image_b = imghide(:,:,3);
%����
img2 = zhiluan(img1);
[h w e]=size(img2);
img2 = double(img2);

%��ͼ���ÿ�����ص�ת����8λ������
matrixImg = reshape(cellstr(dec2bin(img2,8)),size(img2));

%����������ά������ת����Ķ����ƴ�
matrixR=zeros(64,64);
matrixG=zeros(64,64);
matrixB=zeros(64,64);
%�����Ƹ���
num = 1;
%�����ҵ�ͼ���������64*64�ľ����У�����������еļ����㷨�����ؽ����ɫͼƬR\G\B��������ά����
for row = 1:h
    for column = 1:w
        for pos = 8:-1:1
            if(num<=64*64)
                %��ǰ��64*64���������ؽ�R��ά����
                if(mod(num,64)~=0)
                    matrixR(floor(num/64+1),mod(num,64)) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                else
                    matrixR(floor(num/64),64) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                end
            elseif(num<=64*64*2)
                %���м�64*64���������ؽ�G��ά����
                if(mod(num,64)~=0)
                    matrixG(floor(num/64+1)-64,mod(num,64)) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                else
                    matrixG(floor(num/64)-64,64) = bitget(bin2dec(matrixImg(row,column)),pos);
                    num = num+1;
                end
            elseif(num<=64*64*3)
                %�����64*64-120���������ؽ�B��ά���󣬺����120λ���������ݣ����ȫ��2
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
%�������������㷨�ֱ��ڲ�ɫͼƬ��������ά����������matrixR��matrixG��matrixB
%�������������㷨�����һ�Ų�������ͼƬ�Ĳ�ɫͼƬ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��DWT��Rֵ��������Ϣ���أ�������ϢΪmatrixR
image_r = DWT(image_r,matrixR);
%��DCT��Gֵ��������Ϣ���أ�������ϢΪmatrixG
image_g = DCT(image_g,matrixG);
%��LSB��Bֵ��������Ϣ���أ�������ϢΪmatrixB
image_b = LSB(image_b,matrixB);

%��������Ϣ���R��G��B����д��ͼƬ����imghide��
imghide(:,:,1) = image_r;
imghide(:,:,2) = image_g;
imghide(:,:,3) = image_b;

subplot(1,1,1)
imshow(imghide);
title('��Ϣ���غ��ͼƬ')
%����������Ϣ���ͼƬ
imwrite(imghide,'images/hide.bmp');