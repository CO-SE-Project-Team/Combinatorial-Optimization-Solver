%Ini adalah implementasi Tabu Search untuk Traveling Salesman
%Problem
​
%untuk merekam waktu komputasi yang dibutuhkan
tic;
clear
clc
%输入数据
N = 31;
TT=[1 82 76
 2 96 44
 3 50 5
 4 49 8
 5 13 7
 6 29 89
 7 58 30
 8 84 39
 9 14 24
 10 2 39
 11 3 82
 12 5 10
 13 98 52
 14 84 25
 15 61 59
 16 1 65
 17 88 51
 18 91 2
 19 19 32
 20 93 3
 21 50 93
 22 98 14
 23 5 42
 24 42 9
 25 61 62
 26 9 97
 27 80 55
 28 57 69
 29 23 15
 30 20 70
 31 85 60
 32 98 5];
X = TT(:,2);
Y = TT(:,3);
ZZ=[1 0 
2 19 
3 21 
4 6 
5 19 
6 7 
7 12 
8 16 
9 6 
10 16 
11 8 
12 14 
13 21 
14 16 
15 3 
16 22 
17 18 
18 19 
19 1 
20 24 
21 8 
22 12 
23 4 
24 8 
25 24 
26 24 
27 2 
28 20 
29 15 
30 2 
31 14 
32 9];
Demand =ZZ(:,2);
Vehicle_load = 100; %车辆载重限制
​
% Parameter TS
runcount= 500;
Solution_count = 200;
​
% 计算出城市之间的距离矩阵
Distancematrix = generatedistancematrix(X, Y);
JaarakSolusiMaksimum = sum(sum(Distancematrix));
​
%生成初始解
%Candidate_TSP_xulie = GenerateSolusiNearestNeighbour(Distancematrix);
Candidate_TSP_xulie = generatesolusirandom(N); %初始序列（随机生成一个n的序列）
Candidate_VRP_xulie = converttovrpsolution(Candidate_TSP_xulie, Demand, Vehicle_load); %初始解
Candidate_VRP_value = calculatetotaldistance(Candidate_VRP_xulie, Distancematrix); %车辆行驶距离Candidate_VRP_value
​
​
% 禁忌表初始化
tabulength = 10;
TabuList = ones(tabulength, 3);
​
%Catat kondisi awal
%Tsekarang = Tawal;
SolusiTerbaik = Candidate_TSP_xulie; %全局序列
best_so_far.VRP = Candidate_VRP_xulie; %全局解
best_so_far.value = Candidate_VRP_value; % 全局目标值
SolusiSaatIni = Candidate_TSP_xulie; %solusi iterasi %全局序列
SolusiVRPSaatIni = Candidate_VRP_xulie; %solusi iterasi %全局解
JarakSolusiSaatIni = Candidate_VRP_value; % Jarak solusi iterasi %全局目标值
​
Neighborhood_TSP_xulie = zeros(Solution_count, N + 2); %生成一个100*12的矩阵，用于存放变异后的解
Neighborhood_VRP_xulie = zeros(Solution_count, N * 2 + 1); %生成一个100*21的矩阵
Neighborhood_VRP_value = zeros(1, Solution_count);%生成一个1*100的矩阵
Variation_list = zeros(Solution_count, 3); %生成一个100*3的矩阵，用于存放每个解的变异的种类和变异的两个位置
​
better_so_far_TSP.xulie = Candidate_TSP_xulie ;
better_so_far_VRP.xulie = Candidate_VRP_xulie;
best_so_far.value =Candidate_VRP_value;
​
better_so_far_TSP_Tabu.xulie = zeros(1, N + 2);
better_so_far_VRP_Tabu.xulie = zeros(1, N * 2 + 1);
better_so_far_Tabu.value = 0;
​
preObjV=best_so_far.value;
figure;
hold on;box on
xlim([0,runcount])
title('优化过程')
xlabel('代数')
ylabel('最优值')
% Mulai iterasi TS
for i = 1 : runcount%1000
    line([i-1,i],[preObjV,best_so_far.value]);pause(0.0001)
    preObjV=best_so_far.value;
    %generate solusi tetangga
    for j = 1 : Solution_count %100
        
        Pilihan = randi(3); %randi 生成均匀分布的伪随机整数，用于判断使用哪一种变异
        switch (Pilihan)
            case 1 % 1-insert
                [Neighborhood_TSP_xulie(j, :) Index_1 Index_2 ] = PerformInsert(SolusiSaatIni); %变异，返回变异后序列，变异的客户点
                Neighborhood_VRP_xulie(j, :) = converttovrpsolution(Neighborhood_TSP_xulie(j, :), Demand, Vehicle_load);
                Neighborhood_VRP_value(j) = calculatetotaldistance(Neighborhood_VRP_xulie(j, :), Distancematrix);
                
            case 2 % 1-swap
                [Neighborhood_TSP_xulie(j, :)  Index_1 Index_2 ] = PerformSwap(SolusiSaatIni); %变异，两个位置的客户点对调
                Neighborhood_VRP_xulie(j, :) = converttovrpsolution(Neighborhood_TSP_xulie(j, :), Demand, Vehicle_load);
                Neighborhood_VRP_value(j) = calculatetotaldistance(Neighborhood_VRP_xulie(j, :), Distancematrix);
                
            case 3 % 2-opt
                [Neighborhood_TSP_xulie(j, :)  Index_1 Index_2 ] = Perform2Opt(SolusiSaatIni); %变异，两个位置之间的客户点完全颠倒
                Neighborhood_VRP_xulie(j, :) = converttovrpsolution(Neighborhood_TSP_xulie(j, :), Demand, Vehicle_load);
                Neighborhood_VRP_value(j) = calculatetotaldistance(Neighborhood_VRP_xulie(j, :), Distancematrix);
        end
        Variation_list(j, :) = [Pilihan  Index_1 Index_2];
    end
    
    %bedakan antara yg tabu maupun yg tidak tabu
    ApakahTabu = zeros(1, Solution_count); %Solution_count=100控制每一代解的个数，100*1的矩阵
    for j = 1 : Solution_count
        for k = 1 : tabulength %tabulength=10
            if Variation_list(j, :) == TabuList(k, :) %判断每一代当中的100个解的变异种类和变异的位置是否在禁忌表中
                ApakahTabu(j) = 1; %ApakahTabu是一个100*1的矩阵用于判断100个解的变异类别是否已经在禁忌表中
            end
        end
    end
​
​
    
    %寻找每代100个候选解中在禁忌表中和不在禁忌表中的最佳解，并记录其位置
    better_so_far_Tabu_ord = 1;
    better_so_far_ord = 1;  
    better_so_far.value = JaarakSolusiMaksimum; %存放到目前为止不在禁忌表中的最小值，一开始用一个比较大的值表示
    better_so_far_Tabu.value = JaarakSolusiMaksimum; %存放禁忌表中的最小值，一开始用一个比较大的值表示
    for j = 1 : Solution_count  %
        if  ApakahTabu(j) == 0 % 判断第i代100个解的变异类型是否在禁忌表中，0表示不在
            if Neighborhood_VRP_value(j) < better_so_far.value %判断Neighborhood_VRP_value（100个解的车辆行驶距离）
                better_so_far_TSP.xulie = Neighborhood_TSP_xulie(j, :); %存放不在禁忌表中的到当前为止的最佳TSP
                better_so_far_VRP.xulie = Neighborhood_VRP_xulie(j, :); %存放不在禁忌表中的到目前为止的最佳VRP
                better_so_far.value = Neighborhood_VRP_value(j); %存放不在禁忌表中的目前为止的最佳车辆行驶距离
                better_so_far_ord = j; %存放不在禁忌表中的到目前为止的最佳解的位置，即每代第几个解，100个解都查看过去后就变成每代最佳解
            end
        else
            if Neighborhood_VRP_value(j) <better_so_far_Tabu.value  
                better_so_far_TSP_Tabu.xulie = Neighborhood_TSP_xulie(j, :);
                better_so_far_VRP_Tabu.xulie = Neighborhood_VRP_xulie(j, :);
                better_so_far_Tabu.value = Neighborhood_VRP_value(j);
                better_so_far_Tabu_ord = j;
            end
        end
    end
    
% 比较每代100个不在禁忌表和在禁忌表中的最佳候选解的大小，并根据是否满足藐视规则更新禁忌表，最佳值
    if better_so_far_Tabu.value < best_so_far.value %表示不满足藐视规则，因为禁忌表的最小值小于不在禁忌表的最小值，说明这一代100个候选解的最佳解小于全局最佳解
        SolusiTerbaik = better_so_far_TSP_Tabu.xulie; %solusi global
        best_so_far.VRP = better_so_far_VRP_Tabu.xulie; %solusi global
        best_so_far.value = better_so_far_Tabu.value; % Jarak solusi global
        SolusiSaatIni = better_so_far_TSP_Tabu.xulie; %solusi iterasi
        SolusiVRPSaatIni = better_so_far_VRP_Tabu.xulie; %solusi iterasi
        JarakSolusiSaatIni = better_so_far_Tabu.value; % Jarak solusi iterasi
        %更新禁忌表
        IndeksTabuList = mod(i, tabulength) + 1; %tabulength=10
        TabuList(IndeksTabuList, :) = Variation_list(better_so_far_Tabu_ord, :);
    else %满足藐视规则
        SolusiSaatIni = better_so_far_TSP.xulie; %solusi iterasi
        SolusiVRPSaatIni = better_so_far_VRP.xulie; %solusi iterasi
        JarakSolusiSaatIni = better_so_far.value; % Jarak solusi iterasi
        if better_so_far.value < best_so_far.value
            SolusiTerbaik = better_so_far_TSP.xulie; %solusi global
            best_so_far.VRP = better_so_far_VRP.xulie; %solusi global
            best_so_far.value = better_so_far.value; % Jarak solusi global
        end
        %update tabu list
        IndeksTabuList = mod(i, tabulength) + 1;
        TabuList(IndeksTabuList, :) = Variation_list(better_so_far_ord, :);
    end
   
end
% disp('berapa kali PP');
% berapakalipp = hitungberapakalipp (sol2);
% disp(berapakalipp);
​
disp ('Jarak Terbaik');
disp (best_so_far.value);
disp (best_so_far.VRP);
toc
