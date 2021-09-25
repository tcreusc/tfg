classdef StressComputer < handle
    properties (SetAccess = private, GetAccess = public)
        Fx, Fy, Mz
    end
    
    properties (Access = private)
        data
        dim
        displacement
        connectivities
        KElem
    end
    
    methods(Access = public)

        function obj = StressComputer(cParams)
            obj.init(cParams);
        end

        function obj = compute(obj)
            for iElem = 1:obj.dim.nel
                bar = obj.createBar(iElem);
                Re = bar.calculateRotationMatrix();
                ue = obj.calculateElementDisplacement(iElem);
                Feint = obj.calculateForces(iElem, Re, ue);
                [FX, FY, MZ] = obj.assignForces(iElem, Feint);
            end
            obj.Fx = FX;
            obj.Fy = FY;
            obj.Mz = MZ;
        end
    end
    
    methods(Access = private)
        
        function init(obj, cParams)
            obj.dim            = cParams.dim;
            obj.data           = cParams.data;
            obj.KElem          = cParams.KElem;  
            obj.displacement   = cParams.displacement;
            obj.connectivities = cParams.connectivities;
        end
        
        function bar = createBar(obj, e)
            s.data = obj.data;
            bar = Bar(s);
            bar.create(e);
        end
        
        function uelem = calculateElementDisplacement(obj, iElem)
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            uelem = zeros(nne*ni,1);
            for i = 1:nne*ni
                I = obj.connectivities(iElem,i);
                uelem(i,1) = obj.displacement(I);
            end
        end
        
        function Feint = calculateForces(obj, e, Re, uElem)
            K = obj.KElem(:,:,e);
            Feint = Re * K * uElem;
        end
        
    end
    
    methods(Static)
        
        function [Fx, Fy, Mz] = assignForces(e, F)
            Fx(e,1) = -F(1);
            Fx(e,2) =  F(4);
            Fy(e,1) = -F(2);
            Fy(e,2) =  F(5);
            Mz(e,1) = -F(3);
            Mz(e,2) =  F(6);
        end

    end
end