function b = zhiluan(img2)
[h w e]=size(img2);
img2 = double(img2);

%���ҵĴ���
n=250; 
%���ص�λ�����ҵĲ���
a=3;b=8;
%����ֵ���ҵĲ���
c=6;d=10;
N=h;

figure(1);

%����ֵ����
for i=1:n
    i
    for i=1:h
        for j=1:w     
            %�����ص��еĻҶ�ֵ��ֳ�����ʮ��������
            y=mod(img2(i,j),16);
            x=(img2(i,j)-y)/16;
            xk = x+d*y;
            yk = c*x+(c*d+1)*y;
            xk = mod(xk,16);
            yk = mod(yk,16);
            img2(i,j)=xk*16+yk;
        end
    end
end

%���ص�����
imgn=zeros(h,w);
for i=1:n
    i
    for y=1:h
        for x=1:w           
            xx=mod((x-1)+b*(y-1),N)+1;
            yy=mod(a*(x-1)+(a*b+1)*(y-1),N)+1;        
            imgn(yy,xx)=img2(y,x);                
        end
    end
end

%�ֿ�
for row=1:h/8
    for column=1:w/16
        for x=(row-1)*8+1:row*8 
            for y=(column-1)*16+1:(column-1)*16+8
                temp = imgn(x,y);
                imgn(x,y)=imgn(x,y+8);
                imgn(x,y+8)=temp;             
            end
        end
    end
end
for row=1:h/16
    for column=1:w/8
        for x=(row-1)*16+1:(row-1)*16+8
            for y=(column-1)*8+1:column*8 
                temp = imgn(x,y);
                imgn(x,y)=imgn(x+8,y);
                imgn(x+8,y)=temp;               
            end
        end
    end
end

%��ʾ��������Һ��ͼ��
b = uint8(imgn);
%imwrite(b,'zhiluan.bmp','bmp');
return
