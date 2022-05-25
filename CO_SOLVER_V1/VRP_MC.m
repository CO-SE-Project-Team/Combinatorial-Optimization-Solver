classdef  VRP_MC < ALGORITHM
    methods
        function solve(obj)
            problem = obj.Data.problem;
            n = obj.Data.n;
            capacity = obj.Data.capacity;
            demand = obj.Data.demand;
            cx = obj.Data.cx;
            cy = obj.Data.cy;

            % compute dis matrix
            n = size(cx,2);
            dis=zeros(n);
            for i=2:n 
                for j=1:i
                    dis(i,j) = sqrt(double((cx(i)-cx(j))^2 + (cy(i)-cy(j))^2));
                end
            end
            dis = dis + dis';

            while obj.is_stop() == false
                clientsPool = linspace(2, n, n-1);
                sequence = [1];
                objVal = 0;
                for i = 1:size(clientsPool,2)
                    index = randi(size(clientsPool,2));
                    objVal = objVal + dis

                end

                obj.Data.xi=sequence(1,size(sequence,2)-1);
                obj.Data.xj=sequence(2,size(sequence,2));
                obj.Data.objVal=objVal;
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
            end
            
            obj.Data.xi = r(1, 1:size(r,2)-1);
            obj.Data.xj = r(1, 2:size(r,2));
            obj.Data.objVal = minDis;
            obj.Data.n = n;
            obj.Data.distance = dis;

            % obj.start_clock();
            % while (obj.is_stop() == false)

            %     obj.Data.iterator = obj.Data.iterator + 1;
            % end
        end     
    end
end