clear;clc
% 只有8个城市的简单情况
 towns =[0.64 0.41 0.99 0.55 0.77 0.25 0.11 0.89;
         0.74 0.45 0.66 0.21  0.32 0.99 0.54 0.11]' ;  % 城市坐标矩阵，n行2列
n = size(towns,1);  % 城市的数目

figure(1)  % 新建一个编号为1的图形窗口
plot(towns(:,1),towns(:,2),'o');   % 画出城市的分布散点图
for i = 1:n
    text(towns(i,1)+0.02,towns(i,2)+0.02,num2str(i))   % 在图上标上城市的编号（加上0.02表示把文字的标记往右上方偏移各0.02单位）
end
hold on % 接着在这个图形上画图的


d = zeros(n);   % 初始化两个城市的距离矩阵全为0
for i = 2:n    %i从2开始，是因为他与他自己的距离是0
    for j = 1:i  
        towns_i = towns(i,:);   x_i = towns_i(1);     y_i = towns_i(2);  % 城市i的横坐标为x_i，纵坐标为y_i
        towns_j = towns(j,:);   x_j = towns_j(1);     y_j = towns_j(2);  % 城市j的横坐标为x_j，纵坐标为y_j
        d(i,j) = sqrt((x_i-x_j)^2 + (y_i-y_j)^2);   % 计算城市i和j的距离
    end
end
d = d+d';   % 生成对称完整的距离矩阵

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
        min_path = path;
        min_result = result;
    end
end
min_path
min_path = [min_path,min_path(1)];   % 在最短路径的最后面加上一个元素，即第一个点（我们要生成一个封闭的图形）
n = n+1;  % 城市的个数加一个（紧随着上一步）
for i = 1:n-1 
     j = i+1;
    towns_i = towns(min_path(i),:);   x_i = towns_i(1);     y_i = towns_i(2); 
    towns_j = towns(min_path(j),:);   x_j = towns_j(1);     y_j = towns_j(2);
    plot([x_i,x_j],[y_i,y_j],'-')    % 每两个点就作出一条线段，直到所有的城市都走完
    pause(0.5)  % 暂停0.5s再画下一条线段
    hold on
end

