classdef IterativeSolver < Solver
    methods(Access = protected)    
        function calculateSolution(obj)
            obj.solucio = pcg(obj.RHS,obj.LHS,[],1000);
        end
    end
end

