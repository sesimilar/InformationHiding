function image_r = DWT(original,watermark)
%dwthiding 小波变换信息隐藏
%   传入载体矩阵origin      512*512
%   传入水印矩阵watermark    64*64
%   输出嵌入信息矩阵process 512*512

M=512; % 原图像长度
N=64;  % 水印信息长度
K=8;   % 分块系数
D = 5;
image_r =zeros(M,M); %处理后的水印矩阵数据
block_dwt = zeros(K,K);
sX=size(block_dwt);%矩阵的维度
ncH1 = zeros(K/2,K/2);
sX2 = size(ncH1);%矩阵的维度

%　读取源图像和水印数据,并显示
%subplot(1,3,1); 
%original=imread('low.bmp','bmp'); 
%original=original(1:M,1:M);
%imshow(original);
%title('源图像');

%subplot(1,3,2);
%watermark=imread('mark.bmp','bmp');
%watermark=watermark(1:N,1:N);
%imshow(watermark);
%title('水印信息');

%嵌入水印信息
   for i=1:N
    for j = 1:N
        %定位Block的顶点
            x=(i-1)*K+1;
            y=(j-1)*K+1;
            %找到要藏信息的block
            block = original(x:x+K-1,y:y+K-1);
            %对block作二维DWT变换
            [cA1,cH1,cV1,cD1]=dwt2(block,'db1');
            %注意
            %这里是对block的cH1水平细节系数进行第二次DWT变换
            [cA2,cH2,cV2,cD2]=dwt2(cH1,'db1');
        %如果要嵌入的信息为1
        if(watermark(i,j)==1)
            %cH2即为我们要藏信息的矩阵，这是一个2*2的矩阵
            %如果是要嵌入1，表示cH(1,1)>=cH(2,2)
            %对于两个数，用距离D来放大他们的大小关系以降低提取难度
            if((cH2(1,1)-cH2(2,2))<0.000001)
                temp = cH2(2,2);
                cH2(2,2) = cH2(1,1)-D;
                cH2(1,1) = temp+D;
            end
        elseif(watermark(i,j)==0)
           %如果是要嵌入0,则表示cH(1,1)<cH(2,2)
           %对于两个数，用距离D来放大他们的大小关系以降低提取难度
           if((cH2(1,1)-cH2(2,2))>0.000001)
               temp = cH2(2,2);
               cH2(2,2) = cH2(1,1)+D;
               cH2(1,1) = temp-D;
           end
        else
            %如果是填充信息
            
        end
        %作两次逆DWT变换
        xcH1 = idwt2(cA2,cH2,cV2,cD2,'db1',sX2);
        A0 = idwt2(cA1,xcH1,cV1,cD1,'db1',sX);
        %保存嵌入秘密信息后的逆变换结果
        image_r(x:x+K-1,y:y+K-1) = A0;      
    end
   end
   image_r = uint8(image_r);
return

