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
                
        function obj = create(obj)
            obj.initializeStiffnessMatrix(n);
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
                
        function Ke = initializeStiffnessMatrix(obj, n)
            % crear amb zeros i anar omplint
            % refer nodes
            le  = n.le;
            c1 = n.Ize*n.Ee/le^3;
            c2 = n.Ae*n.Ee/le;
            Keprima = zeros(6,6);
            Keprima(1,1) = c2;
            Keprima(1,4) = -c2;
            Keprima(2,2) = c1 * 12;
            Keprima(2,3) = c1 * 6*le;
            Keprima(2,5) = c1 * (-12);
            Keprima(2,6) = c1 * 6*le;
            Keprima(3,2) = c1 * 6*le;
            Keprima(3,3) = c1 * 4*le^2;
            Keprima(3,5) = c1 * (-6*le);
            Keprima(3,6) = c1 * 2*le^2;
            Keprima(4,1) = -c2;
            Keprima(4,4) = c2;
            Keprima(5,2) = -12*c1;
            Keprima(5,3) = -6*le*c1;
            Keprima(5,5) = 12*c1;
            Keprima(5,6) = -6*le*c1;
            Keprima(6,2) = 6*le*c1;
            Keprima(6,3) = 2*le^2*c1;
            Keprima(6,5) = -6*le*c1;
            Keprima(6,6) = 4*le^2*c1;
            Ke = transpose(Re)* Keprima * Re; % moure a funcio rotateStiffnessMatrix
        end           
    end
end

