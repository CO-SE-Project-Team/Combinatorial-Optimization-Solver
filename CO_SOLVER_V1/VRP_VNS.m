classdef VRP_VNS < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
    % SubALGORITHM 继承了 ALGORITHM
    % 父类具有 Data 结构体, 此处无需再次声明、
    % 本类不需要有任何变量
    methods
        % 本类有且仅有以下一种方法/函数
        function solve(obj)
            % 把父类Data中变量赋予该类中你需要使用的变量， 不同问题可能不同
            % 如;
            problem = obj.Data.problem;
            n = obj.Data.n;
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;
            xi = obj.Data.xi;
            xj = obj.Data.xj;
            objVal = obj.Data.objVal;
            
            % 其他变量设置 & 初始化
            data = zeros(n, n);
            C=[cx;cy]';% 存放城市之间距离的矩阵
            for i=1:n
                for j=1:n
                    if i~=j
                        data(i,j) = ((C(i,1)-C(j,1))^2+(C(i,2)-C(j,2))^2)^0.5;
                    else
                        data(i,j) = eps;
                    end
                    data(j,i) = data(i,j);
                end
            end
            % start_clock() 是父类方法，开始计时
            obj.start_clock();
            % 开始你的迭代循环
            xnew = randperm(n);
            xnew(xnew == 1) = [];
            [xbest, fitxbest] = dist(xnew, data, capacity, demand, n);
            
               xnew = [1, xnew];
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
             
                neighbors = neighborBy2opt(xnew);                       % 产生xnew的邻域解

                neighbors = neighbors(:, 2:n);
                % 计算neighbors中每个解的值，并获得最小解
                neighborRows = size(neighbors,1);
                fitnesses = zeros(neighborRows,1);
                for i = 1:neighborRows
                    fitnesses(i) = dist2(neighbors(i,:), data, capacity, demand, n);  % 计算每个邻域解的路线长度
                end
                [~, idx] = sortrows(fitnesses);                         % 对邻域解进行升序排列
                xnow = neighbors(idx(1),:);                             % 把最短路线长度的解赋给xnow
                fitnow = fitnesses(idx(1));                             % xnow的路线长度

                % 进行解的更新和终止循环判断
                if fitnow < fitxbest                                    % 如果xnow优于xbest时将xnow赋给xbest
                    [xbest,fitxbest] = dist(neighbors(i,:), data, capacity, demand, n);
                end
%                 xnew = [1,neighbors(idx(1), :)];                                            % 将xnow赋给xnew

                % 解随机移动下
                segCities = circshift(2:n,randperm(n,1)-1);
                 newIdx = [1 segCities];
                xnew = xnew(newIdx);                
                
                
                
                
                
                
                
                
                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------
                        
                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
                
                obj.Data.xi=xbest(1, 1:size(xbest, 2) - 1);
                obj.Data.xj=xbest(1,2:size(xbest,2));
                obj.Data.objVal=fitxbest;

                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);% 这将会把当前的objVal，xi，xj更新到GUI中。
            end
            obj.Data.distance = data;
        end
    end
end
function [Route,dist] = dist(route, data, cap, demand,n)
count = 0;
dist = 0;
Route = [];
before = 1;
Route = [Route, 1];
for i = 1:n-1
    count = count + demand(route(i));
    if count <= cap
        Route = [Route, route(i)];
        dist = dist + data(before, route(i));
        before = route(i);
    else
        
        count = demand;
        dist = dist + data(before, 1);
        Route = [Route, 1];
        Route = [Route, route(i)];
        before = route(i);
        dist = dist + data(1, route(i));
    end

end
Route = [Route, 1];
dist = dist + data(1, before);
end

function dist = dist2(route, data, cap, demand,n)
count = 0;
dist = 0;
before = 1;
for i = 1:n-1
    count = count + demand(route(i));
    if count <= cap
        dist = dist + data(before, route(i));
        before = route(i);
    else
        count = demand;
        dist = dist + data(before, 1);
        before = 1;
        before = route(i);
        dist = dist + data(1, route(i));
    end
dist = dist + data(1, before);
end
end
function routes = neighborBy2opt( route )

cityQty = max(size(route));

pos = 2 : cityQty;
changePos = nchoosek(pos, 2);
rows = size(changePos, 1);
routes = zeros(rows, cityQty);
% 依次对两个点进行位置互换，形成新的解
k = 1;
for i = 2:cityQty
    for j = i + 1:cityQty
        city1 = route(1, i);
        city2 = route(1, j);
        part1 = [];
        if i > 2
        part1 = route(1, 2:i - 1);
        end
        part2 = [];
        if j > i + 1
            part2 = route(1, i + 1:j - 1);
        end
        part3 = [];
        if cityQty > j
            part3 = route(1, j + 1:cityQty);
        end
        routes(k, :) = [1 route(1,i) route(1,j) part1 part2 part3];
        k = k + 1;
    end
end
% for i  = 1 : rows
%     city1 = route(changePos(i,1));
%     city2 = route(changePos(i,2));
%     midRoute = route;
%     midRoute(changePos(i,1)) = city2;
%     midRoute(changePos(i,2)) = city1;
%     routes(i,:) = midRoute;
% end
end

%本地命令行测试步骤
% p=SubALGORITHM()
% 打开.mat文件导入数据Data
% p.set_Data(Data)
% p.solve()
% p.get_Data() 需要在变量里把Data.timeLim修改，测试能完整跑完和无法完整跑完两种情况
% p.get_solved_Data(Data)这个是前几种方法的集合，也需要测试一次