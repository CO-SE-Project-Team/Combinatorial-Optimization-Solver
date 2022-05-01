classdef TestClass < handle
    %TESTCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
        TestProperty
        a
        b
    end
    
    methods
        function obj = TestClass(inputArg1,inputArg2)
            %TESTCLASS Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end

        function set_ab(obj,a,b)
            obj.a = a;
            obj.b = b;
        end

        function a = get_a(obj)
            a = obj.a;
        end

    end
end

