classdef SubALGORITHM < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'
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
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
                
                
                
                
                
                
                
                
                
                
                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------
                
                % 当前迭代数加一，方便父类is_stop()检查是否超过iterations并停止算法
                obj.Data.iterator = obj.Data.iterator + 1;
            end
        end
        
        % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
        obj.Data.xi=xi;
        obj.Data.xj=xj;
        obj.Data.objVal=objVal;
        
    end
end