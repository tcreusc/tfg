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
            obj.calculateForcesMatrix();
        end
        
    end
    
    methods(Access = private)

        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.fdata = cParams.data.fdata;
        end
        
        function calculateForcesMatrix(obj)
            Fdata = obj.fdata;
            d = obj.dim;
            ndof = d.ndof;
            F = zeros(ndof,1);
            for i = 1:height(Fdata)
               val   = Fdata(i,3);
               converter = NodeDOFConverter(d, Fdata, i);
               DOF = converter.convert();
               F(DOF,1) = val;
            end
            obj.Fext = F;
        end
        
    end
end