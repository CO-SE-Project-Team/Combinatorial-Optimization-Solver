clear;clc
timeLimit=0.005;
t1=clock;
problem='TSP';
% 只有8个城市的简单情况
 towns =[0.64 0.41 0.99 0.55 0.77 0.25 0.11 0.89;
         0.74 0.45 0.66 0.21  0.32 0.99 0.54 0.11]' ;  % 城市坐标矩阵，n行2列
     coord=towns;
n = size(towns,1);  % 城市的数目
cx=coord(:,1).';
cy=coord(:,2).';
xi=[];
xj=[];
for k=1:n
    for m=1:n
        xi=[xi k];
        xj=[xj k];
    end
end


d = zeros(n);   % 初始化两个城市的距离矩阵全为0
for i = 2:n    %i从2开始，是因为他与他自己的距离是0
    for j = 1:i  
        towns_i = towns(i,:);   x_i = towns_i(1);     y_i = towns_i(2);  % 城市i的横坐标为x_i，纵坐标为y_i
        towns_j = towns(j,:);   x_j = towns_j(1);     y_j = towns_j(2);  % 城市j的横坐标为x_j，纵坐标为y_j
        d(i,j) = sqrt((x_i-x_j)^2 + (y_i-y_j)^2);   % 计算城市i和j的距离
    end
end
d = d+d';   % 生成对称完整的距离矩阵
dis=d;

min_result = +inf;  % 假设最短的距离为min_result，初始化为无穷大，后面只要找到比它小的就对其更新
min_path = [1:n];   % 初始化最短的路径就是1-2-3-...-n
N = 500000;  % 模拟的次数，尽量比解的个数大几倍十几倍，但也不要太大，运行慢

for i = 1:N  % 开始循环
    result = 0;  % 初始化走过的路程为0
    path = randperm(n);  % 生成一个1-n的随机打乱的序列
    for i = 1:n-1  
        result = d(path(i),path(i+1)) + result;  % 按照这个序列不断的更新走过的路程这个值
    end
    result = d(path(1),path(n)) + result;  % 别忘了加上从最后一个城市返回到最开始那个城市的距离
    if result < min_result  % 判断这次模拟走过的距离是否小于最短的距离，如果小于就更新最短距离和最短的路径
        t2=clock;
        t=etime(t2,t1);
        min_path = path;
        min_result = result;
        if t>timeLimit
            break
        end
    end
end
min_path = [min_path,min_path(1)];   % 在最短路径的最后面加上一个元素，即第一个点（我们要生成一个封闭的图形）
n = n;  

objVal=min_result;
Problem.problem=problem;
Problem.n=n;
Problem.cx=cx;
Problem.cy=cy;
Problem.dis=dis;
Problem.xi=xi;
Problem.xj=xj;
Problem.objVal=objVal;
Problem.timeLimit=timeLimit;



