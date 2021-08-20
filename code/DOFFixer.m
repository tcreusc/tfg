%% Funció fixedDOF(dim,fixnod)
% A partir de la matriu introduida de nodes fixats, retorna tres matrius:
%   (1) Matriu ur. Conte els desplacaments dels nodes fixats
%   (2) Matriu vr. Conte els DOFs fixats
%   (3) Matriu vl. Conte els DOFs lliures
classdef DOFFixer < handle

    properties(SetAccess = private, GetAccess = public)
        ur,vr,vl
    end
    
    properties(Access = private)
        
    end
    
    methods(Access = public)
        
        function obj = DOFFixer(dim,fixnod)
            obj.calculateFixedData(fixnod);
            obj.calculateFreeDOFs(dim);
        end

        function [ur,vr,vl] = getDisplacementsAndDOFs(obj)
            ur = obj.ur;
            vr = obj.vr;
            vl = obj.vl;
        end
        
    end
    
    methods(Access = private)   
        
        function calculateFixedData(obj, fixnod)
            varvr = zeros(height(fixnod), 1);
            varur = zeros(height(fixnod), 1);

            for j = 1:height(fixnod)
               varvr(j) = nod3dof (fixnod(j,1),fixnod(j,2));
               varur(j) = fixnod(j,3);
            end
            
            obj.vr = varvr;
            obj.ur = varur;
        end
        
        function calculateFreeDOFs(obj, dim)
            count = 1;

            for dof = 1:dim.ndof
                if ~ismember(dof, obj.vr)
                    varvl(count) = dof;
                    count = count+1;
                end
            end
            
            obj.vl = varvl;
        end
        
    end
end