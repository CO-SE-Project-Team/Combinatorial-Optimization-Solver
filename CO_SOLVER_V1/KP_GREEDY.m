classdef KP_GREEDY < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
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

            if obj.is_stop()==true
                objVal=-1;
                %-1表示程序没跑完
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