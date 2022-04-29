classdef Test
    properties(SetAccess = private)
        a;
        b;
        c;
    end

    methods
        function obj = Test()
            obj.a = 1;
            obj.b = 2;
            obj.c = 3;
        end

        function draw()
%             app.Lamp = [1,0,1];
        end
    end

end