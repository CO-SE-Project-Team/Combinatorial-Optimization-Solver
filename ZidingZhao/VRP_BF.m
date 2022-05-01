classdef  VRP_BF < ALGORITHM
    methods
        function solve(obj)
            problem = obj.Data.problem;
            n = obj.Data.n;
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;
            
            if problem == 'VRP'
                n = size(cx,2);
                dis=zeros(n + n - 2);   % 初始化两个城市的距离矩阵全为0
                for i=2:n
                    for j=1:i
                        dis(i,j) = sqrt((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2);   % 计算城市i和j的距离
                    end
                end
                for i = n+1:n+n-2
                    for j = 1:n
                        dis(i,j) = dis(1,j);
                    end
                end
                dis = dis + dis';

                p = linespace(2,n+n-2);
                p = perms(p);

                
            end

            obj.start_clock();
            while (obj.is_stop() == false)

                obj.Data.iterator = obj.Data.iterator + 1;
            end

            obj.Data.n = n;
            obj.Data.distance = dis;
        end     
    end
end