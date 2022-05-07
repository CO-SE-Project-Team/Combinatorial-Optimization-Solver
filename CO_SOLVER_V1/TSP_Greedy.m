classdef TSP_GREEDY < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
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

            % start_clock() 是父类方法，开始计时
            obj.start_clock();
            % 开始你的迭代循环
            inputIndex = [cx.' , cy.'];
            inputAdjacencyMatrix = zeros(n);
            for i = 1:n
                for j = 1:n
                    inputAdjacencyMatrix(i, j) = sqrt((inputIndex(i, 1) - inputIndex(j, 1)) ^ 2 + (inputIndex(i, 2) - inputIndex(j, 2)) ^ 2);
                end
            end
            row = size(inputAdjacencyMatrix, 1);
            outputRoad = [];%输出路径
            outputCost = 0;%输出总长度
            havePass = zeros(1, row);%标记点是否被走过
            nextPoint = 1;%确定开始点
            haveNumber = 0;%确定已走路程
            while haveNumber < row
                havePass(1, nextPoint) = 1;
                outputRoad = [outputRoad, nextPoint];
                min = 0;
                haveNumber = haveNumber + 1;
                for i = 1:row%确定起始搜索点
                    if havePass(1, i) == 0
                        min = inputAdjacencyMatrix(nextPoint, i);
                        break
                    end
                end
                tem = nextPoint;
                for i = 1:row%找到最短的路径
                    if havePass(1, i) == 0 && inputAdjacencyMatrix(tem, i) <= min
                        min = inputAdjacencyMatrix(tem, i);
                        nextPoint = i;
                    end
                end
                outputCost = outputCost + min;
            end
            objVal = 0;
            
            outputRoad = [outputRoad , 1];
            outputCost = outputCost + inputAdjacencyMatrix(row, 1);

            obj.Data.problem = problem;
            xi = outputRoad(1, 1:n);
            xj = outputRoad(1 , 2:n + 1);
            obj.Data.dis=inputAdjacencyMatrix;
            
            obj.Data.cx = inputIndex(:, 1).';
            obj.Data.cy = inputIndex(:, 2).';
            
            obj.Data.objVal = outputCost;
            
            obj.Data.xi=xi;
            obj.Data.xj=xj;

            obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj); % 这将会把当前的objVal，xi，xj更新到GUI中。
        end
    end
end


%本地命令行测试步骤
% p=SubALGORITHM()
% 打开.mat文件导入数据Data
% p.set_Data(Data)
% p.solve()
% p.get_Data() 需要在变量里把Data.timeLim修改，测试能完整跑完和无法完整跑完两种情况
% p.get_solved_Data(Data)这个是前几种方法的集合，也需要测试一次