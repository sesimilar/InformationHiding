function image_g = DCT(original,watermark)
M=512; % ԭͼ�񳤶�  b=zeros(size(a),'uint8');
I=zeros(M,M);	% ԭͼ����
D=zeros(M,M);	
D1=zeros(M,M,'uint8');
J=zeros(M,M); % ˮӡͼƬ����Ϣ
N=64;                   % ˮӡ��Ϣ����
W=zeros(N,N);	%�ָ���ˮӡ
L=zeros(M,M);
block_dct1=zeros(M,M);
block_idct=zeros(M,M);
K=8;                     % �ֿ�ϵ��


%���ؾ���浽I�У�������Ϣ�浽J��
I=original;
J=watermark;
for m=1:N                               %N=64Ϊ������Ϣ�����С
    for n=1:N 
        x=(m-1)*K+1;                    %K=8Ϊ�ֿ�Ĵ�С
        y=(n-1)*K+1;
        block_dct=I(x:x+K-1,y:y+K-1);   %ȡ��һ��8*8�ֿ�
        block_dct1=dct2(block_dct);     %�Էֿ���ж�ά��ɢ���ұ任 
		if(J(m, n)==0)
			%��б�½ǵĶԱ� С�ھͲ���0
			if(block_dct1(4,4)>block_dct1(5,5))
                if(abs(block_dct1(4,4)-block_dct1(5,5))<4)
                    block_dct1(5,5) = block_dct1(5,5) - 4;
                end
				temp = block_dct1(4,4);
				block_dct1(4,4) = block_dct1(5,5);
				block_dct1(5,5) = temp;
			end
        else
			%����б�½ǵľͲ���1
			if(block_dct1(4,4)<block_dct1(5,5))
                if(abs(block_dct1(4,4)-block_dct1(5,5))<4)
                    block_dct1(4,4) = block_dct1(4,4) - 4;
                end
				temp = block_dct1(4,4);
				block_dct1(4,4) = block_dct1(5,5);
				block_dct1(5,5) = temp;
			end
		end
        block_idct=idct2(block_dct1);     %����ɢ���ұ任
        
        D(x:x+K-1,y:y+K-1)=block_idct;    %����Ƕ��������Ϣ�����任���
    end
end
image_g = uint8(D);
return
