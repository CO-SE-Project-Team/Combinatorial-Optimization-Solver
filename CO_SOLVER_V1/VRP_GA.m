classdef  VRP_GA < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;
            %% 遗传算法求解CVRP
            %输入：
            %City           需求点经纬度
            %Distance       距离矩阵
            %Demand         各点需求量
            %Capacity       车容量约束
            %NIND           种群个数
            %MAXGEN         遗传到第MAXGEN代时程序停止
            %Pc             交叉概率(Probability of Crossover)
            %Pm             变异概率(Probability of Mutation)
            %GGAP           代沟(probability of Generation GAP)

            %输出：
            %bestroute      最短路径
            %mindisever     路径长度
            %% 加载数据
            %load('../test_data/City.mat')	      %需求点经纬度，用于画实际路径的XY坐标
            %load('../test_data/Distance.mat')	  %距离矩阵
            %load('../test_data/Demand.mat')       %需求量
            %load('../test_data/Capacity.mat')     %车容量约束

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

            %% 遗传参数
            NIND=100;       %种群大小
            MAXGEN=obj.Data.iterations;     %最大遗传代数
            GGAP=0.9;       %代沟概率
            Pc=0.9;         %交叉概率
            Pm=0.05;        %变异概率

            %% 为预分配内存而初始化的0矩阵
            mindis = zeros(1,MAXGEN);
            bestind = zeros(1,CityNum*2+1);

            %% 初始化种群
            Chrom=InitPop(NIND,CityNum,Demand,Capacity);

            %% 迭代
            Iter=1;

            while obj.is_stop() == false %当未到达最大迭代次数
                %% 计算适应度
                [ttlDistance,FitnV]=Fitness(Distance,Demand,Chrom,Capacity);  %计算路径长度
                [mindisbygen,bestindex] = min(ttlDistance);

                mindis(Iter) = mindisbygen; % 最小适应值fit的集
                bestind = Chrom(bestindex,:); % 最优个体集
                %% 选择
                SelCh=Select(Chrom,FitnV,GGAP);
                %% 交叉操作
                SelCh=Crossover(SelCh,Pc);
                %% 变异
                SelCh=Mutate(SelCh,Pm);
                %% 逆转操作
                SelCh=Reverse(Distance,Demand,SelCh,Capacity);
                %% 亲代重插入子代
                Chrom=Reins(Chrom,SelCh,FitnV);
                %% 显示此代信息
                %fprintf('Iteration = %d, Min Distance = %.2f km  \n',Iter,mindisbygen)
                %% 更新迭代次数
                Iter=Iter+1;

                %% 找出历史最短距离和对应路径
%                 mindisever=mindis(MAXGEN);  % 取最优适应值的位置、最优目标函数值
                [ttlDistance1,~]=Fitness(Distance,Demand,Chrom,Capacity);  %计算路径长度
                [mindisbygennew,bestindex1] = min(ttlDistance1);
                bestind = Chrom(bestindex1,:); % 最优个体集
                bestroute=bestind; % 取最优个体

                %删去路径中多余1
                for i=1:length(bestroute)-1
                    if bestroute(i)==bestroute(i+1)
                        bestroute(i)=0;  %相邻位都为1时前一个置零
                    end
                end
                bestroute(bestroute==0)=[];  %删去多余零元素
                % bestroute=bestroute-1;  % 编码各减1，与文中的编码一致
                obj.Data.objVal=mindisbygennew;
                obj.Data.xi = bestroute(1, 1:size(bestroute,2)-1);
                obj.Data.xj = bestroute(1, 2:size(bestroute,2));
                %             disp(obj.Data.xi);
                %             disp(obj.Data.xj);
                %             disp(obj.Data.objVal);
                obj.update_status_by(obj.Data.objVal, obj.Data.xi, obj.Data.xj);
            end


            obj.Data.n = n;
            obj.Data.distance = Distance;

        end
    end

end

function SelCh=Crossover(SelCh,Pc)
%% 交叉操作
% 输入
%SelCh  被选择的个体
%Pc     交叉概率
%输出：
%SelCh	交叉后的个体

[NSel,len]=size(SelCh);
for i=1:2:NSel-mod(NSel,2)
    if Pc>=rand %交叉概率Pc
        [SelCh(i,2:len-1),SelCh(i+1,2:len-1)]=intercross(SelCh(i,2:len-1),SelCh(i+1,2:len-1));
    end
end
end

function [a,b]=intercross(a,b)
%% 类PMX方法交叉
%输入：
%a和b为两个待交叉的个体
%输出：
%a和b为交叉后得到的两个个体

L=length(a); %获取亲代染色体长度
r1=unidrnd(L); %在1~L中随机选一整数
r2=unidrnd(L); %在1~L中随机选一整数

s=min([r1,r2]); %起点为较小值
e=max([r1,r2]); %终点为较大值

a0=a(s:e); %用于最后插入
b0=b(s:e); %用于最后插入

aa=a(s:e); %用于检查重复元素
bb=b(s:e); %用于检查重复元素

a(s:e)=[];     %去除交叉部分   去除后后面的元素会往前移
b(s:e)=[];     %去除交叉部分   去除后后面的元素会往前移
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

for i=1:exlen%ab上下去重后
	for j=1:outlen%交叉部分外
		if aa(i)==b(j) %若交叉部分内上下有相同元素
			b(j)=bb(i); %冗余元素换为缺失元素
			break
		end
	end
end
a=[a(1:s-1),b0,a(s:outlen)]; %重新拼接生成子代1
b=[b(1:s-1),a0,b(s:outlen)]; %重新拼接生成子代2
end

function [ttlDistance,FitnV]=Fitness(Distance,Demand,Chrom,Capacity)
%% 计算各个体的路径长度 适应度函数  
% 输入：
% Distance      两两城市之间的距离
% Demand        各点需求量
% Chrom         种群矩阵
% Capacity      容量约束
% 输出：
% ttlDistance	种群个体路径距离组成的向量
% FitnV         个体的适应度值组成的列向量

[NIND,len]=size(Chrom); %行列
ttlDistance=zeros(1,NIND); %分配矩阵内存

for i=1:NIND
    %相关数据初始化
    DisTraveled=0;  % 汽车已经行驶的距离
    delivery=0; % 汽车已经送货量，即已经到达点的需求量之和置零
    Dis=0; %此方案所有车辆的总距离
    route=Chrom(i,:);  %取出一条路径
    for j=2:len
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
    ttlDistance(i)=Dis; %存储此方案总距离
end

FitnV=1./ttlDistance; %适应度函数设为距离倒数  对向量进行点运算
end

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
end

function SelCh=Mutate(SelCh,Pm)
%% 变异操作
%输入：
%SelCh  被选择的个体
%Pm     变异概率
%输出：
%SelCh	变异后的个体

[NSel,L]=size(SelCh); %被选择的个体的行列
for i=1:NSel
    if Pm>=rand %若伪随机数落进变异概率
        R=randperm(L-1); %除去染色体尾1位再突变
        R(R==1)=[]; %除去VRP路线首位可突变的可能
        SelCh(i,R(1:2))=SelCh(i,R(2:-1:1)); %换位变异
    end
end
end

function Chrom=Reins(Chrom,SelCh,FitnV)
%% 重插入子代的新种群
%输入：
%Chrom      亲代的种群
%SelCh      子代种群
%ObjV       亲代适应度
%输出
%Chrom      组合亲代与子代后得到的新种群
 
NIND=size(Chrom,1); %亲代种群个体数
NSel=size(SelCh,1); %参与此代进化的个体数
[~,index] = sort(FitnV,'descend'); %亲代个体的适应度降序排列
Chrom=[Chrom(index(1:NIND-NSel),:);SelCh]; %先把参与此代进化的个体全部放入下代亲代，再把亲代个体适应度高的放入剩下的位置
end

function SelCh=Reverse(Distance,Demand,SelCh,Capacity)
%% 进化逆转函数
%输入：
%SelCh          被选择的个体
%Distance       个城市的距离矩阵
%输出：
%SelCh          进化逆转后的个体


[ttlDistance,~]=Fitness(Distance,Demand,SelCh,Capacity);%计算路径长度
SelCh1=SelCh; %临时存储

SelCh1=Mutate(SelCh1,1); %一定变异

[ttlDistance1,~]=Fitness(Distance,Demand,SelCh1,Capacity); %计算变异后的个体路径长度
index=ttlDistance1<ttlDistance; %若变异后的个体路径长度更短，将这些个体在种群中的索引提取出来
SelCh(index,:)=SelCh1(index,:); %则替换原染色体
end

function SelCh=Select(Chrom,FitnV,GGAP)
%% 选择操作
%输入
%Chrom 种群
%FitnV 适应度值
%输出
%SelCh  被选择的个体

[NIND,len]=size(Chrom);
SelCh = zeros(NIND*GGAP, len);

%轮盘赌选择法开始
Px=FitnV/sum(FitnV);  %概率归一化为列向量
Px=cumsum(Px);    %轮盘赌概率累加为列向量

for i=1:max(floor(NIND*GGAP+.5),2)   %对于主动选择的每个个体：  % 保证选择超过2条染色体（因为要交叉），且选择的个体数为整数
	theta=rand;  % 不在for里面用rand是因为内部for只用确定的一个随机数rand()
	for j=1:NIND %对于被选择到的，将放到第i个个体位置的个体
		if theta<=Px(j) %若随机数落进这个
			SelCh(i,:)=Chrom(j,:);  %轮盘赌规则确定父亲
			break
		end
	end
end
end






