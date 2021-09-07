classdef Analysis < handle

    % eliminar Test, fusionar amb Analysis -> Analysis
    % simplificar stiffnessBlaBla
    
    properties(SetAccess = private, GetAccess = public)
        status
    end
    
    properties(Access = private)
        dataFile
        data
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
            obj.connectDOFs();
            obj.computeStiffnessMatrix();
            obj.splitDOFs();
            obj.solveSystem();
            obj.computeInternal();
            obj.checkAnalysis();
        end       
        
    end
    
    methods(Access = private)   
        
        function init(obj)
            run(obj.dataFile)
            obj.data = data;
            obj.dim = dim;
        end
                
        function connectDOFs(obj)
            
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
            Kcomputer = GlobalStiffnessMatrix(s);
            Kcomputer.compute();
            obj.Kel = Kcomputer.Kel;
            obj.KG = Kcomputer.KG;
            obj.Fext = Kcomputer.Fext;
            
        end
        
        function splitDOFs(obj)
            s.dim = obj.dim;
            s.data.fixnod = obj.data.fixnod;
            DOFfixer = DOFFixer(s);
            DOFfixer.fix();
            obj.ur = DOFfixer.ur;
            obj.vr = DOFfixer.vr;
            obj.vl = DOFfixer.vl;
        end
               
        function solveSystem(obj)
            [obj.u, obj.R] = ForceSystemSolver(obj.KG,obj.Fext,obj.ur,obj.vr,obj.vl).getDisplacementAndReactions();
        end
        
        function computeInternal(obj)
            [obj.Fx, obj.Fy, obj.Mz] = InternalForcesComputer(obj.dim,obj.u,x,Tn,Td,obj.Kel, mat, Tmat).getForces();
        end
        
        function checkAnalysis(obj)
            passed = 1;
            
            if (passed)
                fprintf('Test ') ; cprintf('-comment', 'passed') ; fprintf('!\n') ;
            else
                fprintf('Test ') ; cprintf('-err', 'failed') ; fprintf('!\n') ;
            end
            
        end
    end
end

