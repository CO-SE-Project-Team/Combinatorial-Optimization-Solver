classdef TSP_DP < ALGORITHM
    methods
        function solve(obj)
            obj.start_clock();
            timeLim=obj.Data.timeLim;
            iterations=0; %迭代次数（动规用不着）
            iterator=0; %迭代次数（动规用不着）
            problem='TSP';
            
            cx=obj.Data.cx;
            cy=obj.Data.cy;
            n=size(cx,2);
            
            dis=zeros(n);   % 初始化两个城市的距离矩阵全为0
            for i=2:n    %i从2开始，是因为他与他自己的距离是0
                for j=1:i
                    dis(i,j) = sqrt((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2);   % 计算城市i和j的距离
                end
            end
            dis = dis+dis';   % 生成对称完整的距离矩阵
            
            [m,n] = size(dis); %dp表，n行, stateNum列
            stateNum = bitshift(1,n-1); %dp表列数为C（n-1）1+...+C（n-1）（n-1）+空集的1
            dp = zeros(n,stateNum);
            path={};
            % 提前循环初始化为inf
            for i=1:n
                for j=1:stateNum
                    dp(i,j)=inf;
                end
            end
            
            for i=1:n
                dp(i,1)=dis(i,1);
                path(i,1)={1};
            end
            
            for j=1:stateNum-1
                for i=0:n-1 %这个i不仅代表城市号，还代表第i次迭代
                    if  i==0 || bitand(bitshift(j,-(i-1)),1)==0   %找没去过的
                        for k=0:n-1
                            if k==0 || bitand(bitshift(j,-(k-1)),1)==1
                                %如果j的第k位为1，即j中有k这个城市
                                
                                if dp(i+1,j+1)>dis(k+1,i+1)+dp(k+1,bitxor(j,(bitshift(1,k-1)))+1)
                                    dp(i+1,j+1) = dis(k+1,i+1)+dp(k+1,bitxor(j,(bitshift(1,k-1)))+1);
                                    path(i+1,j+1)= {[k+1 path(k+1,bitxor(j,(bitshift(1,k-1)))+1)]};
                                end
                            end
                            
                        end
                    end
                end
            end
            objVal=dp(1,stateNum);
            route=[];
            a=path{1,stateNum};
            for z=1:n-1
                route=[route a{1,1}];
                a=a{1,2};
            end
            route=[1 route 1];
            xi=route(1,1:n);
            xj=route(1,2:n+1);
            %             t2=clock;
            %             t=etime(t2,t1);
            %             if t>timeLim
            if obj.is_stop()==true
                objVal=0;
                xi=0;
                xj=0;
            end
            %0表示程序没跑完
            %             end
            
            obj.Data.problem=problem;
            obj.Data.n=n;
            obj.Data.cx=cx;
            obj.Data.cy=cy;
            obj.Data.dis=dis;
            obj.Data.xi=xi;
            obj.Data.xj=xj;
            obj.Data.objVal=objVal;
            obj.Data.timeLim=timeLim;
            obj.Data.iterations=iterations;
            obj.Data.iterator=iterator;
        end
    end
end
