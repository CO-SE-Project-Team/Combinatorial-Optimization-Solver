classdef TSP_BF < handle
    properties
        data
    end
    methods
        function [obj]=TSP_BF()
        end
        function solve(obj)
            t1=clock;
            timeLim=obj.data.timeLim;
            iterations=-1; %迭代次数（暴力用不着）
            iterator=-1; %迭代次数（暴力用不着）
            problem='TSP';
            algorithm='BF';
            
            cx=obj.data.cx;
            cy=obj.data.cy;
            n=size(cx,2);
            
            dis=zeros(n);   % 初始化两个城市的距离矩阵全为0
            for i=2:n    %i从2开始，是因为他与他自己的距离是0
                for j=1:i
                    dis(i,j) = sqrt((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2);   % 计算城市i和j的距离
                end
            end
            dis = dis+dis';   % 生成对称完整的距离矩阵
            m=randperm(n-1);
            V=[];
            V2=perms(m);%得到全排列遍历矩阵
            V2=V2+1;
            for v=1:size(V2)
                V(v,:)=[1 V2(v,:) 1];
            end


            d=[];
            for i=1:size(V,1)                           %计算每一条环路的各段长度
                for j=1:size(V,2)-1
                    d(i,j)=dis(V(i,j),V(i,j+1));              %第i种排列情况j城市到j+1城市的距离
                end
            end
            D=sum(d,2);                                 %将各段长度加和
            [d,position]=min(D);                        %找到最短环路
            d_min=d;                                    %最短环路的长度
            path_min=V(position,:);                     %最短环路的路径
            objVal=d_min;
            t2=clock;
            t=etime(t2,t1);
            if t>timeLim
                path_min=-1;
                d_min=-1;
                %-1表示程序没跑完
            end
            if d_min==-1
                xi=-1;
                xj=-1;
            else
                xi=path_min(1,1:n);
                xj=path_min(1,2:n+1);
                
                obj.data.problem=problem;
                obj.data.n=n;
                obj.data.cx=cx;
                obj.data.cy=cy;
                obj.data.dis=dis;
                obj.data.xi=xi;
                obj.data.xj=xj;
                obj.data.objVal=objVal;
                obj.data.timeLim=timeLim;
                obj.data.iterations=iterations;
                obj.data.iterator=iterator;
                obj.data.algorithm=algorithm;
            end
        end
        function set_Data(obj,data)
            obj.data=data;
        end
        function [data]=get_Data(obj)
            data=obj.data;
        end
        function [data]=get_solved_Data(obj,data)
            obj.data=data;
            obj.solve(obj);
            data=obj.data;
        end
    end
end
