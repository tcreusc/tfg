classdef DisplacementComputer < handle

    properties(SetAccess = private, GetAccess = public)
        displacement
    end
    
    properties(Access = private)
        solvertype
        dim
        data
        KGlobal
        Fext
        ur, vr, vl
        ul
        F, K
    end
    
    methods(Access = public)

        function obj = DisplacementComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.reduceStiffnessMatrix(); % repassar nom
            obj.calculateFreeStiffnessMatrix();
            obj.calculateForceMatrix();
            obj.calculateFreeDisplacement();
            obj.imposeFixedDisplacement();
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

        function reduceStiffnessMatrix(obj)
            s.dim         = obj.dim;
            s.data.fixnod = obj.data.fixnod;
            DOFfixer = DOFFixer(s);
            DOFfixer.fix();
            obj.ur = DOFfixer.ur;
            obj.vr = DOFfixer.vr;
            obj.vl = DOFfixer.vl;
        end

        function calculateFreeStiffnessMatrix(obj)
            KLL   = obj.KGlobal(obj.vl, obj.vl);
            obj.K = KLL; 
        end

        function calculateForceMatrix(obj)
            KLR   = obj.KGlobal(obj.vl, obj.vr);
            FLext = obj.Fext(obj.vl,1);
            obj.F = FLext - KLR*obj.ur;
        end

        function calculateFreeDisplacement(obj)
            solver = Solver.create(obj.solvertype);
            solution = solver.solve(obj.K, obj.F);
            obj.displacement(obj.vl,1) = solution;
        end

        function imposeFixedDisplacement(obj)
            obj.displacement(obj.vr,1) = obj.ur;
        end

    end
end