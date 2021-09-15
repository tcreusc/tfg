classdef DisplacementComputer < handle

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
    end
    
    methods(Access = public)
        
        function obj = DisplacementComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.splitDOFMatrices();
            obj.calculateSystemLHSRHS();
            obj.calculateSystemSolution();
            obj.calculateDisplacement();    
        end
    end
    
    methods(Access = private)   
        
        function init(obj, cParams)
            obj.KGlobal    = cParams.KGlobal;
            obj.Fext       = cParams.Fext;
            obj.solvertype = cParams.solvertype;
            obj.dim        = cParams.dim;
            obj.data       = cParams.data;
        end
        
        function splitDOFMatrices(obj)
            s.dim         = obj.dim;
            s.data.fixnod = obj.data.fixnod;
            DOFfixer = DOFFixer(s);
            DOFfixer.fix();
            obj.ur = DOFfixer.ur;
            obj.vr = DOFfixer.vr;
            obj.vl = DOFfixer.vl;
        end
        
        function calculateSystemLHSRHS(obj)
            KLL = obj.KGlobal(obj.vl, obj.vl);
            KLR = obj.KGlobal(obj.vl, obj.vr);
            FLext = obj.Fext(obj.vl,1);        
            obj.LHS = FLext - KLR*obj.ur;
            obj.RHS = KLL; 
        end
        
        function calculateSystemSolution(obj)
            solver = Solver.create(obj.solvertype);
            solution = solver.solve(obj.RHS, obj.LHS);
            obj.ul = solution;
        end
        
        function calculateDisplacement(obj)
            obj.u(obj.vl,1) = obj.ul;
            obj.u(obj.vr,1) = obj.ur;
        end
        
    end
end