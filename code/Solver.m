classdef (Abstract) Solver < handle
    
    properties(SetAccess = protected, GetAccess = public)
        solucio
    end
    
    properties(Access = protected)
        LHS, RHS
    end
    
    methods(Access = public)
        function obj = Solver(LHS,RHS)
            obj.LHS = LHS;
            obj.RHS = RHS;
            obj.calculateSolution();
        end
    end
    
    methods(Access = protected)
         function calculateSolution(obj)
            % A definir per cadascun dels solvers
        end
    end
    
    % funcio estatica create
    % switch cparams.type
    % case 'iterative'
    %
end

