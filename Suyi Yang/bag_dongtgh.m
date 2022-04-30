clc;  %清除所有
clear;%清除变量
close;%关闭图片

Capacity=10;% 背包的容量
w= [0,2,2,6,5,4];% 物品的重量，其中1号位置不使用 。
p= [0,6,3,5,4,6];% 物品价值，1号位置置为空。
n =length(w);% n为物品的个数
V=[];%定义状态转移矩阵存储选中物品总价值
v=[];%背包里物品的状态，0为取，1为不取
s=0;%被选择物品的总价值

%判断第一个物品放或不放；
for j=1:(Capacity+1)
        if w(n)<j
                V(n,j)=p(n) ;
        else
                V(n,j)=0;
        end
end

%判断下一个物品是放还是不放；不放时：F[i,v]=F[i-1,v]；放时：F[i,v]=max{F[i-1,v],F[i-1,v-C_i]+w_i}；
for i=n-1:-1:1
        for j=1:(Capacity+1)
                if j<=w(i)
                        V(i,j)=V(i+1,j);
                else
                        if V(i+1,j)>V(i+1,j-w(i))+p(i)
                                V(i,j)=V(i+1,j);
                        else
                                V(i,j)=V(i+1,j-w(i))+p(i);
                        end
                end
        end
end

%输出被选择的物品。
i=Capacity;
for j=1:n-1
        if V(j,i)==V(j+1,i)
                v(j)=0;
        else
                v(j)=1;
                i=i-w(j);
        end
end
if V(n,i)==0
        v(n)=0;
else
        v(n)=1;
        
end
v

%计算被选择物品的总价值
for i=2:n
    if(v(i)==1)
        s=s+p(i);
    end
end
s

%版权声明：本文为CSDN博主「Tsroad」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
%原文链接：https://blog.csdn.net/tsroad/article/details/52048562
%本代码对原文语法、变量名、输入输出、运算处理进行了部分改动