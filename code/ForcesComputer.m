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
            fdata = obj.fdata;
            forces = zeros(obj.dim.ndof,1);
            for i = 1:height(obj.fdata)
               forces ( nod3dof( fdata(i,1), fdata(i,2) ) ,1) = fdata(i,3);
            end
            obj.Fext = forces;
        end
    end
    
    methods(Access = private)   
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.fdata = cParams.data.fdata;
        end
    end
end