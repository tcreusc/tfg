classdef AnalysisPerformer < handle

    properties(SetAccess = private, GetAccess = public)
        
    end
    
    properties(Access = private)
        materialDataFile, geometricDataFile, boundaryDataFile, u
    end
    
    methods(Access = public)
        
        function obj = AnalysisPerformer(varMaterialData, varGeometricData, varBoundaryData)
            obj.materialDataFile  = varMaterialData;
            obj.geometricDataFile = varGeometricData;
            obj.boundaryDataFile  = varBoundaryData;
            obj.performAnalysis();
        end

        function [u] = getDisplacements(obj)
            u = obj.u;
        end
        
    end
    
    methods(Access = private)   
        
        function performAnalysis(obj)
            run(obj.materialDataFile);
            run(obj.geometricDataFile);
            run(obj.boundaryDataFile);

            %Dimensions
            dim.nd = size(x,2);   % Problem dimension
            dim.nel = size(Tn,1); % Number of elements (bars)
            dim.nnod = size(x,1); % Number of nodes (joints)
            dim.nne = size(Tn,2); % Number of nodes in a bar
            dim.ni = 3;           % Degrees of freedom per node
            dim.ndof = dim.nnod*dim.ni;  % Total number of degrees of freedom

            %% Solver

            Td = connectDOF(dim,Tn);
            [Kel] = GlobalStiffnessMatrixComputer(dim,x,Tn,mat,Tmat).getMatrix();
            myglobalFext = globalFext(dim,fdata);
            [Fext,KG] = assemblyK(dim,Kel,Td,myglobalFext);
            [ur,vr,vl] = DOFFixer(dim,fixnod).getDisplacementsAndDOFs();
            [obj.u, R] = ForceSystemSolver(KG,Fext,ur,vr,vl).getDisplacementAndReactions();
            [Fx, Fy, Mz] = InternalForcesComputer(dim,obj.u,x,Tn,Td,Kel, mat, Tmat).getForces();

            display(Fx)
            display(Fy)
            display(Mz)
        end
        
    end
end

