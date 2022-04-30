classdef KP_BF
    properties
        data
    end
    methods
        function [obj]=KP_BF()
        end
        function [obj]=solve(obj)
            t1=clock;
            timeLim=obj.data.timeLim;
            iterations=-1; %迭代次数（暴力用不着）
            iterator=-1; %迭代次数（暴力用不着）
            problem="KP";
            
            capacity=obj.data.capacity;% 背包的容量
            weight=obj.data.demand;% 物品的重量
            cx=obj.data.cx;
            cy=obj.data.cy;% 物品价值
            n =length(weight);% n为物品的个数
            objVal=0;%被选择物品的总价值
            xi=[];
            xj=[];
            
            for i=0:2^n-1
                v=dec2bin(i,n);%
                temp_w=0;
                temp_p=0;
                for j=1:n
                    if v(j)=='1'
                        temp_w=temp_w+weight(j);
                        temp_p=temp_p+cy(j);
                    end
                    if (temp_w<=capacity)&&(temp_p>objVal)
                        objVal=temp_p;
                        optv=v;
                    end
                end
            end

            t2=clock;
            t=etime(t2,t1);
            if t>timeLim
                objVal=-1;
                %-1表示程序没跑完
            end
            for i=1:n
                if optv(i)=='1'
                    xi=[xi,cx(i)];
                end
            end
            for i=1:n
                if optv(i)=='1'
                    xj=[xj,cy(i)];
                end
            end

            obj.data.problem=problem;
            obj.data.n=n;
            obj.data.capacity=capacity;
            obj.data.demand=weight;
            obj.data.cx=cx;
            obj.data.cy=cy;
            obj.data.dis=0;
            obj.data.xi=xi;
            obj.data.xj=xj;
            obj.data.objVal=objVal;
            obj.data.timeLim=timeLim;
            obj.data.iterations=iterations;
            obj.data.iterator=iterator;
        end
        function [obj]=set_Data(obj,data)
            obj.data=data;
        end
        function [data]=get_Data(obj)
            data=obj.data;
        end
        function [data]=get_solved_Data(obj,data)
            obj.data=data;
            obj=solve(obj);
            data=obj.data;
        end
    end
end
