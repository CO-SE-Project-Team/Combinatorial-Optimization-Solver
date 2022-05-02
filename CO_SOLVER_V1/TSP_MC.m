classdef TSP_MC < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            timeLim=obj.Data.timeLim;
            problem='TSP';
            
            cx=obj.Data.cx;
            cy=obj.Data.cy;
            n=size(cx,2);
            towns=[cx;cy].';
            
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
            N = obj.Data.iterations;  % 模拟的次数，尽量比解的个数大几倍十几倍，但也不要太大，运行慢
            
            for i = 1:N  % 开始循环
                obj.Data.iterator=i;
                if obj.is_stop()==true
                    break
                end
                
                result = 0;  % 初始化走过的路程为0
                path = randperm(n-1);  % 生成一个1-n的随机打乱的序列
                for z=1:n-1
                    path(1,z)=path(1,z)+1;
                end
                path=[1 path];
                for l= 1:n-1
                    result = d(path(l),path(l+1)) + result;  % 按照这个序列不断的更新走过的路程这个值
                end
                result = d(path(1),path(n)) + result;  % 加上从最后一个城市返回到最开始那个城市的距离
                if result < min_result  % 判断这次模拟走过的距离是否小于最短的距离，如果小于就更新最短距离和最短的路径
                    %                     t2=clock;
                    %                     t=etime(t2,t1);
                    min_path = path;
                    min_result = result;
                    min_path = [min_path,min_path(1)];   % 在最短路径的最后面加上一个元素，即第一个点（我们要生成一个封闭的图形）
                    obj.Data.objVal=min_result;
                    obj.Data.xi=min_path(1,1:n);
                    obj.Data.xj=min_path(1,2:n+1);
                    %                     if t>timeLim
                    %                         break
                    %                     end
                end
            end
            
            
            obj.Data.problem=problem;
            obj.Data.n=n;
            obj.Data.cx=cx;
            obj.Data.cy=cy;
            obj.Data.dis=dis;
            obj.Data.timeLim=timeLim;
        end
    end
end
