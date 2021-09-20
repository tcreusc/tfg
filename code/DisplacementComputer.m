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
        fixedDisp, fixedDOFs, freeDOFs
        ul
        F, K
    end
    
    methods(Access = public)

        function obj = DisplacementComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.reduceStiffnessMatrix();
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
            obj.fixedDisp = DOFfixer.fixedDisp;
            obj.fixedDOFs = DOFfixer.fixedDOFs;
            obj.freeDOFs  = DOFfixer.freeDOFs;
        end

        function calculateFreeStiffnessMatrix(obj)
            KLL   = obj.KGlobal(obj.freeDOFs, obj.freeDOFs);
            obj.K = KLL; 
        end

        function calculateForceMatrix(obj)
            KLR   = obj.KGlobal(obj.freeDOFs, obj.fixedDOFs);
            FLext = obj.Fext(obj.freeDOFs,1);
            obj.F = FLext - KLR*obj.fixedDisp;
        end

        function calculateFreeDisplacement(obj)
            solver = Solver.create(obj.solvertype);
            solution = solver.solve(obj.K, obj.F);
            obj.displacement(obj.freeDOFs,1) = solution;
        end

        function imposeFixedDisplacement(obj)
            obj.displacement(obj.fixedDOFs,1) = obj.fixedDisp;
        end

    end
end