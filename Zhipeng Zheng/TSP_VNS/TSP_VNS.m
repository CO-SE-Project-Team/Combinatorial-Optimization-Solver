classdef TSP_VNS < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
    % SubALGORITHM 继承了 ALGORITHM
    % 父类具有 Data 结构体, 此处无需再次声明、
    % 本类不需要有任何变量
    methods
        % 本类有且仅有以下一种方法/函数
        function solve(obj)

            problem = 'TSP';
            timeLim=obj.Data.timeLim;
            %capacity = obj.Data.capacity;
            %demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;
            objVal = obj.Data.objVal;
            n = size(cx, 2);
            % 其他变量设置 & 初始化

            % start_clock() 是父类方法，开始计时
            obj.start_clock();
            % 开始你的迭代循环


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
            cityQty = size(data,1);                                     % 城市总数
            otherCities = 2:cityQty;

            % 随机产生初始解
            randCities = otherCities(randperm(cityQty - 1));
            xnew = [1 randCities];                                      % 产生xnew
            fitxnew = routeDistance(data,xnew);                         % 计算xnew解的路线长度
            xbest = xnew;                                               % 让xbest = xnew
            fitxbest = fitxnew;                                         % 让fitxbest = fitxnew

            % 循环计算
            isStop = 0;
            obj.Data.iterator = 0;
            %while(obj.Data.iterator <= 10)
             %&& isStop < 4
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------



                obj.Data.iterator = obj.Data.iterator + 1;% 设置迭代次数
                % 使用2-opt方式产生xnew的全部邻域解
                neighbors = neighborBy2opt(xnew);                       % 产生xnew的邻域解

                % 计算neighbors中每个解的值，并获得最小解
                neighborRows = size(neighbors,1);
                fitnesses = zeros(neighborRows,1);
                for i = 1:neighborRows
                    fitnesses(i) = routeDistance(data,neighbors(i,:));  % 计算每个邻域解的路线长度
                end
                [~, idx] = sortrows(fitnesses);                         % 对邻域解进行升序排列
                xnow = neighbors(idx(1),:);                             % 把最短路线长度的解赋给xnow
                fitnow = fitnesses(idx(1));                             % xnow的路线长度

                % 进行解的更新和终止循环判断
                if fitnow < fitxbest                                    % 如果xnow优于xbest时将xnow赋给xbest
                    xbest = xnow;
                    fitxbest = fitnow;
                    isStop = 0;
                else                                                    % 如果xnow不优于xbest，进行下一次的迭代
                    isStop = isStop + 1;
                end
                xnew = xnow;                                            % 将xnow赋给xnew

                % 解随机移动下
                segCities = circshift(otherCities,randperm(cityQty,1)-1);
                newIdx = [1 segCities];
                xnew = xnew(newIdx);

                xbestx = [xbest 1];
                obj.Data.xi = xbestx(1 , 1:n);
                obj.Data.xj = xbestx(1, 2:n+1);
                obj.Data.objVal = fitxbest;
                disp(fitxbest);
                disp(xbest)
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj); % 这将会把当前的objVal，xi，xj更新到GUI中。
            end


            obj.Data.problem=problem;
            obj.Data.n=n;
            obj.Data.cx=cx;
            obj.Data.cy=cy;
            obj.Data.dis=data;
            obj.Data.timeLim=timeLim;
        end


        % 注意要记得更新xi，xj，objVal等变量
        % ----------------以上是你的算法内容-----------------------

        % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()

    end
end

%本地命令行测试步骤
% p=SubALGORITHM()
% 打开.mat文件导入数据Data
% p.set_Data(Data)
% p.solve()
% p.get_Data() 需要在变量里把Data.timeLim修改，测试能完整跑完和无法完整跑完两种情况
% p.get_solved_Data(Data)这个是前几种方法的集合，也需要测试一次

function routeDist = routeDistance(cityDist, route)
% 根据城市间的距离计算总路径
qty = max(size(route));
sumDist = 0;
for i = 1 : qty - 1
    sumDist = sumDist + cityDist(route(i),route(i+1));
end
sumDist = sumDist + cityDist(route(qty),route(1));
routeDist = sumDist;
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
