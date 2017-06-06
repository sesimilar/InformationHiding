function b = huifu(img)
[h w e]=size(img);
img = double(img);

%置乱的次数
n=250;
%像素点位置置乱的参数
a=3;b=8;
%像素值置乱的参数
c=6;d=10;
N=h;

figure(1);

%分块恢复，将分块移回原有位置
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

%像素点位置恢复
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

%像素值恢复
for i=1:n
    i
    for i=1:h
        for j=1:w 
            %将像素点中的灰度值拆分成两个十六进制数
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
%title('恢复后的图像');
b = uint8(imgn);
%imwrite(b,'huifu.bmp','bmp');
return