classdef DisplacementComputer < handle

    properties(SetAccess = private, GetAccess = public)
        displacement
    end
    
    properties(Access = private)
        F, K
        solvertype
        boundaryConditions
    end
    
    methods(Access = public)

        function obj = DisplacementComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.calculateFreeDisplacement();
            obj.calculateFixedDisplacement();
        end

    end
    
    methods(Access = private)

        function init(obj, cParams)
            obj.K          = cParams.K;
            obj.F          = cParams.F;
            obj.solvertype = cParams.solvertype;
            obj.boundaryConditions = cParams.boundaryConditions;
        end

        function calculateFreeDisplacement(obj)
            freeDOFs = obj.boundaryConditions.freeDOFs;
            solver = Solver.create(obj.solvertype);
            solution = solver.solve(obj.K, obj.F);
            obj.displacement(freeDOFs,1) = solution;
        end

        function calculateFixedDisplacement(obj)
            fixedDOFs = obj.boundaryConditions.fixedDOFs;
            fixedDisp = obj.boundaryConditions.fixedDisp;
            obj.displacement(fixedDOFs,1) = fixedDisp;
        end

    end
end