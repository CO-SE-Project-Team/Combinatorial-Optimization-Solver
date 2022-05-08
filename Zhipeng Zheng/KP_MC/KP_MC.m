classdef KP_MC < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
    % SubALGORITHM 继承了 ALGORITHM
    % 父类具有 Data 结构体, 此处无需再次声明、
    % 本类不需要有任何变量
    methods
        % 本类有且仅有以下一种方法/函数
        function solve(obj)
            % 把父类Data中变量赋予该类中你需要使用的变量， 不同问题可能不同
            % 如;
            timeLim=obj.Data.timeLim;
            iterations=obj.Data.iterations; %迭代次数（暴力用不着）
            iterator=obj.Data.iterator; %迭代次数（暴力用不着）
            problem='KP';

            capacity=obj.Data.capacity;% 背包的容量
            weight=obj.Data.demand';% 物品的重量
            cx=obj.Data.cx';
            cy=obj.Data.cy';% 物品价值
            n =length(weight);% n为物品的个数

            % 其他变量设置 & 初始化

            % start_clock() 是父类方法，开始计时
            obj.start_clock();
            obj.Data.iterator = 0;
            % 开始你的迭代循环
            MaxVal = 0;
            MaxObj = [];
            
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
                a = randperm(n);
                num = a(1,1);
                Bigset = randperm(n);
                set = Bigset(1:num);
                wei = 0;
                for i = 1:num
                    wei = wei + weight(1,set(i));
                end
                while wei > capacity
                    a = randperm(n);
                    num = a(1,1);
                    Bigset = randperm(n);
                    set = Bigset(1,1:num);
                    wei = 0;
                    for i = 1:num
                        wei = wei + weight(1,set(1,i));
                    end
                end
                Val = 0;
                for i = 1:num
                    Val = Val + cy(1, set(1, i));
                end
                if Val > MaxVal
                    MaxVal = Val;
                    MaxObj = sort(set);
                end
                obj.Data.problem=problem;
                obj.Data.n=n;
                obj.Data.capacity=capacity;
                %obj.Data.demand=weight';
                %obj.Data.cx=cx';
                %obj.Data.cy=cy';
                obj.Data.dis=0;
                if num > 1
                    obj.Data.xi = MaxObj(1, 1:num - 1)';
                    obj.Data.xj = MaxObj(1, 2:num)';
%                     obj.Data.xi = obj.Data.xi(1, 1:num - 1);
%                     obj.Data.xj = obj.Data.xi(1, 2:num);
                else
                    obj.Data.xi=MaxObj;
                    obj.Data.xj=MaxObj;
                end

                obj.Data.objVal=MaxVal;
                obj.Data.timeLim=timeLim;
                obj.Data.iterations=iterations;
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);








                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------

                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()

            end
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