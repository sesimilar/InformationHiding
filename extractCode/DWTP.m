function watermark = DWTP(process)
%idwtextract 逆小波变换水印提取
%   传入嵌入信息后的载体矩阵process 512*512
%   返回水印矩阵watermark 64*64
N=64;  % 水印信息长度
K=8;   % 分块系数
watermark = zeros(N,N); %水印图片数据

%提取水印信息
for i=1:N
    for j = 1:N
        %定位Block的顶点
            x=(i-1)*K+1;
            y=(j-1)*K+1;
            %依次找到藏信息的block
            block = process(x:x+K-1,y:y+K-1);
            %对block作二维DWT变换
            [cA1,cH1,cV1,cD1]=dwt2(block,'db1');
            %注意
            %这里是对block的cH1水平细节系数进行第二次DWT变换
            [cA2,cH2,cV2,cD2]=dwt2(cH1,'db1');
            %如果cH2(2,2)的值为1，表示嵌入的信息为1
        if((cH2(1,1)-cH2(2,2))<-0.000001)
            %cH2为我们藏信息的矩阵，这是一个2*2的矩阵
            %如果cH2(1,1)<cH2(2,2),表示嵌入的是0
            watermark(i,j)=0;
        elseif((cH2(1,1)-cH2(2,2))>-0.000001)
            %如果cH2(1,1)>=cH2(2,2),表示嵌入的是1
            watermark(i,j)=1;
        else
            %如果为其他的，表示嵌入的信息是填充信息，统一表示为2
            watermark(i,j)=2;
        end
    end
end
return 

