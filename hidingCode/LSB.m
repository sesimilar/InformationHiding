function image_b = LSB(original,watermark)
%���ؾ���浽I�У�������Ϣ�浽J��
L =original;      
J=watermark;
%NΪ���ؾ����С
N=64;
%KΪ�ֿ��С1
K=8;
%p,qΪ�任ϵ��
p=2;
q=1;

%
%����˼�룺��512*512�ľ����Ϊ64*64��8*8�ķ��飬����p,qѡ��������ĳһ��Ԫ�أ�����LSB��������0��1
%p,q�任��p��ʼֵΪ2��q��ʼֵΪ1��ÿ��һ��8*8����Ƕ������Ϣ��p��ֵΪq+2��8��ģ��ֵ��1����ģ�ó���ֵ����Ϊ1����ͬ��q��ֵΪp+2��8��ģ��ֵ��1
%�˷���������Ƶ�����أ�����������ͨLSB����
%������ϢǶ�뷽������ѡ����ֵ���ж����Ʊ任��תΪ�����ƺ�Ƚϵ����ڶ�λ�����һλ�Ĳ�ֵ�������ڶ�λ��ȥ���һλ������ֵΪ0��ʾǶ��0����ֵΪ1��ʾǶ��1
%
for m=1:N                               
    for n=1:N
        x=(m-1)*K+1;                    
        y=(n-1)*K+1;
        %ȡ��һ��8*8�ֿ�
        block=L(x:x+K-1,y:y+K-1); 
        %ȡ��������ѡֵ�ĵ����ڶ�λ
        temp0 = bitget(block(p,q),2);
        %ȡ��������ѡֵ�����һλ
        temp1 = bitget(block(p,q),1);
        %�����ֵ
        temp = double(temp0) - double(temp1);
        %Ƕ����ϢΪ0ʱ
        if(J(m, n)==0)
            %��ֵΪ1ʱ����ѡֵ���2λΪ10����2���Ϊ00����ֵΪ0
            if(temp == 1)
                block(p,q) = block(p,q) - 2;
            end
            %��ֵΪ-11ʱ����ѡֵ���2λΪ01����1���Ϊ00����ֵΪ0
            if(temp == -1)
                block(p,q) = block(p,q) - 1;
            end
        %Ƕ����ϢΪ1ʱ
        else
            %��ֵΪ0ʱ����ѡֵ���2λΪ00��11
            if(temp == 0)
                %���2λΪ00ʱ����2�������λΪ10����ֵΪ1
                if(mod(block(p,q),2)==0)
                    block(p,q) = block(p,q) + 2;
                %���2λΪ11ʱ����1�������λΪ10����ֵΪ1
                else
                    block(p,q) = block(p,q) - 1;
                end
            end
            %��ֵΪ-1ʱ����ѡֵ���2λΪ01����1�������λΪ10����ֵΪ1
            if(temp == -1)
                block(p,q) = block(p,q) + 1;
            end
        end
        %��Ƕ��������Ϣ��ľ���Ż�ԭ����
        L(x:x+K-1,y:y+K-1)=block;
        %��p,q���б任
        p=p+2;
        q=q+2;
        p=mod(q,8)+1;
        q=mod(p,8)+1;
    end
end
image_b = uint8(L);
return