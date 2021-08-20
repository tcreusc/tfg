%% Funció solveSystem(KG,Fext,ur,vr,vl)
% Soluciona el sistema, i retorna una matriu amb el desplacament de cada
% DOF, i una matriu amb les forces de reaccio
classdef ForceSystemSolver < handle

    properties(SetAccess = private, GetAccess = public)
        u, R
    end
    
    properties(Access = private)
        sistema, ul
    end
    
    methods(Access = public)
        
        function obj = ForceSystemSolver(KG,Fext,ur,vr,vl)
            obj.sistema = ForceSystemLHSRHS(KG, ur, vl, vr, Fext);
            obj.calculateSystemSolution();
            obj.calculateDisplacementAndReactions(vr, vl, ur);
        end

        function [u, R] = getDisplacementAndReactions(obj)
            u = obj.u;
            R = obj.R;
        end
        
    end
    
    methods(Access = private)   
        
        function calculateSystemSolution(obj)
            [LHS,RHS] = obj.sistema.getLHSRHS();
            solver = IterativeSolver(LHS, RHS); 
            obj.ul = solver.solucio;
        end
        
        function calculateDisplacementAndReactions(obj, vr, vl, ur)
            [KRL, KRR, FRext] = obj.sistema.getDisplacementData();
            obj.R = KRR * ur + KRL*obj.ul-FRext;
            obj.u(vl,1) = obj.ul;
            obj.u(vr,1) = ur;
        end
        
    end
end