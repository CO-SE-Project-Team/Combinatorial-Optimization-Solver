classdef KP_TWOOPT < ALGORITHM %类名改成 问题_算法, 如把subALGORITHM改成：'TSP_GA'，这个文件需要把ALGORITHM加到目录
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
            weight=obj.Data.demand;% 物品的重量
            cx=obj.Data.cx;
            cy=obj.Data.cy;% 物品价值
            n =length(weight);% n为物品的个数
            objVal=0;%被选择物品的总价值
            xi=[];
            xj=[];
            a=[];%物品单位重量的价值
            v=[];
            temp=capacity;


            %计算物品单位重量的价值并降序排列
            for i=1:n
                a(i)=cy(i)/weight(i);
            end
            [~,place]=sort(a,"descend");

            %在满足选取物品总重量不超过背包容量的前提下，优先选择单位重量价值较大的物品
            for i=1:n-1
                objVal=objVal+cy(place(i));
                capacity=capacity-weight(place(i));
                if(capacity<0)
                    objVal=objVal-cy(place(i));
                    capacity=capacity+weight(place(i));
                else
                    v(place(i))=1;
                end
            end
            %
            %             if obj.is_stop()==true
            %                 objVal=-1;
            %                 %-1表示程序没跑完
            %             end
            %             for i=1:n
            %                 if v(i)==1
            %                     xi=[xi,cx(i)];
            %                     xj=[xj,cx(i)];
            %                 end
            %             end
            %             l=length(xi);
            %             if(l>1)
            %                 xi(l)=[];
            %                 xj(1)=[];
            %             end
            % 其他变量设置 & 初始化

            % start_clock() 是父类方法，开始计时
           
            obj.start_clock();
            % 开始你的迭代循环
            while (obj.is_stop() == false)  % is_stop()是父类方法，会检查是否超时，超迭代。如果是，则停止算法
                % 循环内部
                % ----------------下面写你的算法内容-----------------------
xi=[];
xj=[];
                vs = neighborBy2opt(v);
                disp(size(vs))
                for i = 1:size(vs, 1)
                    WW = 0;
                    WEA = 0;
                    for j = 1:size(vs, 2)
                        if vs(i,j) == 1
                            WW = WW + weight(1,j);
                            WEA = WEA + cy(1, j);
                        end
                    end
                    if WW <= capacity && WEA > objVal
                        objVal = WEA;
                        v = vs(i,:);
                    end
                end

                for i=1:n
                    if v(i)==1
                        xi=[xi,cx(i)];
                        xj=[xj,cx(i)];
                    end
                end
                l=length(xi);
                if(l>1)
                    xi(l)=[];
                    xj(1)=[];
                end






                % 注意要记得更新xi，xj，objVal等变量
                % ----------------以上是你的算法内容-----------------------

                % 这里将算法内部算好的变量赋给父类Data，方便父类get_Data()
               obj.Data.problem=problem;
            obj.Data.n=n;
            obj.Data.capacity=temp;
            obj.Data.demand=weight;
            obj.Data.cx=cx;
            obj.Data.cy=cy;
            obj.Data.dis=0;
            obj.Data.xi=xi;
            obj.Data.xj=xj;
            obj.Data.objVal=objVal;
            obj.Data.timeLim=timeLim;
            obj.Data.iterations=iterations;
            obj.Data.iterator=iterator;
            
            obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
            end
        end
            end

end
function routes = neighborBy2opt( route )
            % 根据一条路径route，采用2opt方式产生其全部邻域解集
            cityQty = max(size(route));
            % if cityQty <= 3
            %     disp('cityQty is too small in neighborBy2opt.....');
            % end
            pos = 2 : cityQty;
            changePos = nchoosek(pos, 2);
            rows = size(changePos, 1);
            routes = zeros(rows, cityQty);
            % 依次对两个点进行位置互换，形成新的解
            for i  = 1 : rows
                city1 = route(changePos(i,1));
                city2 = route(changePos(i,2));
                midRoute = route;
                midRoute(changePos(i,1)) = city2;
                midRoute(changePos(i,2)) = city1;
                routes(i,:) = midRoute;
            end
        end

%本地命令行测试步骤
% p=SubALGORITHM()
% 打开.mat文件导入数据Data
% p.set_Data(Data)
% p.solve()
% p.get_Data() 需要在变量里把Data.timeLim修改，测试能完整跑完和无法完整跑完两种情况
% p.get_solved_Data(Data)这个是前几种方法的集合，也需要测试一次