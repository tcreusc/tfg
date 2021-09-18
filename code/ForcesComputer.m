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
            % moure a funcio a sota
            Fdata = obj.fdata;
            forces = zeros(obj.dim.ndof,1);
            for i = 1:height(Fdata)
               nod = Fdata(i,1);
               dir = Fdata(i,2);
               F   = Fdata(i,3);
               DOF = nod3dof(nod, dir);
               forces (DOF,1) = F;
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