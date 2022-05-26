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

            bestSequence = []; % record bestSequence
            bestObjVal = Inf; % record bestObjVal
            % for one possible solution
            while obj.is_stop() == false
                clients = linspace(2, n, n-1); % clients that haven't been delivered
                sequence = [1]; % sequence for this solution, starting from depot 1.
                objVal = 0; % objVal for this objVal
                
                truckLoad = capacity; % full load
                % while there are clients that haven't been delivered.
                while size(clients,2) ~= 0
                    % find out possibleClients
                    possibleClients = []; % the possibleClients that truck can go next
                    for i = 1:size(clients,2) % for every clients
                        if demand(clients(i)) <= truckLoad % if truck can satisfy this client
                            possibleClients(end+1) = clients(i); % add to possible 
                        end
                    end
                    if size(possibleClients,2) == 0 % no clients are possible to satisfied
                        objVal = objVal + dis(sequence(end),1);
                        sequence(end+1) = 1; % go back to depot
                        truckLoad = capacity; % fill full of items.
                        continue; % ready to go to clients
                    end

                    randomIndex = randi(size(possibleClients,2)); % random select a possibleClient
                    objVal = objVal + dis(sequence(end),possibleClients(randomIndex)); % update objVal
                    sequence(end+1) = possibleClients(randomIndex); % add to sequence
                    truckLoad = truckLoad - possibleClients(randomIndex); % move items out of the truck
                    clients(randomIndex) = []; % delete this client out of the clients
                end

                if objVal < bestObjVal
                    bestObjVal = objVal;
                    bestSequence = sequence;

                    obj.Data.xi=bestSequence(1:size(bestSequence,2)-1);
                    obj.Data.xj=bestSequence(2:size(bestSequence,2));
                    obj.Data.objVal=bestObjVal;
                end

                % update_status_by() to GUI
                obj.update_status_by(obj.Data.objVal,obj.Data.xi,obj.Data.xj);
            end
            
            obj.Data.objVal = bestObjVal;
            obj.Data.xi = bestSequence(1:size(bestSequence,2)-1);
            obj.Data.xj = bestSequence(2:size(bestSequence,2));
            obj.Data.distance = dis;
        end     
    end
end