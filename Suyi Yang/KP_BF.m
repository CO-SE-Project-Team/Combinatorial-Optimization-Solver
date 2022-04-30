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
            problem='KP';
            
            capacity=obj.data.capacity;% 背包的容量
            weight=obj.data.weight;% 物品的重量
            cy=obj.data.cy;% 物品价值
            n =length(weight);% n为物品的个数
            v=[];%背包里物品的状态，0为取，1为不取
            objVal=0;%被选择物品的总价值
            
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
                        xi=v;
                    end
                end
            end

            t2=clock;
            t=etime(t2,t1);
            if t>timeLim
                objVal=-1;
                %-1表示程序没跑完
            end
            if objVal==-1
                xi=-1;
                xj=-1;
            else
                obj.data.problem=problem;
                obj.data.weight=weight;
                obj.data.n=n;
                obj.data.cx=(1:n);
                obj.data.cy=cy;
                obj.data.dis=0;
                obj.data.xi=xi;
                obj.data.xj=[];
                obj.data.objVal=objVal;
                obj.data.timeLim=timeLim;
                obj.data.iterations=iterations;
                obj.data.iterator=iterator;
            end
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
