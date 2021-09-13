classdef ElementStiffnessMatrix< handle

    properties(SetAccess = private, GetAccess = public)
        Keprima
    end
    
    properties(Access = private)
        
    end
    
    methods(Access = public)
        function obj = ElementStiffnessMatrix(cParams)
            obj.init(cParams);
        end
                
        function obj = compute(obj)
            obj.create();
            obj.assembleGlobalMatrix();
        end
    end
    
    methods(Access = private)   
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.x     = cParams.data.x;
            obj.Tn    = cParams.data.Tn;
            obj.mat   = cParams.data.mat;
            obj.Tmat  = cParams.data.Tmat;
            obj.fdata = cParams.data.fdata;
            obj.Td    = cParams.Td;
        end
                
        function Ke = initializeStiffnessMatrices(obj, n)
            % crear amb zeros i anar omplint
            % refer nodes
            Re = 1/n.le* [
                n.x2e - n.x1e, n.y2e - n.y1e, 0, 0, 0, 0;
                -(n.y2e - n.y1e), n.x2e - n.x1e, 0, 0, 0, 0;
                0, 0, n.le, 0, 0, 0;
                0, 0, 0, n.x2e - n.x1e, n.y2e - n.y1e, 0;
                0, 0, 0, -(n.y2e - n.y1e), n.x2e - n.x1e, 0;
                0, 0, 0, 0, 0, n.le;
                ];
            Keprima = n.Ize*n.Ee/n.le^3 * [
                0, 0, 0, 0, 0, 0;
                0, 12, 6*n.le, 0, -12, 6*n.le;
                0, 6*n.le, 4*n.le^2, 0, -6*n.le, 2*n.le^2;
                0, 0, 0, 0, 0, 0;
                0, -12, -6*n.le, 0, 12, -6*n.le;
                0, 6*n.le, 2*n.le^2, 0, -6*n.le, 4*n.le^2;
                ] + n.Ae*n.Ee/n.le * [
                1, 0, 0, -1, 0, 0;
                0, 0, 0, 0, 0, 0;
                0, 0, 0, 0, 0, 0;
                -1, 0, 0, 1, 0, 0;
                0, 0, 0, 0, 0, 0;
                0, 0, 0, 0, 0, 0;        
                ];
            Ke = transpose(Re)* Keprima * Re; % moure a funcio rotateStiffnessMatrix
        end           
    end
end

