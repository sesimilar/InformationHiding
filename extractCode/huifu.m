function b = huifu(img)
[h w e]=size(img);
img = double(img);

%���ҵĴ���
n=250;
%���ص�λ�����ҵĲ���
a=3;b=8;
%����ֵ���ҵĲ���
c=6;d=10;
N=h;

figure(1);

%�ֿ�ָ������ֿ��ƻ�ԭ��λ��
for row=1:h/16
    for column=1:w/8
        for x=(row-1)*16+1:(row-1)*16+8
            for y=(column-1)*8+1:column*8 
                temp = img(x+8,y);
                img(x+8,y)=img(x,y);
                img(x,y)=temp;               
            end
        end
    end
end
for row=1:h/8
    for column=1:w/16
        for x=(row-1)*8+1:row*8 
            for y=(column-1)*16+1:(column-1)*16+8
                temp = img(x,y+8);
                img(x,y+8)=img(x,y);
                img(x,y)=temp;               
            end
        end
    end
end

%���ص�λ�ûָ�
imgn=zeros(h,w);
for i=1:n
    i
    for y=1:h
        for x=1:w            
            xx=mod((a*b+1)*(x-1)-b*(y-1),N)+1;
            yy=mod(-a*(x-1)+(y-1),N)+1  ;        
            imgn(yy,xx)=img(y,x);                   
        end
    end
end

%����ֵ�ָ�
for i=1:n
    i
    for i=1:h
        for j=1:w 
            %�����ص��еĻҶ�ֵ��ֳ�����ʮ��������
            y=mod(imgn(i,j),16);
            x=(imgn(i,j)-y)/16;     
            xk = (c*d+1)*x-d*y;
            yk = -c*x+y;
            xk = mod(xk,16);
            yk = mod(yk,16);
            imgn(i,j)=xk*16+yk;
        end
    end
end

%imshow(imgn,[]);
%title('�ָ����ͼ��');
b = uint8(imgn);
%imwrite(b,'huifu.bmp','bmp');
return