function image_b = LSB(original,watermark)
%隐藏矩阵存到I中，隐藏信息存到J中
L =original;      
J=watermark;
%N为隐藏矩阵大小
N=64;
%K为分块大小1
K=8;
%p,q为变换系数
p=2;
q=1;

%
%隐藏思想：将512*512的矩阵分为64*64个8*8的方块，根据p,q选出方块中某一个元素，根据LSB方法隐藏0或1
%p,q变换：p初始值为2，q初始值为1，每对一个8*8矩阵嵌入完信息，p新值为q+2对8求模的值加1（求模得出的值可能为1），同理q新值为p+2对8求模的值加1
%此方法适用与频域隐藏，不适用于普通LSB隐藏
%隐藏信息嵌入方法：对选出的值进行二进制变换，转为二进制后比较倒数第二位和最后一位的差值（倒数第二位减去最后一位），差值为0表示嵌入0，差值为1表示嵌入1
%
for m=1:N                               
    for n=1:N
        x=(m-1)*K+1;                    
        y=(n-1)*K+1;
        %取出一个8*8分块
        block=L(x:x+K-1,y:y+K-1); 
        %取出方块所选值的倒数第二位
        temp0 = bitget(block(p,q),2);
        %取出方块所选值的最后一位
        temp1 = bitget(block(p,q),1);
        %求出差值
        temp = double(temp0) - double(temp1);
        %嵌入信息为0时
        if(J(m, n)==0)
            %差值为1时，所选值最后2位为10，减2后变为00，差值为0
            if(temp == 1)
                block(p,q) = block(p,q) - 2;
            end
            %差值为-11时，所选值最后2位为01，减1后变为00，差值为0
            if(temp == -1)
                block(p,q) = block(p,q) - 1;
            end
        %嵌入信息为1时
        else
            %差值为0时，所选值最后2位为00或11
            if(temp == 0)
                %最后2位为00时，加2后最后两位为10，差值为1
                if(mod(block(p,q),2)==0)
                    block(p,q) = block(p,q) + 2;
                %最后2位为11时，减1后最后两位为10，差值为1
                else
                    block(p,q) = block(p,q) - 1;
                end
            end
            %差值为-1时，所选值最后2位为01，加1后最后两位为10，差值为1
            if(temp == -1)
                block(p,q) = block(p,q) + 1;
            end
        end
        %将嵌入隐藏信息后的矩阵放回原矩阵
        L(x:x+K-1,y:y+K-1)=block;
        %对p,q进行变换
        p=p+2;
        q=q+2;
        p=mod(q,8)+1;
        q=mod(p,8)+1;
    end
end
image_b = uint8(L);
return