classdef Analysis < handle
    
    properties(SetAccess = private, GetAccess = public)
        passed
    end
    
    properties(Access = private)
        dataFile
        data
        solvertype
        results
        Td
        KElem, KGlobal, Fext
        ur, vr, vl, u
        Fx, Fy, Mz
        R
        dim
    end
    
    methods(Access = public)
        
        function obj = Analysis(dataFile)
            obj.dataFile  = dataFile;
            obj.init();
        end

        function obj = perform(obj)
            obj.computeMesh();
            obj.computeStiffnessMatrix();
            obj.computeForces();
            obj.computeDisplacements();
            obj.computeStress();
        end  
        
        function check(obj)
            tolerance = 1e15*eps(min(abs(obj.results),abs(obj.u)));
            if abs(obj.results-obj.u) < tolerance
                obj.passed = 1;
                fprintf('Test ') ; cprintf('-comment', 'passed') ; fprintf('!\n') ;
            else
                obj.passed = 0;
                fprintf('Test ') ; cprintf('-err', 'failed') ; fprintf('!\n') ;
            end
        end
    end
    
    methods(Access = private)   
        
        function init(obj)
            run(obj.dataFile)
            obj.data       = data;
            obj.dim        = dim;
            obj.solvertype = solvertype;
            obj.results    = results;
        end
                
        function computeMesh(obj)
            vTd = zeros(obj.dim.nel,obj.dim.nne*obj.dim.ni);
            for e = 1:obj.dim.nel
                for i = 1:obj.dim.nne
                    for j = 1:obj.dim.ni
                        I = obj.dim.ni*(i-1)+j;
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
            GSMComputer = GlobalStiffnessMatrixComputer(s);
            GSMComputer.compute();
            obj.KElem   = GSMComputer.KElem;
            obj.KGlobal = GSMComputer.KGlobal;
        end
        
        function computeForces(obj)
            s.dim  = obj.dim;
            s.data = obj.data;
            FC = ForcesComputer(s);
            FC.compute();
            obj.Fext = FC.Fext;
        end
        
        function computeDisplacements(obj)
            s.KGlobal = obj.KGlobal;
            s.Fext = obj.Fext;
            s.solvertype = obj.solvertype;
            s.dim = obj.dim;
            s.data = obj.data;
            DC = DisplacementComputer(s);
            DC.compute();
            obj.u = DC.u;
            obj.R = DC.R;
        end
        
        function computeStress(obj)
            s.dim = obj.dim;
            s.data = obj.data;
            s.u = obj.u;
            s.Td = obj.Td;
            s.KElem = obj.KElem;
            IFC = InternalForcesComputer(s);
            IFC.compute();
            obj.Fx = IFC.Fx;
            obj.Fy = IFC.Fy;
            obj.Mz = IFC.Mz;
        end
        
    end
end

