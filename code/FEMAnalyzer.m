classdef FEMAnalyzer < handle
    
    properties(SetAccess = private, GetAccess = public)
        displacement
    end
    
    properties(Access = private)
        data
        solvertype
        connectivities
        K, KElem, KGlobal
        F, Fext
        Fx, Fy, Mz
        dim
        boundaryConditions 
    end
    
    methods(Access = public)
        
        function obj = FEMAnalyzer(cParams)
            obj.init(cParams);
        end

        function obj = perform(obj)  
            obj.computeConnectivities();
            obj.computeStiffnessMatrix();
            obj.computeForces();
            obj.applyBoundaryConditions();
            obj.computeDisplacements();
            obj.computeStress();
        end  

    end
    
    methods(Access = public)
        function obj = compute(obj)
            obj.perform();
        end
    end
    
    methods(Access = private)   
        
        function init(obj, cParams)
            obj.data       = cParams.data;
            obj.dim        = cParams.dim;
            obj.solvertype = cParams.solvertype;
        end

        function computeConnectivities(obj)
            nel = obj.dim.nel;
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            T = zeros(nel,nne*ni);
            for e = 1:nel
                for i = 1:nne
                    for j = 1:ni
                        I = ni*(i-1)+j;
                        Tn = obj.data.Tn(e,i);
                        T(e,I) = ni*(Tn-1)+j;
                    end
                end
            end
            obj.connectivities = T;
        end
        
        function computeStiffnessMatrix(obj)
            s.dim            = obj.dim;
            s.data           = obj.data;
            s.connectivities = obj.connectivities;
            KComp = StiffnessMatrixComputer(s);
            KComp.compute();
            obj.KElem   = KComp.KElem;
            obj.KGlobal = KComp.KGlobal;
        end
        
        function computeForces(obj)
            s.dim  = obj.dim;
            s.data = obj.data;
            FC = ForcesComputer(s);
            FC.compute();
            obj.Fext = FC.Fext;
        end

        function applyBoundaryConditions(obj)
            s.dim         = obj.dim;
            s.Fext        = obj.Fext;
            s.KGlobal     = obj.KGlobal;
            s.data.fixnod = obj.data.fixnod;
            BCA = BoundaryConditionsApplier(s);
            obj.boundaryConditions.fixedDisp = BCA.fixedDisp;
            obj.boundaryConditions.fixedDOFs = BCA.fixedDOFs;
            obj.boundaryConditions.freeDOFs  = BCA.freeDOFs;
            obj.K = BCA.calculateFreeStiffnessMatrix();
            obj.F = BCA.calculateForceMatrix();
        end

        function computeDisplacements(obj)
            s.K                  = obj.K;
            s.F                  = obj.F;
            s.solvertype         = obj.solvertype;
            s.boundaryConditions = obj.boundaryConditions;
            DC = DisplacementComputer(s);
            DC.compute();
            obj.displacement = DC.displacement;
        end
        
        function computeStress(obj)
            s.dim            = obj.dim;
            s.data           = obj.data;
            s.displacement   = obj.displacement;
            s.connectivities = obj.connectivities;
            s.KElem = obj.KElem;
            SC = StressComputer(s);
            SC.compute();
            obj.Fx = SC.Fx;
            obj.Fy = SC.Fy;
            obj.Mz = SC.Mz;
        end
        
    end
end