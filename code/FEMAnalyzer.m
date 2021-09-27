classdef FEMAnalyzer < handle
    
    properties(SetAccess = private, GetAccess = public)
        displacement
    end
    
    properties(Access = private)
        data
        DOFManager
        solvertype
        connectivities
        K, KElem, KGlobal
        F, Fext
        Fx, Fy, Mz
        dim
    end
    
    methods(Access = public)
        
        function obj = FEMAnalyzer(cParams)
            obj.init(cParams);
        end

        function obj = perform(obj)     
            obj.computeConnectivities();
            obj.computeStiffnessMatrix();
            obj.computeForces();
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
            obj.createDOFManager();
        end

        function createDOFManager(obj)
            s.dim         = obj.dim;
            s.data.fixnod = obj.data.fixnod;
            DOFMgr = DOFManager(s);
            DOFMgr.fix();
            obj.DOFManager = DOFMgr;
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
            s.DOFManager     = obj.DOFManager;
            s.connectivities = obj.connectivities;
            KComp = StiffnessMatrixComputer(s);
            KComp.compute();
            obj.KElem   = KComp.KElem;
            obj.KGlobal = KComp.KGlobal;
            obj.K = KComp.calculateFreeStiffnessMatrix();
        end
        
        function computeForces(obj)
            s.dim        = obj.dim;
            s.data       = obj.data;
            s.KGlobal    = obj.KGlobal;
            s.DOFManager = obj.DOFManager;
            FC = ForcesComputer(s);
            FC.compute();
            obj.Fext = FC.Fext;
            obj.F = FC.F;
        end
        
        function computeDisplacements(obj)
            s.K          = obj.K;
            s.F          = obj.F;
            s.solvertype = obj.solvertype;
            s.DOFManager = obj.DOFManager;
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