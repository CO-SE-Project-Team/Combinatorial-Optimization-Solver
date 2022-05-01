% CLASS ALGORITHM CREATED
classdef  ALGORITHM < handle
    properties
        Data;
        timeEditField;
        iterEditField;
        objValEidtField;
        UIAxes_objVal;
        startTime;
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
        end
        function [bool]=is_stop(obj)
            obj.endTime=clock;
            deltaT=etime(obj.endTime,obj.startTime);
            if deltaT>timeLim && obj.Data.iterator> obj.Data.iterations %iterator+=1需要算法在循环中补充
                bool=true;
            else
                bool=false;
            end
        end
    end
end