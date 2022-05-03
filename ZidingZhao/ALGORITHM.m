% CLASS ALGORITHM CREATED
classdef  ALGORITHM < handle
    properties
        Data;

        iter = 0;
        objVals; % save objVal for all iterations.

        timeEditField;
        iterEditField;
        objValEidtField;
        UIAxes_objVal;
        UIAxes_Result;
        guiSetted = false;

        startTime;
        midStartTime;
        endTime;
    end

    methods
        function obj = ALGORITHM()
        end

        % IMPLEMENT YOUR ALGORITHM FOR THIS FUNCITON
        % function solve(obj)
        %     % YOUR SOLVE FUNCITON, IMPLEMENT THIS FUNCITON
        % end

        function set_Data(obj, Data)
            obj.Data = Data;
            % obj.objVals = zeros(1,obj.Data.iterations);
        end

        function Data = get_Data(obj)
            Data = obj.Data;
        end

        function Data = get_solved_Data(obj, Data)
            obj.Data = Data;
            obj.solve();
            Data = obj.get_Data();
        end

        % FOLLOWING FUNCTIONS/METHODS ARE NOT NEEDED FOR INITIAL VERSIONS
        % function pause(obj)
        % end

        % function resume(obj)
        % end

        function set_all(obj, problem, n, capacity, demand, cx, cy, timeLim, iterations)
            obj.Data.problem = problem;
            obj.Data.n = n;
            obj.Data.capacity = capacity;
            obj.Data.demand = demand;
            obj.Data.cx = cx;
            obj.Data.cy = cy;
            obj.Data.timeLim = timeLim;
            obj.Data.iterations = iterations;
        end

        function set_problem(obj, problem)
            obj.Data.problem = problem;
        end
        function problem = get_problem(obj)
            problem = obj.Data.problem;
        end

        function set_n(obj, n)
            obj.Data.n = n;
        end
        function n = get_n(obj)
            n = obj.Data.n;
        end

        function set_capacity(obj, capacity)
            obj.Data.capacity = capacity;
        end
        function capacity = get_capacity(obj)
            capacity = obj.Data.capacity;
        end

        function set_demand(obj,demand)
            obj.Data.demand =demand;
        end
        function demand = get_demand(obj)
            demand = obj.Data.demand;
        end

        function set_cx(obj,cx)
            obj.Data.cx =cx;
        end
        function cx = get_cx(obj)
            cx = obj.Data.cx;
        end

        function set_cy(obj,cy)
            obj.Data.cy =cy;
        end
        function cy = get_cy(obj)
            cy = obj.Data.cy;
        end

        function set_timeLim(obj,timeLim)
            obj.Data.timeLim =timeLim;
        end
        function timeLim = get_timeLim(obj)
            timeLim = obj.Data.timeLim;
        end

        function set_iterations(obj,iterations)
            obj.Data.iterations =iterations;
        end
        function iterations = get_iterations(obj)
            iterations = obj.Data.iterations;
        end

        function iterator = get_iterator(obj)
            iterator = obj.Data.iterator;
        end

        function start_clock(obj)
            obj.startTime=clock;
            obj.midStartTime = clock;
        end
        
        function bool = is_stop(obj)
            obj.iter = obj.iter + 1;
            obj.endTime=clock;
            deltaT=etime(obj.endTime,obj.startTime);
            if (deltaT > obj.Data.timeLim) || (obj.iter > obj.Data.iterations)
                bool=true;
            else
                bool=false;
            end
        end

        function set_GUI(obj, timeEditField, iterEditField, objValEidtField, UIAxes_objVal, UIAxes_Result)
            obj.guiSetted = true;
            obj.timeEditField = timeEditField;
            obj.iterEditField = iterEditField;
            obj.objValEidtField = objValEidtField;
            obj.UIAxes_objVal = UIAxes_objVal;
            obj.UIAxes_Result = UIAxes_Result;
        end

        function update_status_by(obj, objVal, xi, xj)
            if obj.guiSetted == true % to exclude condition of running from command line.
                obj.objVals = [obj.objVals, objVal];
                if etime(clock, obj.midStartTime) > 0.5
                    % print time
                    disp(['Message: Time elapsed: ',num2str(etime(clock, obj.startTime)), ' iter: ', num2str(obj.iter), ' objVal: ', num2str(objVal)]);

                    % gui time, iterator, objVal
                    obj.timeEditField.Value = num2str(etime(clock, obj.startTime));
                    obj.iterEditField.Value = num2str(size(obj.objVals,2));
                    obj.objValEidtField.Value = num2str(objVal);

                    % plot UIAxes_objVal by linspace & objVals
                    cla(obj.UIAxes_objVal);
                    plot(obj.UIAxes_objVal, linspace(1,size(obj.objVals,2),size(obj.objVals,2)), obj.objVals);

                    % plot result coordinates
                    cla(obj.UIAxes_Result);
                    hold(obj.UIAxes_Result,'on');
                    G = graph(xi,xj);
                    plot(obj.UIAxes_Result,G,'XData',obj.Data.cx,'YData',obj.Data.cy,'NodeFontSize',5);
                    scatter(obj.UIAxes_Result,obj.Data.cx(1),obj.Data.cy(1),50,'red','filled','s');
                    scatter(obj.UIAxes_Result,obj.Data.cx(2:end),obj.Data.cy(2:end),20,'blue','filled');
                    % text(obj.UIAxes_Result, obj.Data.cx(2:end), obj.Data.cy(2:end)+1, cellstr(num2str(obj.Data.demand(2:end)')),'Fontsize', 14); % 0.5 for a step
                    
                    drawnow();
                    pause(0.01);
                    obj.midStartTime = clock;
                end
            end
        end

        function update_status(obj)
            if obj.guiSetted == true  % to exclude condition of running from command line.
                obj.objVals = [obj.objVals, obj.Data.objVal];
                if etime(clock, obj.midStartTime) > 0.5
                    % print time
                    disp(['Message: Time elapsed: ',num2str(etime(clock, obj.startTime)), ' iter: ', num2str(obj.iter), ' objVal: ', num2str(objVal)]);

                    % gui time, iterator, objVal
                    obj.timeEditField.Value = num2str(etime(clock, obj.startTime));
                    obj.iterEditField.Value = num2str(size(obj.objVals,2));
                    obj.objValEidtField.Value = num2str(obj.Data.objVal);

                    % plot objVal by linspace & objVals
                    cla(obj.UIAxes_objVal);
                    plot(obj.UIAxes_objVal, linspace(1,size(obj.objVals,2),size(obj.objVals,2)), obj.objVals);

                    % plot result coordinates
                    cla(obj.UIAxes_Result);
                    hold(obj.UIAxes_Result,'on');
                    G = graph(obj.Data.xi,obj.Data.xj);
                    plot(obj.UIAxes_Result,G,'XData',obj.Data.cx,'YData',obj.Data.cy,'NodeFontSize',5);
                    scatter(obj.UIAxes_Result,obj.Data.cx(1),obj.Data.cy(1),50,'red','filled','s');
                    scatter(obj.UIAxes_Result,obj.Data.cx(2:end),obj.Data.cy(2:end),20,'blue','filled');
                    % text(obj.UIAxes_Result, obj.Data.cx(2:end), obj.Data.cy(2:end)+1, cellstr(num2str(obj.Data.demand(2:end)')),'Fontsize', 14); % 0.5 for a step
                    
                    drawnow();
                    pause(0.01);
                    obj.midStartTime = clock;
                end
            end
        end
    end
end