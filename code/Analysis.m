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
        Kel, KG, Fext
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

        function [u] = getDisplacements(obj)
            u = obj.u;
        end
                
        function obj = perform(obj)
            obj.connectDOFs(); %computeMesh/Connectivity
            obj.computeStiffnessMatrix();
            obj.splitDOFs();
            obj.solveSystem(); %computeDisplacements
            obj.computeInternal(); %computeStress
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
            obj.data = data;
            obj.dim = dim;
            obj.solvertype = solvertype;
            obj.results = results;
        end
                
        function connectDOFs(obj)
            %computeConnectivityMatr
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
            s.dim = obj.dim;
            s.data = obj.data;
            s.Td = obj.Td;
            Kcomputer = GlobalStiffnessMatrix(s); %GSMComputer
            Kcomputer.compute();
            obj.Kel = Kcomputer.Kel; %KElem
            obj.KG = Kcomputer.KG; %KGlobal
            obj.Fext = Kcomputer.Fext; % fora d'aqui, no hi ha cohesio
        end
        
        function splitDOFs(obj) % fusionar-ho amb solvesyst i reanoenar
            s.dim = obj.dim;
            s.data.fixnod = obj.data.fixnod;
            DOFfixer = DOFFixer(s);
            DOFfixer.fix();
            obj.ur = DOFfixer.ur;
            obj.vr = DOFfixer.vr;
            obj.vl = DOFfixer.vl;
        end
               
        function solveSystem(obj)
            s.KG = obj.KG;
            s.Fext = obj.Fext;
            s.ur = obj.ur;
            s.vr = obj.vr;
            s.vl = obj.vl;
            s.solvertype = obj.solvertype;
            FSS = ForceSystemSolver(s);
            FSS.solve();
            obj.u = FSS.u;
            obj.R = FSS.R;
        end
        
        function computeInternal(obj)
            s.dim = obj.dim;
            s.data = obj.data;
            s.u = obj.u;
            s.Td = obj.Td;
            s.Kel = obj.Kel;
            IFC = InternalForcesComputer(s);
            IFC.compute();
            obj.Fx = IFC.Fx;
            obj.Fy = IFC.Fy;
            obj.Mz = IFC.Mz;
        end
        
    end
end

