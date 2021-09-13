%% Funció solveSystem(KGlobal,Fext,ur,vr,vl)
% Soluciona el sistema, i retorna una matriu amb el desplacament de cada
% DOF, i una matriu amb les forces de reaccio

classdef ForcesComputer < handle

    % ForcesComputer
    % DisplacementComputer
    properties(SetAccess = private, GetAccess = public)
        u, R
    end
    
    properties(Access = private)
        solvertype
        dim
        data
        KGlobal
        Fext
        ur, vr, vl
        ul
        LHS, RHS
        KRL, KRR, FRext
    end
    
    methods(Access = public)
        
        function obj = ForcesComputer(cParams)
            obj.init(cParams);
        end

        function obj = solve(obj)
            obj.splitDOFs();
            obj.calculateLHSRHS();
            obj.calculateSystemSolution();
            obj.calculateDisplacementAndReactions();    
        end
    end
    
    methods(Access = private)   
        
        function init(obj, cParams)
            obj.KGlobal = cParams.KGlobal;
            obj.Fext = cParams.Fext;
            obj.solvertype = cParams.solvertype;
            obj.dim = cParams.dim;
            obj.data = cParams.data;
        end
        
        function splitDOFs(obj) % fusionar-ho amb solvesyst i reanoenar
            s.dim = obj.dim;
            s.data.fixnod = obj.data.fixnod;
            DOFfixer = DOFFixer(s);
            DOFfixer.fix();
            obj.ur = DOFfixer.ur;
            obj.vr = DOFfixer.vr;
            obj.vl = DOFfixer.vl;
        end
        
        function calculateLHSRHS(obj)
            KLL = obj.KGlobal(obj.vl, obj.vl);
            KLR = obj.KGlobal(obj.vl, obj.vr);
            FLext = obj.Fext(obj.vl,1);        
            obj.LHS = FLext - KLR*obj.ur;
            obj.RHS = KLL;
            
            obj.KRL = obj.KGlobal(obj.vr, obj.vl); % es pot moure a sota
            obj.KRR = obj.KGlobal(obj.vr, obj.vr);
            obj.FRext = obj.Fext(obj.vr,1);            
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