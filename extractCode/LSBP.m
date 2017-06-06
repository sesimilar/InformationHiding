function watermark = LSBP(image_b)
%QΪ����������Ϣ�ľ���
Q =image_b;
%������Ϣ�����С
N=64;
%�ֿ��С
K=8;
%��ȡ��������Ϣ��Ĵ�ž���
W=zeros(N,N);
%��ȡϵ��
m=2;
n=1;
for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        %��ԭ����ȡ��һ��8*8����
        block2=Q(x:x+K-1,y:y+K-1);
        %���������Ԫ�ض����������λ�Ĳ�ֵ
		temp0 = bitget(block2(m,n),2);
        temp1 = bitget(block2(m,n),1);
        temp = double(temp0) - double(temp1);
        %��ȡ������Ϣ
		if(temp==1)
			W(p, q) = 1;
		else
			W(p, q) = 0;
        end
        %ϵ���任
        m=m+2;
        n=n+2;
        m=mod(n,8)+1;
        n=mod(m,8)+1;
    end
end
watermark = W;
return