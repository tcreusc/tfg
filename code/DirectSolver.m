classdef DirectSolver < Solver
    methods(Access = protected)    
        function calculateSolution(obj)
            obj.solucio = obj.RHS \ obj.LHS;
        end
    end
end

