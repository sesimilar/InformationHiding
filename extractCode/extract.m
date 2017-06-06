%����Ϊ�ָ��㷨
%ʹ�����������㷨�Ļָ��㷨�õ�����64*64�Ķ�ά����matrixR��matrixG��matrixB
%��ԭɫ������ϻָ���ԭͼ��
clear;
clc;
h=39;
w=39;
%��ȡ����������Ϣ��ͼƬ
imghiding=imread('../hidingCode/images/hide.bmp');
%�ֳ�R G Bֵ����
imagehide_r = imghiding(:,:,1);
imagehide_g = imghiding(:,:,2);
imagehide_b = imghiding(:,:,3);

%�����ƽ��ļ��ֿ��ƽ⣬����������Ϣ�ľ���
matrixR = DWTP(imagehide_r);
matrixG = DCTP(imagehide_g);
matrixB = LSBP(imagehide_b);

imghuifu = zeros(h,w);
num2 = 1;
bits='';
bitsR = zeros(1,64*64);
bitsG = zeros(1,64*64);
bitsB = zeros(1,64*64);
%��ȡ�õ�����ԭɫ�������ֵ����һά�����У��������ָ�
for i=1:64
    for j=1:64
        bitsR(1,(i-1)*64+j) = matrixR(i,j);
        bitsG(1,(i-1)*64+j) = matrixG(i,j);
        bitsB(1,(i-1)*64+j) = matrixB(i,j);
    end
end
%ÿȡ��λ��ɶ����ƴ�ת��Ϊʮ���ƴ���ָ�����
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
        elseif(num2<=64*64*3-120)  %��Ϊ���һ��������滹��120��λ���ǿյģ�û���������ݣ����Լ�ȥ120λ
            for i=num2:num2+7
                bits = strcat(bits,num2str(bitsB(num2-64*64*2)));
                num2 = num2+1;
            end
        end
        %��ȡ�õİ�λ�����ƴ�תΪʮ���ƴ���ָ�����
        imghuifu(row,column) = bin2dec(bits);
        bits = '';
    end
end;

%���һָ�
huifu = huifu(imghuifu);
imshow(huifu,[]);
imwrite(huifu,'images/extract.bmp','bmp');
title('��ȡ��ˮӡͼ��');