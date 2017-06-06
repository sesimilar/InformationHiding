function image_g = DCT(original,watermark)
M=512; % 原图像长度  b=zeros(size(a),'uint8');
I=zeros(M,M);	% 原图数据
D=zeros(M,M);	
D1=zeros(M,M,'uint8');
J=zeros(M,M); % 水印图片的信息
N=64;                   % 水印信息长度
W=zeros(N,N);	%恢复的水印
L=zeros(M,M);
block_dct1=zeros(M,M);
block_idct=zeros(M,M);
K=8;                     % 分块系数


%隐藏矩阵存到I中，隐藏信息存到J中
I=original;
J=watermark;
for m=1:N                               %N=64为隐藏信息矩阵大小
    for n=1:N 
        x=(m-1)*K+1;                    %K=8为分块的大小
        y=(n-1)*K+1;
        block_dct=I(x:x+K-1,y:y+K-1);   %取出一个8*8分块
        block_dct1=dct2(block_dct);     %对分块进行二维离散余弦变换 
		if(J(m, n)==0)
			%和斜下角的对比 小于就插入0
			if(block_dct1(4,4)>block_dct1(5,5))
                if(abs(block_dct1(4,4)-block_dct1(5,5))<4)
                    block_dct1(5,5) = block_dct1(5,5) - 4;
                end
				temp = block_dct1(4,4);
				block_dct1(4,4) = block_dct1(5,5);
				block_dct1(5,5) = temp;
			end
        else
			%大于斜下角的就插入1
			if(block_dct1(4,4)<block_dct1(5,5))
                if(abs(block_dct1(4,4)-block_dct1(5,5))<4)
                    block_dct1(4,4) = block_dct1(4,4) - 4;
                end
				temp = block_dct1(4,4);
				block_dct1(4,4) = block_dct1(5,5);
				block_dct1(5,5) = temp;
			end
		end
        block_idct=idct2(block_dct1);     %逆离散余弦变换
        
        D(x:x+K-1,y:y+K-1)=block_idct;    %保存嵌入秘密信息后的逆变换结果
    end
end
image_g = uint8(D);
return
