clc;  %清除所有
clear;%清除变量
close;%关闭图片

capacity=10;% 背包的容量
weight= [2,2,6,5,4];% 物品的重量，其中1号位置不使用 。
cx=[1 2 3 4 5];
cy= [6,3,5,4,6];% 物品价值，1号位置置为空。
n =length(weight);% n为物品的个数
v=[];%背包里物品的状态，0为取，1为不取
objVal=0;%被选择物品的总价值
xi=[];
xj=[];

v=dec2bin(randi([0 2^n-1]),n);
selections=[];
for i=1:n
    selections(1,i)=str2num(v(i));
end
num=1;
for i=1:n
    if(v(i)=='1')
        v(i)='0';
    else
        v(i)='1';
    end
    num=num+1;
    for m=1:n
        selections(num,m)=str2num(v(m));
    end
    if(n>1)
        for j=(i+1):n
            vj=v;
            if(vj(j)=='1')
                vj(j)='0';
            else
                vj(j)='1';
            end
            num=num+1;
            for m=1:n
                selections(num,m)=str2num(vj(m));
            end
            if(n>3)
                vk=vj;
                if(i>3)
                    c=vk(i);
                    vk(i)=vk(i-3);
                    vk(i-3)=c;
                else
                    c=vk(i);
                    vk(n-i)=vk(i);
                    vk(n-i)=c;
                end
                num=num+1;
                for m=1:n
                    selections(num,m)=str2num(vk(m));
                end
            end
        end
    end
end
for i=1:num
    vi=selections(i,:);
    temp_w=0;
    temp_p=0;
    for j=1:n
        if vi(j)==1
            temp_w=temp_w+weight(j);
            temp_p=temp_p+cy(j);
        end
        if (temp_w<=capacity)&&(temp_p>objVal)
            objVal=temp_p;
            optv=vi;
        end
    end
end
% 注意要记得更新xi，xj，objVal等变量
% ----------------以上是你的算法内容-----------------------
        
% 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
for i=1:n
    if optv(i)==1
        xi=[xi,cx(i)];
        xj=[xj,cx(i)];
    end
end
l=length(xi);
if(l>1)
    xi(l)=[];
    xj(1)=[];
end

xi
xj
objVal

%原文链接：https://ishare.iask.sina.com.cn/f/14405145.html
%本代码对原文语法、变量名、输入输出、运算处理进行了部分改动