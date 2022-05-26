classdef  VRP_HPSO < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;

            %% GA-PSO算法求解CVRP
            %输入：
            %City           需求点经纬度
            %Distance       距离矩阵
            %Demand         各点需求量
            %Capacity       车容量约束
            %NIND           种群个数
            %obj.Data.iterations         遗传到第obj.Data.iterations代时程序停止

            %输出：
            %Gbest          最短路径
            %GbestDistance	最短路径长度



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
            CityNum=size(City,1)-1; %需求点个数

            %% 初始化算法参数
            NIND=60; %粒子数量

            %% 为预分配内存而初始化的0矩阵
            Population = zeros(NIND,CityNum*2+1); %预分配内存，用于存储种群数据
            PopDistance = zeros(NIND,1); %预分配矩阵内存
            GbestDisByGen = zeros(obj.Data.iterations,1); %预分配矩阵内存

            for i = 1:NIND
                %% 初始化各粒子
                Population(i,:)=InitPop(CityNum,Demand,Capacity); %随机生成TSP路径

                %% 计算路径长度
                PopDistance(i) = CalcDis(Population(i,:),Distance,Demand,Capacity); % 计算路径长度
            end

            %% 存储Pbest数据
            Pbest = Population; % 初始化Pbest为当前粒子集合
            PbestDistance = PopDistance; % 初始化Pbest的目标函数值为当前粒子集合的目标函数值

            %% 存储Gbest数据
            [mindis,index] = min(PbestDistance); %获得Pbest中
            Gbest = Pbest(index,:); % 初始Gbest粒子
            GbestDistance = mindis; % 初始Gbest粒子的目标函数值

            %% 开始迭代

            % while obj.is_stop() == false
            %for  Iter=1:obj.Data.iterations %遍历每一代
            % obj.Data.iterator=Iter;
            %if obj.is_stop()==true
            %   break
            %end
            Iter=1;
            while obj.is_stop() == false
                %% 每个粒子更新
                for i=1:NIND
                    %% 粒子与Pbest交叉
                    Population(i,2:end-1)=Crossover(Population(i,2:end-1),Pbest(i,2:end-1)); %交叉

                    % 新路径长度变短则记录至Pbest
                    PopDistance(i) = CalcDis(Population(i,:),Distance,Demand,Capacity); %计算距离
                    if PopDistance(i) < PbestDistance(i) %若新路径长度变短
                        Pbest(i,:)=Population(i,:); %更新Pbest
                        PbestDistance(i)=PopDistance(i); %更新Pbest距离
                    end

                    %% 根据Pbest更新Gbest
                    [mindis,index] = min(PbestDistance); %找出Pbest中最短距离

                    if mindis < GbestDistance %若Pbest中最短距离小于Gbest距离
                        Gbest = Pbest(index,:); %更新Gbest
                        GbestDistance = mindis; %更新Gbest距离
                    end

                    %% 粒子与Gbest交叉
                    Population(i,2:end-1)=Crossover(Population(i,2:end-1),Gbest(2:end-1));

                    % 新路径长度变短则记录至Pbest
                    PopDistance(i) = CalcDis(Population(i,:),Distance,Demand,Capacity); %计算距离
                    if PopDistance(i) < PbestDistance(i) %若新路径长度变短
                        Pbest(i,:)=Population(i,:); %更新Pbest
                        PbestDistance(i)=PopDistance(i); %更新Pbest距离
                    end

                    %% 粒子自身变异
                    Population(i,:)=Mutate(Population(i,:));

                    % 新路径长度变短则记录至Pbest
                    PopDistance(i) = CalcDis(Population(i,:),Distance,Demand,Capacity); %计算距离
                    if PopDistance(i) < PbestDistance(i) %若新路径长度变短
                        Pbest(i,:)=Population(i,:); %更新Pbest
                        PbestDistance(i)=PopDistance(i); %更新Pbest距离
                    end

                    %% 根据Pbest更新Gbest
                    [mindis,index] = min(PbestDistance); %找出Pbest中最短距离

                    if mindis < GbestDistance %若Pbest中最短距离小于Gbest距离
                        Gbest = Pbest(index,:); %更新Gbest
                        Gbestshort=Gbest;
                        %删去路径中多余1
                        for ii=1:length(Gbestshort)-1
                            if Gbestshort(ii)==Gbestshort(ii+1)
                                Gbestshort(ii)=0;  %相邻位都为1时前一个置零
                            end
                        end
                        Gbestshort(Gbestshort==0)=[];  %删去多余零元素
                        GbestDistance = mindis; %更新Gbest距离
                        
                        
                    end
                    
                end

                %% 存储此代最短距离
                GbestDisByGen(Iter)=GbestDistance;

                %% 更新迭代次数
                Iter=Iter+1;
                obj.Data.objVal=GbestDistance;
                obj.Data.xi = Gbestshort(1, 1:size(Gbestshort,2)-1);
                obj.Data.xj = Gbestshort(1, 2:size(Gbestshort,2));
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
            end

            % Gbest=Gbest-1;  % 编码各减1，与文中的编码一致
            % Gbest(Gbest==0)=[];  %删去多余零元素
            % Gbest=Gbest-1;  % 编码各减1，与文中的编码一致
            

            %             obj.update_status_by(obj.Data.objVal, obj.Data.xi, obj.Data.xj);
            obj.Data.n = n;
            obj.Data.distance = Distance;

        end
    end
end



function a=Crossover(a,b)
%% PMX方法交叉
%输入：
%a  粒子代表的路径
%b  个体最优粒子代表的路径

%输出：
%a	交叉后的粒子代表的路径

L=length(a); %获取亲代染色体长度
r1=unidrnd(L); %在1~L中随机选一整数
r2=unidrnd(L); %在1~L中随机选一整数

s=min([r1,r2]); %起点为较小值
e=max([r1,r2]); %终点为较大值

b0=b(s:e); %用于最后插入

aa=a(s:e); %用于检查重复元素
bb=b(s:e); %用于检查重复元素

a(s:e)=[];     %去除交叉部分   去除后后面的元素会往前移

outlen=length(a); %去除交叉部分后，  a，b的长度   length outside cross section
inlen=e-s+1;      %交叉部分长度  length inside cross section

for i=1:inlen     %交叉部分去除相同元素
    for j=1:inlen
        if aa(i)==bb(j) %若交叉部分内上下有相同元素
            aa(i)=0; %删去
            bb(j)=0;
            break  %  break能保证最后aa和bb一样长 且无重复元素
        end
    end
end
aa(aa==0)=[];   % 0置空后后面的元素往前移
bb(bb==0)=[];% 0置空后后面的元素往前移

exlen=length(aa);     %交叉部分去除相同元素后长度   length after deduplication
for i=1:exlen %ab上下去重后
    for j=1:outlen %交叉部分外
        if bb(i)==a(j)   %若交叉部分内上下有相同元素
            a(j)=aa(i); %冗余元素换为缺失元素
            break
        end
    end
end

a=[a(1:s-1),b0,a(s:outlen)]; %重新拼接生成子代1
end

function ttlDistance=CalcDis(route,Distance,Demand,Capacity)
%% 计算各个体的路径长度 适应度函数
%输入：
%route          某粒子代表的路径
%Distance       两两城市之间的距离矩阵
%Demand        各点需求量
%Capacity      容量约束

%输出：
%ttlDistance	种群个体路径距离

%相关数据初始化
DisTraveled=0;  % 汽车已经行驶的距离
delivery=0; % 汽车已经送货量，即已经到达点的需求量之和置零
Dis=0; %此方案所有车辆的总距离

for j=2:length(route)
    DisTraveled = DisTraveled+Distance(route(j-1),route(j)); %每两点间距离累加
    delivery = delivery+Demand(route(j)); %累加可配送量
    if delivery > Capacity
        Dis = Inf;  %对非可行解进行惩罚
        break
    end
    if route(j)==1 %若此位是配送中心
        Dis=Dis+DisTraveled; %累加已行驶距离
        DisTraveled=0; %已行驶距离置零
        delivery=0; %已配送置零
    end
end
ttlDistance=Dis; %存储此方案总距离
end

function VRProute=InitPop(CityNum,Demand,Capacity)
%% 初始化各粒子

%输入：
%CityNum	需求点个数
%Distance    距离矩阵
%Demand      各点需求量
%Capacity   车容量约束

%输出：
%VRProute	VRP路径

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
end


function route=Mutate(route)
%% 变异操作
%输入：
%route  某粒子代表的路径

%输出：
%route	变异后的粒子代表的路径

RandIndex = randperm(length(route)-2)+1; %除去染色体首尾配送中心位后再突变

route(RandIndex(2:-1:1)) = route(RandIndex(1:2)); %换位变异
route(RandIndex(4:-1:3)) = route(RandIndex(3:4)); %二次换位变异
end
%本地命令行测试步骤
% p=SubALGORITHM()
% 打开.mat文件导入数据Data
% p.set_Data(Data)
% p.solve()
% p.get_Data() 需要在变量里把Data.timeLim修改，测试能完整跑完和无法完整跑完两种情况
% p.get_solved_Data(Data)这个是前几种方法的集合，也需要测试一次