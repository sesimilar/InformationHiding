function watermark = DCTP(image_r)
L=image_r;
N = 64;
K = 8;
for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        block2=L(x:x+K-1,y:y+K-1);   %D保存嵌入秘密信息后的图像值
        block_dct2=dct2(block2);     %对分块进行二维离散余弦变换
		if(block_dct2(4,4)<block_dct2(5,5))
			W(p, q) = 0;
		else
			W(p, q) = 1;
		end
    end
end
watermark = W;
return