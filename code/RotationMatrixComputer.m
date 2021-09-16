classdef RotationMatrixComputer < handle

    properties(SetAccess = private, GetAccess = public)
        RotationMatrix
    end
    
    properties(Access = private)
        nodes
    end
    
    methods(Access = public)
        function obj = RotationMatrixComputer(cParams)
            obj.init(cParams);
        end
                
        function obj = compute(obj)
            n = obj.nodes;
            le = n.le;
            x1 = n.x1e;
            x2 = n.x2e;
            y1 = n.y1e;
            y2 = n.y2e;
            coef = 1/le;
            Re = zeros(6,6);
            Re(1,1) =   coef * (x2-x1);
            Re(1,2) =   coef * (y2-y1);
            Re(2,1) = - coef * (y2-y1);
            Re(2,2) =   coef * (x2-x1);
            Re(3,3) =   coef * le;
            Re(4,4) =   coef * (x2-x1);
            Re(4,5) =   coef * (y2-y1);
            Re(5,4) = - coef * (y2-y1);
            Re(5,5) =   coef * (x2-x1);
            Re(6,6) =   coef * le;
            obj.RotationMatrix = Re;
        end
    end
    
    methods(Access = private)   
        function init(obj, cParams)
            obj.nodes = cParams.n;
        end            
    end
end

