classdef DOFFixer < handle

    properties(SetAccess = private, GetAccess = public)
        ur,vr,vl
    end
    
    properties(Access = private)
        dim
        fixnod
    end
    
    methods(Access = public)
        function obj = DOFFixer(cParams)
            obj.init(cParams);
        end
        
        function obj = fix(obj)
            obj.calculateFixedData();
            obj.calculateFreeDOFs();
        end
    end
    
    methods(Access = private)
        function init(obj, cParams)
            obj.dim = cParams.dim;
            obj.fixnod = cParams.data.fixnod;
        end
        
        function calculateFixedData(obj, fixnod)
            fixnod = obj.fixnod;
            
            varvr = zeros(height(fixnod), 1);
            varur = zeros(height(fixnod), 1);
            for j = 1:height(fixnod)
               varvr(j) = nod3dof (fixnod(j,1),fixnod(j,2));
               varur(j) = fixnod(j,3);
            end
            obj.vr = varvr;
            obj.ur = varur;
        end
        
        function calculateFreeDOFs(obj)
            dim = obj.dim;
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