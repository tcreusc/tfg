classdef (Abstract) TestableObject < handle
    
    properties(SetAccess = protected, GetAccess = public)
        
    end
    
    properties(Access = protected)
    end
    
    methods(Access = public)
    end
    
    methods(Access = protected)
         function compute(obj)
            % A definir per cadascun dels solvers
        end
    end

end