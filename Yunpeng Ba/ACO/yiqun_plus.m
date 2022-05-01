 
%%%%%蚁群算法解决TSP%%%%%
%%%%%初始化%%%%%
clear all; %清除所有变量
close all; %清屏
clc ;      %清图
m=50;    %蚂蚁个数
Alpha=1;  %Alpha表征信息素重要程度的参数
Beta=5;  % Beta表征启发式因子重要程度的参数
Rho=0.1; % Rho信息素蒸发系数
NC_max=200; %最大迭代次数
Q=100;         %信息素增加强度
 
C=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;
   3238 1229;4196 1004;4312 790;4386 570;3007 1970; 2562 1756;
  2788 1491;2381 1676;1332 695;3715 1678;3918 2179;4061 2370;
  3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2376;
  3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;
  2370 2975];                %%31个省会坐标数据
%%%%%%第一步：变量初始化%%%%%%%%%%%%%%%
n=size(C,1);%城市个数
D=zeros(n,n);%两的城市距离间隔矩阵
for i=1:n
    for j=1:n
        if i~=j
            D(i,j)=((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
        else
            D(i,j)=eps;      
        end
        D(j,i)=D(i,j);   
    end
end
Eta=1./D;          %Eta为启发因子，这里设为距离的倒数
Tau=ones(n,n);     %Tau为信息素矩阵
Tabu=zeros(m,n);   %存储并记录路径的生成
NC=1;               %迭代计数器，记录迭代次数
R_best=zeros(NC_max,n);       %各代最佳路线
L_best=inf.*ones(NC_max,1);   %各代最佳路线的长度  %inf 正无穷
L_ave=zeros(NC_max,1);        %各代路线的平均长度
while NC<=NC_max       
    
    
%%第二步：将m只蚂蚁放到起点上，形成有n个城市的路径%%
    Tabu=zeros(m,n);
    for i=1:m
        Tabu(i,1)=1;
    end
    %这个地方把蚂蚁的投放地点改成1
    
%%第三步：m只蚂蚁按概率函数选择下一座城市，完成各自的周游%%
    for j=2:n     
        for i=1:m
            visited=Tabu(i,1:(j-1)); %记录已访问的城市，避免重复访问
            J=zeros(1,(n-j+1));       %待访问的城市
            P=J;                      %待访问城市的选择概率分布
            Jc=1;
            for k=1:n
                if length(find(visited==k))==0   %开始时置0
                    J(Jc)=k;
                    Jc=Jc+1;                         %访问的城市个数自加1
                end
            end
             %下面计算待选城市的概率分布
            for k=1:length(J)
                P(k)=(Tau(visited(end),J(k))^Alpha)*(Eta(visited(end),J(k))^Beta);
            end
            P=P/(sum(P));
            %按概率原则选取下一个城市
            Pcum=cumsum(P);     %cumsum，元素累加即求和
            Select=find(Pcum>=rand); %若计算的概率大于原来的就选择这条路线
            to_visit=J(Select(1));
            Tabu(i,j)=to_visit;
        end
    end
    
    if NC>=2
        Tabu(1,:)=R_best(NC-1,:); 
    end
 %%%第四步：记录本次迭代最佳路线%%%
    L=zeros(m,1);     %开始距离为0，m*1的列向量
    for i=1:m
        R=Tabu(i,:);
        for j=1:(n-1)
            L(i)=L(i)+D(R(j),R(j+1));    %原距离加上第j个城市到第j+1个城市的距离
        end
        L(i)=L(i)+D(R(1),R(n));      %加上回到起点的距离，得到一轮下来后走过的距离
    end
    L_best(NC)=min(L);           %最佳距离取最小
    pos=find(L==L_best(NC));
    R_best(NC,:)=Tabu(pos(1),:); %此轮迭代后的最佳路线
    L_ave(NC)=mean(L);           %此轮迭代后的平均距离
    NC=NC+1;                      %迭代继续
 
%%%第五步：更新信息素%%%
    Delta_Tau=zeros(n,n);        %开始时信息素为n*n的0矩阵
    for i=1:m
        for j=1:(n-1)
            Delta_Tau(Tabu(i,j),Tabu(i,j+1))=Delta_Tau(Tabu(i,j),Tabu(i,j+1))+Q/L(i);
            %此次循环在路径（i，j）上的信息素增量
        end
        Delta_Tau(Tabu(i,n),Tabu(i,1))=Delta_Tau(Tabu(i,n),Tabu(i,1))+Q/L(i);
        %此次循环在整个路径上的信息素增量
    end
    Tau=(1-Rho).*Tau+Delta_Tau; %考虑信息素挥发，更新后的信息素
%第六步：禁忌表清零（禁忌表：防止搜索过程中出现循环，避免局部最优）
    Tabu=zeros(m,n);             %%直到最大迭代次数
end
 
%%第七步：输出结果%%%
Pos=find(L_best==min(L_best)); %找到最佳路径
Shortest_Route=R_best(Pos(1),:) %最大迭代次数后最佳路径
Shortest_Length=L_best(Pos(1)) %最大迭代次数后最短距离
 
figure(1) 
plot(L_best)
xlabel('迭代次数')
ylabel('最短路径长度')
title('每代最短路径长度进化曲线')
 
figure(2)
%绘制第一个子图形,路线图
subplot(1,2,1)                 
N=length(Shortest_Route);
scatter(C(:,1),C(:,2)); %绘制闪点图
 hold on
 plot([C(Shortest_Route(1),1),C(Shortest_Route(N),1)],[C(Shortest_Route(1),2),C(Shortest_Route(N),2)],'g')
 hold on
for ii=2:N
    plot([C(Shortest_Route(ii-1),1),C(Shortest_Route(ii),1)],[C(Shortest_Route(ii-1),2),C(Shortest_Route(ii),2)],'g')
     hold on
end
title('旅行商最短路线结果图 ')
 
%绘制第二个子图形
subplot(1,2,2)                  
plot(L_best)
hold on                         %保持图形
plot(L_ave,'r')
legend('最短距离','平均距离')
title('平均距离和最短距离')     %标题
 