classdef IterativeSolver < Solver
    
    methods (Static)
        function solucio = solve(RHS, LHS)
            solucio = pcg(RHS,LHS,[],1000);
        end
    end
    
end

