classdef StressComputer < handle
    properties (SetAccess = private, GetAccess = public)
        stress
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
            str = zeros(obj.dim.nel, 1);
            for iElem = 1:obj.dim.nel
                bar = obj.createBar(iElem);
                Re = bar.calculateRotationMatrix();
                ue = obj.calculateElementDisplacement(iElem);
                strainE = obj.calculateElementStrain(bar, Re, ue);
                str(iElem, 1) = obj.calculateElementStress(bar, strainE);
            end
            obj.stress = str;
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
        
        function strain = calculateElementStrain(obj, bar, Re, uElem)
            uep = Re * uElem;
            le = bar.length;
            strain = 1/le * [-1, 1] * uep;
        end
        
    end
    
    methods(Static)
        
        function sig = calculateElementStress(bar, str)
            [E, ~, ~] = bar.getMaterialData();
            sig = E * str;
        end

    end
end