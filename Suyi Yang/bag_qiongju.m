clc;  %清除所有
clear;%清除变量
close;%关闭图片

capacity=10;% 背包的容量
weight= [2;2;6;5;4];% 物品的重量，其中1号位置不使用 。
cy= [6;3;5;4;6];% 物品价值，1号位置置为空。
cx=[1;2;3;4;5];
dis=0;
xi=[];
xj=[];
n =length(weight);% n为物品的个数
v=[];%背包里物品的状态，0为取，1为不取
objVal=0;%被选择物品的总价值
iterations=0;
iterator=0;
is_stop=true;
time_limit=0;

for i=0:2^n-1
    v=dec2bin(i,n);%
    temp_w=0;
    temp_p=0;
    for j=1:n
        if v(j)=='1'
            temp_w=temp_w+weight(j);
            temp_p=temp_p+cy(j);
        end
    end
    if (temp_w<=capacity)&&(temp_p>objVal)
        objVal=temp_p;
        xi=v;
    end
end
xi
objVal