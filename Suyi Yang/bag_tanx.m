clc;  %清除所有
clear;%清除变量
close;%关闭图片

capacity=10;% 背包的容量
weight= [2,2,6,5,4];% 物品的重量，其中1号位置不使用 。
cy= [6,3,5,4,6];% 物品价值，1号位置置为空。
n =length(weight);% n为物品的个数
a=[];%物品单位重量的价值，其中1号位置不使用
place=[];%物品序号，其中1号位置不使用
v=[];%背包里物品的状态，0为取，1为不取
objVal=0;%被选择物品的总价值

%计算物品单位重量的价值并降序排列
for i=1:n
    a(i)=cy(i)/weight(i);
end
[a,place]=sort(a,"descend");

%在满足选取物品总重量不超过背包容量的前提下，优先选择单位重量价值较大的物品
for i=1:n-1
    objVal=objVal+cy(place(i));
    capacity=capacity-weight(place(i));
    if(capacity<0)
        objVal=objVal-cy(place(i));
        capacity=capacity+weight(place(i));
    else
        v(place(i))=1;
    end
end

v
objVal

%原文链接：https://ishare.iask.sina.com.cn/f/14405145.html
%本代码对原文语法、变量名、输入输出、运算处理进行了部分改动