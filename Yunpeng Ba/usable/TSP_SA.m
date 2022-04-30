classdef TSP_SA
    properties
        data
    end
    methods
        function [obj]=TSP_SA()
        end
        function [obj]=solve(obj)
            t1=clock;
            timeLim=obj.data.timeLim;
            problem='TSP';
            algorithm='SA';
            
            cx=obj.data.cx;
            cy=obj.data.cy;
            n=size(cx,2);
            
            C=[cx;cy]';
            T=obj.data.iterations;     %初始温度
            L=100;       %马尔科夫链的长度
            %K=0.99;      %衰减参数
            
            dis=zeros(n);   % 初始化两个城市的距离矩阵全为0
            for i=2:n    %i从2开始，是因为他与他自己的距离是0
                for j=1:i
                    dis(i,j) = sqrt((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2);   % 计算城市i和j的距离
                end
            end
            dis = dis+dis';   % 生成对称完整的距离矩阵
            
            %%%城市坐标结构体%%%%%%%
            city=struct([]);
            
            for f=1:n
                city(f).x=C(f,1);
                city(f).y=C(f,2);
            end
            
            
            l=1;        %统计迭代次数
            len(l)=func5(city,n); %每次迭代后路线的长度
            
            
            %figure(1);
            count=0;
            while T>0
                %%%%%%%%%%%%%%%多次迭代扰动，温度降低前多次试验%%%%%%%%
                for z=1:L
                    %%%%%%%%%%%%%%%计算原路线总距离%%%%%%%%%
                    len1=func5(city,n);
                    %%%%%%%%%%%%%%%产生随机扰动%%%%%%%%%
                    %%%%%%%%%%%%%%%随机置换两个不同的城市的坐标%%%%%%%%%
                    p1=floor(1+n*rand);
                    p2=floor(1+n*rand);
                    while p1==p2
                        p1=floor(1+n*rand);
                        p2=floor(1+n*rand);
                    end
                    tmp_city=city;
                    %%交换元素
                    tmp=tmp_city(p1);
                    tmp_city(p1)=tmp_city(p2);
                    tmp_city(p2)=tmp;
                    %%%%%%%%%%%%%%%计算新路线总距离%%%%%%%%%
                    len2=func5(tmp_city,n);
                    %%%%%%%%%%%%%%%新老距离的差值，相当于能量%%%%%%%%%
                    delta_e=len2-len1;
                    %%%%%%%%%%%%%%%新路线好于旧路线，用新路线替代旧路线%%%%%%%%%
                    if delta_e<0
                        city=tmp_city;
                    else
                        %%%%%%%%%%%%%%%以一定概率选择是否接受%%%%%%%%%
                        if exp(-delta_e/T)>rand()
                            city=tmp_city;
                        end
                    end
                end
                l=l+1;          %迭代次数加1
                
                %%%%%%%%%%%%%%%计算新路线的距离%%%%%%%%%
                len(l)=func5(city,n);
                %%%%%%%%%%%%%%%温度不断下降%%%%%%%%%
                T=T-1;
                count=count+1;
                obj.data.iterator=count;
                %T=T*K;
                
                %for i=1:n-1
                %  plot([city(i).x,city(i+1).x],[city(i).y,city(i+1).y],'bo-');
                %   hold on;
                %end
                %plot([city(n).x,city(1).x],[city(n).y,city(1).y],'ro-');
                
                %title(['优化最短距离:',num2str(len(l))]);%%num2str将数字转为字符数组
                %hold off;
                %pause(0.005);
                t2=clock;
                t=etime(t2,t1);
                if t>timeLim
                    break
                end
            end
            
            path=[];
            for z=1:n
                for y=1:n
                    if [city(z).x,city(z).y]==C(y,:)
                        path=[path y];
                        break
                    end
                end
            end
            %求出来的路径目前是随机起始点，但路径是闭环，所以把路径开头改成1即可
            path1=[];
            for u=1:n
                if path(1,u)==1
                    path1=[path(1,u:n) path(1,1:u-1) 1];
                    break
                end
            end
            
            objVal=len(l);
            xi=path1(1,1:n);
            xj=path1(1,2:n+1);
            
            %计算距离的函数
            function len=func5(city,n)
                len=0;
                for i=1:n-1
                    len=len+sqrt((city(i).x-city(i+1).x)^2+(city(i).y-city(i+1).y)^2);
                end
                len=len+sqrt((city(n).x-city(1).x)^2+(city(n).y-city(1).y)^2);
            end
            
            obj.data.problem=problem;
            obj.data.n=n;
            obj.data.cx=cx;
            obj.data.cy=cy;
            obj.data.dis=dis;
            obj.data.xi=xi;
            obj.data.xj=xj;
            obj.data.objVal=objVal;
            obj.data.timeLim=timeLim;
            obj.data.algorithm=algorithm;
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
