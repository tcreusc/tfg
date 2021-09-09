%% Funció solveSystem(KG,Fext,ur,vr,vl)
% Soluciona el sistema, i retorna una matriu amb el desplacament de cada
% DOF, i una matriu amb les forces de reaccio

classdef ForceSystemSolver < handle

    properties(SetAccess = private, GetAccess = public)
        u, R
    end
    
    properties(Access = private)
        solvertype
        KG
        Fext
        ur, vr, vl
        ul
        LHS, RHS
        KRL, KRR, FRext
    end
    
    methods(Access = public)
        
        function obj = ForceSystemSolver(cParams)
            obj.init(cParams);
        end

        function obj = solve(obj)
            obj.calculateLHSRHS();
            obj.calculateSystemSolution();
            obj.calculateDisplacementAndReactions();    
        end
        
    end
    
    methods(Access = private)   
        
        function init(obj, cParams)
            obj.KG = cParams.KG;
            obj.Fext = cParams.Fext;
            obj.ur = cParams.ur;
            obj.vr = cParams.vr;
            obj.vl = cParams.vl;
            obj.solvertype = cParams.solvertype;
        end
        
        function calculateLHSRHS(obj)
            KLL = obj.KG(obj.vl, obj.vl);
            KLR = obj.KG(obj.vl, obj.vr);
            FLext = obj.Fext(obj.vl,1);
            obj.KRL = obj.KG(obj.vr, obj.vl);
            obj.KRR = obj.KG(obj.vr, obj.vr);
            obj.FRext = obj.Fext(obj.vr,1);
            
            obj.LHS = FLext - KLR*obj.ur;
            obj.RHS = KLL;  
        end
        
        function calculateSystemSolution(obj)
            
            solver = Solver.create(obj.solvertype);
            solution = solver.solve(obj.RHS, obj.LHS);
            obj.ul = solution;
            
        end
        
        function calculateDisplacementAndReactions(obj)
            obj.R = obj.KRR * obj.ur + obj.KRL*obj.ul - obj.FRext;
            obj.u(obj.vl,1) = obj.ul;
            obj.u(obj.vr,1) = obj.ur;
        end
        
    end
end