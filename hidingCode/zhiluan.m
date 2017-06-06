function b = zhiluan(img2)
[h w e]=size(img2);
img2 = double(img2);

%置乱的次数
n=250; 
%像素点位置置乱的参数
a=3;b=8;
%像素值置乱的参数
c=6;d=10;
N=h;

figure(1);

%像素值置乱
for i=1:n
    i
    for i=1:h
        for j=1:w     
            %将像素点中的灰度值拆分成两个十六进制数
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

%像素点置乱
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

%分块
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

%显示并输出置乱后的图像
b = uint8(imgn);
%imwrite(b,'zhiluan.bmp','bmp');
return
