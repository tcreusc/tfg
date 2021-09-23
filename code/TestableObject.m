classdef (Abstract) TestableObject < handle
    
    properties(SetAccess = protected, GetAccess = public)
        
    end
    
    properties(Access = protected)
    end
    
%     methods(Access = public)
%     end
    
    methods(Access = public)
         function obj = compute(obj)
            % A definir per cadascun dels solvers
        end
    end

end