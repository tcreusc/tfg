classdef Analysis < handle

    % eliminar Test, fusionar amb Analysis -> Analysis
    % simplificar stiffnessBlaBla
    
    properties(SetAccess = private, GetAccess = public)
        
    end
    
    properties(Access = private)
        materialDataFile
        geometricDataFile
        boundaryDataFile
        cParams
        Td
        K
        ur
        vr
        ul
        u
        dim
    end
    
    methods(Access = public)
        
        function obj = Analysis(varMaterialData, varGeometricData, varBoundaryData)
            obj.materialDataFile  = varMaterialData;
            obj.geometricDataFile = varGeometricData;
            obj.boundaryDataFile  = varBoundaryData;
            
            obj.init(cParams);
        end

        function [u] = getDisplacements(obj)
            u = obj.u;
        end
        
        function createAnalysis(obj)
            %loadData
            %create
            %bla 
        end
        
        function perform(obj)
            obj.connectDOFs();
            obj.computeStiffnessMatrix();
            obj.splitDOFs();
            obj.solveSystem();
            obj.computeInternal();
            obj.checkAnalysis();
        end       
        
    end
    
    methods(Access = private)   
        
        function init(obj, cParams)
            obj.cParams = cParams;
        end
        
        function performAnalysis(obj) % 
            run(obj.materialDataFile);
            run(obj.geometricDataFile);
            run(obj.boundaryDataFile);
            
            % ^ loadParams

            %Dimensions
            dim.nd = size(x,2);   % Problem dimension
            dim.nel = size(Tn,1); % Number of elements (bars)
            dim.nnod = size(x,1); % Number of nodes (joints)
            dim.nne = size(Tn,2); % Number of nodes in a bar
            dim.ni = 3;           % Degrees of freedom per node
            dim.ndof = dim.nnod*dim.ni;  % Total number of degrees of freedom
            
            % obj.createDims
            
            %% Solver

%             Td = connectDOF(dim,Tn);
            myglobalFext = globalFext(dim,fdata);
            [Fext,KG] = assemblyK(dim,Kel,Td,myglobalFext);
            [ur,vr,vl] = DOFFixer(dim,fixnod).getDisplacementsAndDOFs();
            [obj.u, R] = ForceSystemSolver(KG,Fext,ur,vr,vl).getDisplacementAndReactions();
            [Fx, Fy, Mz] = InternalForcesComputer(dim,obj.u,x,Tn,Td,Kel, mat, Tmat).getForces();

%             display(Fx)
%             display(Fy)
%             display(Mz)
        end
        
        function connectDOFs(obj, dim, Tn)
            
            vTd = zeros(dim.nel,dim.nne*dim.ni);
            
            for e = 1:dim.nel
                for i = 1:dim.nne
                    for j = 1:dim.ni
                        I = dim.ni*(i-1)+j;
                        vTd(e,I) = dim.ni*(Tn(e,i)-1)+j;
                    end
                end
            end
            
            obj.Td = vTd;
            
        end
        
        function Kel = computeStiffnessMatrix(obj)
            s = 1; 
            Kcomputer = GlobalStiffnessMatrix(s);
            obj.K = Kcomputer.compute();
            
        end
        
        function splitDOFs(obj)
            s = 1;
            DOFfixer = DOFFixer(dim,fixnod);
            [ur,vr,vl] = DOFfixer.getDisplacementsAndDOFs();
        end
               
        function solveSystem(obj)
        end
        
        function computeInternal(obj)
        end
        
        function checkAnalysis(obj)
        end
    end
end

