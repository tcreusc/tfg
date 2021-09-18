classdef Analysis < handle % potser reanomenar
    
    properties(SetAccess = private, GetAccess = public)
        displacement
    end
    
    properties(Access = private)
        dataFile
        data
        solvertype
        connectivities
        KElem, KGlobal, Fext
        ur, vr, vl
        Fx, Fy, Mz
        dim
    end
    
    methods(Access = public)
        
        function obj = Analysis(cParams)
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
            s.dim  = obj.dim;
            s.data = obj.data;
            s.connectivities   = obj.connectivities;
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
        
        function computeDisplacements(obj)
            s.KGlobal    = obj.KGlobal;
            s.Fext       = obj.Fext;
            s.solvertype = obj.solvertype;
            s.dim        = obj.dim;
            s.data       = obj.data;
            DC = DisplacementComputer(s);
            DC.compute();
            obj.displacement = DC.displacement;
        end
        
        function computeStress(obj)
            s.dim   = obj.dim;
            s.data  = obj.data;
            s.displacement     = obj.displacement;
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