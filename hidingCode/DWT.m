function image_r = DWT(original,watermark)
%dwthiding С���任��Ϣ����
%   �����������origin      512*512
%   ����ˮӡ����watermark    64*64
%   ���Ƕ����Ϣ����process 512*512

M=512; % ԭͼ�񳤶�
N=64;  % ˮӡ��Ϣ����
K=8;   % �ֿ�ϵ��
D = 5;
image_r =zeros(M,M); %������ˮӡ��������
block_dwt = zeros(K,K);
sX=size(block_dwt);%�����ά��
ncH1 = zeros(K/2,K/2);
sX2 = size(ncH1);%�����ά��

%����ȡԴͼ���ˮӡ����,����ʾ
%subplot(1,3,1); 
%original=imread('low.bmp','bmp'); 
%original=original(1:M,1:M);
%imshow(original);
%title('Դͼ��');

%subplot(1,3,2);
%watermark=imread('mark.bmp','bmp');
%watermark=watermark(1:N,1:N);
%imshow(watermark);
%title('ˮӡ��Ϣ');

%Ƕ��ˮӡ��Ϣ
   for i=1:N
    for j = 1:N
        %��λBlock�Ķ���
            x=(i-1)*K+1;
            y=(j-1)*K+1;
            %�ҵ�Ҫ����Ϣ��block
            block = original(x:x+K-1,y:y+K-1);
            %��block����άDWT�任
            [cA1,cH1,cV1,cD1]=dwt2(block,'db1');
            %ע��
            %�����Ƕ�block��cH1ˮƽϸ��ϵ�����еڶ���DWT�任
            [cA2,cH2,cV2,cD2]=dwt2(cH1,'db1');
        %���ҪǶ�����ϢΪ1
        if(watermark(i,j)==1)
            %cH2��Ϊ����Ҫ����Ϣ�ľ�������һ��2*2�ľ���
            %�����ҪǶ��1����ʾcH(1,1)>=cH(2,2)
            %�������������þ���D���Ŵ����ǵĴ�С��ϵ�Խ�����ȡ�Ѷ�
            if((cH2(1,1)-cH2(2,2))<0.000001)
                temp = cH2(2,2);
                cH2(2,2) = cH2(1,1)-D;
                cH2(1,1) = temp+D;
            end
        elseif(watermark(i,j)==0)
           %�����ҪǶ��0,���ʾcH(1,1)<cH(2,2)
           %�������������þ���D���Ŵ����ǵĴ�С��ϵ�Խ�����ȡ�Ѷ�
           if((cH2(1,1)-cH2(2,2))>0.000001)
               temp = cH2(2,2);
               cH2(2,2) = cH2(1,1)+D;
               cH2(1,1) = temp-D;
           end
        else
            %����������Ϣ
            
        end
        %��������DWT�任
        xcH1 = idwt2(cA2,cH2,cV2,cD2,'db1',sX2);
        A0 = idwt2(cA1,xcH1,cV1,cD1,'db1',sX);
        %����Ƕ��������Ϣ�����任���
        image_r(x:x+K-1,y:y+K-1) = A0;      
    end
   end
   image_r = uint8(image_r);
return

