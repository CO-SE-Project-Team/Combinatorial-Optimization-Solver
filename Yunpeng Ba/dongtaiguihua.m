

%% 邻接矩阵
edges=[0 30 6 4; 30 0 5 10 ;6 5 0 20; 4 10 20 0];

%% 动态规划

%% 初始化dp矩阵
[m,n] = size(edges); %dp表，n行, stateNum列
stateNum = bitshift(1,n-1); %dp表列数为C（n-1）1+...+C（n-1）（n-1）+空集的1
dp = zeros(n,stateNum); 
% 提前循环初始化为inf
for i=1:n
    for j=1:stateNum
        dp(i,j)=inf;
    end
end

%% 动规算法部分
% 更新第一列
for i=1:n
    dp(i,1)=edges(i,1);
end

%dp（i,j）中的i是一个二进制形式的数，表示经过城市的集合，如0111表示经过了城市0,1,2
%dp[i][j]表示经过了i中的城市，并且以j结尾的路径长度

%从城市0出发，所以经过城市0，以城市0结尾的路径为0
%从城市0出发，更新和其他城市的距离


% 循环迭代求解
% matlab 数组索引从1开始
for j=1:stateNum-1
    for i=0:n-1 %这个i不仅代表城市号，还代表第i次迭代
        if  i==0 || bitand(bitshift(j,-(i-1)),1)==0   %找没去过的
            %因为j就代表城市子集V[j],((j >> (i - 1))是把第i号城市取出来，位与上1等于0说明是从i号城市出发，经过城市子集V[j]，回到起点0号城市
            %“取出来”指集合j里面没有i这个城市，所以可以表示从i触发经过集合j中的城市
            
            for k=0:n-1
                temp2 = bitand(bitshift(j,-(k-1)),1);
                if k==0 || bitand(bitshift(j,-(k-1)),1)==1 
                %如果j的第k位为1，i.e.j中有k这个城市
                    
                    dp(i+1,j+1) = min(dp(i+1,j+1),edges(k+1,i+1)+dp(k+1,bitxor(j,(bitshift(1,k-1)))+1));
                    %dp[k][j ^ (1 << (k - 1))，是将dp定位到，从k城市出发，经过城市子集V[s]，回到0号城市所花费的最小距离
                    %如果从k城市出发经过城市子集V[s]，V[s]中肯定不包含k，则在j中把第k个城市置0即可
                    %(j ^ (1 <<k -1))表示j的k位（必为1）置0，其他位保持不变
                    
                    %没有访问过k，且从这里到k的距离小于原来的距离，则更新
                    %所有的计算都是以dp表为准，从左往右从上往下的计算的，每次计算都用到左边列的数据
                end
                
            end
        end
    end
end

%% 结果就是
dp(1,stateNum)
