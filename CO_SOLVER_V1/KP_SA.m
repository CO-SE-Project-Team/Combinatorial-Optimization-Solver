classdef KP_SA < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            timeLim=obj.Data.timeLim;
            iterations=obj.Data.iterations; %迭代次数（暴力用不着）
            iterator=obj.Data.iterator; %迭代次数（暴力用不着）
            problem='KP';

            capacity=obj.Data.capacity;% 背包的容量
            weight=obj.Data.demand';% 物品的重量
            cx=obj.Data.cx';
            cy=obj.Data.cy';% 物品价值
            n =length(weight);% n为物品的个数

            sol_new = ones(1,n);          %生成初始解
            E_current = inf;
            E_best = inf;
            %E_current是当前解对应的目标函数值（即背包中物品总价值）
            %E_new是新解的目标函数值
            %E_best是最优解
            sol_current = sol_new;
            sol_best = sol_new;
            t0 = 97;
            tf = 3;
            t = t0;
            a = 0.95;
            p = 1;
            cy = -cy;
            
            % 开始你的迭代循环
            while (obj.is_stop() == false && t>=tf)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
                xi=[];
                xj=[];
                objVal=0;

                for r = 1:100
                    %产生随机扰动
                    tmp = ceil(rand*n);
                    sol_new(1,tmp) = ~sol_new(1,tmp);
                    %检查是否满足约束
                    while 1
                        q = (sol_new *weight <= capacity);
                        if ~q
                            p = ~p;             %实现交错着逆转头尾的第一个1
                            tmp = find(sol_new == 1);
                            if p
                                sol_new(1,tmp(1)) = 0;
                            else
                                sol_new(1,tmp(end)) = 0;
                            end
                        else
                            break
                        end
                    end
                    
                    %计算背包中的物品价值
                    E_new = sol_new *cy;
                    if E_new < E_current
                        E_current = E_new;
                        sol_current = sol_new;
                        if E_new < E_best
                            E_best = E_new;
                            sol_best = sol_new;
                        end
                    else
                        if rand < exp( -(E_new - E_current) / t)
                            E_current = E_new;
                            sol_surrent = sol_new;
                        else
                            sol_new = sol_current;
                        end
                    end
                end
                t = t * a;
                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------
                        
                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()

                for i=1:n
                    if sol_best(i)==1
                        xi=[xi,cx(i)];
                        xj=[xj,cx(i)];
                    end
                end
                l=length(xi);
                if(l>1)
                    xi(l)=[];
                    xj(1)=[];
                end
    
                obj.Data.problem=problem;
                obj.Data.n=n;
                obj.Data.capacity=capacity;
                obj.Data.demand=weight';
                obj.Data.cx=cx';
                obj.Data.cy=-cy';
                obj.Data.dis=0;
                obj.Data.xi=xi;
                obj.Data.xj=xj;
                obj.Data.objVal=-E_best;
                obj.Data.timeLim=timeLim;
                obj.Data.iterations=iterations;
                obj.Data.iterator=iterator;
                
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
                % 当前迭代数加一，方便父类is_stop()检查是否超过iterations并停止算法
                obj.Data.iterator = obj.Data.iterator + 1;
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