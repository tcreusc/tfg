classdef DirectSolver < Solver
    methods (Static)
        function solucio = solve(RHS, LHS)
            solucio = RHS \ LHS;
        end
    end
end