classdef ElementStiffnessComputer < handle

    properties(SetAccess = private, GetAccess = public)
        KBase
    end
    
    properties(Access = private)
        nodes
    end
    
    methods(Access = public)
        function obj = ElementStiffnessComputer(cParams)
            obj.init(cParams);
        end
                
        function obj = compute(obj)
            n  = obj.nodes;
            le = n.le;
            c1 = n.Ize*n.Ee/le^3;
            c2 = n.Ae*n.Ee/le;
            K = zeros(6,6);
            K(1,1) = c2;
            K(1,4) = -c2;
            K(2,2) = c1 * 12;
            K(2,3) = c1 * 6*le;
            K(2,5) = c1 * (-12);
            K(2,6) = c1 * 6*le;
            K(3,2) = c1 * 6*le;
            K(3,3) = c1 * 4*le^2;
            K(3,5) = c1 * (-6*le);
            K(3,6) = c1 * 2*le^2;
            K(4,1) = -c2;
            K(4,4) = c2;
            K(5,2) = -12*c1;
            K(5,3) = -6*le*c1;
            K(5,5) = 12*c1;
            K(5,6) = -6*le*c1;
            K(6,2) = 6*le*c1;
            K(6,3) = 2*le^2*c1;
            K(6,5) = -6*le*c1;
            K(6,6) = 4*le^2*c1;
            obj.KBase = K;
        end
    end
    
    methods(Access = private)   
        function init(obj, cParams)
            obj.nodes = cParams.n;
        end
    end
end