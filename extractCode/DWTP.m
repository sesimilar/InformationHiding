function watermark = DWTP(process)
%idwtextract ��С���任ˮӡ��ȡ
%   ����Ƕ����Ϣ����������process 512*512
%   ����ˮӡ����watermark 64*64
N=64;  % ˮӡ��Ϣ����
K=8;   % �ֿ�ϵ��
watermark = zeros(N,N); %ˮӡͼƬ����

%��ȡˮӡ��Ϣ
for i=1:N
    for j = 1:N
        %��λBlock�Ķ���
            x=(i-1)*K+1;
            y=(j-1)*K+1;
            %�����ҵ�����Ϣ��block
            block = process(x:x+K-1,y:y+K-1);
            %��block����άDWT�任
            [cA1,cH1,cV1,cD1]=dwt2(block,'db1');
            %ע��
            %�����Ƕ�block��cH1ˮƽϸ��ϵ�����еڶ���DWT�任
            [cA2,cH2,cV2,cD2]=dwt2(cH1,'db1');
            %���cH2(2,2)��ֵΪ1����ʾǶ�����ϢΪ1
        if((cH2(1,1)-cH2(2,2))<-0.000001)
            %cH2Ϊ���ǲ���Ϣ�ľ�������һ��2*2�ľ���
            %���cH2(1,1)<cH2(2,2),��ʾǶ�����0
            watermark(i,j)=0;
        elseif((cH2(1,1)-cH2(2,2))>-0.000001)
            %���cH2(1,1)>=cH2(2,2),��ʾǶ�����1
            watermark(i,j)=1;
        else
            %���Ϊ�����ģ���ʾǶ�����Ϣ�������Ϣ��ͳһ��ʾΪ2
            watermark(i,j)=2;
        end
    end
end
return 

