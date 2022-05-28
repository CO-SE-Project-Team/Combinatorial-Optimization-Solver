classdef  VRP_SA < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;

            %% 模拟退火算法求解CVRP
            %输入：
            %City           需求点经纬度
            %Distance       距离矩阵
            %Demand         各点需求量
            %Capacity       车容量约束
            %T0             初始温度
            %Tend           终止温度
            %L              各温度下的迭代次数（链长）
            %q              降温速率

            %输出：
            %bestroute      最短路径
            %mindisever     路径长度
            %% 加载数据


            %% 初始化问题参数
            Demand = demand;
            Capacity = capacity;
            City  = [cx;cy]';
            n=size(cx,2);
            Distance = zeros(n,n);
            for i=1:n
                for j=1:n
                    if i~=j
                        Distance(i,j)=((City(i,1)-City(j,1))^2+(City(i,2)-City(j,2))^2)^0.5;
                    else
                        Distance(i,j)=0;
                    end
                    Distance(j,i)=Distance(i,j);
                end
            end
            CityNum=size(City,1)-1;    %需求点个数

            %% 初始化算法参数
            T0=1000;        %初始温度
            %             Tend=1e-3;      %终止温度
            L=200;          %各温度下的迭代次数（链长）
            %             q=0.9;          %降温速率
            Iter=0;        %迭代计数

            %% 初始解（必须为满足各约束的可行解）
            TSProute=[0,randperm(CityNum)]+1; %随机生成一条不包括尾位的TSP路线
            S1=ones(1,CityNum*2+1); %初始化VRP路径S1，为其分配内存

            delivery=0; % 汽车已经送货量，即已经到达点的需求量之和
            k=1;
            for j=2:CityNum+1
                k=k+1;   %对VRP路径下一点进行赋值
                if delivery+Demand(TSProute(j)) > Capacity %这一点配送完成后车辆可配送量超容量约束
                    S1(k)=1; %经过配送中心

                    % 新一辆车再去下一个需求点
                    delivery=Demand(TSProute(j)); %新一辆车可配送量初始化
                    k=k+1;
                    S1(k)=TSProute(j);  %TSP路线中此点添加到VRP路线
                else %
                    delivery=delivery+Demand(TSProute(j)); %累加可配送量
                    S1(k)=TSProute(j); %TSP路线中此点添加到VRP路线
                end
            end

            %% 计算迭代的次数Time，即求解 T0 * q^x = Tend
            %             Time=ceil(double(log(Tend/T0)/log(q)))
            Time=obj.Data.iterations;
            bestind=zeros(1,CityNum*2+1);      %每代的最优路线矩阵初始化
            BestObjByIter=zeros(Time,1);       %每代目标值矩阵初始化

            %% 迭代

            while obj.is_stop() == false

                Iter = Iter+1;     %更新迭代次数
                Population = zeros(L,CityNum*2+1); %为此温度下迭代个体矩阵分配内存
                ObjByIter = zeros(L,1); %为此温度下迭代个体的目标函数值矩阵分配内存
                for k = 1:L
                    %% 产生新解
                    S2 = NewSolution(S1);
                    %% Metropolis法则判断是否接受新解
                    [S1,ttlDis] = Metropolis(S1,S2,Distance,Demand,Capacity,T0);  % Metropolis 抽样算法
                    ObjByIter(k) = ttlDis;    %此温度下每迭代一次就存储一次目标函数值
                    Population(k,:) = S1;          %此温度下每迭代一次就存储一次此代最优个体
                end

                %% 记录每次迭代过程的最优路线
                [d0,index] = min(ObjByIter); %取出此温度下所有迭代中最优的一次
                if Iter == 1 || d0 < BestObjByIter(Iter-1) %若为第一次迭代或上次迭代比这次更满意
                    BestObjByIter(Iter) = d0;            %如果当前温度下最优路程小于上一路程则记录当前路程
                    bestind = Population(index,:);  %记录当前温度的最优路线
                else
                    BestObjByIter(Iter) = BestObjByIter(Iter-1);  %如果当前温度下最优路程大于上一路程则记录上一路程的目标函数值
                end
                %% 找出历史最短距离和对应路径
                mindisever = BestObjByIter(Iter); %找出历史最优目标函数值
                bestroute=bestind; % 取最优个体

                %删去路径中多余1
                for i=1:length(bestroute)-1
                    if bestroute(i)==bestroute(i+1)
                        bestroute(i)=0;  %相邻位都为1时前一个置零
                    end
                end
                bestroute(bestroute==0)=[];  %删去多余零元素

                %                 bestroute=bestroute-1;  % 编码各减1，与文中的编码一致
                obj.Data.objVal=mindisever;
                obj.Data.xi = bestroute(1, 1:size(bestroute,2)-1);
                obj.Data.xj = bestroute(1, 2:size(bestroute,2));
                %                 disp(obj.Data.xi);
                %                 disp(obj.Data.xj);
                %                 disp(obj.Data.objVal);
                obj.update_status_by(obj.Data.objVal, obj.Data.xi, obj.Data.xj);
                %                 T0 = q * T0; %降温

            end

            obj.Data.n = n;
            obj.Data.distance = Distance;
        end
    end
end


function ttlDis=Evaluation(route,Distance,Demand,Capacity)
%% 计算各个体的路径长度 适应度函数
% 输入：
% route         种群矩阵
% Distance      两两城市之间的距离
% Demand        各点需求量
% Capacity      容量约束
% 输出：
% ttlDis	此个体路径的距离


len=size(route,2);
%相关数据初始化
DisTraveled=0;  % 汽车已经行驶的距离
delivery=0; % 汽车已经送货量，即已经到达点的需求量之和置零
ttlDis=0; %此方案所有车辆的总距离

for j=2:len
    DisTraveled = DisTraveled+Distance(route(j-1),route(j)); %每两点间距离累加
    delivery = delivery+Demand(route(j)); %累加可配送量
    if delivery > Capacity
        ttlDis = Inf;  %对非可行解进行惩罚
        break
    end
    if route(j)==1 %若此位是配送中心
        ttlDis=ttlDis+DisTraveled; %累加已行驶距离
        DisTraveled=0; %已行驶距离置零
        delivery=0; %已配送置零
    end
end
end

function [S,ttlDis]=Metropolis(S1,S2,Distance,Demand,Capacity,T)
%% 输入
% S1        当前解
% S2        新解
% Distance  距离矩阵（两两城市的之间的距离）
% Demand        各点需求量
% Capacity      容量约束
% T         当前温度
%% 输出
% S         下一个当前解
% ttlDis	下一个当前解的路线距离

%%
ttlDis1 = Evaluation(S1,Distance,Demand,Capacity);  %计算路线长度
ttlDis2 = Evaluation(S2,Distance,Demand,Capacity);  %计算路线长度
dC = ttlDis2 - ttlDis1;   %计算路线长度之差

if dC < 0       %如果能力降低 接受新路线
    S = S2;
    ttlDis = ttlDis2;
elseif exp(-dC/T) >= rand   %以exp(-dC/T)概率接受新路线
    S = S2;
    ttlDis = ttlDis2;
else  %不接受新路线
    S = S1;
    ttlDis = ttlDis1;
end
end

function S2=NewSolution(S1)
% 输入
% S1:当前解
% 输出
% S2：新解

Length=length(S1); %获得原解元素个数
S2=S1;

R=randperm(Length-2)+1; %产生2:CityNum+1的随机序列作为要交换位置的索引
S2(R(1:2))=S2(R(2:-1:1)); %换位
end

