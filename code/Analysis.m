classdef Analysis < handle
    
    properties(SetAccess = private, GetAccess = public)
        displacement
    end
    
    properties(Access = private)
        dataFile
        data
        solvertype
        Td
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
            obj.computeMesh();
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
                
        function computeMesh(obj)
            nel = obj.dim.nel;
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            vTd = zeros(nel,nne*ni);
            for e = 1:nel
                for i = 1:nne
                    for j = 1:ni
                        I = ni*(i-1)+j;
                        vTd(e,I) = obj.dim.ni*(obj.data.Tn(e,i)-1)+j;
                    end
                end
            end
            obj.Td = vTd;
        end
        
        function computeStiffnessMatrix(obj)
            s.dim  = obj.dim;
            s.data = obj.data;
            s.Td   = obj.Td;
            GSMComp = GlobalStiffnessMatrixComputer(s);
            GSMComp.compute();
            obj.KElem   = GSMComp.KElem;
            obj.KGlobal = GSMComp.KGlobal;
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
            s.u     = obj.displacement;
            s.Td    = obj.Td;
            s.KElem = obj.KElem;
            SC = StressComputer(s);
            SC.compute();
            obj.Fx = SC.Fx;
            obj.Fy = SC.Fy;
            obj.Mz = SC.Mz;
        end 
    end
end

