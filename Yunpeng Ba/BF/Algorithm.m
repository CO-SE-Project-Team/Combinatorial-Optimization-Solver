classdef Algorithm
    properties
        data
    end
    methods
        function [obj]=Algorithm()
        end
        function [obj]=solve(obj)
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
