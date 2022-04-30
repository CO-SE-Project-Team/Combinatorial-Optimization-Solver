function Chrom=InitPop(NIND,CityNum,Demand,Capacity)
%% 初始化种群
%输入：
%NIND       种群大小
%CityNum	需求点个数
%Demand      各点需求量
%Capacity   车容量约束

%输出：
%Chrom      初始种群

Chrom=zeros(NIND,CityNum*2+1); %预分配内存，用于存储种群数据

for i=1:NIND
    TSProute=[0,randperm(CityNum)]+1; %随机生成一条不包括尾位的TSP路线
    VRProute=ones(1,CityNum*2+1); %初始化VRP路径
    
    delivery=0; % 汽车已经送货量，即已经到达点的需求量之和
    k=1;
    for j=2:CityNum+1
        k=k+1;   %对VRP路径下一点进行赋值
        if delivery+Demand(TSProute(j)) > Capacity %这一点配送完成后车辆可配送量超容量约束
        	VRProute(k)=1; %经过配送中心
            
            % 新一辆车再去下一个需求点
            delivery=Demand(TSProute(j)); %新一辆车可配送量初始化
            k=k+1;
            VRProute(k)=TSProute(j);  %TSP路线中此点添加到VRP路线
        else %
            delivery=delivery+Demand(TSProute(j)); %累加可配送量
            VRProute(k)=TSProute(j); %TSP路线中此点添加到VRP路线
        end
    end
    Chrom(i,:)=VRProute;  %此路线加入种群
end