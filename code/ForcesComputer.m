classdef ForcesComputer < handle

    properties(SetAccess = private, GetAccess = public)
        Fext
    end
    
    properties(Access = private)
        dim
        fdata
    end
    
    methods(Access = public)
        
        function obj = ForcesComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            obj.Fext = zeros(obj.dim.ndof,1);
            for i = 1:height(obj.fdata)
               obj.Fext ( nod3dof( obj.fdata(i,1), obj.fdata(i,2) ) ,1) = obj.fdata(i,3);
            end
        end
    end
    
    methods(Access = private)   
        
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.fdata = cParams.data.fdata;
        end
        
        function createForcesMatrix(obj)
        end
    end
end