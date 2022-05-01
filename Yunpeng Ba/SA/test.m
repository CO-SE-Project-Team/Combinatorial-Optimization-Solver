clear all; %清除所有变量
close all; %清图
clc ;      %清屏
C=[
    0.64 0.41 0.99 0.55 0.77 0.25 0.11 0.89;
         0.74 0.45 0.66 0.21  0.32 0.99 0.54 0.11
    ]';%31个省会坐标


n=size(C,1); %TSP问题的规模，即城市数目
T=100*n;     %初始温度
L=100;       %马尔科夫链的长度
K=0.99;      %衰减参数


%%%城市坐标结构体%%%%%%%
city=struct([]);


for i=1:n
    city(i).x=C(i,1);
    city(i).y=C(i,2);
end


l=1;        %统计迭代次数
len(l)=func5(city,n); %每次迭代后路线的长度


figure(1);

while T>0.001
    %%%%%%%%%%%%%%%多次迭代扰动，温度降低前多次试验%%%%%%%%
    for i=1:L
        %%%%%%%%%%%%%%%计算原路线总距离%%%%%%%%%
        len1=func5(city,n);
        %%%%%%%%%%%%%%%产生随机扰动%%%%%%%%%
        %%%%%%%%%%%%%%%随机置换两个不同的城市的坐标%%%%%%%%%
        p1=floor(1+n*rand);
        p2=floor(1+n*rand);
        while p1==p2
            p1=floor(1+n*rand);
            p2=floor(1+n*rand);
        end
        tmp_city=city;
        %%交换元素
        tmp=tmp_city(p1);
        tmp_city(p1)=tmp_city(p2);
        tmp_city(p2)=tmp;
        %%%%%%%%%%%%%%%计算新路线总距离%%%%%%%%%
        len2=func5(tmp_city,n);
        %%%%%%%%%%%%%%%新老距离的差值，相当于能量%%%%%%%%%
        delta_e=len2-len1;
        %%%%%%%%%%%%%%%新路线好于旧路线，用新路线替代旧路线%%%%%%%%%
        if delta_e<0
            city=tmp_city;
        else
            %%%%%%%%%%%%%%%以一定概率选择是否接受%%%%%%%%%
            if exp(-delta_e/T)>rand()
                city=tmp_city;
            end
        end
    end
    l=l+1;          %迭代次数加1
    
    %%%%%%%%%%%%%%%计算新路线的距离%%%%%%%%%
    len(l)=func5(city,n);
    %%%%%%%%%%%%%%%温度不断下降%%%%%%%%%
    T=T*K;
    for i=1:n-1
        plot([city(i).x,city(i+1).x],[city(i).y,city(i+1).y],'bo-');
        hold on;
    end
    plot([city(n).x,city(1).x],[city(n).y,city(1).y],'ro-');
    
    title(['优化最短距离:',num2str(len(l))]);%%num2str将数字转为字符数组
    hold off;
    pause(0.005);
end

figure(2)
plot(len);
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');

%计算距离的函数
function len=func5(city,n)
len=0;
for i=1:n-1
    len=len+sqrt((city(i).x-city(i+1).x)^2+(city(i).y-city(i+1).y)^2);
end
len=len+sqrt((city(n).x-city(1).x)^2+(city(n).y-city(1).y)^2);
end
