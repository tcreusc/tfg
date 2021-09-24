classdef IterativeSolver < Solver
    methods (Static) % marcar-ho com a public
        function solucio = solve(RHS, LHS)
            solucio = pcg(RHS,LHS,[],1000);
        end
    end 
end