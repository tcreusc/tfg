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
    end
    
    methods(Access = public)

        function obj = compute(obj)
            obj.reduceStiffnessMatrix();
            obj.calculateFreeStiffnessMatrix();
            obj.calculateForceMatrix();
            obj.calculateFreeDisplacement();
            obj.calculateFixedDisplacement();
        end

    end
    
    methods(Access = private)

        function init(obj, cParams)
            obj.Fext       = cParams.Fext;
            obj.dim        = cParams.dim;
            obj.data       = cParams.data;
            obj.KGlobal    = cParams.KGlobal;
            obj.solvertype = cParams.solvertype;
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
            KG        = obj.KGlobal;
            F_ext	  = obj.Fext;
            freeDOFS  = obj.freeDOFs;
            fixedDOFS = obj.fixedDOFs;
            fixedDis  = obj.fixedDisp;
            KLR   = KG(freeDOFS, fixedDOFS);
            FLext = F_ext(freeDOFS,1);
            obj.F = FLext - KLR*fixedDis;
        end

        function calculateFreeDisplacement(obj)
            solver = Solver.create(obj.solvertype);
            solution = solver.solve(obj.K, obj.F);
            obj.displacement(obj.freeDOFs,1) = solution;
        end

        function calculateFixedDisplacement(obj)
            obj.displacement(obj.fixedDOFs,1) = obj.fixedDisp;
        end

    end
end