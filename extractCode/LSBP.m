function watermark = LSBP(image_b)
%Q为含有隐藏信息的矩阵
Q =image_b;
%隐藏信息矩阵大小
N=64;
%分块大小
K=8;
%提取出隐藏信息后的存放矩阵
W=zeros(N,N);
%提取系数
m=2;
n=1;
for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        %从原矩阵取出一个8*8矩阵
        block2=Q(x:x+K-1,y:y+K-1);
        %求出矩阵中元素二进制最后两位的差值
		temp0 = bitget(block2(m,n),2);
        temp1 = bitget(block2(m,n),1);
        temp = double(temp0) - double(temp1);
        %提取隐藏信息
		if(temp==1)
			W(p, q) = 1;
		else
			W(p, q) = 0;
        end
        %系数变换
        m=m+2;
        n=n+2;
        m=mod(n,8)+1;
        n=mod(m,8)+1;
    end
end
watermark = W;
return