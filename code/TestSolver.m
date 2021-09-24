classdef TestSolver < handle
    
    properties(SetAccess = protected, GetAccess = public)
        solucio
    end
    
    properties(Access = protected)
        expectedResults
    end
    
    methods(Access = public)
        function obj = TestSolver()
        end
        
        function check(obj, results)
        end
    end
    
    methods (Static)
            
    end
    
    methods(Access = private)
    end
    
end