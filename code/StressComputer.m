classdef StressComputer < handle
    properties (SetAccess = private, GetAccess = public)
        Fx, Fy, Mz
    end
    
    properties (Access = private)
        dim
        u
        x
        Tn
        Tconn
        KElem
    end
    
    methods(Access = public)
        function obj = StressComputer(cParams)
            obj.init(cParams);
        end
        
        function obj = compute(obj)
            for iElem = 1:obj.dim.nel
                elem = obj.initializeElement(iElem);
                Re = obj.createRotationMatrix(elem); % barra mes que element
                ue = obj.calculateElementDisplacement(iElem);
                Feint = obj.calculateForces(iElem, Re, ue);
            end
            obj.assignForces(Feint);
        end
    end
    
    methods(Access = private)
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.u     = cParams.u;
            obj.x     = cParams.data.x;
            obj.Tn    = cParams.data.Tn;
            obj.Tconn    = cParams.Tconn;
            obj.KElem = cParams.KElem;  
        end
        
        function n = initializeElement(obj, e)
            n.x1e = obj.x(obj.Tn(e,1), 1);
            n.x2e = obj.x(obj.Tn(e,2), 1);
            n.y1e = obj.x(obj.Tn(e,1), 2);
            n.y2e = obj.x(obj.Tn(e,2), 2);
            n.le  = obj.calculateElementLength(n);
        end
        
        function Re = createRotationMatrix(obj, n)
            s.n = n;
            RM = RotationMatrixComputer(s);
            RM.compute();
            Re = RM.RotationMatrix;
        end
        
        function uelem = calculateElemenTconnisplacement(obj, iElem)
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            uelem = zeros(nne*ni,1);
            for i = 1:nne*ni
                I = obj.Tconn(iElem,i);
                uelem(i,1) = obj.u(I);
            end
        end
        
        function Feint = calculateForces(obj, e, Re, uelem)
            Feint = Re*obj.KElem(:,:,e)*uelem;
        end
        
        function assignForces(obj, F)
            for e = 1:obj.dim.nel
                obj.Fx(e,1) = -F(1);
                obj.Fx(e,2) =  F(4);
                obj.Fy(e,1) = -F(2);
                obj.Fy(e,2) =  F(5);
                obj.Mz(e,1) = -F(3);
                obj.Mz(e,2) =  F(6);
            end
        end
        
        function le = calculateElementLength(obj, n)
            le = sqrt((n.x2e - n.x1e)^2 + (n.y2e - n.y1e)^2);
        end
    end
end